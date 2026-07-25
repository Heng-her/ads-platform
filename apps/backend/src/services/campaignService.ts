import { eq } from "drizzle-orm";
import type { DbClient } from "../db/index";
import { campaigns } from "../db/schema/index";

export class CampaignService {
  constructor(private db: DbClient) {}

  async createCampaign(userId: string, title: string, budget: number, description?: string, dailyBudget?: number) {
    const campaignId = crypto.randomUUID();
    await this.db.insert(campaigns).values({
      id: campaignId,
      userId,
      title,
      description,
      budget,
      dailyBudget,
      status: "DRAFT"
    });

    return this.getCampaignById(campaignId);
  }

  async getCampaignById(id: string) {
    return await this.db.select().from(campaigns).where(eq(campaigns.id, id)).get() || null;
  }

  async getUserCampaigns(userId: string) {
    return await this.db.select().from(campaigns).where(eq(campaigns.userId, userId)).all();
  }

  async getAllCampaigns() {
    return await this.db.select().from(campaigns).all();
  }

  async updateCampaignStatus(id: string, status: "DRAFT" | "PENDING_APPROVAL" | "ACTIVE" | "PAUSED" | "REJECTED" | "COMPLETED") {
    await this.db.update(campaigns).set({ status, updatedAt: new Date() }).where(eq(campaigns.id, id));
    return this.getCampaignById(id);
  }
}
