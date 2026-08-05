import type { Context } from "hono";
import type { HonoEnv, UserJwtPayload } from "../types/env";
import type { DbClient } from "../db/index";
import { DashboardService } from "../services/dashboardService";
import { sendSuccess, sendError } from "../utils/response";

export async function handleDashboardAction(
  c: Context<HonoEnv>,
  db: DbClient,
  action: string,
  authenticate: (c: Context<HonoEnv>, strict?: boolean) => Promise<UserJwtPayload>,
) {
  switch (action) {
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
      return null;
  }
}
