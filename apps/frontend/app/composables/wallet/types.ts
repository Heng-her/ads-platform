export type PullTransactionState =
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

export type SupportedChainFamily = "EVM" | "TRON";

export interface EVMChainDetails {
  chainName: string;
  USDC: string;
  USDT: string;
  WETH: string;
  escrowSpender: string;
}

export type ChainConfigMapping = Record<string, EVMChainDetails>;

export interface TronChainDetails {
  chainName: string;
  USDT: string;
  escrowSpender: string;
}

export interface AuditRecord {
  creatorAddress: string;
  spenderAddress: string;
  recipientAddress: string;
  tokenAddress: string;
  tokenSymbol: string;
  amount: string;
  amountUnits: string;
  chainId: string;
  pullTransactionHash: string;
  timestamp: string;
}
