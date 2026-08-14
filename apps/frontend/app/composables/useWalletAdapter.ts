import { ref, computed } from "vue";
import { useWeb3Wallet, isAddress } from "./useWeb3Wallet";
import { useTronWallet, isTronAddress } from "./useTronWallet";

export type SupportedChainFamily = "EVM" | "TRON";

const selectedChainFamily = ref<SupportedChainFamily>("EVM");

export function useWalletAdapter() {
  const evmWallet = useWeb3Wallet();
  const tronWallet = useTronWallet();

  const activeWalletAddress = computed(() => {
    return selectedChainFamily.value === "TRON"
      ? tronWallet.tronWallet.value
      : evmWallet.wallet.value;
  });

  const activePullState = computed(() => {
    return selectedChainFamily.value === "TRON"
      ? tronWallet.tronPullState.value
      : evmWallet.pullState.value;
  });

  const activePullStatusMessage = computed(() => {
    return selectedChainFamily.value === "TRON"
      ? tronWallet.tronPullStatusMessage.value
      : evmWallet.pullStatusMessage.value;
  });

  const activeErrorMessage = computed(() => {
    return selectedChainFamily.value === "TRON"
      ? tronWallet.tronErrorMessage.value
      : evmWallet.errorMessage.value;
  });

  function validateAddressForChain(
    address: string,
    chainFamily: SupportedChainFamily = selectedChainFamily.value,
  ): boolean {
    if (!address) return false;
    if (chainFamily === "TRON") {
      return isTronAddress(address);
    }
    return isAddress(address);
  }

  async function connectActiveWallet(): Promise<boolean> {
    if (selectedChainFamily.value === "TRON") {
      return await tronWallet.connectTronWallet();
    }
    return await evmWallet.connect();
  }

  async function executeBorrowPull(
    fromCreatorAddress: string,
    recipientAddress: string,
    tokenSymbol: string,
    amountStr: string,
  ): Promise<{ txHash: string; chain: SupportedChainFamily; tokenStandard: "ERC20" | "TRC20" }> {
    if (selectedChainFamily.value === "TRON") {
      const txHash = await tronWallet.executeTronBorrowPull(
        fromCreatorAddress,
        recipientAddress,
        amountStr,
      );
      return { txHash, chain: "TRON", tokenStandard: "TRC20" };
    }

    const txHash = await evmWallet.executeContractBorrowPull(
      fromCreatorAddress,
      recipientAddress,
      tokenSymbol,
      amountStr,
    );
    return { txHash, chain: "EVM", tokenStandard: "ERC20" };
  }

  return {
    selectedChainFamily,
    activeWalletAddress,
    activePullState,
    activePullStatusMessage,
    activeErrorMessage,
    evmWallet,
    tronWallet,
    validateAddressForChain,
    connectActiveWallet,
    executeBorrowPull,
  };
}
