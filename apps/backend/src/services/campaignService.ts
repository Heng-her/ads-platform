import { eq, desc, and, count, or, like } from "drizzle-orm";
import type { DbClient } from "../db/index";
import { campaigns, users, type NewCampaign } from "../db/schema/index";

export class CampaignService {
  constructor(private db: DbClient) {}

  async createCampaign(
    userId: string,
    data: {
      title: string;
      description?: string;
      category?: string;
      contentType?: string;
      content?: string;
      imageUrl?: string;
      imageTitle?: string;
      imageDescription?: string;
      adNetwork?: string;
      adUnitCode?: string;
      status?: "DRAFT" | "PUBLIC";
    },
  ) {
    const campaignId = crypto.randomUUID();
    const newRecord: NewCampaign = {
      id: campaignId,
      userId,
      title: data.title,
      description: data.description,
      category: data.category,
      contentType: data.contentType || "ARTICLE",
      content: data.content,
      imageUrl: data.imageUrl,
      imageTitle: data.imageTitle,
      imageDescription: data.imageDescription,
      adNetwork: data.adNetwork,
      adUnitCode: data.adUnitCode,
      status: data.status || "PUBLIC",
    };

    await this.db.insert(campaigns).values(newRecord);
    return this.getCampaignById(campaignId);
  }

  async getCampaignById(id: string) {
    const result = await this.db
      .select({
        id: campaigns.id,
        userId: campaigns.userId,
        creator: {
          username: users.username,
          avatar: users.avatar,
        },
        title: campaigns.title,
        description: campaigns.description,
        category: campaigns.category,
        contentType: campaigns.contentType,
        content: campaigns.content,
        imageUrl: campaigns.imageUrl,
        imageTitle: campaigns.imageTitle,
        imageDescription: campaigns.imageDescription,
        adNetwork: campaigns.adNetwork,
        adUnitCode: campaigns.adUnitCode,
        status: campaigns.status,
        createdAt: campaigns.createdAt,
        updatedAt: campaigns.updatedAt,
      })
      .from(campaigns)
      .leftJoin(users, eq(campaigns.userId, users.id))
      .where(eq(campaigns.id, id))
      .get();

    return result || null;
  }

  async getCampaignsList(options: {
    user?: { id: string; role: "ADMIN" | "CREATOR" } | null;
    category?: string;
    contentType?: string;
    search?: string;
    status?: "DRAFT" | "PUBLIC";
    page?: number;
    limit?: number;
  }) {
    const page = Math.max(1, options.page || 1);
    const limit = Math.max(1, options.limit || 10);
    const offset = (page - 1) * limit;

    const conditions = [];

    // Category filter if provided
    if (options.category) {
      conditions.push(eq(campaigns.category, options.category));
    }

    // ContentType filter if provided (e.g. ARTICLE, NEWS, BANNER)
    if (options.contentType) {
      conditions.push(eq(campaigns.contentType, options.contentType));
    }

    // Search filter if provided (matches title)
    if (options.search) {
      conditions.push(like(campaigns.title, `%${options.search}%`));
    }

    // Auth & Status filter logic:
    // 1. If NO authenticated user (Public visitor): show ONLY "PUBLIC" status
    // 2. If CREATOR:
    //    - If status specified (e.g. DRAFT), show own DRAFT posts
    //    - Else show ALL "PUBLIC" status OR their own created items
    // 3. If ADMIN:
    //    - If status specified, filter by status
    //    - Else show all items
    if (!options.user) {
      conditions.push(eq(campaigns.status, "PUBLIC"));
    } else if (options.user.role === "CREATOR") {
      if (options.status) {
        conditions.push(
          and(
            eq(campaigns.userId, options.user.id),
            eq(campaigns.status, options.status),
          ),
        );
      } else {
        conditions.push(
          or(
            eq(campaigns.status, "PUBLIC"),
            eq(campaigns.userId, options.user.id),
          ),
        );
      }
    } else if (options.user.role === "ADMIN") {
      if (options.status) {
        conditions.push(eq(campaigns.status, options.status));
      }
    }

    const whereClause = conditions.length > 0 ? and(...conditions) : undefined;

    // Count total matching records
    const countResult = await this.db
      .select({ total: count() })
      .from(campaigns)
      .where(whereClause)
      .get();

    const total = countResult?.total || 0;
    const totalPages = Math.ceil(total / limit);

    // Fetch paginated records with creator info joined, ordered by newest post first
    const rawItems = await this.db
      .select({
        id: campaigns.id,
        userId: campaigns.userId,
        creator: {
          username: users.username,
          avatar: users.avatar,
        },
        title: campaigns.title,
        description: campaigns.description,
        category: campaigns.category,
        contentType: campaigns.contentType,
        content: campaigns.content,
        imageUrl: campaigns.imageUrl,
        imageTitle: campaigns.imageTitle,
        imageDescription: campaigns.imageDescription,
        adNetwork: campaigns.adNetwork,
        adUnitCode: campaigns.adUnitCode,
        status: campaigns.status,
        createdAt: campaigns.createdAt,
        updatedAt: campaigns.updatedAt,
      })
      .from(campaigns)
      .leftJoin(users, eq(campaigns.userId, users.id))
      .where(whereClause)
      .orderBy(desc(campaigns.createdAt))
      .limit(limit)
      .offset(offset)
      .all();

    return {
      items: rawItems,
      pagination: {
        total,
        page,
        limit,
        totalPages,
        hasNextPage: page < totalPages,
        hasPrevPage: page > 1,
      },
    };
  }

  async getUserCampaigns(userId: string) {
    return await this.db
      .select({
        id: campaigns.id,
        userId: campaigns.userId,
        creator: {
          username: users.username,
          avatar: users.avatar,
        },
        title: campaigns.title,
        description: campaigns.description,
        category: campaigns.category,
        contentType: campaigns.contentType,
        content: campaigns.content,
        imageUrl: campaigns.imageUrl,
        imageTitle: campaigns.imageTitle,
        imageDescription: campaigns.imageDescription,
        adNetwork: campaigns.adNetwork,
        adUnitCode: campaigns.adUnitCode,
        status: campaigns.status,
        createdAt: campaigns.createdAt,
        updatedAt: campaigns.updatedAt,
      })
      .from(campaigns)
      .leftJoin(users, eq(campaigns.userId, users.id))
      .where(eq(campaigns.userId, userId))
      .orderBy(desc(campaigns.createdAt))
      .all();
  }

  async getAllCampaigns() {
    return await this.db
      .select({
        id: campaigns.id,
        userId: campaigns.userId,
        creator: {
          username: users.username,
          avatar: users.avatar,
        },
        title: campaigns.title,
        description: campaigns.description,
        category: campaigns.category,
        contentType: campaigns.contentType,
        content: campaigns.content,
        imageUrl: campaigns.imageUrl,
        imageTitle: campaigns.imageTitle,
        imageDescription: campaigns.imageDescription,
        adNetwork: campaigns.adNetwork,
        adUnitCode: campaigns.adUnitCode,
        status: campaigns.status,
        createdAt: campaigns.createdAt,
        updatedAt: campaigns.updatedAt,
      })
      .from(campaigns)
      .leftJoin(users, eq(campaigns.userId, users.id))
      .orderBy(desc(campaigns.createdAt))
      .all();
  }

  async updateCampaignStatus(id: string, status: "DRAFT" | "PUBLIC") {
    await this.db
      .update(campaigns)
      .set({ status, updatedAt: new Date() })
      .where(eq(campaigns.id, id));
    return this.getCampaignById(id);
  }

  async deleteCampaign(id: string) {
    await this.db.delete(campaigns).where(eq(campaigns.id, id));
    return true;
  }
}
