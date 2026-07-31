import { sqliteTable, text, integer } from "drizzle-orm/sqlite-core";
import { users } from "./users";

export const campaigns = sqliteTable("campaigns", {
  id: text("id").primaryKey(),
  userId: text("user_id")
    .notNull()
    .references(() => users.id, { onDelete: "cascade" }),

  // Article & Content Details
  title: text("title").notNull(),
  description: text("description"),
  category: text("category"), // e.g. "NEWS", "TECHNOLOGY", "ENTERTAINMENT", "FINANCE", "GENERAL"
  contentType: text("content_type").default("ARTICLE").notNull(), // e.g. "ARTICLE", "NEWS", "BANNER"
  content: text("content"), // Rich text / Paragraphs (supports b, i, point lists, code tags)

  // Image Upload (Stored in Cloudflare R2 Bucket)
  imageUrl: text("image_url"), // Cloudflare R2 public URL / path
  imageTitle: text("image_title"), // Image title / alt text
  imageDescription: text("image_description"), // Image description / caption

  // Monetization & Ad Network Integration (Adsterra, Google Ads / AdSense)
  adNetwork: text("ad_network"), // e.g. "GOOGLE_ADSENSE", "ADSTERRA", "CUSTOM"
  adUnitCode: text("ad_unit_code"), // Ad slot / zone code snippet for ads placement

  // Status (Simplified to DRAFT or PUBLIC) & Timestamps
  status: text("status", {
    enum: ["DRAFT", "PUBLIC"],
  })
    .default("PUBLIC")
    .notNull(),

  // Soft Delete: creators see it as deleted, admins still see it
  isDeleted: integer("is_deleted", { mode: "boolean" }).default(false).notNull(),
  deletedAt: integer("deleted_at", { mode: "timestamp" }),

  createdAt: integer("created_at", { mode: "timestamp" })
    .notNull()
    .$defaultFn(() => new Date()),
  updatedAt: integer("updated_at", { mode: "timestamp" })
    .notNull()
    .$defaultFn(() => new Date()),
});

export type Campaign = typeof campaigns.$inferSelect;
export type NewCampaign = typeof campaigns.$inferInsert;
