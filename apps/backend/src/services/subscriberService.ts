import { eq, count, desc } from "drizzle-orm";
import type { DbClient } from "../db/index";
import { subscribers } from "../db/schema/subscribers";

export class SubscriberService {
  private db: DbClient;

  constructor(db: DbClient) {
    this.db = db;
  }

  async subscribe(
    emailInput: string,
    source: string = "PUBLIC_MODAL",
  ): Promise<{ success: boolean; message: string }> {
    const email = emailInput.trim().toLowerCase();
    if (!email || !email.includes("@")) {
      return { success: false, message: "Please provide a valid email address." };
    }

    const existing = await this.db
      .select()
      .from(subscribers)
      .where(eq(subscribers.email, email))
      .get();

    if (existing) {
      if (existing.status === "SUBSCRIBED") {
        return {
          success: true,
          message: "You are already subscribed to platform updates!",
        };
      } else {
        await this.db
          .update(subscribers)
          .set({ status: "SUBSCRIBED", createdAt: new Date() })
          .where(eq(subscribers.email, email));
        return {
          success: true,
          message: "Welcome back! Your subscription has been reactivated.",
        };
      }
    }

    const id = crypto.randomUUID();
    await this.db.insert(subscribers).values({
      id,
      email,
      status: "SUBSCRIBED",
      source,
      createdAt: new Date(),
    });

    return {
      success: true,
      message: "Thank you for subscribing to our platform updates!",
    };
  }

  async unsubscribe(emailInput: string): Promise<{ success: boolean; message: string }> {
    const email = emailInput.trim().toLowerCase();
    if (!email) return { success: false, message: "Invalid email." };

    await this.db
      .update(subscribers)
      .set({ status: "UNSUBSCRIBED" })
      .where(eq(subscribers.email, email));

    return {
      success: true,
      message: "You have been unsubscribed from platform updates.",
    };
  }

  async getAllActiveSubscribers(): Promise<string[]> {
    const rows = await this.db
      .select({ email: subscribers.email })
      .from(subscribers)
      .where(eq(subscribers.status, "SUBSCRIBED"))
      .all();

    return rows.map((r) => r.email);
  }

  async listSubscribers(
    page: number = 1,
    limit: number = 20,
  ): Promise<{
    items: Array<{ id: string; email: string; status: string; source: string; createdAt: Date }>;
    pagination: { page: number; limit: number; total: number; totalPages: number };
  }> {
    const offset = (page - 1) * limit;

    const [totalRow] = await this.db.select({ total: count() }).from(subscribers);
    const total = totalRow?.total || 0;

    const items = await this.db
      .select()
      .from(subscribers)
      .orderBy(desc(subscribers.createdAt))
      .limit(limit)
      .offset(offset)
      .all();

    return {
      items,
      pagination: {
        page,
        limit,
        total,
        totalPages: Math.ceil(total / limit) || 1,
      },
    };
  }
}
