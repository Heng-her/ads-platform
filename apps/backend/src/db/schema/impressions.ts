import { sqliteTable, text, integer } from "drizzle-orm/sqlite-core";
import { campaigns } from "./campaigns";

export const impressions = sqliteTable("impressions", {
  id: text("id").primaryKey(),
  campaignId: text("campaign_id")
    .notNull()
    .references(() => campaigns.id, { onDelete: "cascade" }),

  // Hashed fingerprint: SHA-256 of (IP + User-Agent + UTC date)
  // Used for daily unique viewer estimation without storing PII
  viewerHash: text("viewer_hash").notNull(),

  createdAt: integer("created_at", { mode: "timestamp" })
    .notNull()
    .$defaultFn(() => new Date()),
});

export type Impression = typeof impressions.$inferSelect;
export type NewImpression = typeof impressions.$inferInsert;
