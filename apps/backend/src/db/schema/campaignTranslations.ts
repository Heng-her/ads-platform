import { index, integer, sqliteTable, text, uniqueIndex } from "drizzle-orm/sqlite-core";
import { campaigns } from "./campaigns";

export const campaignTranslations = sqliteTable("campaign_translations", {
  id: text("id").primaryKey(),
  campaignId: text("campaign_id").notNull().references(() => campaigns.id, { onDelete: "cascade" }),
  locale: text("locale").notNull(),
  title: text("title").notNull(),
  description: text("description"),
  content: text("content"),
  imageTitle: text("image_title"),
  imageDescription: text("image_description"),
  provider: text("provider").notNull().default("google"),
  createdAt: integer("created_at", { mode: "timestamp" }).notNull().$defaultFn(() => new Date()),
  updatedAt: integer("updated_at", { mode: "timestamp" }).notNull().$defaultFn(() => new Date()),
}, (table) => [
  uniqueIndex("campaign_translations_campaign_locale_idx").on(table.campaignId, table.locale),
  index("campaign_translations_locale_idx").on(table.locale),
]);
