import { sqliteTable, text, integer } from "drizzle-orm/sqlite-core";

export const systemSettings = sqliteTable("system_settings", {
  key: text("key").primaryKey(), // "platform" | "dispatch"
  valueJson: text("value_json").notNull(),
  updatedAt: integer("updated_at", { mode: "timestamp" })
    .notNull()
    .$defaultFn(() => new Date()),
});

export type SystemSetting = typeof systemSettings.$inferSelect;
export type NewSystemSetting = typeof systemSettings.$inferInsert;
