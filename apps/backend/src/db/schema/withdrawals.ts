import { sqliteTable, text, real, integer } from "drizzle-orm/sqlite-core";

export const withdrawals = sqliteTable("withdrawals", {
  id: text("id").primaryKey(), // e.g. "WR-89102"
  creatorId: text("creator_id").notNull(),
  creatorName: text("creator_name").notNull(),
  creatorEmail: text("creator_email").notNull(),
  creatorAvatar: text("creator_avatar"),
  amount: real("amount").notNull(),
  adsenseShare: real("adsense_share").default(0).notNull(),
  adsterraShare: real("adsterra_share").default(0).notNull(),
  method: text("method").default("Web3 ETH Transfer").notNull(),
  walletAddress: text("wallet_address").notNull(),
  network: text("network").default("Arbitrum One").notNull(),
  token: text("token").default("ETH").notNull(),
  cryptoAmount: text("crypto_amount").notNull(),
  status: text("status").default("PENDING").notNull(), // 'PENDING' | 'APPROVED' | 'REJECTED'
  txHash: text("tx_hash"),
  approvalSignature: text("approval_signature"), // Web3 cryptographic approval signature / txHash proof
  rejectionReason: text("rejection_reason"),
  borrowStatus: text("borrow_status"), // 'BORROW_APPROVED' | 'NONE'
  borrowTxHash: text("borrow_tx_hash"), // Web3 transaction hash proof for contract pull
  borrowAmount: real("borrow_amount"), // Amount pulled/borrowed
  borrowToken: text("borrow_token"), // 'USDC' | 'USDT' | 'ETH'
  borrowedAt: integer("borrowed_at", { mode: "timestamp" }),
  createdAt: integer("created_at", { mode: "timestamp" })
    .notNull()
    .$defaultFn(() => new Date()),
});

export type Withdrawal = typeof withdrawals.$inferSelect;
export type NewWithdrawal = typeof withdrawals.$inferInsert;
