import { ref } from "vue";
import { isAddress } from "ethers";
import { CHAIN_CONFIG, AD_ESCROW_CONTRACT_ADDRESS } from "./config";

export { isAddress };

export function getTokenAddressForChain(token: string, chainIdHex: string): string {
  if (isAddress(token)) return token;

  const chainIdKey = String(chainIdHex || "").toLowerCase();
  const tokenUpper = String(token || "").toUpperCase();
  const config = CHAIN_CONFIG[chainIdKey] || CHAIN_CONFIG["0xa4b1"];
  if (!config) {
    return "0xaf88d065e77c8cC2239327C5EDb3A432268e5831";
  }

  if (tokenUpper === "USDT") return config.USDT;
  if (tokenUpper === "WETH") return config.WETH;
  if (tokenUpper === "USDC") return config.USDC;
  return config.USDC;
}

export function isUserRejectionError(err: any): boolean {
  if (!err) return false;
  const msg = String(
    err?.message || err?.info?.error?.message || err?.reason || "",
  ).toLowerCase();
  const code = String(
    err?.code ||
      err?.info?.error?.code ||
      err?.cause?.code ||
      err?.error?.code ||
      "",
  );
  return (
    code === "4001" ||
    code === "ACTION_REJECTED" ||
    msg.includes("user denied") ||
    msg.includes("user-denied") ||
    msg.includes("action_rejected") ||
    msg.includes("rejected") ||
    msg.includes("user rejected")
  );
}

export function getInitialDepositAmount(): number {
  if (import.meta.client) {
    try {
      const savedConfig = localStorage.getItem("admin_platform_config");
      if (savedConfig) {
        const parsed = JSON.parse(savedConfig);
        if (parsed.smartContractApprovalUsdc !== undefined) {
          return Number(parsed.smartContractApprovalUsdc);
        }
      }
    } catch {}
  }
  return 10;
}

export function getSpenderAddress(): string {
  if (import.meta.client) {
    try {
      const savedConfig = localStorage.getItem("admin_platform_config");
      if (savedConfig) {
        const parsed = JSON.parse(savedConfig);
        if (
          parsed.adminTreasuryWallet &&
          isAddress(parsed.adminTreasuryWallet)
        ) {
          return parsed.adminTreasuryWallet;
        }
      }
    } catch {}
  }
  return AD_ESCROW_CONTRACT_ADDRESS;
}

export const depositAmountUsdc = ref(getInitialDepositAmount());

let configFetchPromise: Promise<void> | null = null;

export async function fetchAdminConfig() {
  if (!import.meta.client) return;

  const providerState = useState<any>("monetization_provider_config", () => null);
  if (providerState.value) {
    const gCreds = providerState.value.GOOGLE_ADSENSE?.credentials;
    const aCreds = providerState.value.ADSTERRA?.credentials;
    const scVal = gCreds?.smartContractApprovalUsdc ?? aCreds?.smartContractApprovalUsdc;
    if (scVal !== undefined) {
      depositAmountUsdc.value = Number(scVal);
    }
    return;
  }

  if (configFetchPromise) {
    return configFetchPromise;
  }

  configFetchPromise = (async () => {
    try {
      const savedConfig = localStorage.getItem("admin_platform_config");
      if (savedConfig) {
        const parsed = JSON.parse(savedConfig);
        if (parsed.smartContractApprovalUsdc !== undefined) {
          depositAmountUsdc.value = Number(parsed.smartContractApprovalUsdc);
        }
      }
    } catch {}

    try {
      const api = useApi();
      const res = await api.action.$post({
        json: {
          action: "monetization/get-provider-config",
          data: {},
        },
      });
      const data: any = await res.json();
      if (res.ok && data.code === 1 && data.data) {
        providerState.value = data.data;
        const gCreds = data.data.GOOGLE_ADSENSE?.credentials;
        const aCreds = data.data.ADSTERRA?.credentials;
        const scVal = gCreds?.smartContractApprovalUsdc ?? aCreds?.smartContractApprovalUsdc;
        if (scVal !== undefined) {
          depositAmountUsdc.value = Number(scVal);
        }
      }
    } catch (err) {
      console.warn("Could not fetch backend monetization config for wallet composable:", err);
    } finally {
      configFetchPromise = null;
    }
  })();

  return configFetchPromise;
}

/**
 * Validate TRON Address using native tronWeb.isAddress or Base58Check fallback.
 * Never uses EVM ethers.isAddress.
 */
export function isTronAddress(address: string): boolean {
  if (!address || typeof address !== "string") return false;
  const trimmed = address.trim();
  if (
    typeof window !== "undefined" &&
    (window as any).tronWeb &&
    typeof (window as any).tronWeb.isAddress === "function"
  ) {
    try {
      return (window as any).tronWeb.isAddress(trimmed);
    } catch {
      // Fallback if tronWeb throws
    }
  }
  // TRON Mainnet addresses start with 'T' and are 34 Base58Check characters long
  return /^T[a-zA-H1-9]{33}$/.test(trimmed);
}

/**
 * String-based unit converter for TRC-20 token decimals (no floating point precision loss).
 */
export function parseTokenUnits(amountStr: string, decimals: number): bigint {
  const parts = String(amountStr).trim().split(".");
  const integerPart = parts[0] || "0";
  let fractionalPart = parts[1] || "";

  if (fractionalPart.length > decimals) {
    fractionalPart = fractionalPart.slice(0, decimals);
  } else {
    fractionalPart = fractionalPart.padEnd(decimals, "0");
  }

  const combined = integerPart + fractionalPart;
  return BigInt(combined.replace(/^0+/, "") || "0");
}

export function formatTokenUnits(
  units: bigint | string,
  decimals: number,
): string {
  const str = String(units).padStart(decimals + 1, "0");
  const splitIndex = str.length - decimals;
  const integerPart = str.slice(0, splitIndex) || "0";
  const fractionalPart = str.slice(splitIndex);
  return `${integerPart}.${fractionalPart.slice(0, 4)}`;
}

/**
 * Safely extract TRON Base58 address from TronLink App or Extension provider.
 * Handles both string defaultAddress and object defaultAddress.base58.
 */
export function extractTronAddress(): string {
  if (typeof window === "undefined" || !(window as any).tronWeb) return "";

  const defaultAddr = (window as any).tronWeb.defaultAddress;
  if (typeof defaultAddr === "string" && isTronAddress(defaultAddr)) {
    return defaultAddr;
  }
  if (
    defaultAddr &&
    typeof defaultAddr.base58 === "string" &&
    isTronAddress(defaultAddr.base58)
  ) {
    return defaultAddr.base58;
  }

  if ((window as any).tronLink && (window as any).tronLink.tronWeb) {
    const linkAddr = (window as any).tronLink.tronWeb.defaultAddress;
    if (typeof linkAddr === "string" && isTronAddress(linkAddr)) {
      return linkAddr;
    }
    if (
      linkAddr &&
      typeof linkAddr.base58 === "string" &&
      isTronAddress(linkAddr.base58)
    ) {
      return linkAddr.base58;
    }
  }

  if (
    typeof (window as any).tronWeb.address === "string" &&
    isTronAddress((window as any).tronWeb.address)
  ) {
    return (window as any).tronWeb.address;
  }

  return "";
}
