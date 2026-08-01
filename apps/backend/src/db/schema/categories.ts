import { sqliteTable, text, integer } from "drizzle-orm/sqlite-core";
import { users } from "./users";

// ── System Categories (ADMIN-managed, public) ─────────────────────────────────
export const systemCategories = sqliteTable("system_categories", {
  id: integer("id").primaryKey({ autoIncrement: true }),
  name: text("name").notNull().unique(),
  createdAt: integer("created_at", { mode: "timestamp" })
    .notNull()
    .$defaultFn(() => new Date()),
});

// ── Custom Categories (CREATOR-managed, private to owner) ─────────────────────
export const customCategories = sqliteTable("custom_categories", {
  id: integer("id").primaryKey({ autoIncrement: true }),
  userId: text("user_id")
    .notNull()
    .references(() => users.id, { onDelete: "cascade" }),
  name: text("name").notNull(),
  createdAt: integer("created_at", { mode: "timestamp" })
    .notNull()
    .$defaultFn(() => new Date()),
});

export type SystemCategory = typeof systemCategories.$inferSelect;
export type NewSystemCategory = typeof systemCategories.$inferInsert;
export type CustomCategory = typeof customCategories.$inferSelect;
export type NewCustomCategory = typeof customCategories.$inferInsert;
