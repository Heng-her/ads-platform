import { Hono } from "hono";
import { zValidator } from "@hono/zod-validator";
import { z } from "zod";
import type { HonoEnv } from "../types/env";
import { getDb } from "../db/index";
import { AuthService } from "../services/authService";
import { sendSuccess, sendError } from "../utils/response";

export const registerSchema = z.object({
  username: z.string().min(2, "Username must be at least 2 characters"),
  email: z.string().email("Invalid email address"),
  password: z.string().min(8, "Password must be at least 8 characters"),
  role: z.enum(["ADMIN", "CREATOR"]).optional().default("CREATOR")
});

export const loginSchema = z.object({
  email: z.string().email("Invalid email address"),
  password: z.string().min(1, "Password is required")
});

export const authRoutes = new Hono<HonoEnv>()
  .post("/register", zValidator("json", registerSchema, (result, c) => {
    if (!result.success) {
      return sendError(c, result.error.errors[0]?.message || "Validation error", result.error.format());
    }
  }), async (c) => {
    const { username, email, password, role } = c.req.valid("json");
    const db = getDb(c.env.DB);
    const authService = new AuthService(db);

    try {
      const data = await authService.register(username, email, password, role, c.env.JWT_SECRET || "fallback-secret");
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

    try {
      const data = await authService.login(email, password, c.env.JWT_SECRET || "fallback-secret");
      return sendSuccess(c, data, "Login successful");
    } catch (err: any) {
      return sendError(c, err.message);
    }
  });
