import type { Context } from "hono";
import type { HonoEnv, UserJwtPayload } from "../types/env";
import type { DbClient } from "../db/index";
import { CampaignService } from "../services/campaignService";
import { CategoryService } from "../services/categoryService";
import { AuditLogService } from "../services/auditLogService";
import { CampaignDispatchService } from "../services/campaignDispatchService";
import {
  SystemSettingsService,
  DEFAULT_POST_CONFIG,
  type PostConfig,
} from "../services/systemSettingsService";
import {
  createCampaignSchema,
  updateCampaignSchema,
  updateCampaignStatusSchema,
  listCampaignsQuerySchema,
} from "../schemas/campaign";
import { sendSuccess, sendError } from "../utils/response";
import { getClientIp } from "../utils/ip";
import { checkRateLimit } from "../middlewares/rateLimiter";
import { ImpressionService } from "../services/impressionService";

function validateVideoLimit(videoUrls: string[] | undefined, isAdmin: boolean, maxVideos: number = 2) {
  return isAdmin || !videoUrls || videoUrls.length <= maxVideos;
}

function validateImageLimit(images: any[] | undefined, isAdmin: boolean, maxImages: number = 10) {
  return isAdmin || !images || images.length <= maxImages;
}

export async function handleCampaignAction(
  c: Context<HonoEnv>,
  db: DbClient,
  action: string,
  payloadData: any,
  authenticate: (c: Context<HonoEnv>, strict?: boolean) => Promise<UserJwtPayload>,
) {
  const auditLogService = new AuditLogService(db);
  const settingsService = new SystemSettingsService({ db });

  switch (action) {
    case "campaigns/search-suggestions": {
      const q = (payloadData?.q || payloadData?.search || "").trim();
      if (!q) return sendSuccess(c, []);

      let currentUser: UserJwtPayload | null = null;
      try {
        currentUser = await authenticate(c);
      } catch {
        // Optional auth
      }

      const categoryService = new CategoryService(db);
      const pattern = `%${q}%`;

      const [systemCats, allContentTypes, titleMatches, customCats] = await Promise.all([
        categoryService.getAllSystemCategories(),
        categoryService.getAllContentTypes(),
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
        currentUser
          ? categoryService.getCustomCategoriesByUser(currentUser.id)
          : Promise.resolve([]),
      ]);

      const qLower = q.toLowerCase();
      const suggestions: Array<{
        type: "category" | "customCategory" | "contentType" | "title";
        label: string;
        filter: string;
        campaignId?: string;
      }> = [];

      for (const cat of systemCats) {
        if (cat.name.toLowerCase().includes(qLower)) {
          suggestions.push({
            type: "category",
            label: cat.name,
            filter: `category=${encodeURIComponent(cat.name)}`,
          });
        }
      }

      for (const cat of customCats) {
        if (cat.name.toLowerCase().includes(qLower)) {
          suggestions.push({
            type: "customCategory",
            label: cat.name,
            filter: `customCategoryId=${cat.id}`,
          });
        }
      }

      for (const ct of allContentTypes) {
        if (ct.name.toLowerCase().includes(qLower)) {
          suggestions.push({
            type: "contentType",
            label: ct.name,
            filter: `contentType=${encodeURIComponent(ct.name)}`,
          });
        }
      }

      for (const campaign of titleMatches) {
        suggestions.push({
          type: "title",
          label: campaign.title,
          filter: `search=${encodeURIComponent(campaign.title)}`,
          campaignId: campaign.id,
        });
      }

      return sendSuccess(c, suggestions);
    }
    // Support both the named action used by the frontend and the path-style
    // action used by API clients: { action: "/campaigns" }.
    case "campaigns/list":
    case "/campaigns": {
      let currentUser: UserJwtPayload | null = null;
      try {
        // The list endpoint is public. Passing strict=true prevents the
        // development-only admin fallback from changing public visibility.
        currentUser = await authenticate(c, true);
      } catch {
        // Public access if no token or if the optional token is invalid.
      }

      const parseResult = listCampaignsQuerySchema.safeParse(payloadData ?? {});
      if (!parseResult.success) {
        return sendError(
          c,
          parseResult.error.errors[0]?.message || "Validation error",
          parseResult.error.format(),
        );
      }

      const {
        page,
        limit,
        category,
        contentType,
        search,
        status,
        customCategoryId,
      } = parseResult.data;
      // The public infinite-scroll feed is intentionally limited to three
      // campaigns per request. Authenticated management lists keep their
      // caller-provided page size.
      const effectiveLimit = currentUser ? limit : Math.min(limit, 3);

      const campaignService = new CampaignService(db);
      const result = await campaignService.getCampaignsList({
        user: currentUser,
        category,
        contentType,
        search,
        status,
        customCategoryId,
        page,
        limit: effectiveLimit,
      });

      // Keep the action response aligned with GET /campaigns. The POST
      // gateway does not record impressions because it is an action/read
      // dispatcher rather than the public page-list request itself.
      const impressionService = new ImpressionService(db, c.env.CACHE_KV);
      const statsMap = await impressionService.getStatsForCampaigns(
        result.items.map((item) => item.id),
      );
      const itemsWithStats = result.items.map((item) => ({
        ...item,
        ...(statsMap[item.id] ?? { totalImpressions: 0, uniqueViewers: 0 }),
      }));

      return sendSuccess(c, { ...result, items: itemsWithStats });
    }

    case "campaigns/create": {
      const postConfig = await settingsService.getSetting<PostConfig>("post", DEFAULT_POST_CONFIG);
      const rateLimitErr = await checkRateLimit(c, {
        limit: postConfig.maxPostPerDay,
        windowSeconds: 86400,
        keyPrefix: "campaign_create",
        message: `Post limit reached. You can only publish a maximum of ${postConfig.maxPostPerDay} posts per day from your IP address.`,
      });
      if (rateLimitErr) return sendError(c, rateLimitErr, null, 429);

      const currentUser = await authenticate(c);
      const parseResult = createCampaignSchema.safeParse(payloadData);
      if (!parseResult.success) {
        return sendError(
          c,
          parseResult.error.errors[0]?.message || "Validation error",
          parseResult.error.format(),
        );
      }
      if (!validateVideoLimit(parseResult.data.videoUrls, currentUser.role === "ADMIN", postConfig.maxUploadVideo)) {
        return sendError(c, `Maximum ${postConfig.maxUploadVideo} videos allowed per campaign`, null, 400);
      }
      if (!validateImageLimit(parseResult.data.images, currentUser.role === "ADMIN", postConfig.maxUploadImage)) {
        return sendError(c, `Maximum ${postConfig.maxUploadImage} images allowed per campaign`, null, 400);
      }
      const campaignService = new CampaignService(db);
      const newCampaign = await campaignService.createCampaign(
        currentUser.id,
        parseResult.data,
        currentUser.role === "ADMIN",
      );
      await auditLogService.createLog(
        "CAMPAIGN_CREATE",
        currentUser.id,
        getClientIp(c),
        JSON.stringify({
          campaignId: newCampaign?.id,
          title: newCampaign?.title,
        }),
      );
      if (newCampaign && newCampaign.status === "PUBLIC") {
        const dispatchService = new CampaignDispatchService(db);
        await dispatchService.dispatchNewCampaignNotifications(newCampaign);
      }
      return sendSuccess(c, newCampaign, "Campaign created successfully");
    }

    case "campaigns/admin-users": {
      const currentUser = await authenticate(c, true);
      if (currentUser.role !== "ADMIN") return sendError(c, "Forbidden", null, 403);

      const campaignService = new CampaignService(db);
      const result = await campaignService.getAdminCampaignUsers({
        page: Number(payloadData?.page) || 1,
        limit: 3,
        search: typeof payloadData?.search === "string" ? payloadData.search.trim() || undefined : undefined,
      });
      return sendSuccess(c, { ...result, total: result.pagination.total, totalPages: result.pagination.totalPages });
    }

    case "campaigns/admin-user-campaigns": {
      const currentUser = await authenticate(c, true);
      if (currentUser.role !== "ADMIN") return sendError(c, "Forbidden", null, 403);
      if (typeof payloadData?.userId !== "string" || !payloadData.userId) {
        return sendError(c, "User ID is required");
      }

      const campaignService = new CampaignService(db);
      const result = await campaignService.getAdminUserCampaigns(
        payloadData.userId,
        Number(payloadData?.page) || 1,
      );
      return sendSuccess(c, { ...result, total: result.pagination.total, totalPages: result.pagination.totalPages });
    }

    case "campaigns/get": {
      const currentUser = await authenticate(c);
      const campaignId = payloadData?.id;
      if (!campaignId) return sendError(c, "Campaign ID is required");
      const campaignService = new CampaignService(db);
      const campaign = await campaignService.getCampaignById(campaignId);
      if (!campaign) return sendError(c, "Campaign not found", null, 404);
      if (
        currentUser.role !== "ADMIN" &&
        campaign.userId !== currentUser.id
      ) {
        return sendError(c, "Forbidden", null, 403);
      }
      return sendSuccess(c, campaign);
    }

    case "campaigns/update-status": {
      const currentUser = await authenticate(c);
      const parseResult = updateCampaignStatusSchema.safeParse(payloadData);
      if (!parseResult.success) {
        return sendError(
          c,
          parseResult.error.errors[0]?.message || "Validation error",
          parseResult.error.format(),
        );
      }
      const campaignId = payloadData?.id;
      if (!campaignId) return sendError(c, "Campaign ID is required");
      const campaignService = new CampaignService(db);
      const campaign = await campaignService.getCampaignById(campaignId);
      if (!campaign) return sendError(c, "Campaign not found", null, 404);
      if (
        currentUser.role !== "ADMIN" &&
        campaign.userId !== currentUser.id
      ) {
        return sendError(c, "Forbidden", null, 403);
      }
      const updated = await campaignService.updateCampaignStatus(
        campaignId,
        parseResult.data.status,
      );
      await auditLogService.createLog(
        "CAMPAIGN_UPDATE_STATUS",
        currentUser.id,
        getClientIp(c),
        JSON.stringify({ campaignId, newStatus: parseResult.data.status }),
      );
      if (updated && updated.status === "PUBLIC" && campaign.status !== "PUBLIC") {
        const dispatchService = new CampaignDispatchService(db);
        await dispatchService.dispatchNewCampaignNotifications(updated);
      }
      return sendSuccess(c, updated);
    }

    case "campaigns/update": {
      const currentUser = await authenticate(c);
      const campaignId = payloadData?.id;
      if (!campaignId) return sendError(c, "Campaign ID is required");
      const parseResult = updateCampaignSchema.safeParse(payloadData);
      if (!parseResult.success) {
        return sendError(
          c,
          parseResult.error.errors[0]?.message || "Validation error",
          parseResult.error.format(),
        );
      }
      const postConfig = await settingsService.getSetting<PostConfig>("post", DEFAULT_POST_CONFIG);
      if (!validateVideoLimit(parseResult.data.videoUrls, currentUser.role === "ADMIN", postConfig.maxUploadVideo)) {
        return sendError(c, `Maximum ${postConfig.maxUploadVideo} videos allowed per campaign`, null, 400);
      }
      if (!validateImageLimit(parseResult.data.images, currentUser.role === "ADMIN", postConfig.maxUploadImage)) {
        return sendError(c, `Maximum ${postConfig.maxUploadImage} images allowed per campaign`, null, 400);
      }
      const campaignService = new CampaignService(db);
      const campaign = await campaignService.getCampaignById(campaignId);
      if (!campaign) return sendError(c, "Campaign not found", null, 404);
      if (
        currentUser.role !== "ADMIN" &&
        campaign.userId !== currentUser.id
      ) {
        return sendError(c, "Forbidden", null, 403);
      }
      const updated = await campaignService.updateCampaign(
        campaignId,
        parseResult.data,
        currentUser.role === "ADMIN",
      );
      await auditLogService.createLog(
        "CAMPAIGN_UPDATE",
        currentUser.id,
        getClientIp(c),
        JSON.stringify({ campaignId, title: updated?.title }),
      );
      return sendSuccess(c, updated, "Campaign updated successfully");
    }

    case "campaigns/delete": {
      const currentUser = await authenticate(c);
      const campaignId = payloadData?.id;
      if (!campaignId) return sendError(c, "Campaign ID is required");
      const campaignService = new CampaignService(db);
      const campaign = await campaignService.getCampaignById(campaignId);
      if (!campaign) return sendError(c, "Campaign not found", null, 404);

      if (
        currentUser.role !== "ADMIN" &&
        campaign.userId !== currentUser.id
      ) {
        return sendError(c, "Forbidden", null, 403);
      }

      await campaignService.softDeleteCampaign(campaignId);
      return sendSuccess(
        c,
        { deleted: true, id: campaignId },
        "Campaign deleted successfully",
      );
    }

    default:
      return null;
  }
}
