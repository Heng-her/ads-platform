import { Hono } from "hono";
import { zValidator } from "@hono/zod-validator";
import { z } from "zod";
import type { HonoEnv } from "../types/env";
import { getDb } from "../db/index";
import { UserService } from "../services/userService";
import { authMiddleware, requireRole } from "../middlewares/auth";
import { sendSuccess, sendError } from "../utils/response";

export const updateUserStatusSchema = z.object({
  status: z.enum(["ACTIVE", "SUSPENDED", "PENDING"])
});

export const userRoutes = new Hono<HonoEnv>()
  .use("*", authMiddleware())
  .get("/me", async (c) => {
    const userPayload = c.get("user");
    if (!userPayload) return sendError(c, "Unauthorized", null, 401);

    const db = getDb(c.env.DB);
    const userService = new UserService(db);
    const user = await userService.getUserById(userPayload.id);

    if (!user) return sendError(c, "User not found", null, 404);
    return sendSuccess(c, user);
  })
  .get("/", requireRole(["ADMIN"]), async (c) => {
    const db = getDb(c.env.DB);
    const userService = new UserService(db);
    const usersList = await userService.getAllUsers();
    return sendSuccess(c, usersList);
  })
  .get("/:id", requireRole(["ADMIN"]), async (c) => {
    const id = c.req.param("id");
    const db = getDb(c.env.DB);
    const userService = new UserService(db);
    const user = await userService.getUserById(id);
    if (!user) return sendError(c, "User not found", null, 404);
    return sendSuccess(c, user);
  })
  .patch("/:id/status", requireRole(["ADMIN"]), zValidator("json", updateUserStatusSchema, (result, c) => {
    if (!result.success) {
      return sendError(c, result.error.errors[0]?.message || "Validation error", result.error.format());
    }
  }), async (c) => {
    const id = c.req.param("id");
    const { status } = c.req.valid("json");
    const db = getDb(c.env.DB);
    const userService = new UserService(db);

    const updatedUser = await userService.updateUserStatus(id, status);
    return sendSuccess(c, updatedUser);
  });
