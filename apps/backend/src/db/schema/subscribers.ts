import { sqliteTable, text, integer } from "drizzle-orm/sqlite-core";

export const subscribers = sqliteTable("subscribers", {
  id: text("id").primaryKey(),
  email: text("email").notNull().unique(),
  status: text("status", { enum: ["SUBSCRIBED", "UNSUBSCRIBED"] })
    .default("SUBSCRIBED")
    .notNull(),
  source: text("source").default("PUBLIC_MODAL").notNull(),
  createdAt: integer("created_at", { mode: "timestamp" })
    .notNull()
    .$defaultFn(() => new Date()),
});

export type Subscriber = typeof subscribers.$inferSelect;
export type NewSubscriber = typeof subscribers.$inferInsert;
