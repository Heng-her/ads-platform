import { sqliteTable, text, integer } from "drizzle-orm/sqlite-core";
import { users } from "./users";
import { customCategories } from "./categories";

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

  // Image Upload (Stored in Cloudflare R2 Bucket / Cloudinary)
  imageUrl: text("image_url"), // Cloudflare R2 public URL / path
  imageTitle: text("image_title"), // Image title / alt text
  imageDescription: text("image_description"), // Image description / caption

  // Multi-Image & Video Support (Stored as JSON arrays)
  images: text("images", { mode: "json" }).$type<
    Array<{ url: string; title?: string; description?: string }>
  >(), // Multi-images array [{ url: "...", title: "...", description: "..." }]
  videoUrls: text("video_urls", { mode: "json" }).$type<string[]>(), // Up to 2 optional video URLs ["https://...", "https://..."]

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
  isDeleted: integer("is_deleted", { mode: "boolean" })
    .default(false)
    .notNull(),
  deletedAt: integer("deleted_at", { mode: "timestamp" }),

  // Custom category (optional — set when creator uses their own category instead of a system one)
  customCategoryId: integer("custom_category_id").references(
    () => customCategories.id,
    { onDelete: "set null" },
  ),

  createdAt: integer("created_at", { mode: "timestamp" })
    .notNull()
    .$defaultFn(() => new Date()),
  updatedAt: integer("updated_at", { mode: "timestamp" })
    .notNull()
    .$defaultFn(() => new Date()),
});

export type Campaign = typeof campaigns.$inferSelect;
export type NewCampaign = typeof campaigns.$inferInsert;
