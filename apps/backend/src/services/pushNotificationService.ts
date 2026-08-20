import { eq, desc } from "drizzle-orm";
import type { DbClient } from "../db/index";
import { pushSubscriptions } from "../db/schema/pushSubscriptions";

export interface PushSubscriptionPayload {
  endpoint: string;
  keys: {
    p256dh: string;
    auth: string;
  };
}

// Default VAPID Public Key for Web Push (can be overridden via ENV)
export const DEFAULT_VAPID_PUBLIC_KEY =
  "BEl62iUYgUivxIkv69yViEuiBIa-Ib9-Skv6b135n6-xR155eZ65eR65-vR65eR65eR65eR65eR65eR65eR65eR6=";

export class PushNotificationService {
  constructor(private db: DbClient) {}

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

    const summary = campaign.description
      ? campaign.description.replace(/<[^>]*>/g, "").slice(0, 120) + "..."
      : "Check out this new campaign post!";
    const campaignUrl = `${campaign.siteUrl.replace(/\/$/, "")}/article/${campaign.id}`;

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

        // Send HTTP POST payload directly to Push Service Endpoint (FCM/APNs/Mozilla)
        const response = await fetch(sub.endpoint, {
          method: "POST",
          headers: {
            "Content-Type": "application/json",
            "TTL": "86400", // Keep notification alive for 24 hours if device is offline
            "Urgency": "high"
          },
          body: pushPayload,
        });

        if (response.ok || response.status === 201 || response.status === 202) {
          successCount++;
        } else if (response.status === 404 || response.status === 410) {
          // Endpoint expired or unsubscribed -> Auto-clean dead subscription
          await this.removeSubscription(sub.endpoint).catch(() => null);
        }
      } catch (err) {
        console.warn("[PushNotificationService] Error sending push notification:", err);
      }
    }

    return { totalSubscriptions: subscriptions.length, attempted, successCount };
  }
}
