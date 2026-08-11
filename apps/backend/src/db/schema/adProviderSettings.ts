import { sqliteTable, text, integer } from "drizzle-orm/sqlite-core";

export const adProviderSettings = sqliteTable("ad_provider_settings", {
  id: text("id").primaryKey(), // e.g. "GOOGLE_ADSENSE" | "ADSTERRA"
  provider: text("provider").notNull(), // "GOOGLE_ADSENSE" | "ADSTERRA"
  enabled: integer("enabled", { mode: "boolean" }).default(true).notNull(),
  credentialsJson: text("credentials_json").notNull(), // Encrypted / Secret JSON String
  updatedAt: integer("updated_at", { mode: "timestamp" })
    .notNull()
    .$defaultFn(() => new Date()),
});

export type AdProviderSetting = typeof adProviderSettings.$inferSelect;
export type NewAdProviderSetting = typeof adProviderSettings.$inferInsert;
