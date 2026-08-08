import { Hono } from "hono";
import { zValidator } from "@hono/zod-validator";
import type { HonoEnv, UserJwtPayload } from "../types/env";
import { getDb } from "../db/index";
import { CampaignService } from "../services/campaignService";
import { AuditLogService } from "../services/auditLogService";
import { ImpressionService } from "../services/impressionService";
import { CategoryService } from "../services/categoryService";
import { authMiddleware, requireRole } from "../middlewares/auth";
import { sendSuccess, sendError } from "../utils/response";
import { getClientIp } from "../utils/ip";
import { getJwtSecret } from "../utils/env";
import { extractBearerToken, verifyToken } from "../utils/jwt";
import { zodErrorHandler } from "../utils/validation";
import { createCampaignRateLimiter } from "../middlewares/rateLimiter";
import {
  createCampaignSchema,
  updateCampaignSchema,
  updateCampaignStatusSchema,
  listCampaignsQuerySchema,
  meCampaignsQuerySchema,
  publicCampaignFeedQuerySchema,
  newCampaignCountQuerySchema,
} from "../schemas/campaign";

// Re-export schemas consumed by actionRoutes.ts
export { createCampaignSchema, updateCampaignStatusSchema } from "../schemas/campaign";

// ─── Helpers ─────────────────────────────────────────────────────────────────

function extractId(rawParam: string): string {
  const uuidMatch = rawParam.match(/[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i);
  return uuidMatch ? uuidMatch[0] : rawParam;
}

/**
 * Optionally extract authenticated user from Bearer token if provided.
 * Returns null if no token or token is invalid — used on public endpoints
 * where auth is optional.
 */
async function getOptionalUser(c: any): Promise<UserJwtPayload | null> {
  const token = extractBearerToken(c.req.header("Authorization"));
  if (!token) return null;
  return verifyToken(token, getJwtSecret(c));
}

/**
 * Returns true if the given user is allowed to mutate (update/delete) a campaign.
 * Admins can mutate any campaign; creators can only mutate their own.
 */
function canMutateCampaign(user: UserJwtPayload, campaignUserId: string): boolean {
  return user.role === "ADMIN" || user.id === campaignUserId;
}

// ─── Routes ──────────────────────────────────────────────────────────────────

export const campaignRoutes = new Hono<HonoEnv>()

  // ── GET /api/campaigns — Stable public cursor feed ─────────────────────────
  .get(
    "/",
    zValidator("query", publicCampaignFeedQuerySchema, (result, c) => {
      if (!result.success) return zodErrorHandler(result, c);
    }),
    async (c) => {
      const db = getDb(c.env.DB);
      const campaignService = new CampaignService(db);
      const impressionService = new ImpressionService(db, c.env.CACHE_KV);
      const user = await getOptionalUser(c);
      const { limit, cursor, snapshotAt, category, contentType, search, customCategoryId } = c.req.valid("query");

      const result = await campaignService.getPublicCampaignFeed({
        user,
        category,
        contentType,
        search,
        customCategoryId,
        limit,
        cursor,
        snapshotAt,
      });

      const campaignIds = result.items.map((item) => item.id);

      // Fetch impression stats for all returned campaigns in one batch
      const statsMap = await impressionService.getStatsForCampaigns(campaignIds);

      // Attach stats to each item
      const itemsWithStats = result.items.map((item) => ({
        ...item,
        ...(statsMap[item.id] ?? { totalImpressions: 0, uniqueViewers: 0 }),
      }));

      // Record one impression per campaign in the background — never blocks the response.
      // Only fires for unauthenticated (public) visitors; authenticated users are skipped.
      if (!user) {
        const ip = getClientIp(c) ?? "unknown";
        const ua = c.req.header("User-Agent") ?? "unknown";
        c.executionCtx.waitUntil(
          ImpressionService.buildViewerHash(ip, ua).then((viewerHash) =>
            Promise.all(
              campaignIds.map((id) => impressionService.recordImpression(id, viewerHash)),
            ),
          ),
        );
      }

      return sendSuccess(c, { ...result, items: itemsWithStats });
    },
  )

  .get(
    "/new-count",
    zValidator("query", newCampaignCountQuerySchema, (result, c) => {
      if (!result.success) return zodErrorHandler(result, c);
    }),
    async (c) => {
      const db = getDb(c.env.DB);
      const campaignService = new CampaignService(db);
      const user = await getOptionalUser(c);
      const { snapshotAt, category, contentType, search, customCategoryId } = c.req.valid("query");
      const count = await campaignService.getPublicCampaignNewCount({
        user,
        snapshotAt,
        category,
        contentType,
        search,
        customCategoryId,
      });

      return sendSuccess(c, { count });
    },
  )

  // ── GET /api/campaigns/me — Own campaigns with pagination & status filter ───
  .get(
    "/me",
    authMiddleware(),
    zValidator("query", meCampaignsQuerySchema, (result, c) => {
      if (!result.success) return zodErrorHandler(result, c);
    }),
    async (c) => {
      const userPayload = c.get("user")!;
      const db = getDb(c.env.DB);
      const campaignService = new CampaignService(db);
      const impressionService = new ImpressionService(db, c.env.CACHE_KV);
      const { page, limit, status, category, search } = c.req.valid("query");

      const result = await campaignService.getUserCampaigns(userPayload.id, { page, limit, status, category, search });

      const campaignIds = result.items.map((item) => item.id);

      // Read stats only — no impression recording for the owner's own view
      const statsMap = await impressionService.getStatsForCampaigns(campaignIds);

      const itemsWithStats = result.items.map((item) => ({
        ...item,
        ...(statsMap[item.id] ?? { totalImpressions: 0, uniqueViewers: 0 }),
      }));

      return sendSuccess(c, { ...result, items: itemsWithStats });
    },
  )

  // ── GET /api/campaigns/search/suggestions?q= — Search suggestions ──────────
  // Public endpoint. Returns grouped suggestions: system categories, custom
  // categories (authenticated user's own only), content types, and campaign titles.
  // Frontend uses the returned `filter` value to call GET /campaigns?{filter}.
  .get("/search/suggestions", async (c) => {
    const q = (c.req.query("q") ?? "").trim();
    if (!q) return sendSuccess(c, []);

    const db = getDb(c.env.DB);
    const categoryService = new CategoryService(db);
    const user = await getOptionalUser(c);

    const pattern = `%${q}%`;

    // Run all queries in parallel
    const [systemCats, allContentTypes, titleMatches] = await Promise.all([
      categoryService.getAllSystemCategories(),
      categoryService.getAllContentTypes(),
      // Match campaign titles — public & non-deleted only
      db.query.campaigns.findMany({
        columns: { id: true, title: true },
        where: (campaigns, { and, eq, like }) =>
          and(
            eq(campaigns.status, "PUBLIC"),
            eq(campaigns.isDeleted, false),
            like(campaigns.title, pattern),
          ),
        limit: 5,
      }),
    ]);

    const suggestions: {
      type: string;
      label: string;
      filter: string;
      campaignId?: string;
    }[] = [];

    // System category matches
    for (const cat of systemCats) {
      if (cat.name.toLowerCase().includes(q.toLowerCase())) {
        suggestions.push({
          type: "category",
          label: cat.name,
          filter: `category=${encodeURIComponent(cat.name)}`,
        });
      }
    }

    // Creator's own custom category matches (authenticated only)
    if (user) {
      const customCats = await categoryService.getCustomCategoriesByUser(user.id);
      for (const cat of customCats) {
        if (cat.name.toLowerCase().includes(q.toLowerCase())) {
          suggestions.push({
            type: "customCategory",
            label: cat.name,
            filter: `customCategoryId=${cat.id}`,
          });
        }
      }
    }

    // Content type matches
    for (const ct of allContentTypes) {
      if (ct.name.toLowerCase().includes(q.toLowerCase())) {
        suggestions.push({
          type: "contentType",
          label: ct.name,
          filter: `contentType=${encodeURIComponent(ct.name)}`,
        });
      }
    }

    // Campaign title matches
    for (const campaign of titleMatches) {
      suggestions.push({
        type: "title",
        label: campaign.title,
        filter: `search=${encodeURIComponent(campaign.title)}`,
        campaignId: campaign.id,
      });
    }

    return sendSuccess(c, suggestions);
  })

  // ── GET /api/campaigns/:id — Single campaign by ID ─────────────────────────
  .get("/:id", async (c) => {
    const id = extractId(c.req.param("id"));
    const db = getDb(c.env.DB);
    const campaignService = new CampaignService(db);
    const user = await getOptionalUser(c);

    // Admins can view soft-deleted campaigns; everyone else cannot
    const campaign = await campaignService.getCampaignById(id, user?.role === "ADMIN");
    if (!campaign) return sendError(c, "Campaign not found", null, 404);

    // Block access to DRAFT campaigns for non-owners and non-admins
    if (campaign.status === "DRAFT") {
      if (!user) return sendError(c, "Campaign not found", null, 404);
      if (!canMutateCampaign(user, campaign.userId)) {
        return sendError(c, "Forbidden", null, 403);
      }
    }

    // Non-admins cannot see soft-deleted campaigns (extra safety check)
    if (campaign.isDeleted && user?.role !== "ADMIN") {
      return sendError(c, "Campaign not found", null, 404);
    }

    return sendSuccess(c, campaign);
  })

  // ── POST /api/campaigns — Create campaign ──────────────────────────────────
  .post(
    "/",
    createCampaignRateLimiter(),
    authMiddleware(),
    requireRole(["ADMIN", "CREATOR"]),
    zValidator("json", createCampaignSchema, (result, c) => {
      if (!result.success) return zodErrorHandler(result, c);
    }),
    async (c) => {
      const userPayload = c.get("user")!;
      const body = c.req.valid("json");
      if (userPayload.role !== "ADMIN" && body.videoUrls && body.videoUrls.length > 2) {
        return sendError(c, "Maximum 2 videos allowed per campaign", null, 400);
      }
      const db = getDb(c.env.DB);
      const campaignService = new CampaignService(db);
      const auditLogService = new AuditLogService(db);

      const campaign = await campaignService.createCampaign(userPayload.id, body, userPayload.role === "ADMIN");
      await auditLogService.createLog(
        "CAMPAIGN_CREATE",
        userPayload.id,
        getClientIp(c),
        JSON.stringify({ campaignId: campaign?.id, title: campaign?.title }),
      );
      return sendSuccess(c, campaign, "Campaign created successfully");
    },
  )

  // ── PATCH /api/campaigns/:id — Update campaign content ─────────────────────
  .patch(
    "/:id",
    authMiddleware(),
    zValidator("json", updateCampaignSchema, (result, c) => {
      if (!result.success) return zodErrorHandler(result, c);
    }),
    async (c) => {
      const id = extractId(c.req.param("id"));
      const userPayload = c.get("user")!;
      const body = c.req.valid("json");
      const db = getDb(c.env.DB);
      const campaignService = new CampaignService(db);
      const auditLogService = new AuditLogService(db);

      const campaign = await campaignService.getCampaignById(id);
      if (!campaign) return sendError(c, "Campaign not found", null, 404);

      if (!canMutateCampaign(userPayload, campaign.userId)) {
        return sendError(c, "Forbidden", null, 403);
      }

      if (userPayload.role !== "ADMIN" && body.videoUrls && body.videoUrls.length > 2) {
        return sendError(c, "Maximum 2 videos allowed per campaign", null, 400);
      }

      if (Object.keys(body).length === 0) {
        return sendError(c, "No fields provided for update", null, 400);
      }

      const updated = await campaignService.updateCampaign(id, body, userPayload.role === "ADMIN");
      await auditLogService.createLog(
        "CAMPAIGN_UPDATE",
        userPayload.id,
        getClientIp(c),
        JSON.stringify({ campaignId: id, updatedFields: Object.keys(body) }),
      );
      return sendSuccess(c, updated, "Campaign updated successfully");
    },
  )

  // ── PATCH /api/campaigns/:id/status — Update campaign status only ──────────
  .patch(
    "/:id/status",
    authMiddleware(),
    zValidator("json", updateCampaignStatusSchema, (result, c) => {
      if (!result.success) return zodErrorHandler(result, c);
    }),
    async (c) => {
      const id = extractId(c.req.param("id"));
      const userPayload = c.get("user")!;
      const { status } = c.req.valid("json");
      const db = getDb(c.env.DB);
      const campaignService = new CampaignService(db);
      const auditLogService = new AuditLogService(db);

      const campaign = await campaignService.getCampaignById(id);
      if (!campaign) return sendError(c, "Campaign not found", null, 404);

      if (!canMutateCampaign(userPayload, campaign.userId)) {
        return sendError(c, "Forbidden", null, 403);
      }

      const updated = await campaignService.updateCampaignStatus(id, status);
      await auditLogService.createLog(
        "CAMPAIGN_UPDATE_STATUS",
        userPayload.id,
        getClientIp(c),
        JSON.stringify({ campaignId: id, newStatus: status }),
      );
      return sendSuccess(c, updated);
    },
  )

  // ── DELETE /api/campaigns/:id — Soft delete ────────────────────────────────
  .delete("/:id", authMiddleware(), async (c) => {
    const id = extractId(c.req.param("id"));
    const userPayload = c.get("user")!;
    const db = getDb(c.env.DB);
    const campaignService = new CampaignService(db);
    const auditLogService = new AuditLogService(db);

    const campaign = await campaignService.getCampaignById(id, userPayload.role === "ADMIN");
    if (!campaign) return sendError(c, "Campaign not found", null, 404);

    if (!canMutateCampaign(userPayload, campaign.userId)) {
      return sendError(c, "Forbidden", null, 403);
    }

    await campaignService.softDeleteCampaign(id);
    await auditLogService.createLog(
      "CAMPAIGN_DELETE",
      userPayload.id,
      getClientIp(c),
      JSON.stringify({ campaignId: id, title: campaign.title }),
    );
    return sendSuccess(c, null, "Campaign deleted successfully");
  });
