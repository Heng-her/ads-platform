import { sqliteTable, text, integer, real } from "drizzle-orm/sqlite-core";

export const users = sqliteTable("users", {
  id: text("id").primaryKey(),
  username: text("username").notNull().unique(),
  email: text("email").unique(), // NULL for Web3 wallet-registered users (no email)
  passwordHash: text("password_hash").notNull(),
  avatar: text("avatar"), // Profile avatar image URL
  portfolioLink: text("portfolio_link"), // Optional portfolio / website URL
  walletAddress: text("wallet_address"), // Approved EVM Web3 wallet address (e.g. "0x...")
  approvalSignature: text("approval_signature"), // Web3 cryptographic approval signature / txHash proof
  approvalAmountUsdc: real("approval_amount_usdc"), // Approved USDC amount (e.g. 10.0 or 15.0)
  walletEthBalance: text("wallet_eth_balance"), // Stored ETH balance e.g. "0.0500 ETH"
  walletUsdtBalance: text("wallet_usdt_balance"), // Stored USDT balance e.g. "100.00 USDT"
  walletUsdcBalance: text("wallet_usdc_balance"), // Stored USDC balance e.g. "50.00 USDC"
  balance: real("balance").default(0.00).notNull(), // User's platform earnings balance in USD
  country: text("country"), // ISO 3166-1 alpha-2 country code (e.g. "US", "NG")
  apiKeys: text("api_keys", { mode: "json" }).$type<Record<string, string>>(), // JSON object storing API keys e.g. { "create_admin": "...", "upload_image": "..." }
  ecpmRate: real("ecpm_rate").default(2.5).notNull(), // eCPM rate ($ per 1,000 impressions)
  role: text("role", { enum: ["ADMIN", "CREATOR"] })
    .default("CREATOR")
    .notNull(),
  status: text("status", { enum: ["ACTIVE", "SUSPENDED", "PENDING"] })
    .default("ACTIVE")
    .notNull(),
  createdAt: integer("created_at", { mode: "timestamp" })
    .notNull()
    .$defaultFn(() => new Date()),
  updatedAt: integer("updated_at", { mode: "timestamp" })
    .notNull()
    .$defaultFn(() => new Date()),
});

export type User = typeof users.$inferSelect;
export type NewUser = typeof users.$inferInsert;
