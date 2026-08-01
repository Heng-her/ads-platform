import { eq, sql, countDistinct, inArray } from "drizzle-orm";
import type { DbClient } from "../db/index";
import type { KVNamespace } from "@cloudflare/workers-types";
import { impressions } from "../db/schema/index";

// ─── KV key helpers ───────────────────────────────────────────────────────────
const kvTotalKey  = (campaignId: string) => `impressions:total:${campaignId}`;
const kvUniqueKey = (campaignId: string) => `impressions:unique:${campaignId}`;
const kvSeenKey   = (campaignId: string, viewerHash: string) => {
  const date = new Date().toISOString().slice(0, 10); // "YYYY-MM-DD"
  return `impressions:seen:${campaignId}:${viewerHash}:${date}`;
};

export class ImpressionService {
  constructor(
    private db: DbClient,
    private kv: KVNamespace,
  ) {}

  /**
   * Build a daily unique viewer fingerprint from IP + User-Agent.
   * SHA-256 hashed — no PII stored.
   */
  static async buildViewerHash(ip: string, userAgent: string): Promise<string> {
    const date = new Date().toISOString().slice(0, 10);
    const raw  = `${ip}:${userAgent}:${date}`;
    const buf  = await crypto.subtle.digest("SHA-256", new TextEncoder().encode(raw));
    return Array.from(new Uint8Array(buf))
      .map((b) => b.toString(16).padStart(2, "0"))
      .join("");
  }

  /**
   * Record a single impression for a campaign.
   * - Inserts a row in D1
   * - Increments KV total counter
   * - Increments KV unique counter only if this viewer hasn't been seen today
   */
  async recordImpression(campaignId: string, viewerHash: string): Promise<void> {
    // Write raw impression to D1
    await this.db.insert(impressions).values({
      id: crypto.randomUUID(),
      campaignId,
      viewerHash,
      createdAt: new Date(),
    });

    // Increment KV total
    const totalKey    = kvTotalKey(campaignId);
    const currentTotal = await this.kv.get(totalKey);
    await this.kv.put(totalKey, ((currentTotal ? parseInt(currentTotal, 10) : 0) + 1).toString());

    // Increment KV unique only once per viewer per day
    const seenKey    = kvSeenKey(campaignId, viewerHash);
    const alreadySeen = await this.kv.get(seenKey);
    if (!alreadySeen) {
      await this.kv.put(seenKey, "1", { expirationTtl: 90000 }); // ~25 hours
      const uniqueKey    = kvUniqueKey(campaignId);
      const currentUnique = await this.kv.get(uniqueKey);
      await this.kv.put(uniqueKey, ((currentUnique ? parseInt(currentUnique, 10) : 0) + 1).toString());
    }
  }

  /**
   * Get impression stats for a single campaign.
   * Reads KV first; falls back to D1 and warms KV if missing.
   */
  async getStats(campaignId: string): Promise<{
    totalImpressions: number;
    uniqueViewers: number;
  }> {
    const [totalStr, uniqueStr] = await Promise.all([
      this.kv.get(kvTotalKey(campaignId)),
      this.kv.get(kvUniqueKey(campaignId)),
    ]);

    if (totalStr !== null && uniqueStr !== null) {
      return {
        totalImpressions: parseInt(totalStr, 10),
        uniqueViewers: parseInt(uniqueStr, 10),
      };
    }

    return this._statsFromD1AndWarm([campaignId]).then((m) => m[campaignId] ?? { totalImpressions: 0, uniqueViewers: 0 });
  }

  /**
   * Batch-fetch impression stats for multiple campaign IDs.
   * Reads each counter from KV; any misses are resolved in a single D1 query.
   * Returns a map of campaignId → { totalImpressions, uniqueViewers }.
   */
  async getStatsForCampaigns(campaignIds: string[]): Promise<
    Record<string, { totalImpressions: number; uniqueViewers: number }>
  > {
    if (campaignIds.length === 0) return {};

    // Try KV for all IDs in parallel
    const kvResults = await Promise.all(
      campaignIds.map(async (id) => ({
        id,
        total:  await this.kv.get(kvTotalKey(id)),
        unique: await this.kv.get(kvUniqueKey(id)),
      })),
    );

    const result: Record<string, { totalImpressions: number; uniqueViewers: number }> = {};
    const missedIds: string[] = [];

    for (const { id, total, unique } of kvResults) {
      if (total !== null && unique !== null) {
        result[id] = {
          totalImpressions: parseInt(total, 10),
          uniqueViewers:    parseInt(unique, 10),
        };
      } else {
        missedIds.push(id);
      }
    }

    // Resolve misses from D1 in one query
    if (missedIds.length > 0) {
      const d1Stats = await this._statsFromD1AndWarm(missedIds);
      Object.assign(result, d1Stats);
    }

    return result;
  }

  // ─── Private ───────────────────────────────────────────────────────────────

  /**
   * Compute total + unique counts from D1 for the given campaign IDs,
   * then warm the KV counters so subsequent calls are fast.
   */
  private async _statsFromD1AndWarm(
    campaignIds: string[],
  ): Promise<Record<string, { totalImpressions: number; uniqueViewers: number }>> {
    const [totalRows, uniqueRows] = await Promise.all([
      this.db
        .select({
          campaignId: impressions.campaignId,
          count: sql<number>`count(*)`,
        })
        .from(impressions)
        .where(inArray(impressions.campaignId, campaignIds))
        .groupBy(impressions.campaignId)
        .all(),
      this.db
        .select({
          campaignId: impressions.campaignId,
          count: countDistinct(impressions.viewerHash),
        })
        .from(impressions)
        .where(inArray(impressions.campaignId, campaignIds))
        .groupBy(impressions.campaignId)
        .all(),
    ]);

    const totals: Record<string, number>  = {};
    const uniques: Record<string, number> = {};

    for (const row of totalRows)  totals[row.campaignId]  = row.count;
    for (const row of uniqueRows) uniques[row.campaignId] = row.count;

    const result: Record<string, { totalImpressions: number; uniqueViewers: number }> = {};

    // Warm KV for all queried IDs (including those with 0 counts)
    const warmOps: Promise<void>[] = [];
    for (const id of campaignIds) {
      const total  = totals[id]  ?? 0;
      const unique = uniques[id] ?? 0;
      result[id] = { totalImpressions: total, uniqueViewers: unique };
      warmOps.push(this.kv.put(kvTotalKey(id),  total.toString()));
      warmOps.push(this.kv.put(kvUniqueKey(id), unique.toString()));
    }
    await Promise.all(warmOps);

    return result;
  }
}
