import type { Context } from "hono";
import type { DbClient } from "../db/index";
import type { UserJwtPayload } from "../types/env";
import { PushNotificationService } from "../services/pushNotificationService";
import { SubscriberService } from "../services/subscriberService";
import { SystemSettingsService } from "../services/systemSettingsService";

export async function handlePushNotificationAction(options: {
  c: Context;
  db: DbClient;
  action: string;
  data: any;
  currentUser?: UserJwtPayload | null;
}) {
  const { db, action, data, currentUser } = options;
  const pushService = new PushNotificationService(db);
  const subscriberService = new SubscriberService(db);
  const settingsService = new SystemSettingsService({ db });

  if (action === "notifications/subscribe") {
    try {
      const { endpoint, keys } = data || {};
      if (!endpoint || !keys?.p256dh || !keys?.auth) {
        return { code: 0, msg: "Invalid push subscription details." };
      }

      await pushService.saveSubscription(
        { endpoint, keys },
        currentUser?.id || null,
      );

      return {
        code: 1,
        msg: "Chrome push notification subscription saved successfully.",
        data: { subscribed: true },
      };
    } catch (err: any) {
      return {
        code: 0,
        msg: err.message || "Failed to save push subscription.",
      };
    }
  }

  if (action === "notifications/unsubscribe") {
    try {
      const { endpoint } = data || {};
      if (!endpoint) {
        return { code: 0, msg: "Push endpoint is required." };
      }

      await pushService.removeSubscription(endpoint);
      return {
        code: 1,
        msg: "Push notification subscription removed successfully.",
        data: { unsubscribed: true },
      };
    } catch (err: any) {
      return {
        code: 0,
        msg: err.message || "Failed to remove push subscription.",
      };
    }
  }

  if (action === "notifications/list") {
    try {
      const subscriptions = await pushService.getAllSubscriptions();
      return {
        code: 1,
        msg: "Fetched push subscriptions.",
        data: { total: subscriptions.length, items: subscriptions },
      };
    } catch (err: any) {
      return {
        code: 0,
        msg: err.message || "Failed to fetch push subscriptions.",
      };
    }
  }

  if (action === "notifications/send-custom") {
    if (!currentUser || currentUser.role !== "ADMIN") {
      return { code: 0, msg: "Unauthorized: Admin privileges required to dispatch notifications." };
    }

    const { targets, title, body, url, icon } = data || {};

    if (!title || !title.trim()) {
      return { code: 0, msg: "Notification title is required." };
    }
    if (!body || !body.trim()) {
      return { code: 0, msg: "Notification message body is required." };
    }
    if (!Array.isArray(targets) || targets.length === 0) {
      return { code: 0, msg: "Please select at least one notification target audience." };
    }

    const results: Record<string, any> = {};

    // Target 1: Chrome Web Push Devices
    if (targets.includes("chrome_push")) {
      try {
        const pushResult = await pushService.sendCustomPushNotification({
          title: title.trim(),
          body: body.trim(),
          url: url?.trim(),
          icon: icon?.trim() || "/ads-platform.png",
        });
        results.push = pushResult;
      } catch (err: any) {
        results.push = { error: err.message || "Failed to dispatch Web Push notifications." };
      }
    }

    // Target 2: Active Email Subscribers
    if (targets.includes("email_subscribers")) {
      try {
        const activeEmails = await subscriberService.getAllActiveSubscribers();
        let attempted = 0;
        let successCount = 0;

        for (const recipientEmail of activeEmails) {
          attempted++;
          const mailRes = await settingsService.testDispatchChannel("mail", {
            recipientEmail,
            customSubject: title.trim(),
            customMessage: body.trim() + (url ? `\n\nClick link to open: ${url}` : ""),
          });
          if (mailRes.success) {
            successCount++;
          }
        }

        results.email = { total: activeEmails.length, attempted, successCount };
      } catch (err: any) {
        results.email = { error: err.message || "Failed to dispatch emails to subscribers." };
      }
    }

    // Target 3: Telegram Public Channel
    if (targets.includes("telegram_public")) {
      try {
        const tgRes = await settingsService.testDispatchChannel("public_channel", {
          customMessage: `📢 <b>${title.trim()}</b>\n\n${body.trim()}${url ? `\n\n🔗 <a href="${url.trim()}">Click Here to View</a>` : ""}`,
        });
        results.telegramPublic = tgRes;
      } catch (err: any) {
        results.telegramPublic = { success: false, message: err.message };
      }
    }

    // Target 4: Telegram Admin Group
    if (targets.includes("telegram_admin")) {
      try {
        const tgAdminRes = await settingsService.testDispatchChannel("admin_group", {
          customMessage: `🛡️ <b>${title.trim()}</b>\n\n${body.trim()}${url ? `\n\n🔗 <a href="${url.trim()}">Click Here to View</a>` : ""}`,
        });
        results.telegramAdmin = tgAdminRes;
      } catch (err: any) {
        results.telegramAdmin = { success: false, message: err.message };
      }
    }

    const summaryParts: string[] = [];
    if (results.push) {
      summaryParts.push(`Chrome Push: ${results.push.successCount ?? 0}/${results.push.totalSubscriptions ?? 0} sent`);
    }
    if (results.email) {
      summaryParts.push(`Email: ${results.email.successCount ?? 0}/${results.email.total ?? 0} sent`);
    }
    if (results.telegramPublic) {
      summaryParts.push(`Telegram Channel: ${results.telegramPublic.success ? "Success" : "Failed"}`);
    }
    if (results.telegramAdmin) {
      summaryParts.push(`Telegram Admin Group: ${results.telegramAdmin.success ? "Success" : "Failed"}`);
    }

    return {
      code: 1,
      msg: `Custom notification broadcast completed! (${summaryParts.join(" • ")})`,
      data: results,
    };
  }

  return { code: 0, msg: `Unknown notification action: ${action}` };
}

