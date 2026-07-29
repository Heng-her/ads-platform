import { Hono } from "hono";
import { zValidator } from "@hono/zod-validator";
import { z } from "zod";
import type { HonoEnv } from "../types/env";
import { getDb } from "../db/index";
import { AuthService } from "../services/authService";
import { AuditLogService } from "../services/auditLogService";
import { sendSuccess, sendError } from "../utils/response";
import { getClientIp } from "../utils/ip";
import { registerRateLimiter } from "../middlewares/rateLimiter";

export const registerSchema = z.object({
  username: z.string().min(2, "Username must be at least 2 characters"),
  email: z.string().email("Invalid email address"),
  password: z.string().min(8, "Password must be at least 8 characters"),
  avatar: z.string().optional(),
  role: z.enum(["ADMIN", "CREATOR"]).optional().default("CREATOR")
});

export const loginSchema = z.object({
  email: z.string().email("Invalid email address"),
  password: z.string().min(1, "Password is required")
});

export const authRoutes = new Hono<HonoEnv>()
  .post("/register", registerRateLimiter(), zValidator("json", registerSchema, (result, c) => {
    if (!result.success) {
      return sendError(c, result.error.errors[0]?.message || "Validation error", result.error.format());
    }
  }), async (c) => {
    const { username, email, password, avatar, role } = c.req.valid("json");
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
        c.env.JWT_SECRET || "fallback-secret"
      );
      await auditLogService.createLog(
        "USER_REGISTER",
        data.user.id,
        getClientIp(c),
        JSON.stringify({ email: data.user.email, role: data.user.role })
      );
      return sendSuccess(c, data, "User registered successfully");
    } catch (err: any) {
      return sendError(c, err.message);
    }
  })
  .post("/login", zValidator("json", loginSchema, (result, c) => {
    if (!result.success) {
      return sendError(c, result.error.errors[0]?.message || "Validation error", result.error.format());
    }
  }), async (c) => {
    const { email, password } = c.req.valid("json");
    const db = getDb(c.env.DB);
    const authService = new AuthService(db);
    const auditLogService = new AuditLogService(db);

    try {
      const data = await authService.login(email, password, c.env.JWT_SECRET || "fallback-secret");
      await auditLogService.createLog(
        "USER_LOGIN",
        data.user.id,
        getClientIp(c),
        JSON.stringify({ email: data.user.email })
      );
      return sendSuccess(c, data, "Login successful");
    } catch (err: any) {
      return sendError(c, err.message);
    }
  });
