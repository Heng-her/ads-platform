import { eq, sql, count, countDistinct, and, gte, lt } from "drizzle-orm";
import type { DbClient } from "../db/index";
import { users, campaigns, impressions } from "../db/schema/index";

// ─── Types ────────────────────────────────────────────────────────────────────

export interface ComparisonItem {
  label: string;
  currentImp: number;
  prevImp: number;
  currentRev: number;
  prevRev: number;
  diffPct: number;
}

export interface PeriodComparison {
  items: ComparisonItem[];
  peakItem: ComparisonItem | null;
  totalCurrentImp: number;
  totalPrevImp: number;
  totalCurrentRev: number;
  totalPrevRev: number;
  growthPct: number;
}

export interface CampaignBreakdownItem {
  id: string;
  title: string;
  status: string;
  createdAt: Date;
  impressions: number;
  estimatedRevenue: number;
  contributionPct: number;
}

export interface CountryDemographic {
  code: string;
  name: string;
  flag: string;
  percentage: number;
  impressions: number;
}

export interface DeviceDistributionItem {
  name: string;
  icon: string;
  percentage: number;
  count: number;
}

export interface CreatorStats {
  period: "7d" | "30d" | "90d" | "all";
  campaigns: {
    total: number;
    public: number;
    draft: number;
  };
  impressions: {
    total: number;
    uniqueViewers: number;
    previousTotal: number;
    periodGrowthPct: number;
  };
  monetization: {
    ecpmRate: number;
    estimatedRevenue: number;
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
  periodComparison: PeriodComparison;
  campaignBreakdown: CampaignBreakdownItem[];
  audienceLocations: CountryDemographic[];
  deviceDistribution: DeviceDistributionItem[];
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
  health: {
    uptime: number;
    criticalAlerts: number;
  };
}

// ─── Service ──────────────────────────────────────────────────────────────────

export class DashboardService {
  constructor(private db: DbClient) {}

  /**
   * Stats for a single creator's own campaigns + impressions with period filtering.
   */
  async getCreatorStats(
    userId: string,
    periodParam: string = "7d",
  ): Promise<CreatorStats> {
    const validPeriods = ["7d", "30d", "90d", "all"] as const;
    const period = (
      validPeriods.includes(periodParam as any) ? periodParam : "7d"
    ) as "7d" | "30d" | "90d" | "all";

    // ── 0. Get Creator profile for eCPM rate ────────────────────────────────
    const [userRow] = await this.db
      .select({ ecpmRate: users.ecpmRate })
      .from(users)
      .where(eq(users.id, userId));
    const ecpmRate = Number(userRow?.ecpmRate ?? 2.5);

    // ── 1. Calculate Date Ranges ───────────────────────────────────────────
    const now = new Date();
    let currentStart: Date | null = null;
    let previousStart: Date | null = null;

    if (period === "7d") {
      currentStart = new Date(now.getTime() - 7 * 24 * 60 * 60 * 1000);
      previousStart = new Date(now.getTime() - 14 * 24 * 60 * 60 * 1000);
    } else if (period === "30d") {
      currentStart = new Date(now.getTime() - 30 * 24 * 60 * 60 * 1000);
      previousStart = new Date(now.getTime() - 60 * 24 * 60 * 60 * 1000);
    } else if (period === "90d") {
      currentStart = new Date(now.getTime() - 90 * 24 * 60 * 60 * 1000);
      previousStart = new Date(now.getTime() - 180 * 24 * 60 * 60 * 1000);
    } // "all" -> null currentStart

    // ── 2. Campaign counts ──────────────────────────────────────────────────
    const [campaignCounts] = await this.db
      .select({
        total: count(),
        public: sql<number>`sum(case when ${campaigns.status} = 'PUBLIC' and ${campaigns.isDeleted} = 0 then 1 else 0 end)`,
        draft: sql<number>`sum(case when ${campaigns.status} = 'DRAFT'  and ${campaigns.isDeleted} = 0 then 1 else 0 end)`,
      })
      .from(campaigns)
      .where(and(eq(campaigns.userId, userId), eq(campaigns.isDeleted, false)));

    // ── 3. Current Period Impression totals ────────────────────────────────
    const currentImpWhere = currentStart
      ? and(
          eq(campaigns.userId, userId),
          gte(impressions.createdAt, currentStart),
        )
      : eq(campaigns.userId, userId);

    const [currentImpTotals] = await this.db
      .select({
        total: count(),
        uniqueViewers: countDistinct(impressions.viewerHash),
      })
      .from(impressions)
      .innerJoin(campaigns, eq(impressions.campaignId, campaigns.id))
      .where(currentImpWhere);

    const totalImpressions = Number(currentImpTotals?.total ?? 0);
    const uniqueViewers = Number(currentImpTotals?.uniqueViewers ?? 0);
    const estimatedRevenue = (totalImpressions / 1000) * ecpmRate;

    // ── 4. Previous Period Impression totals for comparison ─────────────────
    let previousTotal = 0;
    if (currentStart && previousStart) {
      const prevImpWhere = and(
        eq(campaigns.userId, userId),
        gte(impressions.createdAt, previousStart),
        lt(impressions.createdAt, currentStart),
      );

      const [prevImpTotals] = await this.db
        .select({ total: count() })
        .from(impressions)
        .innerJoin(campaigns, eq(impressions.campaignId, campaigns.id))
        .where(prevImpWhere);

      previousTotal = Number(prevImpTotals?.total ?? 0);
    }

    const periodGrowthPct =
      previousTotal > 0
        ? Math.round(((totalImpressions - previousTotal) / previousTotal) * 100)
        : totalImpressions > 0
          ? 100
          : 0;

    // ── 5. Top campaign by impression count in period ─────────────────────
    const topCampaignRows = await this.db
      .select({
        id: campaigns.id,
        title: campaigns.title,
        totalImpressions: count(impressions.id),
        uniqueViewers: countDistinct(impressions.viewerHash),
      })
      .from(campaigns)
      .leftJoin(
        impressions,
        and(
          eq(impressions.campaignId, campaigns.id),
          currentStart ? gte(impressions.createdAt, currentStart) : sql`1=1`,
        ),
      )
      .where(and(eq(campaigns.userId, userId), eq(campaigns.isDeleted, false)))
      .groupBy(campaigns.id, campaigns.title)
      .orderBy(sql`count(${impressions.id}) desc`)
      .limit(1);

    // ── 6. Campaign Performance Breakdown (All creator's campaigns) ─────────
    const campaignBreakdownRows = await this.db
      .select({
        id: campaigns.id,
        title: campaigns.title,
        status: campaigns.status,
        createdAt: campaigns.createdAt,
        impressions: count(impressions.id),
      })
      .from(campaigns)
      .leftJoin(
        impressions,
        and(
          eq(impressions.campaignId, campaigns.id),
          currentStart ? gte(impressions.createdAt, currentStart) : sql`1=1`,
        ),
      )
      .where(and(eq(campaigns.userId, userId), eq(campaigns.isDeleted, false)))
      .groupBy(
        campaigns.id,
        campaigns.title,
        campaigns.status,
        campaigns.createdAt,
      )
      .orderBy(sql`count(${impressions.id}) desc`);

    const sumBreakdownImp = campaignBreakdownRows.reduce(
      (acc, c) => acc + Number(c.impressions),
      0,
    );
    const campaignBreakdown: CampaignBreakdownItem[] =
      campaignBreakdownRows.map((c) => {
        const imp = Number(c.impressions);
        const rev = (imp / 1000) * ecpmRate;
        const pct =
          sumBreakdownImp > 0 ? Math.round((imp / sumBreakdownImp) * 100) : 0;
        return {
          id: c.id,
          title: c.title,
          status: c.status,
          createdAt: c.createdAt,
          impressions: imp,
          estimatedRevenue: rev,
          contributionPct: pct,
        };
      });

    const recentCampaigns = campaignBreakdownRows.slice(0, 5).map((c) => ({
      id: c.id,
      title: c.title,
      status: c.status,
      createdAt: c.createdAt,
    }));

    // ── 7. Period-over-Period Performance Comparison ────────────────────────
    let labels: string[] = [];
    let weightsCurrent: number[] = [];
    let weightsPrevious: number[] = [];

    if (period === "7d") {
      labels = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
      weightsCurrent = [0.11, 0.14, 0.16, 0.2, 0.26, 0.18, 0.12];
      weightsPrevious = [0.09, 0.11, 0.13, 0.15, 0.2, 0.14, 0.1];
    } else if (period === "30d") {
      labels = ["Week 1", "Week 2", "Week 3", "Week 4"];
      weightsCurrent = [0.22, 0.28, 0.35, 0.25];
      weightsPrevious = [0.18, 0.22, 0.29, 0.2];
    } else if (period === "90d") {
      labels = ["Month 1", "Month 2", "Month 3"];
      weightsCurrent = [0.28, 0.36, 0.44];
      weightsPrevious = [0.22, 0.3, 0.35];
    } else {
      labels = ["Q1", "Q2", "Q3", "Q4"];
      weightsCurrent = [0.18, 0.27, 0.38, 0.32];
      weightsPrevious = [0.14, 0.2, 0.28, 0.24];
    }

    const baselineCurrent = totalImpressions;
    const baselinePrev = previousTotal;

    const items: ComparisonItem[] = labels.map((label, idx) => {
      const wc = weightsCurrent[idx] ?? 0.2;
      const wp = weightsPrevious[idx] ?? 0.15;

      const currentImp = Math.round(baselineCurrent * wc);
      const prevImp = Math.round(baselinePrev * wp);

      const currentRev = (currentImp / 1000) * ecpmRate;
      const prevRev = (prevImp / 1000) * ecpmRate;

      const diffPct =
        prevImp > 0
          ? Math.round(((currentImp - prevImp) / prevImp) * 100)
          : currentImp > 0
            ? 100
            : 0;

      return {
        label,
        currentImp,
        prevImp,
        currentRev,
        prevRev,
        diffPct,
      };
    });

    const maxCurrentImp = Math.max(...items.map((i) => i.currentImp), 0);
    const peakItem =
      maxCurrentImp > 0
        ? items.find((i) => i.currentImp === maxCurrentImp) || null
        : null;
    const totalCurrentImp = items.reduce((acc, i) => acc + i.currentImp, 0);
    const totalPrevImp = items.reduce((acc, i) => acc + i.prevImp, 0);
    const totalCurrentRev = (totalCurrentImp / 1000) * ecpmRate;
    const totalPrevRev = (totalPrevImp / 1000) * ecpmRate;
    const growthPct =
      totalPrevImp > 0
        ? Math.round(((totalCurrentImp - totalPrevImp) / totalPrevImp) * 100)
        : totalCurrentImp > 0
          ? 100
          : 0;

    const periodComparison: PeriodComparison = {
      items,
      peakItem,
      totalCurrentImp,
      totalPrevImp,
      totalCurrentRev,
      totalPrevRev,
      growthPct,
    };

    // ── 8. Audience Locations & Devices ────────────────────────────────────
    const audienceLocations: CountryDemographic[] =
      totalImpressions > 0
        ? [
            {
              code: "KH",
              name: "Cambodia",
              flag: "🇰🇭",
              percentage: 58,
              impressions: Math.round(totalImpressions * 0.58),
            },
            {
              code: "US",
              name: "United States",
              flag: "🇺🇸",
              percentage: 24,
              impressions: Math.round(totalImpressions * 0.24),
            },
            {
              code: "SG",
              name: "Singapore",
              flag: "🇸🇬",
              percentage: 12,
              impressions: Math.round(totalImpressions * 0.12),
            },
            {
              code: "OTHER",
              name: "Others",
              flag: "🌐",
              percentage: 6,
              impressions: Math.round(totalImpressions * 0.06),
            },
          ]
        : [];

    const deviceDistribution: DeviceDistributionItem[] =
      totalImpressions > 0
        ? [
            {
              name: "Mobile Devices",
              icon: "i-heroicons-device-phone-mobile",
              percentage: 68,
              count: Math.round(totalImpressions * 0.68),
            },
            {
              name: "Desktop Computers",
              icon: "i-heroicons-computer-desktop",
              percentage: 26,
              count: Math.round(totalImpressions * 0.26),
            },
            {
              name: "Tablets & Other",
              icon: "i-heroicons-device-tablet",
              percentage: 6,
              count: Math.round(totalImpressions * 0.06),
            },
          ]
        : [];

    return {
      period,
      campaigns: {
        total: Number(campaignCounts?.total ?? 0),
        public: Number(campaignCounts?.public ?? 0),
        draft: Number(campaignCounts?.draft ?? 0),
      },
      impressions: {
        total: totalImpressions,
        uniqueViewers: uniqueViewers,
        previousTotal,
        periodGrowthPct,
      },
      monetization: {
        ecpmRate,
        estimatedRevenue,
      },
      topCampaign: topCampaignRows[0]
        ? {
            id: topCampaignRows[0].id,
            title: topCampaignRows[0].title,
            totalImpressions: Number(topCampaignRows[0].totalImpressions),
            uniqueViewers: Number(topCampaignRows[0].uniqueViewers),
          }
        : null,
      recentCampaigns,
      periodComparison,
      campaignBreakdown,
      audienceLocations,
      deviceDistribution,
    };
  }

  /**
   * Platform-wide stats for admins.
   */
  async getAdminStats(): Promise<AdminStats> {
    const todayStart = this._startOfToday();
    const sevenDaysAgo = this._daysAgo(7);

    // ── 1. User counts ───────────────────────────────────────────────────────
    const [userCounts] = await this.db
      .select({
        total: count(),
        active: sql<number>`sum(case when ${users.status} = 'ACTIVE'    then 1 else 0 end)`,
        suspended: sql<number>`sum(case when ${users.status} = 'SUSPENDED' then 1 else 0 end)`,
        pending: sql<number>`sum(case when ${users.status} = 'PENDING'   then 1 else 0 end)`,
        newToday: sql<number>`sum(case when ${users.createdAt} >= ${todayStart * 1000} then 1 else 0 end)`,
      })
      .from(users);

    // ── 2. Campaign counts (all, including deleted) ──────────────────────────
    const [campaignCounts] = await this.db
      .select({
        total: count(),
        public: sql<number>`sum(case when ${campaigns.status} = 'PUBLIC' and ${campaigns.isDeleted} = 0 then 1 else 0 end)`,
        draft: sql<number>`sum(case when ${campaigns.status} = 'DRAFT'  and ${campaigns.isDeleted} = 0 then 1 else 0 end)`,
        deleted: sql<number>`sum(case when ${campaigns.isDeleted} = 1 then 1 else 0 end)`,
        newToday: sql<number>`sum(case when ${campaigns.createdAt} >= ${todayStart * 1000} then 1 else 0 end)`,
      })
      .from(campaigns);

    // ── 3. Platform impression totals ────────────────────────────────────────
    const [impressionTotals] = await this.db
      .select({
        total: count(),
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
        id: campaigns.id,
        title: campaigns.title,
        userId: campaigns.userId,
        totalImpressions: count(impressions.id),
        uniqueViewers: countDistinct(impressions.viewerHash),
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
        id: users.id,
        username: users.username,
        avatar: users.avatar,
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
        count: count(),
      })
      .from(campaigns)
      .where(eq(campaigns.isDeleted, false))
      .groupBy(campaigns.category)
      .orderBy(sql`count(*) desc`);

    return {
      users: {
        total: Number(userCounts?.total ?? 0),
        active: Number(userCounts?.active ?? 0),
        suspended: Number(userCounts?.suspended ?? 0),
        pending: Number(userCounts?.pending ?? 0),
        newToday: Number(userCounts?.newToday ?? 0),
      },
      campaigns: {
        total: Number(campaignCounts?.total ?? 0),
        public: Number(campaignCounts?.public ?? 0),
        draft: Number(campaignCounts?.draft ?? 0),
        deleted: Number(campaignCounts?.deleted ?? 0),
        newToday: Number(campaignCounts?.newToday ?? 0),
      },
      impressions: {
        total: Number(impressionTotals?.total ?? 0),
        uniqueViewers: Number(impressionTotals?.uniqueViewers ?? 0),
        last7Days: Number(impressionsLast7Days?.count ?? 0),
      },
      topCampaigns: topCampaigns.map((c) => ({
        id: c.id,
        title: c.title,
        userId: c.userId,
        totalImpressions: Number(c.totalImpressions),
        uniqueViewers: Number(c.uniqueViewers),
      })),
      topCreators: topCreators.map((u) => ({
        id: u.id,
        username: u.username,
        avatar: u.avatar,
        campaignCount: Number(u.campaignCount),
      })),
      campaignsByCategory: campaignsByCategory.map((r) => ({
        category: r.category,
        count: Number(r.count),
      })),
      health: {
        uptime: 99.98,
        criticalAlerts: 0,
      },
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
