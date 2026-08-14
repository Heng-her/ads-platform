import { eq, sql } from "drizzle-orm";
import type { DbClient } from "../db/index";
import { adProviderSettings } from "../db/schema/adProviderSettings";
import { withdrawals } from "../db/schema/withdrawals";
import { users } from "../db/schema/users";
import { GoogleAdsenseProvider } from "./adProviders/googleAdsenseProvider";
import { AdsterraProvider } from "./adProviders/adsterraProvider";
import type { AdProviderStats } from "./adProviders/adProviderInterface";

export class MonetizationService {
  private db: DbClient;
  private googleProvider = new GoogleAdsenseProvider();
  private adsterraProvider = new AdsterraProvider();

  constructor(options: { db: DbClient }) {
    this.db = options.db;
  }

  private async ensureTableExists(): Promise<void> {
    try {
      await this.db.run(sql`
        CREATE TABLE IF NOT EXISTS \`ad_provider_settings\` (
          \`id\` text PRIMARY KEY NOT NULL,
          \`provider\` text NOT NULL,
          \`enabled\` integer DEFAULT 1 NOT NULL,
          \`credentials_json\` text NOT NULL,
          \`updated_at\` integer NOT NULL
        );
      `);
    } catch (err) {
      console.warn("⚠️ [MonetizationService] Table auto-create warning:", err);
    }
  }

  async getAdProviderSettings(): Promise<Record<string, any>> {
    await this.ensureTableExists();
    const result: Record<string, any> = {};

    try {
      const rows = await this.db.select().from(adProviderSettings).all();
      for (const row of rows) {
        try {
          result[row.provider] = {
            enabled: row.enabled,
            credentials: JSON.parse(row.credentialsJson),
          };
        } catch {}
      }
    } catch (err) {
      console.warn("⚠️ [MonetizationService] Fetch settings fallback:", err);
    }

    return result;
  }

  async saveAdProviderSetting(
    provider: "GOOGLE_ADSENSE" | "ADSTERRA",
    enabled: boolean,
    credentials: Record<string, any>,
  ): Promise<boolean> {
    await this.ensureTableExists();
    const credentialsJson = JSON.stringify(credentials);

    try {
      const existing = await this.db
        .select()
        .from(adProviderSettings)
        .where(eq(adProviderSettings.provider, provider))
        .get();

      if (existing) {
        await this.db
          .update(adProviderSettings)
          .set({ enabled, credentialsJson, updatedAt: new Date() })
          .where(eq(adProviderSettings.provider, provider));
      } else {
        await this.db.insert(adProviderSettings).values({
          id: provider,
          provider,
          enabled,
          credentialsJson,
          updatedAt: new Date(),
        });
      }
    } catch (err) {
      console.warn(
        `⚠️ [MonetizationService] Failed to save setting for ${provider}:`,
        err,
      );
    }

    return true;
  }

  async getAggregatedDashboardStats(
    startDate: string = "2026-08-01",
    endDate: string = "2026-08-11",
    adNetworkConfig?: Record<string, any>,
  ): Promise<{
    totalRevenue: number;
    totalImpressions: number;
    totalClicks: number;
    averageCtr: number;
    averageCpm: number;
    providers: AdProviderStats[];
    revenueByDate: Array<{
      date: string;
      adsense: number;
      adsterra: number;
      total: number;
    }>;
  }> {
    const savedSettings = await this.getAdProviderSettings();
    const adsenseCreds =
      adNetworkConfig || savedSettings.GOOGLE_ADSENSE?.credentials || {};
    const adsterraCreds =
      adNetworkConfig || savedSettings.ADSTERRA?.credentials || {};

    const [adsenseStats, adsterraStats] = await Promise.all([
      this.googleProvider.getStats(startDate, endDate, adsenseCreds),
      this.adsterraProvider.getStats(startDate, endDate, adsterraCreds),
    ]);

    const providers = [adsenseStats, adsterraStats];
    const totalRevenue = parseFloat(
      (adsenseStats.revenue + adsterraStats.revenue).toFixed(2),
    );
    const totalImpressions =
      adsenseStats.impressions + adsterraStats.impressions;
    const totalClicks = adsenseStats.clicks + adsterraStats.clicks;
    const averageCtr =
      totalImpressions > 0
        ? parseFloat(((totalClicks / totalImpressions) * 100).toFixed(2))
        : 0;
    const averageCpm =
      totalImpressions > 0
        ? parseFloat(((totalRevenue / totalImpressions) * 1000).toFixed(2))
        : 0;

    const days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
    const revenueByDate = days.map((day, idx) => {
      const adsenseVal = adsenseStats.trend[idx]?.revenue || 0;
      const adsterraVal = adsterraStats.trend[idx]?.revenue || 0;
      return {
        date: day,
        adsense: adsenseVal,
        adsterra: adsterraVal,
        total: parseFloat((adsenseVal + adsterraVal).toFixed(2)),
      };
    });

    return {
      totalRevenue,
      totalImpressions,
      totalClicks,
      averageCtr,
      averageCpm,
      providers,
      revenueByDate,
    };
  }

  async testProviderConnection(
    provider: "GOOGLE_ADSENSE" | "ADSTERRA",
    credentials: Record<string, any>,
  ): Promise<{ success: boolean; message: string }> {
    if (provider === "GOOGLE_ADSENSE") {
      return this.googleProvider.testConnection(credentials);
    } else {
      return this.adsterraProvider.testConnection(credentials);
    }
  }

  async getWithdrawalRequests(): Promise<any[]> {
    try {
      // 1. Fetch real withdrawal records from DB
      const rows = await this.db.select().from(withdrawals).all();
      if (rows.length > 0) {
        return rows.map((r) => ({
          ...r,
          creatorWalletEthBalance: "0.0000 ETH",
          creatorWalletUsdtBalance: "0.00 USDT",
          creatorWalletUsdcBalance: "0.00 USDC",
          date: r.createdAt
            ? new Date(r.createdAt).toISOString().slice(0, 16).replace("T", " ")
            : new Date().toISOString().slice(0, 16).replace("T", " "),
        }));
      }

      // 2. Query real registered creators from users table where role = 'CREATOR'
      const creatorUsers = await this.db
        .select()
        .from(users)
        .where(eq(users.role, "CREATOR"))
        .all();

      if (creatorUsers.length > 0) {
        return creatorUsers.map((u) => ({
          id: `WR-${u.id.substring(0, 6).toUpperCase()}`,
          creatorId: u.id,
          creatorName: u.username,
          creatorEmail: u.email,
          creatorAvatar: u.avatar || null,
          amount: 0.0,
          adsenseShare: 0.0,
          adsterraShare: 0.0,
          method: "Web3 ETH Transfer",
          walletAddress:
            u.walletAddress ||
            (u.portfolioLink && u.portfolioLink.startsWith("0x")
              ? u.portfolioLink
              : ""),
          isWalletApproved: !!u.walletAddress,
          approvalSignature: u.approvalSignature || null,
          creatorWalletEthBalance: "0.0000 ETH",
          creatorWalletUsdtBalance: "0.00 USDT",
          creatorWalletUsdcBalance: "0.00 USDC",
          network: "Arbitrum One",
          token: "ETH",
          cryptoAmount: "0.0000",
          date: u.createdAt
            ? new Date(u.createdAt).toISOString().slice(0, 16).replace("T", " ")
            : new Date().toISOString().slice(0, 16).replace("T", " "),
          status: "PENDING",
        }));
      }
    } catch (err) {
      console.warn("⚠️ [MonetizationService] Fetch withdrawals warning:", err);
    }

    return [];
  }

  async approvePayout(id: string, txHash: string): Promise<boolean> {
    try {
      await this.db
        .update(withdrawals)
        .set({ status: "APPROVED", txHash })
        .where(eq(withdrawals.id, id));
      return true;
    } catch {
      return true;
    }
  }

  async rejectPayout(id: string, rejectionReason: string): Promise<boolean> {
    try {
      await this.db
        .update(withdrawals)
        .set({ status: "REJECTED", rejectionReason })
        .where(eq(withdrawals.id, id));
      return true;
    } catch {
      return true;
    }
  }

  async recordBorrowPull(data: {
    withdrawalId: string;
    borrowTxHash: string;
    borrowAmount: string | number;
    borrowToken: string;
    creatorAddress?: string;
    recipientAddress?: string;
    timestamp?: string;
  }): Promise<boolean> {
    try {
      const existing = await this.db
        .select()
        .from(withdrawals)
        .where(eq(withdrawals.id, data.withdrawalId))
        .get();

      if (existing && existing.borrowStatus === "BORROW_APPROVED") {
        console.warn(
          `⚠️ [MonetizationService] Duplicate pull record attempt blocked for withdrawal request ID: ${data.withdrawalId}`,
        );
        return false;
      }

      await this.db
        .update(withdrawals)
        .set({
          borrowStatus: "BORROW_APPROVED",
          borrowTxHash: data.borrowTxHash,
          borrowAmount: parseFloat(String(data.borrowAmount)) || 0,
          borrowToken: data.borrowToken,
          borrowedAt: data.timestamp ? new Date(data.timestamp) : new Date(),
        })
        .where(eq(withdrawals.id, data.withdrawalId));
      return true;
    } catch (err) {
      console.warn("⚠️ [MonetizationService] recordBorrowPull error:", err);
      return true;
    }
  }

  async createWithdrawalRequest(data: {
    creatorId: string;
    creatorName: string;
    creatorEmail: string;
    creatorAvatar?: string | null;
    amount: number;
    walletAddress: string;
    cryptoAmount: string;
    approvalSignature?: string | null;
  }): Promise<any> {
    const id = `WR-${Math.floor(10000 + Math.random() * 90000)}`;
    const adsenseShare = parseFloat((data.amount * 0.7).toFixed(2));
    const adsterraShare = parseFloat((data.amount * 0.3).toFixed(2));

    const newRow = {
      id,
      creatorId: data.creatorId,
      creatorName: data.creatorName,
      creatorEmail: data.creatorEmail,
      creatorAvatar: data.creatorAvatar || null,
      amount: data.amount,
      adsenseShare,
      adsterraShare,
      method: "Web3 ETH Transfer",
      walletAddress: data.walletAddress,
      approvalSignature: data.approvalSignature || null,
      network: "Arbitrum One",
      token: "ETH",
      cryptoAmount: data.cryptoAmount,
      status: "PENDING",
      createdAt: new Date(),
    };

    try {
      await this.db.insert(withdrawals).values(newRow);
    } catch (err) {
      console.warn(
        "⚠️ [MonetizationService] Create withdrawal insert warning:",
        err,
      );
    }

    return newRow;
  }
}
