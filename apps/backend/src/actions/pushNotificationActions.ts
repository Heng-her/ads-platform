import type { Context } from "hono";
import type { DbClient } from "../db/index";
import type { UserJwtPayload } from "../types/env";
import { PushNotificationService } from "../services/pushNotificationService";
import { sendSuccess, sendError } from "../utils/response";

export async function handlePushNotificationAction(options: {
  c: Context;
  db: DbClient;
  action: string;
  data: any;
  currentUser?: UserJwtPayload | null;
}) {
  const { c, db, action, data, currentUser } = options;
  const pushService = new PushNotificationService(db);

  if (action === "notifications/subscribe") {
    try {
      const { endpoint, keys } = data || {};
      if (!endpoint || !keys?.p256dh || !keys?.auth) {
        return sendError(c, "Invalid push subscription details.", 400);
      }

      await pushService.saveSubscription(
        { endpoint, keys },
        currentUser?.id || null,
      );

      return sendSuccess(
        c,
        { subscribed: true },
        "Chrome push notification subscription saved successfully.",
      );
    } catch (err: any) {
      return sendError(
        c,
        err.message || "Failed to save push subscription.",
        500,
      );
    }
  }

  if (action === "notifications/unsubscribe") {
    try {
      const { endpoint } = data || {};
      if (!endpoint) {
        return sendError(c, "Push endpoint is required.", 400);
      }

      await pushService.removeSubscription(endpoint);
      return sendSuccess(
        c,
        { unsubscribed: true },
        "Push notification subscription removed successfully.",
      );
    } catch (err: any) {
      return sendError(
        c,
        err.message || "Failed to remove push subscription.",
        500,
      );
    }
  }

  if (action === "notifications/list") {
    try {
      const subscriptions = await pushService.getAllSubscriptions();
      return sendSuccess(
        c,
        { total: subscriptions.length, items: subscriptions },
        "Fetched push subscriptions.",
      );
    } catch (err: any) {
      return sendError(
        c,
        err.message || "Failed to fetch push subscriptions.",
        500,
      );
    }
  }

  return { code: 0, msg: `Unknown notification action: ${action}` };
}
