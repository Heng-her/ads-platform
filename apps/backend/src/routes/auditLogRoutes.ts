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
      const parseDate = (value?: string) => {
        if (!value) return undefined;
        const parsed = new Date(value);
        return Number.isNaN(parsed.getTime()) ? null : parsed;
      };
      const from = parseDate(c.req.query("from"));
      const to = parseDate(c.req.query("to"));
      if (from === null || to === null) return sendError(c, "Invalid date filter", null, 400);
      const db = getDb(c.env.DB);
      const auditLogService = new AuditLogService(db);
      const logs = await auditLogService.getLogs({
        page: Number(c.req.query("page")) || 1,
        limit: Number(c.req.query("limit")) || 25,
        ipAddress: c.req.query("ipAddress") || undefined,
        device: c.req.query("device") || undefined,
        from: from || undefined,
        to: to || undefined,
      });
      return sendSuccess(c, logs);
    } catch (err: any) {
      return sendError(c, err.message || "Failed to fetch audit logs");
    }
  })
  .delete("/", async (c) => {
    try {
      const beforeValue = c.req.query("before");
      const before = beforeValue ? new Date(beforeValue) : undefined;
      if (before && Number.isNaN(before.getTime())) return sendError(c, "Invalid clear date", null, 400);
      const db = getDb(c.env.DB);
      const auditLogService = new AuditLogService(db);
      const result = await auditLogService.clearLogs(before);
      if (result) return sendSuccess(c, result, "Audit logs cleared successfully");
      return sendError(c, "Failed to clear audit logs");
    } catch (err: any) {
      return sendError(c, err.message || "Failed to clear audit logs");
    }
  });
