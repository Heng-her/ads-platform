import { sqliteTable, text, integer, index } from "drizzle-orm/sqlite-core";
import { campaigns } from "./campaigns";
import { users } from "./users";

export const adClicks = sqliteTable(
  "ad_clicks",
  {
    id: text("id").primaryKey(),
    campaignId: text("campaign_id").references(() => campaigns.id, {
      onDelete: "set null",
    }),
    creatorId: text("creator_id")
      .notNull()
      .references(() => users.id, { onDelete: "cascade" }),
    provider: text("provider").notNull(), // 'ADSTERRA' | 'GOOGLE_ADSENSE'
    format: text("format").notNull(), // 'SMARTLINK' | 'BANNER' | 'NATIVE'
    placement: text("placement").notNull(), // 'header' | 'inArticle' | 'sidebar' | 'articleTop' | 'articleSidebar' | 'categoryFeed'
    viewerHash: text("viewer_hash").notNull(),
    createdAt: integer("created_at", { mode: "timestamp" })
      .notNull()
      .$defaultFn(() => new Date()),
  },
  (table) => ({
    campaignIdx: index("idx_ad_clicks_campaign_id").on(table.campaignId),
    creatorIdx: index("idx_ad_clicks_creator_id").on(table.creatorId),
    createdAtIdx: index("idx_ad_clicks_created_at").on(table.createdAt),
  })
);

export type AdClick = typeof adClicks.$inferSelect;
export type NewAdClick = typeof adClicks.$inferInsert;
