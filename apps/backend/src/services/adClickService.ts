import { eq, sql, countDistinct, inArray } from "drizzle-orm";
import type { DbClient } from "../db/index";
import type { KVNamespace } from "@cloudflare/workers-types";
import { adClicks, campaigns, users } from "../db/schema/index";
import type { TrackAdClickInput } from "../schemas/ads";

// ─── KV Key Helpers ───────────────────────────────────────────────────────────
const kvClickTotalKey = (id: string) => `clicks:total:${id}`;
const kvClickUniqueKey = (id: string) => `clicks:unique:${id}`;
const kvClickSeenKey = (id: string, viewerHash: string) => {
  const date = new Date().toISOString().slice(0, 10); // "YYYY-MM-DD"
  return `clicks:seen:${id}:${viewerHash}:${date}`;
};

export class AdClickService {
  constructor(
    private db: DbClient,
    private kv: KVNamespace
  ) {}

  /**
   * Build a daily viewer fingerprint from IP + User-Agent.
   * SHA-256 hashed — no PII stored.
   */
  static async buildViewerHash(ip: string, userAgent: string): Promise<string> {
    const date = new Date().toISOString().slice(0, 10);
    const raw = `${ip}:${userAgent}:${date}`;
    const buf = await crypto.subtle.digest(
      "SHA-256",
      new TextEncoder().encode(raw)
    );
    return Array.from(new Uint8Array(buf))
      .map((b) => b.toString(16).padStart(2, "0"))
      .join("");
  }

  /**
   * Record a single first-party ad click.
   * - Derives authoritative creatorId from campaign relationship when campaignId exists
   * - Inserts click row in D1 ad_clicks table
   * - Increments KV total & unique click counters
   */
  async recordClick(
    input: TrackAdClickInput,
    viewerHash: string
  ): Promise<{ success: boolean; creatorId: string }> {
    let resolvedCampaignId: string | null = input.campaignId || null;
    let authoritativeCreatorId: string | null = null;

    // 1. Authoritative attribution lookup via campaignId
    if (resolvedCampaignId) {
      const campaign = await this.db
        .select({ id: campaigns.id, userId: campaigns.userId })
        .from(campaigns)
        .where(eq(campaigns.id, resolvedCampaignId))
        .get();

      if (campaign) {
        authoritativeCreatorId = campaign.userId;
      } else {
        // Invalid campaignId supplied
        resolvedCampaignId = null;
      }
    }

    // 2. If no valid campaign found, fallback to client creatorId if user exists
    if (!authoritativeCreatorId && input.creatorId) {
      const user = await this.db
        .select({ id: users.id })
        .from(users)
        .where(eq(users.id, input.creatorId))
        .get();

      if (user) {
        authoritativeCreatorId = user.id;
      }
    }

    // 3. Fallback to first available user or fallback string if DB empty
    if (!authoritativeCreatorId) {
      const fallbackUser = await this.db
        .select({ id: users.id })
        .from(users)
        .limit(1)
        .get();
      authoritativeCreatorId = fallbackUser?.id || "system";
    }

    // 4. Insert raw click into D1 ad_clicks table
    await this.db.insert(adClicks).values({
      id: crypto.randomUUID(),
      campaignId: resolvedCampaignId,
      creatorId: authoritativeCreatorId,
      provider: input.provider,
      format: input.format,
      placement: input.placement,
      viewerHash,
      createdAt: new Date(),
    });

    // 5. Update KV counters for campaign and/or creator
    const targetKeyId = resolvedCampaignId || authoritativeCreatorId;
    if (targetKeyId) {
      const totalKey = kvClickTotalKey(targetKeyId);
      const currentTotal = await this.kv.get(totalKey);
      await this.kv.put(
        totalKey,
        ((currentTotal ? parseInt(currentTotal, 10) : 0) + 1).toString()
      );

      const seenKey = kvClickSeenKey(targetKeyId, viewerHash);
      const alreadySeen = await this.kv.get(seenKey);
      if (!alreadySeen) {
        await this.kv.put(seenKey, "1", { expirationTtl: 90000 }); // ~25 hours
        const uniqueKey = kvClickUniqueKey(targetKeyId);
        const currentUnique = await this.kv.get(uniqueKey);
        await this.kv.put(
          uniqueKey,
          ((currentUnique ? parseInt(currentUnique, 10) : 0) + 1).toString()
        );
      }
    }

    return { success: true, creatorId: authoritativeCreatorId };
  }

  /**
   * Fetch outbound click stats for a given target ID (campaignId or creatorId).
   */
  async getClickStats(
    targetId: string
  ): Promise<{ totalClicks: number; uniqueClicks: number }> {
    const [totalStr, uniqueStr] = await Promise.all([
      this.kv.get(kvClickTotalKey(targetId)),
      this.kv.get(kvClickUniqueKey(targetId)),
    ]);

    if (totalStr !== null && uniqueStr !== null) {
      return {
        totalClicks: parseInt(totalStr, 10),
        uniqueClicks: parseInt(uniqueStr, 10),
      };
    }

    // Fallback query to D1
    const [totalRow, uniqueRow] = await Promise.all([
      this.db
        .select({ count: sql<number>`count(*)` })
        .from(adClicks)
        .where(
          sql`${adClicks.campaignId} = ${targetId} OR ${adClicks.creatorId} = ${targetId}`
        )
        .get(),
      this.db
        .select({ count: countDistinct(adClicks.viewerHash) })
        .from(adClicks)
        .where(
          sql`${adClicks.campaignId} = ${targetId} OR ${adClicks.creatorId} = ${targetId}`
        )
        .get(),
    ]);

    const total = totalRow?.count ?? 0;
    const unique = uniqueRow?.count ?? 0;

    // Warm KV cache
    await Promise.all([
      this.kv.put(kvClickTotalKey(targetId), total.toString()),
      this.kv.put(kvClickUniqueKey(targetId), unique.toString()),
    ]);

    return { totalClicks: total, uniqueClicks: unique };
  }
}
