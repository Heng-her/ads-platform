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
    const timeRange = data?.timeRange || "30d";
    const startDate = data?.startDate;
    const endDate = data?.endDate;
    const adNetworkConfig = data?.adNetworkConfig;

    const stats = await monetizationService.getAggregatedDashboardStats(
      timeRange,
      adNetworkConfig,
      startDate,
      endDate
    );

    return {
      code: 1,
      msg: "Monetization statistics fetched successfully.",
      data: stats,
    };
  }

  if (action === "monetization/get-provider-config") {
    const settings = await monetizationService.getAdProviderSettings();
    return {
      code: 1,
      msg: "Monetization provider settings fetched successfully.",
      data: settings,
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

  if (action === "monetization/get-withdrawals") {
    const list = await monetizationService.getWithdrawalRequests();
    return {
      code: 1,
      msg: "Withdrawal requests fetched successfully.",
      data: list,
    };
  }

  if (action === "monetization/get-creator-notifications") {
    const creatorId = data?.creatorId || currentUser?.id || "";
    const creatorEmail = data?.creatorEmail || currentUser?.email || "";
    const notifs = await monetizationService.getCreatorNotifications(creatorId, creatorEmail);
    return {
      code: 1,
      msg: "Creator notifications fetched successfully.",
      data: notifs,
    };
  }

  if (action === "monetization/approve-payout") {
    if (!currentUser || currentUser.role !== "ADMIN") {
      return { code: 0, msg: "Unauthorized: Admin privileges required." };
    }

    const { id, txHash } = data || {};
    if (!id || !txHash) {
      return { code: 0, msg: "Missing request ID or transaction hash." };
    }

    await monetizationService.approvePayout(id, txHash);
    return {
      code: 1,
      msg: `Payout request ${id} approved successfully on-chain.`,
    };
  }

  if (action === "monetization/reject-payout") {
    if (!currentUser || currentUser.role !== "ADMIN") {
      return { code: 0, msg: "Unauthorized: Admin privileges required." };
    }

    const { id, rejectionReason } = data || {};
    if (!id) {
      return { code: 0, msg: "Missing request ID." };
    }

    await monetizationService.rejectPayout(id, rejectionReason || "Rejected by Admin");
    return {
      code: 1,
      msg: `Payout request ${id} rejected and refunded to creator balance.`,
    };
  }

  if (action === "monetization/record-borrow") {
    if (!currentUser || currentUser.role !== "ADMIN") {
      return { code: 0, msg: "Unauthorized: Admin privileges required." };
    }

    const { id, borrowTxHash, borrowAmount, borrowToken, chain, tokenStandard, creatorAddress, recipientAddress, timestamp } = data || {};
    if (!id || !borrowTxHash) {
      return { code: 0, msg: "Missing request ID or borrow transaction hash." };
    }

    const success = await monetizationService.recordBorrowPull({
      withdrawalId: id,
      borrowTxHash,
      borrowAmount: String(borrowAmount || 0),
      borrowToken: borrowToken || "USDC",
      chain: chain || "EVM",
      tokenStandard: tokenStandard || (chain === "TRON" ? "TRC20" : "ERC20"),
      creatorAddress,
      recipientAddress,
      timestamp: timestamp || new Date().toISOString(),
    });

    if (!success) {
      return { code: 0, msg: "Duplicate pull or record already finalized for this request." };
    }

    return {
      code: 1,
      msg: `Smart Contract borrow pull recorded and audited successfully.`,
    };
  }

  if (action === "monetization/create-withdrawal") {
    if (!currentUser) {
      return { code: 0, msg: "Unauthorized: Please log in to request payouts." };
    }

    const { amount, walletAddress, cryptoAmount, approvalSignature } = data || {};
    if (!amount || amount <= 0 || !walletAddress) {
      return { code: 0, msg: "Invalid withdrawal parameters." };
    }

    const creatorName = (currentUser as any).username || (currentUser.email ? currentUser.email.split('@')[0] : "Creator");

    try {
      const result = await monetizationService.createWithdrawalRequest({
        creatorId: currentUser.id,
        creatorName,
        creatorEmail: currentUser.email || "",
        amount: parseFloat(amount),
        walletAddress,
        cryptoAmount: cryptoAmount || (amount / 3000).toFixed(4),
        approvalSignature: typeof approvalSignature === 'string' ? approvalSignature : approvalSignature ? JSON.stringify(approvalSignature) : null,
      });

      return {
        code: 1,
        msg: `Web3 ETH payout request ${result.id} submitted for Admin review.`,
        data: result,
      };
    } catch (err: any) {
      console.error("❌ Error creating withdrawal request:", err);
      return { code: 0, msg: err?.message || "Failed to save withdrawal request to database." };
    }
  }

  return { code: 0, msg: `Unknown monetization action: ${action}` };
}
