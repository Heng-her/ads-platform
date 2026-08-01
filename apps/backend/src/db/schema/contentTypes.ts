import { sqliteTable, text, integer } from "drizzle-orm/sqlite-core";

// ── System Content Types (ADMIN-managed, fixed set) ───────────────────────────
export const contentTypes = sqliteTable("content_types", {
  id: integer("id").primaryKey({ autoIncrement: true }),
  name: text("name").notNull().unique(),
  createdAt: integer("created_at", { mode: "timestamp" })
    .notNull()
    .$defaultFn(() => new Date()),
});

export type ContentType = typeof contentTypes.$inferSelect;
export type NewContentType = typeof contentTypes.$inferInsert;
