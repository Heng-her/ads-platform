import type { MiddlewareHandler } from "hono";
import { secureHeaders } from "hono/secure-headers";
import { cors } from "hono/cors";
import { bodyLimit } from "hono/body-limit";
import type { HonoEnv } from "../types/env";
import { sendError } from "../utils/response";

export const ipBlacklistMiddleware = (): MiddlewareHandler<HonoEnv> => {
  return async (c, next) => {
    const clientIp = c.req.header("cf-connecting-ip") || c.req.header("x-forwarded-for") || "unknown";

    if (clientIp !== "unknown" && c.env.CACHE_KV) {
      const isBlocked = await c.env.CACHE_KV.get(`blocked_ip:${clientIp}`);
      if (isBlocked) {
        return sendError(c, "Access forbidden. Your IP address has been blocked due to security policies.", null, 403);
      }
    }

    await next();
  };
};

export const corsMiddleware = () =>
  cors({
    origin: (origin) => {
      if (!origin) return "*";
      if (
        origin.startsWith("http://localhost:") ||
        origin.endsWith(".pages.dev") ||
        origin.endsWith(".workers.dev")
      ) {
        return origin;
      }
      return origin;
    },
    allowMethods: ["GET", "POST", "PUT", "DELETE", "OPTIONS", "PATCH"],
    allowHeaders: ["Content-Type", "Authorization", "X-Requested-With"],
    maxAge: 86400,
  });

export const securityHeadersMiddleware = () =>
  secureHeaders({
    xFrameOptions: "DENY",
    xContentTypeOptions: "nosniff",
    referrerPolicy: "strict-origin-when-cross-origin",
    strictTransportSecurity: "max-age=31536000; includeSubDomains"
  });

export const payloadLimitMiddleware = () =>
  async (c: Parameters<MiddlewareHandler<HonoEnv>>[0], next: Parameters<MiddlewareHandler<HonoEnv>>[1]) => {
    if (new URL(c.req.url).pathname === "/api/media/upload") {
      return next();
    }

    return bodyLimit({
      maxSize: 2 * 1024 * 1024,
      onError: (context) => {
        return sendError(context, "Payload size too large. Maximum allowed size is 2MB.", null, 413);
      },
    })(c, next);
  };
