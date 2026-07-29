import { Hono } from "hono";
import { zValidator } from "@hono/zod-validator";
import { z } from "zod";
import type { HonoEnv } from "../types/env";
import { getDb } from "../db/index";
import { UserService } from "../services/userService";
import { AuditLogService } from "../services/auditLogService";
import { authMiddleware, requireRole } from "../middlewares/auth";
import { sendSuccess, sendError } from "../utils/response";
import { getClientIp } from "../utils/ip";

export const updateUserStatusSchema = z.object({
  status: z.enum(["ACTIVE", "SUSPENDED", "PENDING"]),
});

export const userRoutes = new Hono<HonoEnv>()
  // 1. Get Current Logged-in User Profile (Authenticated)
  .get("/me", authMiddleware(), async (c) => {
    const userPayload = c.get("user");
    if (!userPayload) return sendError(c, "Unauthorized", null, 401);

    const db = getDb(c.env.DB);
    const userService = new UserService(db);
    const user = await userService.getUserById(userPayload.id);

    if (!user) return sendError(c, "User not found", null, 404);
    return sendSuccess(c, user);
  })
  // 2. Get Public User Profile by ID (Public Access - No Token Required)
  .get("/:id", async (c) => {
    const id = c.req.param("id");
    const db = getDb(c.env.DB);
    const userService = new UserService(db);
    const user = await userService.getPublicUserById(id);

    if (!user) return sendError(c, "User not found", null, 404);
    return sendSuccess(c, user);
  })
  // 3. Get All Users (Admin Only)
  .get("/", authMiddleware(), requireRole(["ADMIN"]), async (c) => {
    const db = getDb(c.env.DB);
    const userService = new UserService(db);
    const usersList = await userService.getAllUsers();
    return sendSuccess(c, usersList);
  })
  // 4. Update User Status (Admin Only)
  .patch(
    "/:id/status",
    authMiddleware(),
    requireRole(["ADMIN"]),
    zValidator("json", updateUserStatusSchema, (result, c) => {
      if (!result.success) {
        return sendError(
          c,
          result.error.errors[0]?.message || "Validation error",
          result.error.format(),
        );
      }
    }),
    async (c) => {
      const id = c.req.param("id");
      const userPayload = c.get("user")!;
      const { status } = c.req.valid("json");
      const db = getDb(c.env.DB);
      const userService = new UserService(db);
      const auditLogService = new AuditLogService(db);

      const updatedUser = await userService.updateUserStatus(id, status);
      await auditLogService.createLog(
        "USER_UPDATE_STATUS",
        userPayload.id,
        getClientIp(c),
        JSON.stringify({ targetUserId: id, newStatus: status }),
      );
      return sendSuccess(c, updatedUser);
    },
  );
