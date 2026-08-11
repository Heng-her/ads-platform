import type { Context } from "hono";
import type { DbClient } from "../db/index";
import type { UserJwtPayload } from "../types/env";
import { MonetizationService } from "../services/monetizationService";

export interface ActionHandlerOptions {
  c?: Context<any>;
  db: DbClient;
  action: string;
  data: any;
  currentUser?: UserJwtPayload | null;
}

export async function handleMonetizationAction({
  action,
  data,
  currentUser,
  db,
}: ActionHandlerOptions): Promise<any> {
  const monetizationService = new MonetizationService({ db });

  if (action === "monetization/get-dashboard") {
    const startDate = data?.startDate || "2026-08-01";
    const endDate = data?.endDate || "2026-08-11";
    const adNetworkConfig = data?.adNetworkConfig;

    const stats = await monetizationService.getAggregatedDashboardStats(
      startDate,
      endDate,
      adNetworkConfig
    );

    return {
      code: 1,
      msg: "Monetization statistics fetched successfully.",
      data: stats,
    };
  }

  if (action === "monetization/save-provider-config") {
    if (!currentUser || currentUser.role !== "ADMIN") {
      return { code: 0, msg: "Unauthorized: Admin privileges required." };
    }

    const { provider, enabled, credentials } = data || {};
    if (!provider || (provider !== "GOOGLE_ADSENSE" && provider !== "ADSTERRA")) {
      return { code: 0, msg: "Invalid provider specified." };
    }

    await monetizationService.saveAdProviderSetting(provider, enabled ?? true, credentials || {});
    return {
      code: 1,
      msg: `Monetization provider settings for ${provider} saved securely.`,
    };
  }

  if (action === "monetization/test-provider-connection") {
    if (!currentUser || currentUser.role !== "ADMIN") {
      return { code: 0, msg: "Unauthorized: Admin privileges required." };
    }

    const { provider, credentials } = data || {};
    if (!provider) {
      return { code: 0, msg: "Missing provider parameter." };
    }

    const testResult = await monetizationService.testProviderConnection(
      provider,
      credentials || {}
    );

    return {
      code: testResult.success ? 1 : 0,
      msg: testResult.message,
      data: testResult,
    };
  }

  return { code: 0, msg: `Unknown monetization action: ${action}` };
}
