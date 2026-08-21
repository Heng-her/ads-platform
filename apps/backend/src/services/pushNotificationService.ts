import { eq, desc } from "drizzle-orm";
import webpush from "web-push";
import type { DbClient } from "../db/index";
import { pushSubscriptions } from "../db/schema/pushSubscriptions";
import { SystemSettingsService, DEFAULT_DISPATCH_CONFIG } from "./systemSettingsService";

export interface PushSubscriptionPayload {
  endpoint: string;
  keys: {
    p256dh: string;
    auth: string;
  };
}

// Default VAPID Public Key for Web Push (can be overridden via system settings / ENV)
export const DEFAULT_VAPID_PUBLIC_KEY =
  "BMKHUIgMv3UqzA2igg6C0hLcsP3yaAsAObt0BA__P5dGO8mClLzR04Yt5E-6Ft233LhEgq8p13MtgjR5AVXSbj4";

export class PushNotificationService {
  private settingsService: SystemSettingsService;

  constructor(private db: DbClient) {
    this.settingsService = new SystemSettingsService({ db });
  }

  /**
   * Save or update a Web Push Subscription endpoint
   */
  async saveSubscription(
    payload: PushSubscriptionPayload,
    userId?: string | null,
  ): Promise<boolean> {
    if (!payload?.endpoint || !payload?.keys?.p256dh || !payload?.keys?.auth) {
      throw new Error("Invalid Push Subscription payload.");
    }

    const existing = await this.db
      .select()
      .from(pushSubscriptions)
      .where(eq(pushSubscriptions.endpoint, payload.endpoint))
      .get();

    if (existing) {
      await this.db
        .update(pushSubscriptions)
        .set({
          p256dh: payload.keys.p256dh,
          auth: payload.keys.auth,
          userId: userId || existing.userId || null,
        })
        .where(eq(pushSubscriptions.endpoint, payload.endpoint));
    } else {
      const id = `push_${Date.now()}_${Math.random().toString(36).slice(2, 8)}`;
      await this.db.insert(pushSubscriptions).values({
        id,
        endpoint: payload.endpoint,
        p256dh: payload.keys.p256dh,
        auth: payload.keys.auth,
        userId: userId || null,
        createdAt: new Date(),
      });
    }

    return true;
  }

  /**
   * Remove a Web Push Subscription by endpoint
   */
  async removeSubscription(endpoint: string): Promise<boolean> {
    if (!endpoint) return false;
    await this.db
      .delete(pushSubscriptions)
      .where(eq(pushSubscriptions.endpoint, endpoint));
    return true;
  }

  /**
   * Fetch all active push subscriptions from database
   */
  async getAllSubscriptions() {
    return await this.db
      .select()
      .from(pushSubscriptions)
      .orderBy(desc(pushSubscriptions.createdAt));
  }

  /**
   * Broadcast a Web Push Notification to all stored Web Push Endpoints
   */
  async broadcastNewCampaignNotification(campaign: {
    id: string;
    title: string;
    description?: string | null;
    imageUrl?: string | null;
    siteUrl: string;
  }): Promise<{ totalSubscriptions: number; attempted: number; successCount: number }> {
    const subscriptions = await this.getAllSubscriptions();
    if (subscriptions.length === 0) {
      return { totalSubscriptions: 0, attempted: 0, successCount: 0 };
    }

    // Load active VAPID key settings
    const dispatchConfig = await this.settingsService.getSetting("dispatch", DEFAULT_DISPATCH_CONFIG);
    const vapidPublicKey = dispatchConfig.vapidPublicKey || DEFAULT_VAPID_PUBLIC_KEY;
    const vapidPrivateKey = dispatchConfig.vapidPrivateKey;

    if (vapidPublicKey && vapidPrivateKey) {
      try {
        webpush.setVapidDetails(
          `mailto:${dispatchConfig.mailSenderEmail || "notifications@adsplatform.com"}`,
          vapidPublicKey,
          vapidPrivateKey,
        );
      } catch (e) {
        console.warn("[PushNotificationService] Failed to set VAPID details:", e);
      }
    }

    const summary = campaign.description
      ? campaign.description.replace(/<[^>]*>/g, "").slice(0, 120) + "..."
      : "Check out this new campaign post!";
    const titleSlug = campaign.title
      ? campaign.title
          .normalize("NFC")
          .toLowerCase()
          .trim()
          .replace(/[^\p{L}\p{M}\p{N}\s-]/gu, "")
          .replace(/[\s_-]+/g, "-")
          .replace(/^-+|-+$/g, "")
      : "";
    const articleSlug = titleSlug ? `${titleSlug}-${campaign.id}` : campaign.id;
    const campaignUrl = `${campaign.siteUrl.replace(/\/$/, "")}/article/${articleSlug}`;

    const pushPayload = JSON.stringify({
      title: `🚀 New Campaign: ${campaign.title}`,
      body: summary,
      icon: campaign.imageUrl || "/ads-platform.png",
      badge: "/ads-platform.png",
      url: campaignUrl,
      campaignId: campaign.id,
      timestamp: Date.now()
    });

    let attempted = 0;
    let successCount = 0;

    for (const sub of subscriptions) {
      try {
        attempted++;

        if (vapidPublicKey && vapidPrivateKey) {
          await webpush.sendNotification(
            {
              endpoint: sub.endpoint,
              keys: {
                p256dh: sub.p256dh,
                auth: sub.auth,
              },
            },
            pushPayload,
          );
          successCount++;
        } else {
          // Fallback to fetch POST if VAPID keys not configured
          const headers: Record<string, string> = {
            "Content-Type": "application/json",
            "TTL": "86400",
            "Urgency": "high",
          };
          const response = await fetch(sub.endpoint, {
            method: "POST",
            headers,
            body: pushPayload,
          });
          if (response.ok || response.status === 201 || response.status === 202) {
            successCount++;
          }
        }
      } catch (err: any) {
        const status = err?.statusCode || err?.status;
        if (status === 404 || status === 410 || status === 400 || status === 401) {
          // Endpoint expired, unsubscribed, or invalid VAPID token -> Auto-clean dead subscription
          await this.removeSubscription(sub.endpoint).catch(() => null);
        } else {
          console.warn("[PushNotificationService] Error sending push notification:", err);
        }
      }
    }

    return { totalSubscriptions: subscriptions.length, attempted, successCount };
  }
}
