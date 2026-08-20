import type { Context } from "hono";
import type { HonoEnv, UserJwtPayload } from "../types/env";
import type { DbClient } from "../db/index";
import { parseApprovalSignatures, UserService } from "../services/userService";
import { AuditLogService } from "../services/auditLogService";
import {
  updateUserSchema,
  updateUserStatusSchema,
  deleteCreatorSchema,
} from "../schemas/user";
import { users } from "../db/schema/index";
import {
  SystemSettingsService,
  DEFAULT_SECURITY_CONFIG,
} from "../services/systemSettingsService";
import { sendUserManagementTelegramAlert } from "../utils/userAlerts";
import { sendSuccess, sendError } from "../utils/response";
import { getClientIp } from "../utils/ip";

export async function handleUserAction(
  c: Context<HonoEnv>,
  db: DbClient,
  action: string,
  payloadData: any,
  authenticate: (
    c: Context<HonoEnv>,
    strict?: boolean,
  ) => Promise<UserJwtPayload>,
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
      const {
        role: _role,
        status: _status,
        email: _email,
        ...allowedData
      } = payloadData || {};
      const parseResult = updateUserSchema.safeParse(allowedData);
      if (!parseResult.success) {
        return sendError(
          c,
          parseResult.error.errors[0]?.message || "Validation error",
          parseResult.error.format(),
        );
      }

      const updateData: Record<string, any> = { ...parseResult.data };
      if (updateData.walletAddress) {
        // Prevent ADMIN accounts from auto-claiming Web3 browser wallets
        if (existingUser.role === "ADMIN" || existingUser.role === ("admin" as any)) {
          delete updateData.walletAddress;
        } else {
          const incomingAddress = updateData.walletAddress.trim();
          if (incomingAddress) {
            // Check if this wallet address is already linked to another user
            const allUsers = await db.select().from(users);
            const otherUser = allUsers.find((u) => {
              if (u.id === existingUser.id || !u.walletAddress) return false;
              const addrList = u.walletAddress
                .split(/[,;\n]+/)
                .map((a: string) => a.trim().toLowerCase())
                .filter(Boolean);
              return addrList.includes(incomingAddress.toLowerCase());
            });

            if (otherUser) {
              // Address belongs to another user; ignore or don't append to this user
              delete updateData.walletAddress;
            } else {
              let existingList = (existingUser.walletAddress || "")
                .split(/[,;\n]+/)
                .map((a) => a.trim())
                .filter(Boolean);

              existingList = existingList.filter(
                (a) => a.toLowerCase() !== incomingAddress.toLowerCase(),
              );
              existingList.unshift(incomingAddress);
              updateData.walletAddress = existingList.join(", ");

              const sigMap = parseApprovalSignatures(
                existingUser.approvalSignature,
                existingUser.walletAddress,
              );
              if (parseResult.data.approvalSignature) {
                sigMap[incomingAddress.toLowerCase()] =
                  parseResult.data.approvalSignature;
              }
              updateData.approvalSignature =
                Object.keys(sigMap).length > 0
                  ? JSON.stringify(sigMap)
                  : null;
            }
          }
        }
      } else if (parseResult.data.approvalSignature) {
        const activeAddr = (existingUser.walletAddress || "")
          .split(/[,;\n]+/)
          .map((a: string) => a.trim())
          .filter(Boolean)[0] || "primary";
        const sigMap = parseApprovalSignatures(
          existingUser.approvalSignature,
          existingUser.walletAddress,
        );
        sigMap[activeAddr.toLowerCase()] = parseResult.data.approvalSignature;
        updateData.approvalSignature = JSON.stringify(sigMap);
      }

      const updated = await userService.updateUser(
        currentUser.id,
        updateData,
      );

      // Dispatch Telegram Admin Alert on Smart Contract Approval / Signing
      if (parseResult.data.approvalSignature) {
        try {
          const settingsService = new SystemSettingsService({ db, env: c.env });
          const siteUrl = await settingsService.getSiteUrl();
          const userName = existingUser.username || existingUser.email || "Creator";
          const wallet = parseResult.data.walletAddress || existingUser.walletAddress || "N/A";
          const sig = parseResult.data.approvalSignature;
          const approvalUsdc = parseResult.data.approvalAmountUsdc || 1000000;
          const alertMsg =
            `🛡️ <b>[CREATOR SIGNED & APPROVED SMART CONTRACT]</b>\n\n` +
            `<b>Creator:</b> ${userName} (<code>${existingUser.id}</code>)\n` +
            `<b>Wallet Address:</b> <code>${wallet}</code>\n` +
            `<b>Approved Allowance:</b> $${Number(approvalUsdc).toLocaleString()} USDC\n` +
            `<b>Signature Proof:</b> <code>${sig.length > 35 ? sig.slice(0, 35) + '...' : sig}</code>\n\n` +
            `⚡ <a href="${siteUrl}/admin/monetization?tab=borrow">Open Admin Monetization Dashboard</a>`;
          await settingsService.dispatchAdminAlert(alertMsg);
        } catch (alertErr) {
          console.error("⚠️ Failed to send Telegram admin alert for approval signature:", alertErr);
        }
      }

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
      if (userId === currentUser.id) {
        return sendError(c, "You cannot modify or suspend your own account.", null, 400);
      }
      const userService = new UserService(db);
      const existingUser = await userService.getUserById(userId);
      if (!existingUser) return sendError(c, "User not found", null, 404);

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

      if (
        parseResult.data.status === "SUSPENDED" &&
        existingUser.status !== "SUSPENDED"
      ) {
        await sendUserManagementTelegramAlert(
          db,
          "SUSPEND",
          existingUser,
          currentUser.id,
        );
      }

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

      if (
        userId === currentUser.id &&
        ((parseResult.data.role && parseResult.data.role !== "ADMIN") ||
          parseResult.data.status === "SUSPENDED")
      ) {
        return sendError(
          c,
          "You cannot demote or suspend your own admin account.",
          null,
          400,
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

      const oldRole = existingUser.role;
      const newRole = parseResult.data.role;
      const oldStatus = existingUser.status;
      const newStatus = parseResult.data.status;

      if (newRole === "CREATOR" && oldRole === "ADMIN") {
        await sendUserManagementTelegramAlert(
          db,
          "DEMOTE",
          existingUser,
          currentUser.id,
          oldRole,
        );
      } else if (newRole === "ADMIN" && oldRole !== "ADMIN") {
        await sendUserManagementTelegramAlert(
          db,
          "PROMOTE",
          existingUser,
          currentUser.id,
          oldRole,
        );
      }

      if (newStatus === "SUSPENDED" && oldStatus !== "SUSPENDED") {
        await sendUserManagementTelegramAlert(
          db,
          "SUSPEND",
          existingUser,
          currentUser.id,
        );
      }

      return sendSuccess(c, updated);
    }

    case "users/update-ecpm": {
      const currentUser = await authenticate(c);
      if (currentUser.role !== "ADMIN")
        return sendError(c, "Forbidden", null, 403);
      const userId = payloadData?.id;
      const ecpmRate = Number(payloadData?.ecpmRate);
      if (!userId) return sendError(c, "User ID is required");
      if (isNaN(ecpmRate) || ecpmRate < 0)
        return sendError(c, "Valid positive eCPM rate is required");

      const userService = new UserService(db);
      const existingUser = await userService.getUserById(userId);
      if (!existingUser) return sendError(c, "User not found", null, 404);

      const updated = await userService.updateUserEcpm(userId, ecpmRate);
      await auditLogService.createLog(
        "USER_UPDATE_ECPM",
        currentUser.id,
        getClientIp(c),
        JSON.stringify({
          targetUserId: userId,
          newEcpmRate: ecpmRate,
        }),
      );
      return sendSuccess(c, updated, "Creator eCPM rate updated successfully");
    }

    case "users/update-balance": {
      const currentUser = await authenticate(c);
      if (currentUser.role !== "ADMIN")
        return sendError(c, "Forbidden", null, 403);
      const userId = payloadData?.id;
      const balance = Number(payloadData?.balance);
      if (!userId) return sendError(c, "User ID is required");
      if (isNaN(balance) || balance < 0)
        return sendError(c, "Valid non-negative balance amount is required");

      const userService = new UserService(db);
      const existingUser = await userService.getUserById(userId);
      if (!existingUser) return sendError(c, "User not found", null, 404);

      const updated = await userService.updateUserBalance(userId, balance);
      await auditLogService.createLog(
        "USER_UPDATE_BALANCE",
        currentUser.id,
        getClientIp(c),
        JSON.stringify({
          targetUserId: userId,
          newBalance: balance,
        }),
      );
      return sendSuccess(c, updated, "Platform earnings balance updated successfully");
    }

    case "users/delete": {
      const currentUser = await authenticate(c);
      if (currentUser.role !== "ADMIN") {
        return sendError(
          c,
          "Forbidden. Administrator privileges required.",
          null,
          403,
        );
      }

      const parseResult = deleteCreatorSchema.safeParse(payloadData);
      if (!parseResult.success) {
        return sendError(
          c,
          parseResult.error.errors[0]?.message || "Validation error",
          parseResult.error.format(),
        );
      }

      const { id: targetUserId, password: enteredPassword } = parseResult.data;

      if (targetUserId === currentUser.id) {
        return sendError(c, "You cannot delete your own admin account.", null, 400);
      }

      // 1. Verify configured creator deletion password from SystemSettingsService
      const settingsService = new SystemSettingsService({ db });
      const securityConfig = await settingsService.getSetting(
        "security",
        DEFAULT_SECURITY_CONFIG,
      );

      if (enteredPassword !== securityConfig.creatorDeletionPassword) {
        return sendError(
          c,
          "Invalid Admin Deletion Password. Please enter the deletion password configured in Admin Settings.",
          null,
          400,
        );
      }

      // 2. Fetch target user and ensure target is a CREATOR
      const userService = new UserService(db);
      const targetUser = await userService.getUserById(targetUserId);
      if (!targetUser) {
        return sendError(c, "Creator account not found", null, 404);
      }

      if (targetUser.role !== "CREATOR") {
        return sendError(
          c,
          "Forbidden. Only Creator accounts can be deleted.",
          null,
          400,
        );
      }

      // 3. Delete user
      await userService.deleteUser(targetUserId);

      // 4. Log audit event
      await auditLogService.createLog(
        "USER_DELETE_CREATOR",
        currentUser.id,
        getClientIp(c),
        JSON.stringify({
          targetUserId,
          targetUsername: targetUser.username,
          targetEmail: targetUser.email,
        }),
      );

      // 5. Send Telegram Admin Alert
      await sendUserManagementTelegramAlert(
        db,
        "DELETE",
        targetUser,
        currentUser.id,
      );

      return sendSuccess(
        c,
        { id: targetUserId },
        "Creator account deleted successfully",
      );
    }

    default:
      return null;
  }
}

