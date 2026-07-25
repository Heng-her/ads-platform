import { Hono } from "hono";
import { zValidator } from "@hono/zod-validator";
import { z } from "zod";
import type { HonoEnv } from "../types/env";
import { getDb } from "../db/index";
import { CampaignService } from "../services/campaignService";
import { authMiddleware, requireRole } from "../middlewares/auth";
import { sendSuccess, sendError } from "../utils/response";

export const createCampaignSchema = z.object({
  title: z.string().min(3, "Title must be at least 3 characters"),
  description: z.string().optional(),
  budget: z.number().positive("Budget must be a positive number"),
  dailyBudget: z.number().positive().optional()
});

export const updateCampaignStatusSchema = z.object({
  status: z.enum(["DRAFT", "PENDING_APPROVAL", "ACTIVE", "PAUSED", "REJECTED", "COMPLETED"])
});

export const campaignRoutes = new Hono<HonoEnv>()
  .use("*", authMiddleware())
  .get("/", async (c) => {
    const userPayload = c.get("user")!;
    const db = getDb(c.env.DB);
    const campaignService = new CampaignService(db);

    if (userPayload.role === "ADMIN") {
      const allCampaigns = await campaignService.getAllCampaigns();
      return sendSuccess(c, allCampaigns);
    }

    const myCampaigns = await campaignService.getUserCampaigns(userPayload.id);
    return sendSuccess(c, myCampaigns);
  })
  .post("/", requireRole(["ADMIN", "CREATOR"]), zValidator("json", createCampaignSchema, (result, c) => {
    if (!result.success) {
      return sendError(c, result.error.errors[0]?.message || "Validation error", result.error.format());
    }
  }), async (c) => {
    const userPayload = c.get("user")!;
    const { title, description, budget, dailyBudget } = c.req.valid("json");
    const db = getDb(c.env.DB);
    const campaignService = new CampaignService(db);

    const campaign = await campaignService.createCampaign(userPayload.id, title, budget, description, dailyBudget);
    return sendSuccess(c, campaign, "Campaign created successfully");
  })
  .get("/:id", async (c) => {
    const id = c.req.param("id");
    const db = getDb(c.env.DB);
    const campaignService = new CampaignService(db);
    const campaign = await campaignService.getCampaignById(id);

    if (!campaign) return sendError(c, "Campaign not found", null, 404);
    return sendSuccess(c, campaign);
  })
  .patch("/:id/status", zValidator("json", updateCampaignStatusSchema, (result, c) => {
    if (!result.success) {
      return sendError(c, result.error.errors[0]?.message || "Validation error", result.error.format());
    }
  }), async (c) => {
    const id = c.req.param("id");
    const userPayload = c.get("user")!;
    const { status } = c.req.valid("json");
    const db = getDb(c.env.DB);
    const campaignService = new CampaignService(db);

    const campaign = await campaignService.getCampaignById(id);
    if (!campaign) return sendError(c, "Campaign not found", null, 404);

    if (userPayload.role !== "ADMIN" && campaign.userId !== userPayload.id) {
      return sendError(c, "Forbidden", null, 403);
    }

    const updated = await campaignService.updateCampaignStatus(id, status);
    return sendSuccess(c, updated);
  });
