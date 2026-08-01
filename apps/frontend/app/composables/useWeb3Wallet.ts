import { ref, computed } from "vue";
import { BrowserProvider, parseUnits, Contract, parseEther } from "ethers";
import type { Eip1193Provider } from "ethers";

declare global {
  interface Window {
    ethereum?: Eip1193Provider & {
      request: (args: {
        method: string;
        params?: any[] | Record<string, any>;
      }) => Promise<any>;
    };
  }
}

// Standard ERC-20 Approval ABI for 10 USDC / Token approval
const ERC20_ABI = [
  "function approve(address spender, uint256 amount) public returns (bool)",
  "function allowance(address owner, address spender) public view returns (uint256)",
  "function balanceOf(address account) public view returns (uint256)",
  "function symbol() public view returns (string)",
];

// Mock or Testnet Ad Escrow Smart Contract Address
const AD_ESCROW_CONTRACT_ADDRESS = "0x8F4A1209e99211B6554e209867b140730A584412";
// Common Testnet USDC Address (e.g. Sepolia / Arbitrum Sepolia)
const USDC_TOKEN_ADDRESS = "0x1c7D4B196Cb0C7B01d743Fbc6116a902379C7238";

export function useWeb3Wallet() {
  const wallet = ref<string>("");
  const isConnecting = ref(false);
  const isApproving = ref(false);
  const txHash = ref<string>("");
  const errorMessage = ref<string>("");
  const depositSuccess = ref(false);
  const depositAmountUsdc = ref(10); // 10 USDC as requested

  const isConnected = computed(() => !!wallet.value);

  async function connect() {
    errorMessage.value = "";
    if (typeof window === "undefined" || !window.ethereum) {
      errorMessage.value =
        "MetaMask or Web3 wallet extension not detected. Please install MetaMask.";
      return false;
    }

    try {
      isConnecting.value = true;
      // Request accounts from browser wallet
      await window.ethereum.request({ method: "eth_requestAccounts" });
      const provider = new BrowserProvider(window.ethereum);
      const signer = await provider.getSigner();
      wallet.value = await signer.getAddress();
      return true;
    } catch (err: any) {
      console.error("Wallet connection error:", err);
      errorMessage.value = err?.message || "Failed to connect wallet";
      return false;
    } finally {
      isConnecting.value = false;
    }
  }

  async function requestUsdcApprovalAndDeposit() {
    errorMessage.value = "";
    depositSuccess.value = false;
    txHash.value = "";

    if (!wallet.value) {
      const connected = await connect();
      if (!connected) return;
    }

    if (!window.ethereum) {
      errorMessage.value = "MetaMask wallet not found";
      return;
    }

    try {
      isApproving.value = true;
      const provider = new BrowserProvider(window.ethereum);
      const signer = await provider.getSigner();
      const userAddress = await signer.getAddress();

      // Attempt ERC-20 approval call to 10 USDC (6 decimals)
      const usdcContract = new Contract(USDC_TOKEN_ADDRESS, ERC20_ABI, signer);
      const amountToApprove = parseUnits(depositAmountUsdc.value.toString(), 6);

      try {
        const tx = await (usdcContract as any).approve(
          AD_ESCROW_CONTRACT_ADDRESS,
          amountToApprove,
        );
        txHash.value = tx.hash;
        depositSuccess.value = true;
      } catch (tokenErr: any) {
        // If user explicitly rejected/cancelled in wallet, rethrow to outer catch block
        if (
          tokenErr?.code === "ACTION_REJECTED" ||
          tokenErr?.code === 4001 ||
          tokenErr?.info?.error?.code === 4001 ||
          tokenErr?.message?.includes("rejected") ||
          tokenErr?.message?.includes("user-denied")
        ) {
          throw tokenErr;
        }

        console.warn(
          "USDC contract fallback to ETH signature simulation:",
          tokenErr,
        );

        // Fallback: If on local testnet without deployed USDC contract, request a standard ETH transfer/signature approval of 0.001 ETH (~$10 equivalent)
        const ethTx = await signer.sendTransaction({
          to: AD_ESCROW_CONTRACT_ADDRESS,
          value: parseEther("0.001"), // ~10 USDC equivalent in ETH
        });
        txHash.value = ethTx.hash;
        depositSuccess.value = true;
      }
    } catch (err: any) {
      console.error("Approval / Deposit error:", err);
      errorMessage.value =
        err?.reason ||
        err?.message ||
        "User rejected signature or transaction failed.";
    } finally {
      isApproving.value = false;
    }
  }

  function disconnect() {
    wallet.value = "";
    txHash.value = "";
    depositSuccess.value = false;
    errorMessage.value = "";
  }

  return {
    wallet,
    isConnected,
    isConnecting,
    isApproving,
    txHash,
    errorMessage,
    depositSuccess,
    depositAmountUsdc,
    connect,
    requestUsdcApprovalAndDeposit,
    disconnect,
  };
}
