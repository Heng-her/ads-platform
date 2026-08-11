import { sqliteTable, text, integer, real } from "drizzle-orm/sqlite-core";

export const users = sqliteTable("users", {
  id: text("id").primaryKey(),
  username: text("username").notNull().unique(),
  email: text("email").notNull().unique(),
  passwordHash: text("password_hash").notNull(),
  avatar: text("avatar"), // Profile avatar image URL
  portfolioLink: text("portfolio_link"), // Optional portfolio / website URL
  country: text("country"), // ISO 3166-1 alpha-2 country code (e.g. "US", "NG")
  apiKeys: text("api_keys", { mode: "json" }).$type<Record<string, string>>(), // JSON object storing API keys e.g. { "create_admin": "...", "upload_image": "..." }
  ecpmRate: real("ecpm_rate").default(2.50).notNull(), // eCPM rate ($ per 1,000 impressions)
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
