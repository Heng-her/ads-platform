import type { DbClient } from "../db/index";
import { UserService } from "../services/userService";
import {
  SystemSettingsService,
  DEFAULT_PLATFORM_CONFIG,
  type PlatformConfig,
} from "../services/systemSettingsService";

export type UserActionAlertType = "DEMOTE" | "PROMOTE" | "SUSPEND" | "DELETE";

export async function sendUserManagementTelegramAlert(
  db: DbClient,
  actionType: UserActionAlertType,
  targetUser: {
    id: string;
    username?: string | null;
    email?: string | null;
    role?: string | null;
    status?: string | null;
  },
  adminUserId: string,
  oldRole?: string,
) {
  try {
    const userService = new UserService(db);
    const settingsService = new SystemSettingsService({ db });
    const platformConfig = await settingsService.getSetting<PlatformConfig>(
      "platform",
      DEFAULT_PLATFORM_CONFIG,
    );
    const siteUrl = platformConfig.siteUrl || "http://localhost:3000";

    const adminUser = await userService.getUserById(adminUserId);
    const adminName = adminUser?.username || "Admin";
    const adminEmail = adminUser?.email || "N/A";

    const username = targetUser.username || "N/A";
    const email = targetUser.email || "No Email";
    const approvalsUrl = `${siteUrl.replace(/\/+$/, "")}/admin/approvals`;

    let alertMsg = "";

    switch (actionType) {
      case "DEMOTE":
        alertMsg =
          `⬇️ <b>[USER DEMOTED TO CREATOR]</b>\n\n` +
          `👤 <b>Target User:</b> ${username} (${email})\n` +
          `🆔 <b>User ID:</b> <code>${targetUser.id}</code>\n` +
          `🔄 <b>Role Change:</b> <code>ADMIN</code> ➔ <code>CREATOR</code>\n` +
          `🛡️ <b>Action By:</b> ${adminName} (${adminEmail})\n\n` +
          `⚡ <a href="${approvalsUrl}">Open Admin Approvals</a>`;
        break;

      case "PROMOTE":
        alertMsg =
          `🛡️ <b>[USER PROMOTED TO ADMIN]</b>\n\n` +
          `👤 <b>Target User:</b> ${username} (${email})\n` +
          `🆔 <b>User ID:</b> <code>${targetUser.id}</code>\n` +
          `🔄 <b>Role Change:</b> <code>${oldRole || "CREATOR"}</code> ➔ <code>ADMIN</code>\n` +
          `🛡️ <b>Action By:</b> ${adminName} (${adminEmail})\n\n` +
          `⚡ <a href="${approvalsUrl}">Open Admin Approvals</a>`;
        break;

      case "SUSPEND":
        alertMsg =
          `⛔ <b>[USER ACCOUNT SUSPENDED]</b>\n\n` +
          `👤 <b>Target User:</b> ${username} (${email})\n` +
          `🆔 <b>User ID:</b> <code>${targetUser.id}</code>\n` +
          `⚠️ <b>New Status:</b> <code>SUSPENDED</code>\n` +
          `🛡️ <b>Action By:</b> ${adminName} (${adminEmail})\n\n` +
          `⚡ <a href="${approvalsUrl}">Open Admin Approvals</a>`;
        break;

      case "DELETE":
        alertMsg =
          `🗑️ <b>[CREATOR ACCOUNT DELETED]</b>\n\n` +
          `👤 <b>Deleted Creator:</b> ${username} (${email})\n` +
          `🆔 <b>User ID:</b> <code>${targetUser.id}</code>\n` +
          `⚠️ <b>Account Type:</b> <code>${targetUser.role || "CREATOR"}</code>\n` +
          `🛡️ <b>Action By:</b> ${adminName} (${adminEmail})\n\n` +
          `⚡ <a href="${approvalsUrl}">Open Admin Approvals</a>`;
        break;
    }

    if (alertMsg) {
      const res = await settingsService.sendAdminAlert(alertMsg);
      if (!res.success) {
        console.info(`ℹ️ [UserAlert] Telegram alert status: ${res.message}`);
      }
    }
  } catch (err) {
    console.warn("⚠️ [UserAlert] Failed to send Telegram admin alert:", err);
  }
}
