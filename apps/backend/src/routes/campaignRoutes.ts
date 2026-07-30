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

export const createCampaignSchema = z.object({
  title: z.string().min(3, "Title must be at least 3 characters"),
  description: z.string().optional(),
  category: z.string().optional(),
  contentType: z.string().optional().default("ARTICLE"),
  content: z.string().optional(),
  imageUrl: z.string().optional(),
  imageTitle: z.string().optional(),
  imageDescription: z.string().optional(),
  adNetwork: z.string().optional(),
  adUnitCode: z.string().optional(),
  status: z.enum(["DRAFT", "PUBLIC"]).optional().default("PUBLIC"),
});

export const updateCampaignStatusSchema = z.object({
  status: z.enum(["DRAFT", "PUBLIC"]),
});

/**
 * Helper to optionally extract authenticated user from Bearer token if provided
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

export const campaignRoutes = new Hono<HonoEnv>()
  .get("/", async (c) => {
    const db = getDb(c.env.DB);
    const campaignService = new CampaignService(db);

    const user = await getOptionalUser(c);
    const query = c.req.query();

    const page = query.page ? parseInt(query.page, 10) : 1;
    const limit = query.limit ? parseInt(query.limit, 10) : 10;
    const category = query.category || undefined;
    const contentType = query.contentType || undefined;
    const search = query.search || undefined;
    const status =
      query.status === "DRAFT" || query.status === "PUBLIC"
        ? query.status
        : undefined;

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
  .get("/me", authMiddleware(), async (c) => {
    const userPayload = c.get("user")!; // comes from the verified JWT
    const db = getDb(c.env.DB);
    const campaignService = new CampaignService(db);

    const items = await campaignService.getUserCampaigns(userPayload.id);
    return sendSuccess(c, items);
  })
  .get("/:id", async (c) => {
    const id = c.req.param("id");
    const db = getDb(c.env.DB);
    const campaignService = new CampaignService(db);
    const campaign = await campaignService.getCampaignById(id);

    if (!campaign) return sendError(c, "Campaign not found", null, 404);

    const user = await getOptionalUser(c);
    if (campaign.status === "DRAFT") {
      if (!user) return sendError(c, "Campaign not found", null, 404);
      if (user.role !== "ADMIN" && campaign.userId !== user.id) {
        return sendError(c, "Forbidden", null, 403);
      }
    }

    return sendSuccess(c, campaign);
  })
  .post(
    "/",
    createCampaignRateLimiter(),
    authMiddleware(),
    requireRole(["ADMIN", "CREATOR"]),
    zValidator("json", createCampaignSchema, (result, c) => {
      if (!result.success) {
        return sendError(
          c,
          result.error.errors[0]?.message || "Validation error",
          result.error.format(),
        );
      }
    }),
    async (c) => {
      const userPayload = c.get("user")!;
      const body = c.req.valid("json");
      const db = getDb(c.env.DB);
      const campaignService = new CampaignService(db);
      const auditLogService = new AuditLogService(db);

      const campaign = await campaignService.createCampaign(
        userPayload.id,
        body,
      );
      await auditLogService.createLog(
        "CAMPAIGN_CREATE",
        userPayload.id,
        getClientIp(c),
        JSON.stringify({ campaignId: campaign?.id, title: campaign?.title }),
      );
      return sendSuccess(c, campaign, "Campaign created successfully");
    },
  )
  .patch(
    "/:id/status",
    authMiddleware(),
    zValidator("json", updateCampaignStatusSchema, (result, c) => {
      if (!result.success) {
        return sendError(
          c,
          result.error.errors[0]?.message || "Validation error",
          result.error.format(),
        );
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
  );
