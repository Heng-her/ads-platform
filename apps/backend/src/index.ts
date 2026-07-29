import { Hono } from "hono";
import type { HonoEnv } from "./types/env";
import {
  corsMiddleware,
  securityHeadersMiddleware,
  ipBlacklistMiddleware,
  payloadLimitMiddleware,
} from "./middlewares/security";
import { rateLimiter } from "./middlewares/rateLimiter";
import { globalAuditLogger } from "./middlewares/auditLogger";
import { routes } from "./routes/index";
import { sendSuccess, sendError } from "./utils/response";

const app = new Hono<HonoEnv>();

// 1. Security Middlewares
app.use("*", corsMiddleware());
app.use("*", securityHeadersMiddleware());
app.use("*", ipBlacklistMiddleware());
app.use("*", payloadLimitMiddleware());

// Global Audit Logger for all API endpoints
app.use("/api/*", globalAuditLogger());

// 2. Global Rate Limiter (60 requests per minute per IP)
app.use("/api/*", rateLimiter({ limit: 60, windowSeconds: 60 }));

// 3. Strict Rate Limiter for Auth endpoints (10 attempts per minute per IP to prevent brute-force attacks)
app.use("/api/auth/*", rateLimiter({ limit: 10, windowSeconds: 60 }));

// Health Check
app.get("/", (c) => {
  return sendSuccess(
    c,
    {
      service: "Ads Platform Backend API",
      version: "1.0.0",
      timestamp: new Date().toISOString(),
    },
    "online",
  );
});

// 4. Register Routes under /api
app.route("/api", routes);

// 5. Global Error Handler
app.onError((err, c) => {
  console.error("Unhandled API Error:", err);
  return sendError(
    c,
    err.message || "Internal Server Error",
    c.env.ENVIRONMENT === "development" ? err.stack : null,
    500,
  );
});

// 404 Handler
app.notFound((c) => {
  return sendError(c, "Route not found", null, 404);
});

export default app;
export type { AppType } from "./routes/index";
