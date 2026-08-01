import { Hono } from "hono";
import type { HonoEnv } from "../types/env";
import { getDb } from "../db/index";
import { DashboardService } from "../services/dashboardService";
import { authMiddleware, requireRole } from "../middlewares/auth";
import { sendSuccess, sendError } from "../utils/response";

export const dashboardRoutes = new Hono<HonoEnv>()

  // ── GET /api/dashboard/me/stats — Creator: own campaign + impression summary
  .get(
    "/me/stats",
    authMiddleware(),
    requireRole(["CREATOR", "ADMIN"]),
    async (c) => {
      try {
        const userPayload = c.get("user")!;
        const db = getDb(c.env.DB);
        const dashboardService = new DashboardService(db);
        const stats = await dashboardService.getCreatorStats(userPayload.id);
        return sendSuccess(c, stats);
      } catch (err: any) {
        return sendError(c, err.message || "Failed to fetch creator dashboard stats");
      }
    },
  )

  // ── GET /api/dashboard/admin/stats — Admin: platform-wide stats
  .get(
    "/admin/stats",
    authMiddleware(),
    requireRole(["ADMIN"]),
    async (c) => {
      try {
        const db = getDb(c.env.DB);
        const dashboardService = new DashboardService(db);
        const stats = await dashboardService.getAdminStats();
        return sendSuccess(c, stats);
      } catch (err: any) {
        return sendError(c, err.message || "Failed to fetch admin dashboard stats");
      }
    },
  );
