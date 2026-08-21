import type { Context } from "hono";
import type { DbClient } from "../db/index";
import type { UserJwtPayload } from "../types/env";
import { PushNotificationService } from "../services/pushNotificationService";

export async function handlePushNotificationAction(options: {
  c: Context;
  db: DbClient;
  action: string;
  data: any;
  currentUser?: UserJwtPayload | null;
}) {
  const { db, action, data, currentUser } = options;
  const pushService = new PushNotificationService(db);

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

  return { code: 0, msg: `Unknown notification action: ${action}` };
}
