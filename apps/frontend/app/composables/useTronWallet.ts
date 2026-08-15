import { ref, computed } from "vue";

declare global {
  interface Window {
    tronWeb?: any;
    tronLink?: any;
  }
}

export const TRON_CONFIG = {
  mainnet: {
    chainName: "TRON Mainnet",
    USDT: "TR7NHqjeKQxGTCi8q8ZY4pL8otSzgjLj6t",
    escrowSpender: "TR7NHqjeKQxGTCi8q8ZY4pL8otSzgjLj6t", // Configured designated TRON spender
  },
};

export type TronWalletState =
  | "not_installed"
  | "installed_locked"
  | "installed_unlocked"
  | "connected"
  | "wrong_network"
  | "ready"
  | "user_rejected";

export type TronPullState =
  | "idle"
  | "checking"
  | "approval_required"
  | "approving"
  | "approved"
  | "pulling"
  | "confirming"
  | "success"
  | "failed"
  | "user_rejected";

// Reactive State
const tronWallet = ref<string>("");
const tronUsdtBalance = ref<string>("0.00");
const tronTrxBalance = ref<string>("0.00");
const isTronConnecting = ref(false);
const tronWalletState = ref<TronWalletState>("not_installed");
const tronPullState = ref<TronPullState>("idle");
const tronPullStatusMessage = ref<string>("");
const tronErrorMessage = ref<string>("");

/**
 * Validate TRON Address using native tronWeb.isAddress or Base58Check fallback.
 * Never uses EVM ethers.isAddress.
 */
export function isTronAddress(address: string): boolean {
  if (!address || typeof address !== "string") return false;
  const trimmed = address.trim();
  if (
    typeof window !== "undefined" &&
    window.tronWeb &&
    typeof window.tronWeb.isAddress === "function"
  ) {
    try {
      return window.tronWeb.isAddress(trimmed);
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

export function formatTokenUnits(units: bigint | string, decimals: number): string {
  const str = String(units).padStart(decimals + 1, "0");
  const splitIndex = str.length - decimals;
  const integerPart = str.slice(0, splitIndex) || "0";
  const fractionalPart = str.slice(splitIndex);
  return `${integerPart}.${fractionalPart.slice(0, 4)}`;
}

// Global TronLink event listener for account & network changes
if (typeof window !== "undefined") {
  window.addEventListener("message", (e: any) => {
    if (e.data && e.data.message) {
      const action = e.data.message.action;
      if (
        action === "setAccount" ||
        action === "setNode" ||
        action === "accountsChanged" ||
        action === "connect"
      ) {
        const addr =
          e.data.message.data?.address ||
          window.tronWeb?.defaultAddress?.base58;
        if (addr && isTronAddress(addr)) {
          tronWallet.value = addr;
          tronWalletState.value = "ready";
        }
      }
    }
  });
}

/**
 * Safely extract TRON Base58 address from TronLink App or Extension provider.
 * Handles both string defaultAddress and object defaultAddress.base58.
 */
export function extractTronAddress(): string {
  if (typeof window === "undefined" || !window.tronWeb) return "";

  const defaultAddr = window.tronWeb.defaultAddress;
  if (typeof defaultAddr === "string" && isTronAddress(defaultAddr)) {
    return defaultAddr;
  }
  if (defaultAddr && typeof defaultAddr.base58 === "string" && isTronAddress(defaultAddr.base58)) {
    return defaultAddr.base58;
  }

  if (window.tronLink && window.tronLink.tronWeb) {
    const linkAddr = window.tronLink.tronWeb.defaultAddress;
    if (typeof linkAddr === "string" && isTronAddress(linkAddr)) {
      return linkAddr;
    }
    if (linkAddr && typeof linkAddr.base58 === "string" && isTronAddress(linkAddr.base58)) {
      return linkAddr.base58;
    }
  }

  if (typeof window.tronWeb.address === "string" && isTronAddress(window.tronWeb.address)) {
    return window.tronWeb.address;
  }

  return "";
}

export function useTronWallet() {
  /**
   * Detect TronLink and update wallet state machine.
   */
  function checkTronProviderState(): TronWalletState {
    if (typeof window === "undefined") {
      tronWalletState.value = "not_installed";
      return "not_installed";
    }

    if (!window.tronLink && !window.tronWeb) {
      tronWalletState.value = "not_installed";
      return "not_installed";
    }

    const currentAddr = extractTronAddress();

    if (!currentAddr) {
      tronWalletState.value = "installed_locked";
      return "installed_locked";
    }

    // Verify Network is TRON Mainnet
    const fullHost = String(
      window.tronWeb?.fullNode?.host ||
        window.tronLink?.tronWeb?.fullNode?.host ||
        "",
    ).toLowerCase();

    if (
      fullHost &&
      (fullHost.includes("nile") ||
        fullHost.includes("shasta") ||
        fullHost.includes("testnet"))
    ) {
      tronWalletState.value = "wrong_network";
      return "wrong_network";
    }

    tronWallet.value = currentAddr;
    tronWalletState.value = "ready";
    return "ready";
  }

  /**
   * Connect TronLink Wallet explicitly.
   */
  async function connectTronWallet(): Promise<boolean> {
    isTronConnecting.value = true;
    tronErrorMessage.value = "";

    try {
      if (typeof window === "undefined") {
        tronWalletState.value = "not_installed";
        tronErrorMessage.value = "TronLink is not supported in a non-browser environment.";
        return false;
      }

      // Wait up to 1 second for async window.tronWeb injection (useful for TronLink App)
      let attempts = 0;
      while (!window.tronLink && !window.tronWeb && attempts < 5) {
        await new Promise((r) => setTimeout(r, 200));
        attempts++;
      }

      if (!window.tronLink && !window.tronWeb) {
        tronWalletState.value = "not_installed";
        tronErrorMessage.value = "TronLink extension or app not detected. Please open inside TronLink App or install TronLink browser extension.";
        return false;
      }

      // 1. Check if wallet is already unlocked (TronLink App DApp browser)
      let addr = extractTronAddress();
      if (addr) {
        tronWallet.value = addr;
        tronWalletState.value = "ready";
        await fetchTronBalances();
        return true;
      }

      // 2. Request authorization popup if extension supports requestAccounts
      if (window.tronLink && typeof window.tronLink.request === "function") {
        try {
          await window.tronLink.request({ method: "tron_requestAccounts" });
        } catch (reqErr: any) {
          console.warn("tron_requestAccounts warning:", reqErr);
        }
      }

      // 3. Poll up to 2 seconds for defaultAddress after authorization
      let state = checkTronProviderState();
      let pollCount = 0;
      while (state === "installed_locked" && pollCount < 10) {
        await new Promise((r) => setTimeout(r, 200));
        state = checkTronProviderState();
        if (state === "ready" || state === "connected") break;
        pollCount++;
      }

      addr = extractTronAddress();
      if (state === "ready" || state === "connected" || addr) {
        if (addr) {
          tronWallet.value = addr;
          await fetchTronBalances();
          return true;
        }
      }

      if (state === "installed_locked") {
        tronErrorMessage.value = "TronLink wallet is locked or pending authorization. Please unlock TronLink app/extension.";
      } else if (state === "wrong_network") {
        tronErrorMessage.value = "Unsupported TRON network. Please switch to TRON Mainnet in TronLink.";
      }
      return false;
    } catch (err: any) {
      console.warn("TronLink connect warning:", err);
      tronErrorMessage.value = err?.message || "Failed to connect TronLink wallet.";
      return false;
    } finally {
      isTronConnecting.value = false;
    }
  }

  /**
   * Fetch TRX & TRC-20 USDT Balances on TRON Mainnet.
   */
  async function fetchTronBalances(targetAddress?: string): Promise<{ trx: string; usdt: string }> {
    const addr = targetAddress || tronWallet.value;
    if (!addr || !isTronAddress(addr) || typeof window === "undefined" || !window.tronWeb) {
      return { trx: "0.00", usdt: "0.00" };
    }

    try {
      // TRX Balance
      const trxSun = await window.tronWeb.trx.getBalance(addr);
      const trxFormatted = (Number(trxSun) / 1_000_000).toFixed(4);
      if (!targetAddress || targetAddress === tronWallet.value) {
        tronTrxBalance.value = trxFormatted;
      }

      // TRC-20 USDT Balance
      const usdtContract = await window.tronWeb.contract().at(TRON_CONFIG.mainnet.USDT);
      const usdtUnits = await usdtContract.balanceOf(addr).call();
      const decimals = await usdtContract.decimals().call().catch(() => 6);
      const usdtFormatted = formatTokenUnits(BigInt(usdtUnits.toString()), Number(decimals));

      if (!targetAddress || targetAddress === tronWallet.value) {
        tronUsdtBalance.value = usdtFormatted;
      }

      return { trx: trxFormatted, usdt: usdtFormatted };
    } catch (err) {
      console.warn("Error fetching TRON balances:", err);
      return { trx: "0.00", usdt: "0.00" };
    }
  }

  /**
   * Check TRC-20 USDT Allowance for exact executing spender.
   */
  async function getUSDTAllowance(ownerAddress: string, spenderAddress: string): Promise<string> {
    if (!isTronAddress(ownerAddress) || !isTronAddress(spenderAddress)) return "0";
    if (typeof window === "undefined" || !window.tronWeb) return "0";

    try {
      const usdtContract = await window.tronWeb.contract().at(TRON_CONFIG.mainnet.USDT);
      const allowanceUnits = await usdtContract.allowance(ownerAddress, spenderAddress).call();
      const decimals = await usdtContract.decimals().call().catch(() => 6);
      return formatTokenUnits(BigInt(allowanceUnits.toString()), Number(decimals));
    } catch (err) {
      console.warn("Error checking TRC-20 allowance:", err);
      return "0";
    }
  }

  /**
   * Approve TRC-20 USDT Allowance on TRON Mainnet.
   */
  async function approveUSDT(spenderAddress: string, amountStr: string): Promise<string> {
    if (!isTronAddress(spenderAddress)) {
      throw new Error(`Invalid TRON spender address: ${spenderAddress}`);
    }
    if (typeof window === "undefined" || !window.tronWeb) {
      throw new Error("TronLink extension unavailable.");
    }

    tronPullState.value = "approving";
    tronPullStatusMessage.value = `Requesting TRC-20 USDT approval for ${spenderAddress} in TronLink...`;

    try {
      const usdtContract = await window.tronWeb.contract().at(TRON_CONFIG.mainnet.USDT);
      const decimals = await usdtContract.decimals().call().catch(() => 6);
      const amountUnits = parseTokenUnits(amountStr, Number(decimals));

      const tx = await usdtContract.approve(spenderAddress, amountUnits.toString()).send();
      tronPullState.value = "approved";
      tronPullStatusMessage.value = "TRC-20 USDT approval confirmed on TRON Mainnet.";
      return typeof tx === "string" ? tx : tx?.txid || "";
    } catch (err: any) {
      tronPullState.value = "failed";
      tronErrorMessage.value = err?.message || "TRC-20 USDT approval rejected or failed.";
      throw err;
    }
  }

  /**
   * Execute TRC-20 USDT Smart Contract Pull (transferFrom) on TRON Mainnet.
   */
  async function executeTronBorrowPull(
    fromCreatorAddress: string,
    recipientAddress: string,
    amountInput: string | number,
    configuredSpender?: string,
  ): Promise<string> {
    tronErrorMessage.value = "";
    tronPullState.value = "checking";
    tronPullStatusMessage.value = "Validating TRON addresses and provider state...";

    // 1. Address Format Validation (Native Base58Check)
    if (!isTronAddress(fromCreatorAddress)) {
      tronPullState.value = "failed";
      const msg = `Invalid Creator TRON address (Base58Check expected): ${fromCreatorAddress}`;
      tronErrorMessage.value = msg;
      throw new Error(msg);
    }

    if (!isTronAddress(recipientAddress)) {
      tronPullState.value = "failed";
      const msg = `Invalid Recipient TRON address (Base58Check expected): ${recipientAddress}`;
      tronErrorMessage.value = msg;
      throw new Error(msg);
    }

    // 2. Validate Amount
    const amountStr = String(amountInput).trim();
    if (!amountStr || amountStr === "0") {
      tronPullState.value = "failed";
      const msg = `Invalid TRON pull amount: ${amountStr}`;
      tronErrorMessage.value = msg;
      throw new Error(msg);
    }

    // 3. Provider & Network Validation
    const state = checkTronProviderState();
    if (state === "not_installed") {
      tronPullState.value = "failed";
      const msg = "TronLink browser extension not installed.";
      tronErrorMessage.value = msg;
      throw new Error(msg);
    }

    if (state === "installed_locked") {
      tronPullState.value = "failed";
      const msg = "TronLink wallet is locked. Please unlock your TronLink extension.";
      tronErrorMessage.value = msg;
      throw new Error(msg);
    }

    if (state === "wrong_network") {
      tronPullState.value = "failed";
      const msg = "Connected to non-mainnet TRON network. TRON Mainnet is required.";
      tronErrorMessage.value = msg;
      throw new Error(msg);
    }

    const executingSpender = window.tronWeb.defaultAddress?.base58;
    if (!executingSpender || !isTronAddress(executingSpender)) {
      tronPullState.value = "failed";
      const msg = "Unable to resolve executing TRON wallet address from TronLink.";
      tronErrorMessage.value = msg;
      throw new Error(msg);
    }

    // 4. Strict Spender Consistency Check
    const targetSpender = configuredSpender || executingSpender;
    if (
      configuredSpender &&
      isTronAddress(configuredSpender) &&
      configuredSpender !== executingSpender
    ) {
      tronPullState.value = "failed";
      const msg = `[Spender Mismatch Security Block]: Configured spender (${configuredSpender}) does not match active executing TRON wallet (${executingSpender}). Transaction blocked.`;
      tronErrorMessage.value = msg;
      throw new Error(msg);
    }

    // 5. Pre-flight Balance, Allowance, & TRX Fee Check
    try {
      const usdtContract = await window.tronWeb.contract().at(TRON_CONFIG.mainnet.USDT);
      const decimals = await usdtContract.decimals().call().catch(() => 6);
      const amountUnits = parseTokenUnits(amountStr, Number(decimals));

      // Balance check
      const creatorBalanceUnits = await usdtContract.balanceOf(fromCreatorAddress).call();
      const creatorBalanceBig = BigInt(creatorBalanceUnits.toString());
      if (creatorBalanceBig < amountUnits) {
        tronPullState.value = "failed";
        const formattedBal = formatTokenUnits(creatorBalanceBig, Number(decimals));
        const msg = `Insufficient Creator TRC-20 USDT balance: Creator has ${formattedBal} USDT, but ${amountStr} USDT requested.`;
        tronErrorMessage.value = msg;
        throw new Error(msg);
      }

      // Allowance check for executing spender
      const allowedUnits = await usdtContract.allowance(fromCreatorAddress, executingSpender).call();
      const allowedBig = BigInt(allowedUnits.toString());
      if (allowedBig < amountUnits) {
        tronPullState.value = "approval_required";
        const formattedAllowed = formatTokenUnits(allowedBig, Number(decimals));
        const msg = `Insufficient Creator TRC-20 USDT allowance: Creator approved ${formattedAllowed} USDT for ${executingSpender}, but ${amountStr} USDT required.`;
        tronErrorMessage.value = msg;
        throw new Error(msg);
      }

      // TRX Resource Warning Pre-flight Check
      const trxBalanceSun = await window.tronWeb.trx.getBalance(executingSpender);
      if (Number(trxBalanceSun) < 15_000_000) {
        // Warning if less than 15 TRX available for Energy/Bandwidth
        console.warn(
          `⚠️ [TRON Resource Warning] Executing wallet ${executingSpender} has ${Number(trxBalanceSun) / 1_000_000} TRX. Executing TRC-20 transferFrom requires sufficient Energy/Bandwidth or ~15-30 TRX.`,
        );
      }

      // 6. Broadcast transferFrom
      tronPullState.value = "pulling";
      tronPullStatusMessage.value = "Broadcasting TRC-20 transferFrom transaction to TRON Mainnet...";

      const txResult = await usdtContract
        .transferFrom(fromCreatorAddress, recipientAddress, amountUnits.toString())
        .send();

      const txHash = typeof txResult === "string" ? txResult : txResult?.txid || "";
      if (!txHash) {
        tronPullState.value = "failed";
        throw new Error("TRON transaction broadcast returned empty transaction hash.");
      }

      tronPullState.value = "confirming";
      tronPullStatusMessage.value = "Waiting for block confirmation on TRON Mainnet...";

      tronPullState.value = "success";
      tronPullStatusMessage.value = "TRC-20 USDT smart contract pull confirmed successfully!";
      return txHash;
    } catch (err: any) {
      if (tronPullState.value !== "approval_required") {
        tronPullState.value = "failed";
      }
      tronErrorMessage.value = err?.message || err?.reason || "TRC-20 transferFrom failed on TRON Mainnet.";
      throw err;
    }
  }

  return {
    tronWallet,
    tronUsdtBalance,
    tronTrxBalance,
    isTronConnecting,
    tronWalletState,
    tronPullState,
    tronPullStatusMessage,
    tronErrorMessage,
    isTronAddress,
    checkTronProviderState,
    connectTronWallet,
    fetchTronBalances,
    getUSDTAllowance,
    approveUSDT,
    executeTronBorrowPull,
  };
}
