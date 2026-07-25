import { sqliteTable, text, real, integer } from "drizzle-orm/sqlite-core";
import { users } from "./users";

export const campaigns = sqliteTable("campaigns", {
  id: text("id").primaryKey(),
  userId: text("user_id").notNull().references(() => users.id, { onDelete: "cascade" }),
  title: text("title").notNull(),
  description: text("description"),
  budget: real("budget").notNull(),
  dailyBudget: real("daily_budget"),
  spent: real("spent").default(0).notNull(),
  status: text("status", { enum: ["DRAFT", "PENDING_APPROVAL", "ACTIVE", "PAUSED", "REJECTED", "COMPLETED"] }).default("DRAFT").notNull(),
  startDate: integer("start_date", { mode: "timestamp" }),
  endDate: integer("end_date", { mode: "timestamp" }),
  createdAt: integer("created_at", { mode: "timestamp" }).notNull().$defaultFn(() => new Date()),
  updatedAt: integer("updated_at", { mode: "timestamp" }).notNull().$defaultFn(() => new Date())
});

export type Campaign = typeof campaigns.$inferSelect;
export type NewCampaign = typeof campaigns.$inferInsert;
