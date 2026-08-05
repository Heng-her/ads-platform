import type { Context } from "hono";
import type { HonoEnv, UserJwtPayload } from "../types/env";
import type { DbClient } from "../db/index";
import { AuditLogService } from "../services/auditLogService";
import { sendSuccess, sendError } from "../utils/response";

export async function handleAuditLogAction(
  c: Context<HonoEnv>,
  db: DbClient,
  action: string,
  authenticate: (c: Context<HonoEnv>, strict?: boolean) => Promise<UserJwtPayload>,
) {
  switch (action) {
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

    default:
      return null;
  }
}
