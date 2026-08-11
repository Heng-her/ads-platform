import { eq } from "drizzle-orm";
import type { DbClient } from "../db/index";
import { adProviderSettings } from "../db/schema/adProviderSettings";
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

  async getAdProviderSettings(): Promise<Record<string, any>> {
    const rows = await this.db.select().from(adProviderSettings).all();
    const result: Record<string, any> = {};

    for (const row of rows) {
      try {
        result[row.provider] = {
          enabled: row.enabled,
          credentials: JSON.parse(row.credentialsJson),
        };
      } catch {}
    }

    return result;
  }

  async saveAdProviderSetting(
    provider: "GOOGLE_ADSENSE" | "ADSTERRA",
    enabled: boolean,
    credentials: Record<string, any>
  ): Promise<boolean> {
    const credentialsJson = JSON.stringify(credentials);
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

    return true;
  }

  async getAggregatedDashboardStats(
    startDate: string = "2026-08-01",
    endDate: string = "2026-08-11",
    adNetworkConfig?: Record<string, any>
  ): Promise<{
    totalRevenue: number;
    totalImpressions: number;
    totalClicks: number;
    averageCtr: number;
    averageCpm: number;
    providers: AdProviderStats[];
    revenueByDate: Array<{ date: string; adsense: number; adsterra: number; total: number }>;
  }> {
    const savedSettings = await this.getAdProviderSettings();
    const adsenseCreds = adNetworkConfig || savedSettings.GOOGLE_ADSENSE?.credentials || {};
    const adsterraCreds = adNetworkConfig || savedSettings.ADSTERRA?.credentials || {};

    const [adsenseStats, adsterraStats] = await Promise.all([
      this.googleProvider.getStats(startDate, endDate, adsenseCreds),
      this.adsterraProvider.getStats(startDate, endDate, adsterraCreds),
    ]);

    const providers = [adsenseStats, adsterraStats];
    const totalRevenue = parseFloat((adsenseStats.revenue + adsterraStats.revenue).toFixed(2));
    const totalImpressions = adsenseStats.impressions + adsterraStats.impressions;
    const totalClicks = adsenseStats.clicks + adsterraStats.clicks;
    const averageCtr = totalImpressions > 0 ? parseFloat(((totalClicks / totalImpressions) * 100).toFixed(2)) : 0;
    const averageCpm = totalImpressions > 0 ? parseFloat(((totalRevenue / totalImpressions) * 1000).toFixed(2)) : 0;

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
    credentials: Record<string, any>
  ): Promise<{ success: boolean; message: string }> {
    if (provider === "GOOGLE_ADSENSE") {
      return this.googleProvider.testConnection(credentials);
    } else {
      return this.adsterraProvider.testConnection(credentials);
    }
  }
}
