import { Hono, type Context } from "hono";
import type { HonoEnv, UserJwtPayload } from "../types/env";
import { getDb } from "../db/index";
import { AuthService } from "../services/authService";
import { UserService } from "../services/userService";
import { CampaignService } from "../services/campaignService";
import { AuditLogService } from "../services/auditLogService";
import { DashboardService } from "../services/dashboardService";
import { registerSchema, loginSchema } from "../schemas/auth";
import { createCampaignSchema, updateCampaignStatusSchema } from "../schemas/campaign";
import { updateUserStatusSchema } from "../schemas/user";
import { sendSuccess, sendError } from "../utils/response";
import { getClientIp } from "../utils/ip";
import { checkRateLimit } from "../middlewares/rateLimiter";
import { getJwtSecret } from "../utils/env";
import { extractBearerToken, verifyToken } from "../utils/jwt";

export const actionRoutes = new Hono<HonoEnv>();

/**
 * Helper to verify JWT token dynamically for actions requiring authentication
 */
async function authenticate(
  c: Context<HonoEnv>,
  strict: boolean = false,
): Promise<UserJwtPayload> {
  const authHeader = c.req.header("Authorization");

  // Dev Mode Bypass: Allowed only if strict is false
  if (!strict && !authHeader && c.env?.ENVIRONMENT === "development") {
    return {
      id: "dev-admin-id",
      email: "dev@admin.local",
      role: "ADMIN",
    };
  }

  const token = extractBearerToken(authHeader);
  if (!token) throw new Error("Unauthorized. Authorization token required.");

  const user = await verifyToken(token, getJwtSecret(c));
  if (!user) throw new Error("Unauthorized. Invalid or expired token.");
  return user;
}

/**
 * Unified POST Method Gateway: Handles all Create/Read/Update action dispatches
 */
actionRoutes.post("/", async (c) => {
  try {
    const body = await c.req.json();
    const action = body?.action;
    const payloadData = body?.data || {};

    if (!action || typeof action !== "string") {
      return sendError(c, "Missing or invalid 'action' field in request body.");
    }

    const db = getDb(c.env.DB);
    const auditLogService = new AuditLogService(db);

    switch (action) {
      // -------------------------------------------------------------
      // Auth Actions
      // -------------------------------------------------------------
      case "auth/register": {
        const rateLimitErr = await checkRateLimit(c, {
          limit: 2,
          windowSeconds: 86400,
          keyPrefix: "register",
          message: "Registration limit reached. You can only create a maximum of 2 accounts per day from your IP address."
        });
        if (rateLimitErr) return sendError(c, rateLimitErr, null, 429);

        const parseResult = registerSchema.safeParse(payloadData);
        if (!parseResult.success) {
          return sendError(
            c,
            parseResult.error.errors[0]?.message || "Validation error",
            parseResult.error.format(),
          );
        }
        const { username, email, password, avatar, role } = parseResult.data;
        const authService = new AuthService(db);
        const res = await authService.register(
          username,
          email,
          password,
          role,
          avatar,
          getJwtSecret(c),
        );
        await auditLogService.createLog(
          "USER_REGISTER",
          res.user.id,
          getClientIp(c),
          JSON.stringify({ email: res.user.email, role: res.user.role }),
        );
        return sendSuccess(c, res, "User registered successfully");
      }

      case "auth/login": {
        const parseResult = loginSchema.safeParse(payloadData);
        if (!parseResult.success) {
          return sendError(
            c,
            parseResult.error.errors[0]?.message || "Validation error",
            parseResult.error.format(),
          );
        }
        const { email, password } = parseResult.data;
        const authService = new AuthService(db);
        const res = await authService.login(
          email,
          password,
          getJwtSecret(c),
        );
        await auditLogService.createLog(
          "USER_LOGIN",
          res.user.id,
          getClientIp(c),
          JSON.stringify({ email: res.user.email }),
        );
        return sendSuccess(c, res, "Login successful");
      }

      // -------------------------------------------------------------
      // User Actions
      // -------------------------------------------------------------
      case "users/me": {
        const currentUser = await authenticate(c);
        const userService = new UserService(db);
        const user = await userService.getUserById(currentUser.id);
        if (!user) return sendError(c, "User not found", null, 404);
        return sendSuccess(c, user);
      }

      case "users/get": {
        const userId = payloadData?.id;
        if (!userId) return sendError(c, "User ID is required");
        const userService = new UserService(db);
        const user = await userService.getPublicUserById(userId);
        if (!user) return sendError(c, "User not found", null, 404);
        return sendSuccess(c, user);
      }

      case "users/list": {
        const currentUser = await authenticate(c);
        if (currentUser.role !== "ADMIN")
          return sendError(c, "Forbidden", null, 403);
        const userService = new UserService(db);
        const usersList = await userService.getAllUsers();
        return sendSuccess(c, usersList);
      }

      case "users/update-status": {
        const currentUser = await authenticate(c);
        if (currentUser.role !== "ADMIN")
          return sendError(c, "Forbidden", null, 403);
        const parseResult = updateUserStatusSchema.safeParse(payloadData);
        if (!parseResult.success) {
          return sendError(
            c,
            parseResult.error.errors[0]?.message || "Validation error",
            parseResult.error.format(),
          );
        }
        const userId = payloadData?.id;
        if (!userId) return sendError(c, "User ID is required");
        const userService = new UserService(db);
        const updated = await userService.updateUserStatus(
          userId,
          parseResult.data.status,
        );
        await auditLogService.createLog(
          "USER_UPDATE_STATUS",
          currentUser.id,
          getClientIp(c),
          JSON.stringify({
            targetUserId: userId,
            newStatus: parseResult.data.status,
          }),
        );
        return sendSuccess(c, updated);
      }

      // -------------------------------------------------------------
      // Campaign Actions
      // -------------------------------------------------------------
      case "campaigns/list": {
        let currentUser: UserJwtPayload | null = null;
        try {
          currentUser = await authenticate(c);
        } catch {
          // Public access if no token
        }
        const page = payloadData?.page ? Number(payloadData.page) : 1;
        const limit = payloadData?.limit ? Number(payloadData.limit) : 10;
        const category = payloadData?.category || undefined;
        const contentType = payloadData?.contentType || undefined;
        const search = payloadData?.search || undefined;
        const status = payloadData?.status === "DRAFT" || payloadData?.status === "PUBLIC" ? payloadData.status : undefined;

        const campaignService = new CampaignService(db);
        const result = await campaignService.getCampaignsList({
          user: currentUser,
          category,
          contentType,
          search,
          status,
          page,
          limit,
        });
        return sendSuccess(c, result);
      }

      case "campaigns/create": {
        const rateLimitErr = await checkRateLimit(c, {
          limit: 5,
          windowSeconds: 86400,
          keyPrefix: "campaign_create",
          message: "Post limit reached. You can only publish a maximum of 5 posts per day from your IP address."
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
        const campaignService = new CampaignService(db);
        const newCampaign = await campaignService.createCampaign(
          currentUser.id,
          parseResult.data
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
        return sendSuccess(c, newCampaign, "Campaign created successfully");
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
        return sendSuccess(c, updated);
      }

      // -------------------------------------------------------------
      // Audit Log Actions (ADMIN Only)
      // -------------------------------------------------------------
      case "audit-logs/list": {
        const currentUser = await authenticate(c, true);
        if (currentUser.role !== "ADMIN")
          return sendError(c, "Forbidden", null, 403);
        const auditLogService = new AuditLogService(db);
        const logs = await auditLogService.getAllLogs();
        return sendSuccess(c, logs);
      }

      case "audit-logs/clear": {
        const currentUser = await authenticate(c, true);
        if (currentUser.role !== "ADMIN")
          return sendError(c, "Forbidden", null, 403);
        const auditLogService = new AuditLogService(db);
        const success = await auditLogService.clearAllLogs();
        if (success) {
          return sendSuccess(c, null, "Audit logs cleared successfully");
        }
        return sendError(c, "Failed to clear audit logs");
      }

      // -------------------------------------------------------------
      // Dashboard Actions
      // -------------------------------------------------------------
      case "dashboard/me/stats": {
        const currentUser = await authenticate(c);
        const dashboardService = new DashboardService(db);
        const stats = await dashboardService.getCreatorStats(currentUser.id);
        return sendSuccess(c, stats);
      }

      case "dashboard/admin/stats": {
        const currentUser = await authenticate(c, true);
        if (currentUser.role !== "ADMIN")
          return sendError(c, "Forbidden", null, 403);
        const dashboardService = new DashboardService(db);
        const stats = await dashboardService.getAdminStats();
        return sendSuccess(c, stats);
      }

      default:
        return sendError(c, `Unknown action: '${action}'`, null, 400);
    }
  } catch (err: any) {
    if (err.message?.startsWith("Unauthorized")) {
      return sendError(c, err.message, null, 401);
    }
    return sendError(c, err.message || "Failed to process request");
  }
});

/**
 * Unified DELETE Method Gateway: Handles all Delete action dispatches
 */
actionRoutes.delete("/", async (c) => {
  try {
    const currentUser = await authenticate(c);
    const body = await c.req.json();
    const action = body?.action;
    const payloadData = body?.data || {};

    if (!action || typeof action !== "string") {
      return sendError(c, "Missing or invalid 'action' field in request body.");
    }

    const db = getDb(c.env.DB);

    switch (action) {
      case "campaigns/delete": {
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

        // Soft delete action logic
        await campaignService.softDeleteCampaign(campaignId);
        return sendSuccess(
          c,
          { deleted: true, id: campaignId },
          "Campaign deleted successfully",
        );
      }

      default:
        return sendError(c, `Unknown delete action: '${action}'`, null, 400);
    }
  } catch (err: any) {
    if (err.message?.startsWith("Unauthorized")) {
      return sendError(c, err.message, null, 401);
    }
    return sendError(c, err.message || "Failed to process delete action");
  }
});
