import { eq, sql, count, countDistinct, and } from "drizzle-orm";
import type { DbClient } from "../db/index";
import { users, campaigns, impressions } from "../db/schema/index";

// ─── Types ────────────────────────────────────────────────────────────────────

export interface CreatorStats {
  campaigns: {
    total: number;
    public: number;
    draft: number;
  };
  impressions: {
    total: number;
    uniqueViewers: number;
  };
  topCampaign: {
    id: string;
    title: string;
    totalImpressions: number;
    uniqueViewers: number;
  } | null;
  recentCampaigns: {
    id: string;
    title: string;
    status: string;
    createdAt: Date;
  }[];
}

export interface AdminStats {
  users: {
    total: number;
    active: number;
    suspended: number;
    pending: number;
    newToday: number;
  };
  campaigns: {
    total: number;
    public: number;
    draft: number;
    deleted: number;
    newToday: number;
  };
  impressions: {
    total: number;
    uniqueViewers: number;
    last7Days: number;
  };
  topCampaigns: {
    id: string;
    title: string;
    userId: string;
    totalImpressions: number;
    uniqueViewers: number;
  }[];
  topCreators: {
    id: string;
    username: string;
    avatar: string | null;
    campaignCount: number;
  }[];
  campaignsByCategory: {
    category: string;
    count: number;
  }[];
}

// ─── Service ──────────────────────────────────────────────────────────────────

export class DashboardService {
  constructor(private db: DbClient) {}

  /**
   * Stats for a single creator's own campaigns + impressions.
   */
  async getCreatorStats(userId: string): Promise<CreatorStats> {
    // ── 1. Campaign counts ──────────────────────────────────────────────────
    const [campaignCounts] = await this.db
      .select({
        total:  count(),
        public: sql<number>`sum(case when ${campaigns.status} = 'PUBLIC' and ${campaigns.isDeleted} = 0 then 1 else 0 end)`,
        draft:  sql<number>`sum(case when ${campaigns.status} = 'DRAFT'  and ${campaigns.isDeleted} = 0 then 1 else 0 end)`,
      })
      .from(campaigns)
      .where(and(eq(campaigns.userId, userId), eq(campaigns.isDeleted, false)));

    // ── 2. Impression totals across all creator's campaigns ─────────────────
    const [impressionTotals] = await this.db
      .select({
        total:         count(),
        uniqueViewers: countDistinct(impressions.viewerHash),
      })
      .from(impressions)
      .innerJoin(campaigns, eq(impressions.campaignId, campaigns.id))
      .where(eq(campaigns.userId, userId));

    // ── 3. Top campaign by impression count ─────────────────────────────────
    const topCampaignRows = await this.db
      .select({
        id:               campaigns.id,
        title:            campaigns.title,
        totalImpressions: count(impressions.id),
        uniqueViewers:    countDistinct(impressions.viewerHash),
      })
      .from(campaigns)
      .leftJoin(impressions, eq(impressions.campaignId, campaigns.id))
      .where(and(eq(campaigns.userId, userId), eq(campaigns.isDeleted, false)))
      .groupBy(campaigns.id, campaigns.title)
      .orderBy(sql`count(${impressions.id}) desc`)
      .limit(1);

    // ── 4. 5 most recent campaigns ──────────────────────────────────────────
    const recentCampaigns = await this.db
      .select({
        id:        campaigns.id,
        title:     campaigns.title,
        status:    campaigns.status,
        createdAt: campaigns.createdAt,
      })
      .from(campaigns)
      .where(and(eq(campaigns.userId, userId), eq(campaigns.isDeleted, false)))
      .orderBy(sql`${campaigns.createdAt} desc`)
      .limit(5);

    return {
      campaigns: {
        total:  Number(campaignCounts?.total  ?? 0),
        public: Number(campaignCounts?.public ?? 0),
        draft:  Number(campaignCounts?.draft  ?? 0),
      },
      impressions: {
        total:         Number(impressionTotals?.total         ?? 0),
        uniqueViewers: Number(impressionTotals?.uniqueViewers ?? 0),
      },
      topCampaign: topCampaignRows[0]
        ? {
            id:               topCampaignRows[0].id,
            title:            topCampaignRows[0].title,
            totalImpressions: Number(topCampaignRows[0].totalImpressions),
            uniqueViewers:    Number(topCampaignRows[0].uniqueViewers),
          }
        : null,
      recentCampaigns: recentCampaigns.map((c) => ({
        id:        c.id,
        title:     c.title,
        status:    c.status,
        createdAt: c.createdAt,
      })),
    };
  }

  /**
   * Platform-wide stats for admins.
   */
  async getAdminStats(): Promise<AdminStats> {
    const todayStart   = this._startOfToday();
    const sevenDaysAgo = this._daysAgo(7);

    // ── 1. User counts ───────────────────────────────────────────────────────
    const [userCounts] = await this.db
      .select({
        total:     count(),
        active:    sql<number>`sum(case when ${users.status} = 'ACTIVE'    then 1 else 0 end)`,
        suspended: sql<number>`sum(case when ${users.status} = 'SUSPENDED' then 1 else 0 end)`,
        pending:   sql<number>`sum(case when ${users.status} = 'PENDING'   then 1 else 0 end)`,
        newToday:  sql<number>`sum(case when ${users.createdAt} >= ${todayStart * 1000} then 1 else 0 end)`,
      })
      .from(users);

    // ── 2. Campaign counts (all, including deleted) ──────────────────────────
    const [campaignCounts] = await this.db
      .select({
        total:    count(),
        public:   sql<number>`sum(case when ${campaigns.status} = 'PUBLIC' and ${campaigns.isDeleted} = 0 then 1 else 0 end)`,
        draft:    sql<number>`sum(case when ${campaigns.status} = 'DRAFT'  and ${campaigns.isDeleted} = 0 then 1 else 0 end)`,
        deleted:  sql<number>`sum(case when ${campaigns.isDeleted} = 1 then 1 else 0 end)`,
        newToday: sql<number>`sum(case when ${campaigns.createdAt} >= ${todayStart * 1000} then 1 else 0 end)`,
      })
      .from(campaigns);

    // ── 3. Platform impression totals ────────────────────────────────────────
    const [impressionTotals] = await this.db
      .select({
        total:         count(),
        uniqueViewers: countDistinct(impressions.viewerHash),
      })
      .from(impressions);

    const [impressionsLast7Days] = await this.db
      .select({ count: count() })
      .from(impressions)
      .where(sql`${impressions.createdAt} >= ${sevenDaysAgo * 1000}`);

    // ── 4. Top 5 campaigns by impression count ───────────────────────────────
    const topCampaigns = await this.db
      .select({
        id:               campaigns.id,
        title:            campaigns.title,
        userId:           campaigns.userId,
        totalImpressions: count(impressions.id),
        uniqueViewers:    countDistinct(impressions.viewerHash),
      })
      .from(campaigns)
      .leftJoin(impressions, eq(impressions.campaignId, campaigns.id))
      .where(eq(campaigns.isDeleted, false))
      .groupBy(campaigns.id, campaigns.title, campaigns.userId)
      .orderBy(sql`count(${impressions.id}) desc`)
      .limit(5);

    // ── 5. Top 5 creators by campaign count ─────────────────────────────────
    const topCreators = await this.db
      .select({
        id:            users.id,
        username:      users.username,
        avatar:        users.avatar,
        campaignCount: count(campaigns.id),
      })
      .from(users)
      .leftJoin(
        campaigns,
        and(eq(campaigns.userId, users.id), eq(campaigns.isDeleted, false)),
      )
      .where(eq(users.role, "CREATOR"))
      .groupBy(users.id, users.username, users.avatar)
      .orderBy(sql`count(${campaigns.id}) desc`)
      .limit(5);

    // ── 6. Campaigns grouped by category ────────────────────────────────────
    const campaignsByCategory = await this.db
      .select({
        category: sql<string>`coalesce(${campaigns.category}, 'UNCATEGORIZED')`,
        count:    count(),
      })
      .from(campaigns)
      .where(eq(campaigns.isDeleted, false))
      .groupBy(campaigns.category)
      .orderBy(sql`count(*) desc`);

    return {
      users: {
        total:     Number(userCounts?.total     ?? 0),
        active:    Number(userCounts?.active    ?? 0),
        suspended: Number(userCounts?.suspended ?? 0),
        pending:   Number(userCounts?.pending   ?? 0),
        newToday:  Number(userCounts?.newToday  ?? 0),
      },
      campaigns: {
        total:    Number(campaignCounts?.total    ?? 0),
        public:   Number(campaignCounts?.public   ?? 0),
        draft:    Number(campaignCounts?.draft    ?? 0),
        deleted:  Number(campaignCounts?.deleted  ?? 0),
        newToday: Number(campaignCounts?.newToday ?? 0),
      },
      impressions: {
        total:         Number(impressionTotals?.total         ?? 0),
        uniqueViewers: Number(impressionTotals?.uniqueViewers ?? 0),
        last7Days:     Number(impressionsLast7Days?.count     ?? 0),
      },
      topCampaigns: topCampaigns.map((c) => ({
        id:               c.id,
        title:            c.title,
        userId:           c.userId,
        totalImpressions: Number(c.totalImpressions),
        uniqueViewers:    Number(c.uniqueViewers),
      })),
      topCreators: topCreators.map((u) => ({
        id:            u.id,
        username:      u.username,
        avatar:        u.avatar,
        campaignCount: Number(u.campaignCount),
      })),
      campaignsByCategory: campaignsByCategory.map((r) => ({
        category: r.category,
        count:    Number(r.count),
      })),
    };
  }

  // ─── Helpers ────────────────────────────────────────────────────────────────

  /** Returns Unix timestamp (seconds) for the start of today */
  private _startOfToday(): number {
    const d = new Date();
    d.setHours(0, 0, 0, 0);
    return Math.floor(d.getTime() / 1000);
  }

  /** Returns Unix timestamp (seconds) for N days ago at midnight */
  private _daysAgo(days: number): number {
    const d = new Date();
    d.setDate(d.getDate() - days);
    d.setHours(0, 0, 0, 0);
    return Math.floor(d.getTime() / 1000);
  }
}
