import { Hono } from "hono";
import type { HonoEnv } from "../types/env";
import { getDb } from "../db/index";
import { AuditLogService } from "../services/auditLogService";
import { authMiddleware, requireRole } from "../middlewares/auth";
import { sendSuccess, sendError } from "../utils/response";

export const auditLogRoutes = new Hono<HonoEnv>()
  .use("*", authMiddleware({ strict: true }))
  .use("*", requireRole(["ADMIN"]))
  .get("/", async (c) => {
    try {
      const db = getDb(c.env.DB);
      const auditLogService = new AuditLogService(db);
      const logs = await auditLogService.getAllLogs();
      return sendSuccess(c, logs);
    } catch (err: any) {
      return sendError(c, err.message || "Failed to fetch audit logs");
    }
  })
  .delete("/", async (c) => {
    try {
      const db = getDb(c.env.DB);
      const auditLogService = new AuditLogService(db);
      const success = await auditLogService.clearAllLogs();
      if (success) {
        return sendSuccess(c, null, "Audit logs cleared successfully");
      }
      return sendError(c, "Failed to clear audit logs");
    } catch (err: any) {
      return sendError(c, err.message || "Failed to clear audit logs");
    }
  });
