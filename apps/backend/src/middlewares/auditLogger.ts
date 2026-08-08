import type { MiddlewareHandler } from "hono";
import type { HonoEnv } from "../types/env";
import { getDb } from "../db/index";
import { AuditLogService } from "../services/auditLogService";
import { getClientIp } from "../utils/ip";
import { getJwtSecret } from "../utils/env";
import { extractBearerToken, verifyToken } from "../utils/jwt";

export const globalAuditLogger = (): MiddlewareHandler<HonoEnv> => {
  return async (c, next) => {
    // Skip OPTIONS preflight, root health check, and GET requests (to reduce noise)
    if (c.req.method === "OPTIONS" || c.req.path === "/" || c.req.method === "GET") {
      return await next();
    }

    const startTime = Date.now();
    await next();

    try {
      const db = getDb(c.env.DB);
      const auditLogService = new AuditLogService(db);

      // Extract user ID from Hono context or Authorization header
      let userId: string | undefined = c.get("user")?.id;

      if (!userId) {
        const token = extractBearerToken(c.req.header("Authorization"));
        if (token) {
          const user = await verifyToken(token, getJwtSecret(c));
          if (user) userId = user.id;
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

      if (c.executionCtx?.waitUntil) {
        c.executionCtx.waitUntil(logPromise);
      } else {
        await logPromise;
      }
    } catch (err) {
      console.error("Global audit logger error:", err);
    }
  };
};
