import type { Context } from "hono";
import type { HonoEnv, UserJwtPayload } from "../types/env";
import type { DbClient } from "../db/index";
import { UserService } from "../services/userService";
import { AuditLogService } from "../services/auditLogService";
import { updateUserSchema, updateUserStatusSchema } from "../schemas/user";
import { sendSuccess, sendError } from "../utils/response";
import { getClientIp } from "../utils/ip";

export async function handleUserAction(
  c: Context<HonoEnv>,
  db: DbClient,
  action: string,
  payloadData: any,
  authenticate: (c: Context<HonoEnv>, strict?: boolean) => Promise<UserJwtPayload>,
) {
  const auditLogService = new AuditLogService(db);

  switch (action) {
    case "users/me": {
      const currentUser = await authenticate(c);
      const userService = new UserService(db);
      const user = await userService.getUserById(currentUser.id);
      if (!user) return sendError(c, "User not found", null, 404);
      return sendSuccess(c, user);
    }

    case "users/update-profile": {
      const currentUser = await authenticate(c);
      const userService = new UserService(db);
      const existingUser = await userService.getUserById(currentUser.id);
      if (!existingUser) return sendError(c, "User not found", null, 404);

      // Strip role and status to prevent privilege escalation
      const { role: _role, status: _status, email: _email, ...allowedData } = payloadData || {};
      const parseResult = updateUserSchema.safeParse(allowedData);
      if (!parseResult.success) {
        return sendError(
          c,
          parseResult.error.errors[0]?.message || "Validation error",
          parseResult.error.format(),
        );
      }

      const updated = await userService.updateUser(currentUser.id, parseResult.data);
      await auditLogService.createLog(
        "USER_UPDATE_PROFILE",
        currentUser.id,
        getClientIp(c),
        JSON.stringify({
          updatedFields: Object.keys(parseResult.data),
        }),
      );
      return sendSuccess(c, updated, "Profile updated successfully");
    }

    case "users/get": {
      const userId = payloadData?.id;
      if (!userId) return sendError(c, "User ID is required");
      const userService = new UserService(db);
      const user = await userService.getPublicUserById(userId);
      if (!user) return sendError(c, "User not found", null, 404);
      return sendSuccess(c, user);
    }

    case "users/list": {
      const currentUser = await authenticate(c);
      if (currentUser.role !== "ADMIN")
        return sendError(c, "Forbidden", null, 403);
      const userService = new UserService(db);
      const usersList = await userService.getAllUsers();
      return sendSuccess(c, usersList);
    }

    case "users/update-status": {
      const currentUser = await authenticate(c);
      if (currentUser.role !== "ADMIN")
        return sendError(c, "Forbidden", null, 403);
      const parseResult = updateUserStatusSchema.safeParse(payloadData);
      if (!parseResult.success) {
        return sendError(
          c,
          parseResult.error.errors[0]?.message || "Validation error",
          parseResult.error.format(),
        );
      }
      const userId = payloadData?.id;
      if (!userId) return sendError(c, "User ID is required");
      const userService = new UserService(db);
      const updated = await userService.updateUserStatus(
        userId,
        parseResult.data.status,
      );
      await auditLogService.createLog(
        "USER_UPDATE_STATUS",
        currentUser.id,
        getClientIp(c),
        JSON.stringify({
          targetUserId: userId,
          newStatus: parseResult.data.status,
        }),
      );
      return sendSuccess(c, updated);
    }

    case "users/update": {
      const currentUser = await authenticate(c);
      if (currentUser.role !== "ADMIN")
        return sendError(c, "Forbidden", null, 403);
      const userId = payloadData?.id;
      if (!userId) return sendError(c, "User ID is required");

      const parseResult = updateUserSchema.safeParse(payloadData);
      if (!parseResult.success) {
        return sendError(
          c,
          parseResult.error.errors[0]?.message || "Validation error",
          parseResult.error.format(),
        );
      }

      const userService = new UserService(db);
      const existingUser = await userService.getUserById(userId);
      if (!existingUser) return sendError(c, "User not found", null, 404);

      const updated = await userService.updateUser(userId, parseResult.data);
      await auditLogService.createLog(
        "USER_UPDATE_DETAILS",
        currentUser.id,
        getClientIp(c),
        JSON.stringify({
          targetUserId: userId,
          updatedFields: Object.keys(parseResult.data),
        }),
      );
      return sendSuccess(c, updated);
    }

    default:
      return null;
  }
}
