import type { MiddlewareHandler } from "hono";
import type { HonoEnv } from "../types/env";
import { getDb } from "../db/index";
import { AuditLogService } from "../services/auditLogService";
import { getClientIp } from "../utils/ip";
import { getJwtSecret } from "../utils/env";
import { jwtVerify } from "jose";

export const globalAuditLogger = (): MiddlewareHandler<HonoEnv> => {
  return async (c, next) => {
    const startTime = Date.now();

    await next();

    // Skip OPTIONS preflight or root health check
    if (c.req.method === "OPTIONS" || c.req.path === "/") {
      return;
    }

    try {
      const db = getDb(c.env.DB);
      const auditLogService = new AuditLogService(db);

      // Extract user ID from Hono context or Authorization header
      let userId: string | undefined = c.get("user")?.id;

      if (!userId) {
        const authHeader = c.req.header("Authorization");
        if (authHeader && authHeader.startsWith("Bearer ")) {
          try {
            const token = authHeader.substring(7);
            const secret = new TextEncoder().encode(getJwtSecret(c));
            const { payload } = await jwtVerify(token, secret);
            if (payload?.id) {
              userId = payload.id as string;
            }
          } catch {
            // Ignore invalid token in logger
          }
        }
      }

      const durationMs = Date.now() - startTime;
      const action = `${c.req.method} ${c.req.path}`;
      const ip = getClientIp(c);
      const details = JSON.stringify({
        status: c.res.status,
        duration: `${durationMs}ms`,
        userAgent: c.req.header("user-agent") || "unknown",
      });

      // Write log asynchronously
      const logPromise = auditLogService.createLog(action, userId, ip, details);

      // Auto-cleanup logs older than 30 days (720 hours)
      const cleanupPromise = auditLogService.cleanupOldLogs(30);

      if (c.executionCtx?.waitUntil) {
        c.executionCtx.waitUntil(Promise.all([logPromise, cleanupPromise]));
      } else {
        await Promise.all([logPromise, cleanupPromise]);
      }
    } catch (err) {
      console.error("Global audit logger error:", err);
    }
  };
};
