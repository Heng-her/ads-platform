import {
  eq,
  desc,
  and,
  count,
  gt,
  lt,
  lte,
  or,
  like,
  notInArray,
  isNull,
} from "drizzle-orm";
import type { DbClient } from "../db/index";
import {
  campaigns,
  campaignTranslations,
  users,
  systemCategories,
  type NewCampaign,
} from "../db/schema/index";
import { parsePagination, buildPaginationMeta } from "../utils/pagination";

type CampaignCursor = {
  createdAt: string;
  id: string;
};

function encodeCampaignCursor(cursor: CampaignCursor): string {
  return btoa(JSON.stringify(cursor));
}

function decodeCampaignCursor(cursor: string): CampaignCursor {
  try {
    const parsed = JSON.parse(atob(cursor)) as CampaignCursor;
    if (!parsed?.id || !parsed?.createdAt || Number.isNaN(new Date(parsed.createdAt).getTime())) {
      throw new Error("Invalid cursor");
    }
    return parsed;
  } catch {
    throw new Error("Invalid campaign feed cursor");
  }
}

// Shared select shape for campaign queries — single source of truth
const campaignSelectShape = {
  id: campaigns.id,
  userId: campaigns.userId,
  creator: {
    username: users.username,
    avatar: users.avatar,
  },
  title: campaigns.title,
  description: campaigns.description,
  category: campaigns.category,
  customCategoryId: campaigns.customCategoryId,
  contentType: campaigns.contentType,
  content: campaigns.content,
  imageUrl: campaigns.imageUrl,
  imageTitle: campaigns.imageTitle,
  imageDescription: campaigns.imageDescription,
  images: campaigns.images,
  videoUrls: campaigns.videoUrls,
  adNetwork: campaigns.adNetwork,
  adUnitCode: campaigns.adUnitCode,
  status: campaigns.status,
  isDeleted: campaigns.isDeleted,
  deletedAt: campaigns.deletedAt,
  createdAt: campaigns.createdAt,
  updatedAt: campaigns.updatedAt,
} as const;

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
      images?: Array<{ url: string; title?: string; description?: string }>;
      videoUrls?: string[];
      adNetwork?: string;
      adUnitCode?: string;
      status?: "DRAFT" | "PUBLIC";
    },
    allowUnlimitedVideos = false,
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
      images: data.images,
      videoUrls: data.videoUrls
        ? (allowUnlimitedVideos ? data.videoUrls : data.videoUrls.slice(0, 2))
        : undefined,
      adNetwork: data.adNetwork,
      adUnitCode: data.adUnitCode,
      status: data.status || "PUBLIC",
    };

    await this.db.insert(campaigns).values(newRecord);
    return this.getCampaignById(campaignId);
  }

  async updateCampaign(
    id: string,
    data: {
      title?: string;
      description?: string;
      category?: string;
      contentType?: string;
      content?: string;
      imageUrl?: string;
      imageTitle?: string;
      imageDescription?: string;
      images?: Array<{ url: string; title?: string; description?: string }>;
      videoUrls?: string[];
      adNetwork?: string;
      adUnitCode?: string;
      status?: "DRAFT" | "PUBLIC";
    },
    allowUnlimitedVideos = false,
  ) {
    const updateData: Record<string, any> = {
      updatedAt: new Date(),
    };

    if (data.title !== undefined) updateData.title = data.title;
    if (data.description !== undefined)
      updateData.description = data.description;
    if (data.category !== undefined) updateData.category = data.category;
    if (data.contentType !== undefined)
      updateData.contentType = data.contentType;
    if (data.content !== undefined) updateData.content = data.content;
    if (data.imageUrl !== undefined) updateData.imageUrl = data.imageUrl;
    if (data.imageTitle !== undefined) updateData.imageTitle = data.imageTitle;
    if (data.imageDescription !== undefined)
      updateData.imageDescription = data.imageDescription;
    if (data.images !== undefined) updateData.images = data.images;
    if (data.videoUrls !== undefined)
      updateData.videoUrls = allowUnlimitedVideos ? data.videoUrls : data.videoUrls.slice(0, 2);
    if (data.adNetwork !== undefined) updateData.adNetwork = data.adNetwork;
    if (data.adUnitCode !== undefined) updateData.adUnitCode = data.adUnitCode;
    if (data.status !== undefined) updateData.status = data.status;

    await this.db.update(campaigns).set(updateData).where(eq(campaigns.id, id));
    return this.getCampaignById(id);
  }

  async getCampaignById(id: string, includeDeleted = false) {
    const conditions = [eq(campaigns.id, id)];
    if (!includeDeleted) {
      conditions.push(eq(campaigns.isDeleted, false));
    }

    const result = await this.db
      .select(campaignSelectShape)
      .from(campaigns)
      .leftJoin(users, eq(campaigns.userId, users.id))
      .where(and(...conditions))
      .get();

    return result || null;
  }

  async saveGoogleTranslation(campaignId: string, locale: string, values: { title: string; description: string | null; content: string | null; imageTitle: string | null; imageDescription: string | null }) {
    const now = new Date();
    await this.db.insert(campaignTranslations).values({ id: crypto.randomUUID(), campaignId, locale, ...values, provider: "google", createdAt: now, updatedAt: now })
      .onConflictDoUpdate({ target: [campaignTranslations.campaignId, campaignTranslations.locale], set: { ...values, provider: "google", updatedAt: now } });
    return this.db.select().from(campaignTranslations).where(and(eq(campaignTranslations.campaignId, campaignId), eq(campaignTranslations.locale, locale))).get();
  }

  async getTranslation(campaignId: string, locale: string) {
    return this.db.select().from(campaignTranslations).where(and(eq(campaignTranslations.campaignId, campaignId), eq(campaignTranslations.locale, locale))).get();
  }

  private async buildPublicFeedConditions(options: {
    user?: { id: string; role: "ADMIN" | "CREATOR" } | null;
    category?: string;
    contentType?: string;
    search?: string;
    customCategoryId?: number;
  }) {
    const conditions = [
      eq(campaigns.status, "PUBLIC"),
      eq(campaigns.isDeleted, false),
    ];

    if (options.category) {
      if (options.category === "OTHER") {
        const systemCats = await this.db
          .select({ name: systemCategories.name })
          .from(systemCategories)
          .all();
        const systemNames = systemCats.map((category) => category.name);

        if (systemNames.length > 0) {
          const otherCategoryCondition = or(
            isNull(campaigns.category),
            notInArray(campaigns.category, systemNames),
          );
          if (otherCategoryCondition) conditions.push(otherCategoryCondition);
        }
      } else {
        conditions.push(eq(campaigns.category, options.category));
      }
    }

    if (options.contentType) {
      conditions.push(eq(campaigns.contentType, options.contentType));
    }
    if (options.search) {
      conditions.push(like(campaigns.title, `%${options.search}%`));
    }
    if (options.customCategoryId !== undefined) {
      if (!options.user) return null;
      conditions.push(eq(campaigns.customCategoryId, options.customCategoryId));
      conditions.push(eq(campaigns.userId, options.user.id));
    }

    return conditions;
  }

  async getPublicCampaignFeed(options: {
    user?: { id: string; role: "ADMIN" | "CREATOR" } | null;
    category?: string;
    contentType?: string;
    search?: string;
    customCategoryId?: number;
    limit: number;
    cursor?: string;
    snapshotAt?: string;
  }) {
    const snapshotDate = options.snapshotAt ? new Date(options.snapshotAt) : new Date();
    if (Number.isNaN(snapshotDate.getTime())) throw new Error("Invalid campaign feed snapshot");

    const conditions = await this.buildPublicFeedConditions(options);
    if (!conditions) {
      return { items: [], nextCursor: null, hasMore: false, snapshotAt: snapshotDate.toISOString() };
    }

    conditions.push(lte(campaigns.createdAt, snapshotDate));

    if (options.cursor) {
      const cursor = decodeCampaignCursor(options.cursor);
      const cursorDate = new Date(cursor.createdAt);
      const cursorCondition = or(
        lt(campaigns.createdAt, cursorDate),
        and(eq(campaigns.createdAt, cursorDate), lt(campaigns.id, cursor.id)),
      );
      if (cursorCondition) conditions.push(cursorCondition);
    }

    const rows = await this.db
      .select(campaignSelectShape)
      .from(campaigns)
      .leftJoin(users, eq(campaigns.userId, users.id))
      .where(and(...conditions))
      .orderBy(desc(campaigns.createdAt), desc(campaigns.id))
      .limit(options.limit + 1)
      .all();

    const hasMore = rows.length > options.limit;
    const items = hasMore ? rows.slice(0, options.limit) : rows;
    const lastItem = items.at(-1);

    return {
      items,
      nextCursor: hasMore && lastItem
        ? encodeCampaignCursor({ createdAt: lastItem.createdAt.toISOString(), id: lastItem.id })
        : null,
      hasMore,
      snapshotAt: snapshotDate.toISOString(),
    };
  }

  async getPublicCampaignNewCount(options: {
    user?: { id: string; role: "ADMIN" | "CREATOR" } | null;
    category?: string;
    contentType?: string;
    search?: string;
    customCategoryId?: number;
    snapshotAt: string;
  }) {
    const snapshotDate = new Date(options.snapshotAt);
    if (Number.isNaN(snapshotDate.getTime())) throw new Error("Invalid campaign feed snapshot");

    const conditions = await this.buildPublicFeedConditions(options);
    if (!conditions) return 0;

    conditions.push(gt(campaigns.createdAt, snapshotDate));
    const result = await this.db
      .select({ total: count() })
      .from(campaigns)
      .where(and(...conditions))
      .get();

    return result?.total ?? 0;
  }

  async getCampaignsList(options: {
    user?: { id: string; role: "ADMIN" | "CREATOR" } | null;
    category?: string;
    contentType?: string;
    search?: string;
    status?: "DRAFT" | "PUBLIC";
    customCategoryId?: number;
    page?: number;
    limit?: number;
  }) {
    const { page, limit, offset } = parsePagination(
      options.page,
      options.limit,
    );

    const conditions = [];

    // Category filter
    if (options.category) {
      if (options.category === "OTHER") {
        // "OTHER" = campaigns whose category is not a system category name
        // Fetch system category names to build the exclusion list
        const systemCats = await this.db
          .select({ name: systemCategories.name })
          .from(systemCategories)
          .all();
        const systemNames = systemCats.map((c) => c.name);

        if (systemNames.length > 0) {
          // Include campaigns with no category, or a category not in the system list
          conditions.push(
            or(
              isNull(campaigns.category),
              notInArray(campaigns.category, systemNames),
            ),
          );
        }
        // If no system categories exist yet, "OTHER" matches everything — no filter added
      } else {
        conditions.push(eq(campaigns.category, options.category));
      }
    }

    // ContentType filter
    if (options.contentType) {
      conditions.push(eq(campaigns.contentType, options.contentType));
    }

    // Custom category filter — only returns campaigns owned by the requesting user
    if (options.customCategoryId !== undefined) {
      conditions.push(eq(campaigns.customCategoryId, options.customCategoryId));
      // Enforce ownership: custom categories are private, only the owner can see them
      if (options.user) {
        conditions.push(eq(campaigns.userId, options.user.id));
      } else {
        // Unauthenticated users cannot query custom categories
        return {
          items: [],
          pagination: buildPaginationMeta(
            0,
            options.page ?? 1,
            options.limit ?? 10,
          ),
        };
      }
    }

    // Search filter (matches title)
    if (options.search) {
      conditions.push(like(campaigns.title, `%${options.search}%`));
    }

    // Auth & Status filter logic:
    // - No user (public visitor): only PUBLIC, non-deleted
    // - CREATOR: PUBLIC (all) OR own campaigns; can filter by status on own items only
    // - ADMIN: sees everything including soft-deleted; can filter by status
    if (!options.user) {
      conditions.push(eq(campaigns.status, "PUBLIC"));
      conditions.push(eq(campaigns.isDeleted, false));
    } else if (options.user.role === "CREATOR") {
      if (options.status) {
        // Filter by status but only on own campaigns (non-deleted)
        conditions.push(
          and(
            eq(campaigns.userId, options.user.id),
            eq(campaigns.status, options.status),
            eq(campaigns.isDeleted, false),
          ),
        );
      } else {
        // All PUBLIC (non-deleted) OR own non-deleted campaigns
        conditions.push(
          or(
            and(eq(campaigns.status, "PUBLIC"), eq(campaigns.isDeleted, false)),
            and(
              eq(campaigns.userId, options.user.id),
              eq(campaigns.isDeleted, false),
            ),
          ),
        );
      }
    } else if (options.user.role === "ADMIN") {
      // Admin sees all including soft-deleted; optional status filter
      if (options.status) {
        conditions.push(eq(campaigns.status, options.status));
      }
      // No isDeleted filter for admins — they see everything
    }

    const whereClause = conditions.length > 0 ? and(...conditions) : undefined;

    // Count total matching records
    const countResult = await this.db
      .select({ total: count() })
      .from(campaigns)
      .where(whereClause)
      .get();

    const total = countResult?.total || 0;

    // Fetch paginated records
    const rawItems = await this.db
      .select(campaignSelectShape)
      .from(campaigns)
      .leftJoin(users, eq(campaigns.userId, users.id))
      .where(whereClause)
      .orderBy(desc(campaigns.createdAt))
      .limit(limit)
      .offset(offset)
      .all();

    return {
      items: rawItems,
      pagination: buildPaginationMeta(total, page, limit),
    };
  }

  async getUserCampaigns(
    userId: string,
    options: {
      status?: "DRAFT" | "PUBLIC";
      page?: number;
      limit?: number;
      category?: string;
      search?: string;
    } = {},
  ) {
    const { page, limit, offset } = parsePagination(
      options.page,
      options.limit,
    );

    const conditions = [
      eq(campaigns.userId, userId),
      eq(campaigns.isDeleted, false), // owners don't see soft-deleted
    ];

    if (options.status) {
      conditions.push(eq(campaigns.status, options.status));
    }
    if (options.category) {
      conditions.push(eq(campaigns.category, options.category));
    }
    if (options.search) {
      conditions.push(like(campaigns.title, `%${options.search}%`));
    }

    const whereClause = and(...conditions);

    const countResult = await this.db
      .select({ total: count() })
      .from(campaigns)
      .where(whereClause)
      .get();

    const total = countResult?.total || 0;

    const items = await this.db
      .select(campaignSelectShape)
      .from(campaigns)
      .leftJoin(users, eq(campaigns.userId, users.id))
      .where(whereClause)
      .orderBy(desc(campaigns.createdAt))
      .limit(limit)
      .offset(offset)
      .all();

    return {
      items,
      pagination: buildPaginationMeta(total, page, limit),
    };
  }

  async updateCampaignStatus(id: string, status: "DRAFT" | "PUBLIC") {
    await this.db
      .update(campaigns)
      .set({ status, updatedAt: new Date() })
      .where(eq(campaigns.id, id));
    return this.getCampaignById(id);
  }

  /**
   * Soft delete: sets isDeleted = true and records deletedAt timestamp.
   * Creators won't see the campaign anymore; admins still can via includeDeleted flag.
   */
  async softDeleteCampaign(id: string) {
    await this.db
      .update(campaigns)
      .set({ isDeleted: true, deletedAt: new Date(), updatedAt: new Date() })
      .where(eq(campaigns.id, id));
    return true;
  }

  /**
   * Admin-only: get all campaigns including soft-deleted ones, with optional filters.
   */
  async getAllCampaigns(
    options: {
      status?: "DRAFT" | "PUBLIC";
      includeDeleted?: boolean;
      page?: number;
      limit?: number;
    } = {},
  ) {
    const { page, limit, offset } = parsePagination(
      options.page,
      options.limit,
    );

    const conditions = [];

    if (options.status) {
      conditions.push(eq(campaigns.status, options.status));
    }
    if (!options.includeDeleted) {
      conditions.push(eq(campaigns.isDeleted, false));
    }

    const whereClause = conditions.length > 0 ? and(...conditions) : undefined;

    const countResult = await this.db
      .select({ total: count() })
      .from(campaigns)
      .where(whereClause)
      .get();

    const total = countResult?.total || 0;

    const items = await this.db
      .select(campaignSelectShape)
      .from(campaigns)
      .leftJoin(users, eq(campaigns.userId, users.id))
      .where(whereClause)
      .orderBy(desc(campaigns.createdAt))
      .limit(limit)
      .offset(offset)
      .all();

    return {
      items,
      pagination: buildPaginationMeta(total, page, limit),
    };
  }

  /**
   * Lightweight admin overview. It loads three users at a time and only the
   * three newest public posts for each user. Full campaign lists are fetched
   * separately when an admin opens a user's campaign panel.
   */
  async getAdminCampaignUsers(options: { page?: number; limit?: number; search?: string } = {}) {
    const { page, limit, offset } = parsePagination(options.page, options.limit);
    const conditions = options.search
      ? [or(like(users.username, `%${options.search}%`), like(users.email, `%${options.search}%`))]
      : [];
    const whereClause = conditions.length ? and(...conditions) : undefined;

    const countResult = await this.db
      .select({ total: count() })
      .from(users)
      .where(whereClause)
      .get();

    const userItems = await this.db
      .select({
        id: users.id,
        username: users.username,
        email: users.email,
        avatar: users.avatar,
        role: users.role,
        status: users.status,
        createdAt: users.createdAt,
      })
      .from(users)
      .where(whereClause)
      .orderBy(desc(users.createdAt))
      .limit(limit)
      .offset(offset)
      .all();

    const publicPostsByUser = await Promise.all(
      userItems.map(async (user) => ({
        userId: user.id,
        posts: (await this.getUserCampaigns(user.id, { page: 1, limit: 3, status: "PUBLIC" })).items,
      })),
    );
    const publicPostsMap = new Map(publicPostsByUser.map(({ userId, posts }) => [userId, posts]));

    const items = userItems.map((user) => {
      return {
        ...user,
        publicPosts: publicPostsMap.get(user.id) ?? [],
      };
    });

    return {
      items,
      pagination: buildPaginationMeta(countResult?.total || 0, page, limit),
    };
  }

  /** Admin-only caller uses this paginated method after expanding one user. */
  async getAdminUserCampaigns(userId: string, page = 1) {
    return this.getUserCampaigns(userId, { page, limit: 3 });
  }
}
