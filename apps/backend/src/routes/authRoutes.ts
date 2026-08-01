import { Hono } from "hono";
import { zValidator } from "@hono/zod-validator";
import type { HonoEnv } from "../types/env";
import { getDb } from "../db/index";
import { AuthService } from "../services/authService";
import { AuditLogService } from "../services/auditLogService";
import { sendSuccess, sendError } from "../utils/response";
import { getClientIp } from "../utils/ip";
import { getJwtSecret } from "../utils/env";
import { zodErrorHandler } from "../utils/validation";
import { registerRateLimiter } from "../middlewares/rateLimiter";
import { registerSchema, loginSchema, googleSchema } from "../schemas/auth";

// Re-export schemas consumed by actionRoutes.ts
export { registerSchema, loginSchema, googleSchema } from "../schemas/auth";

export const authRoutes = new Hono<HonoEnv>()
  .post(
    "/register",
    registerRateLimiter(),
    zValidator("json", registerSchema, (result, c) => {
      if (!result.success) return zodErrorHandler(result, c);
    }),
    async (c) => {
      const {
        username,
        email,
        password,
        avatar,
        role,
        portfolioLink,
        country,
      } = c.req.valid("json");

      // Only allow ADMIN registration if the correct secret header is provided
      if (role === "ADMIN") {
        const adminSecret = c.req.header("x-admin-secret");
        if (!adminSecret || adminSecret !== c.env.ADMIN_SECRET) {
          return sendError(
            c,
            "Forbidden: invalid or missing admin secret",
            null,
            403,
          );
        }
      }

      const db = getDb(c.env.DB);
      const authService = new AuthService(db);
      const auditLogService = new AuditLogService(db);

      try {
        const data = await authService.register(
          username,
          email,
          password,
          role,
          avatar,
          getJwtSecret(c),
          portfolioLink,
          country,
        );
        await auditLogService.createLog(
          "USER_REGISTER",
          data.user.id,
          getClientIp(c),
          JSON.stringify({ email: data.user.email, role: data.user.role }),
        );
        return sendSuccess(c, data, "User registered successfully");
      } catch (err: any) {
        return sendError(c, err.message);
      }
    },
  )
  .post(
    "/login",
    zValidator("json", loginSchema, (result, c) => {
      if (!result.success) return zodErrorHandler(result, c);
    }),
    async (c) => {
      const { email, password } = c.req.valid("json");
      const db = getDb(c.env.DB);
      const authService = new AuthService(db);
      const auditLogService = new AuditLogService(db);

      try {
        const data = await authService.login(email, password, getJwtSecret(c));
        await auditLogService.createLog(
          "USER_LOGIN",
          data.user.id,
          getClientIp(c),
          JSON.stringify({ email: data.user.email }),
        );
        return sendSuccess(c, data, "Login successful");
      } catch (err: any) {
        return sendError(c, err.message);
      }
    },
  )
  .post(
    "/google",
    zValidator("json", googleSchema, (result, c) => {
      if (!result.success) return zodErrorHandler(result, c);
    }),
    async (c) => {
      const { idToken } = c.req.valid("json");
      const db = getDb(c.env.DB);
      const authService = new AuthService(db);
      const auditLogService = new AuditLogService(db);

      try {
        const data = await authService.googleLogin(idToken, getJwtSecret(c));
        await auditLogService.createLog(
          "USER_LOGIN_GOOGLE",
          data.user.id,
          getClientIp(c),
          JSON.stringify({ email: data.user.email }),
        );
        return sendSuccess(c, data, "Google login successful");
      } catch (err: any) {
        return sendError(c, err.message);
      }
    },
  );
