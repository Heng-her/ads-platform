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
   * Broadcast a Chrome Push Notification to all stored Web Push Endpoints
   */
  async broadcastNewCampaignNotification(campaign: {
    id: string;
    title: string;
    description?: string | null;
    imageUrl?: string | null;
    siteUrl: string;
  }): Promise<{ totalSubscriptions: number; attempted: number }> {
    const subscriptions = await this.getAllSubscriptions();
    if (subscriptions.length === 0) {
      return { totalSubscriptions: 0, attempted: 0 };
    }

    const summary = campaign.description
      ? campaign.description.replace(/<[^>]*>/g, "").slice(0, 120) + "..."
      : "Check out this new campaign post!";
    const campaignUrl = `${campaign.siteUrl.replace(/\/$/, "")}/article/${campaign.id}`;

    const pushPayload = JSON.stringify({
      title: `📢 New Campaign: ${campaign.title}`,
      body: summary,
      icon: campaign.imageUrl || "/images/logo.png",
      url: campaignUrl,
      campaignId: campaign.id,
    });

    let attempted = 0;

    for (const sub of subscriptions) {
      try {
        attempted++;
        // Attempt HTTP POST to push service endpoint (Chrome FCM/Mozilla Push)
        await fetch(sub.endpoint, {
          method: "POST",
          headers: {
            "Content-Type": "application/json",
            TTL: "86400",
          },
          body: pushPayload,
        }).catch((err) => {
          console.warn(`⚠️ [PushNotificationService] Failed push dispatch to ${sub.endpoint.slice(0, 30)}:`, err);
        });
      } catch (err) {
        console.warn("[PushNotificationService] Error sending push notification:", err);
      }
    }

    return { totalSubscriptions: subscriptions.length, attempted };
  }
}
