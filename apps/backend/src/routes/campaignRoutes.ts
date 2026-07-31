import { Hono } from "hono";
import { zValidator } from "@hono/zod-validator";
import { z } from "zod";
import type { HonoEnv, UserJwtPayload } from "../types/env";
import { getDb } from "../db/index";
import { CampaignService } from "../services/campaignService";
import { AuditLogService } from "../services/auditLogService";
import { authMiddleware, requireRole } from "../middlewares/auth";
import { sendSuccess, sendError } from "../utils/response";
import { getClientIp } from "../utils/ip";
import { getJwtSecret } from "../utils/env";
import { jwtVerify } from "jose";
import { createCampaignRateLimiter } from "../middlewares/rateLimiter";

// ─── Schemas ─────────────────────────────────────────────────────────────────

export const createCampaignSchema = z.object({
  title: z.string().min(3, "Title must be at least 3 characters"),
  description: z.string().optional(),
  category: z.string().optional(),
  contentType: z.string().optional().default("ARTICLE"),
  content: z.string().optional(),
  imageUrl: z.string().url("Invalid image URL").optional(),
  imageTitle: z.string().optional(),
  imageDescription: z.string().optional(),
  adNetwork: z.string().optional(),
  adUnitCode: z.string().optional(),
  status: z.enum(["DRAFT", "PUBLIC"]).optional().default("PUBLIC"),
});

export const updateCampaignSchema = z.object({
  title: z.string().min(3, "Title must be at least 3 characters").optional(),
  description: z.string().optional(),
  category: z.string().optional(),
  contentType: z.string().optional(),
  content: z.string().optional(),
  imageUrl: z.string().url("Invalid image URL").optional(),
  imageTitle: z.string().optional(),
  imageDescription: z.string().optional(),
  adNetwork: z.string().optional(),
  adUnitCode: z.string().optional(),
  status: z.enum(["DRAFT", "PUBLIC"]).optional(),
});

export const updateCampaignStatusSchema = z.object({
  status: z.enum(["DRAFT", "PUBLIC"]),
});

// Zod schema for query param validation (all string from URL, coerced)
const listQuerySchema = z.object({
  page: z.coerce.number().int().min(1).optional().default(1),
  limit: z.coerce.number().int().min(1).max(100).optional().default(10),
  category: z.string().optional(),
  contentType: z.string().optional(),
  search: z.string().optional(),
  status: z.enum(["DRAFT", "PUBLIC"]).optional(),
});

const meQuerySchema = z.object({
  page: z.coerce.number().int().min(1).optional().default(1),
  limit: z.coerce.number().int().min(1).max(100).optional().default(10),
  status: z.enum(["DRAFT", "PUBLIC"]).optional(),
});

// ─── Helpers ─────────────────────────────────────────────────────────────────

/**
 * Optionally extract authenticated user from Bearer token if provided.
 * Returns null if no token or token is invalid.
 */
async function getOptionalUser(c: any): Promise<UserJwtPayload | null> {
  const authHeader = c.req.header("Authorization");
  if (!authHeader || !authHeader.startsWith("Bearer ")) {
    return null;
  }
  try {
    const token = authHeader.substring(7);
    const secret = new TextEncoder().encode(getJwtSecret(c));
    const { payload } = await jwtVerify(token, secret);
    return {
      id: payload.id as string,
      email: payload.email as string,
      role: payload.role as "ADMIN" | "CREATOR",
    };
  } catch {
    return null;
  }
}

// ─── Routes ──────────────────────────────────────────────────────────────────

export const campaignRoutes = new Hono<HonoEnv>()

  // ── GET /api/campaigns — Public list with filters & pagination ──────────────
  .get("/", zValidator("query", listQuerySchema, (result, c) => {
    if (!result.success) {
      return sendError(c, result.error.errors[0]?.message || "Invalid query parameters", result.error.format(), 400);
    }
  }), async (c) => {
    const db = getDb(c.env.DB);
    const campaignService = new CampaignService(db);
    const user = await getOptionalUser(c);
    const { page, limit, category, contentType, search, status } = c.req.valid("query");

    const result = await campaignService.getCampaignsList({
      user,
      category,
      contentType,
      search,
      status,
      page,
      limit,
    });

    return sendSuccess(c, result);
  })

  // ── GET /api/campaigns/me — Own campaigns with pagination & status filter ───
  .get("/me", authMiddleware(), zValidator("query", meQuerySchema, (result, c) => {
    if (!result.success) {
      return sendError(c, result.error.errors[0]?.message || "Invalid query parameters", result.error.format(), 400);
    }
  }), async (c) => {
    const userPayload = c.get("user")!;
    const db = getDb(c.env.DB);
    const campaignService = new CampaignService(db);
    const { page, limit, status } = c.req.valid("query");

    const result = await campaignService.getUserCampaigns(userPayload.id, { page, limit, status });
    return sendSuccess(c, result);
  })

  // ── GET /api/campaigns/:id — Single campaign by ID ─────────────────────────
  .get("/:id", async (c) => {
    const id = c.req.param("id");
    const db = getDb(c.env.DB);
    const campaignService = new CampaignService(db);
    const user = await getOptionalUser(c);

    // Admins can view soft-deleted campaigns; everyone else cannot
    const includeDeleted = user?.role === "ADMIN";
    const campaign = await campaignService.getCampaignById(id, includeDeleted);

    if (!campaign) return sendError(c, "Campaign not found", null, 404);

    // Block access to DRAFT campaigns for non-owners and non-admins
    if (campaign.status === "DRAFT") {
      if (!user) return sendError(c, "Campaign not found", null, 404);
      if (user.role !== "ADMIN" && campaign.userId !== user.id) {
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
      if (!result.success) {
        return sendError(c, result.error.errors[0]?.message || "Validation error", result.error.format());
      }
    }),
    async (c) => {
      const userPayload = c.get("user")!;
      const body = c.req.valid("json");
      const db = getDb(c.env.DB);
      const campaignService = new CampaignService(db);
      const auditLogService = new AuditLogService(db);

      const campaign = await campaignService.createCampaign(userPayload.id, body);
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
      if (!result.success) {
        return sendError(c, result.error.errors[0]?.message || "Validation error", result.error.format());
      }
    }),
    async (c) => {
      const id = c.req.param("id");
      const userPayload = c.get("user")!;
      const body = c.req.valid("json");
      const db = getDb(c.env.DB);
      const campaignService = new CampaignService(db);
      const auditLogService = new AuditLogService(db);

      const campaign = await campaignService.getCampaignById(id);
      if (!campaign) return sendError(c, "Campaign not found", null, 404);

      // Only owner or admin can update
      if (userPayload.role !== "ADMIN" && campaign.userId !== userPayload.id) {
        return sendError(c, "Forbidden", null, 403);
      }

      // Reject empty update body
      if (Object.keys(body).length === 0) {
        return sendError(c, "No fields provided for update", null, 400);
      }

      const updated = await campaignService.updateCampaign(id, body);
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
      if (!result.success) {
        return sendError(c, result.error.errors[0]?.message || "Validation error", result.error.format());
      }
    }),
    async (c) => {
      const id = c.req.param("id");
      const userPayload = c.get("user")!;
      const { status } = c.req.valid("json");
      const db = getDb(c.env.DB);
      const campaignService = new CampaignService(db);
      const auditLogService = new AuditLogService(db);

      const campaign = await campaignService.getCampaignById(id);
      if (!campaign) return sendError(c, "Campaign not found", null, 404);

      if (userPayload.role !== "ADMIN" && campaign.userId !== userPayload.id) {
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
  // Creator: campaign disappears from their view (isDeleted = true)
  // Admin: campaign still visible via admin endpoints (isDeleted flag shown)
  .delete("/:id", authMiddleware(), async (c) => {
    const id = c.req.param("id");
    const userPayload = c.get("user")!;
    const db = getDb(c.env.DB);
    const campaignService = new CampaignService(db);
    const auditLogService = new AuditLogService(db);

    // Admins can delete any campaign (including already soft-deleted ones to re-mark)
    const campaign = await campaignService.getCampaignById(id, userPayload.role === "ADMIN");
    if (!campaign) return sendError(c, "Campaign not found", null, 404);

    // Only owner or admin can delete
    if (userPayload.role !== "ADMIN" && campaign.userId !== userPayload.id) {
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
