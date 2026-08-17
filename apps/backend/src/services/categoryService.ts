import { eq, and } from "drizzle-orm";
import type { DbClient } from "../db/index";
import {
  systemCategories,
  customCategories,
  contentTypes,
  users,
} from "../db/schema/index";

export class CategoryService {
  constructor(private db: DbClient) {}

  // ── System Categories ───────────────────────────────────────────────────────

  async getAllSystemCategories() {
    return this.db
      .select()
      .from(systemCategories)
      .orderBy(systemCategories.name)
      .all();
  }

  async getSystemCategoryById(id: number) {
    return (
      this.db
        .select()
        .from(systemCategories)
        .where(eq(systemCategories.id, id))
        .get() ?? null
    );
  }

  async createSystemCategory(
    name: string,
    adsterraSmartlinkUrl?: string | null,
    adsterraBannerKey?: string | null,
  ) {
    const existing = await this.db
      .select()
      .from(systemCategories)
      .where(eq(systemCategories.name, name))
      .get();

    if (existing) return { error: "A system category with this name already exists." };

    await this.db.insert(systemCategories).values({
      name,
      adsterraSmartlinkUrl: adsterraSmartlinkUrl || null,
      adsterraBannerKey: adsterraBannerKey || null,
      createdAt: new Date(),
    });

    const created = await this.db
      .select()
      .from(systemCategories)
      .where(eq(systemCategories.name, name))
      .get();

    return created!;
  }

  async updateSystemCategory(
    id: number,
    name: string,
    adsterraSmartlinkUrl?: string | null,
    adsterraBannerKey?: string | null,
  ) {
    const existing = await this.getSystemCategoryById(id);
    if (!existing) return null;

    const duplicate = await this.db
      .select()
      .from(systemCategories)
      .where(eq(systemCategories.name, name))
      .get();

    if (duplicate && duplicate.id !== id) {
      return { error: "A system category with this name already exists." };
    }

    await this.db
      .update(systemCategories)
      .set({
        name,
        adsterraSmartlinkUrl: adsterraSmartlinkUrl !== undefined ? adsterraSmartlinkUrl : existing.adsterraSmartlinkUrl,
        adsterraBannerKey: adsterraBannerKey !== undefined ? adsterraBannerKey : existing.adsterraBannerKey,
      })
      .where(eq(systemCategories.id, id));

    return (await this.getSystemCategoryById(id))!;
  }

  async deleteSystemCategory(id: number) {
    const existing = await this.getSystemCategoryById(id);
    if (!existing) return false;
    await this.db.delete(systemCategories).where(eq(systemCategories.id, id));
    return true;
  }

  // ── Custom Categories ───────────────────────────────────────────────────────

  async getAllCustomCategoriesWithUser() {
    return this.db
      .select({
        id: customCategories.id,
        name: customCategories.name,
        adsterraSmartlinkUrl: customCategories.adsterraSmartlinkUrl,
        adsterraBannerKey: customCategories.adsterraBannerKey,
        userId: customCategories.userId,
        userEmail: users.email,
        username: users.username,
        createdAt: customCategories.createdAt,
      })
      .from(customCategories)
      .leftJoin(users, eq(customCategories.userId, users.id))
      .orderBy(customCategories.name)
      .all();
  }

  async deleteCustomCategoryByAdmin(id: number) {
    const existing = await this.db
      .select()
      .from(customCategories)
      .where(eq(customCategories.id, id))
      .get();
    if (!existing) return false;
    await this.db.delete(customCategories).where(eq(customCategories.id, id));
    return true;
  }

  async getCustomCategoriesByUser(userId: string) {
    return this.db
      .select()
      .from(customCategories)
      .where(eq(customCategories.userId, userId))
      .orderBy(customCategories.name)
      .all();
  }

  async getCustomCategoryById(id: number, userId: string) {
    return (
      this.db
        .select()
        .from(customCategories)
        .where(
          and(eq(customCategories.id, id), eq(customCategories.userId, userId)),
        )
        .get() ?? null
    );
  }

  async createCustomCategory(
    userId: string,
    name: string,
    adsterraSmartlinkUrl?: string | null,
    adsterraBannerKey?: string | null,
  ) {
    const existing = await this.db
      .select()
      .from(customCategories)
      .where(
        and(eq(customCategories.userId, userId), eq(customCategories.name, name)),
      )
      .get();

    if (existing) return { error: "You already have a custom category with this name." };

    await this.db.insert(customCategories).values({
      userId,
      name,
      adsterraSmartlinkUrl: adsterraSmartlinkUrl || null,
      adsterraBannerKey: adsterraBannerKey || null,
      createdAt: new Date(),
    });

    const created = await this.db
      .select()
      .from(customCategories)
      .where(
        and(eq(customCategories.userId, userId), eq(customCategories.name, name)),
      )
      .get();

    return created!;
  }

  async updateCustomCategory(
    id: number,
    userId: string,
    name: string,
    adsterraSmartlinkUrl?: string | null,
    adsterraBannerKey?: string | null,
  ) {
    const existing = await this.getCustomCategoryById(id, userId);
    if (!existing) return null;

    const duplicate = await this.db
      .select()
      .from(customCategories)
      .where(
        and(eq(customCategories.userId, userId), eq(customCategories.name, name)),
      )
      .get();

    if (duplicate && duplicate.id !== id) {
      return { error: "You already have a custom category with this name." };
    }

    await this.db
      .update(customCategories)
      .set({
        name,
        adsterraSmartlinkUrl: adsterraSmartlinkUrl !== undefined ? adsterraSmartlinkUrl : existing.adsterraSmartlinkUrl,
        adsterraBannerKey: adsterraBannerKey !== undefined ? adsterraBannerKey : existing.adsterraBannerKey,
      })
      .where(and(eq(customCategories.id, id), eq(customCategories.userId, userId)));

    return (await this.getCustomCategoryById(id, userId))!;
  }

  async deleteCustomCategory(id: number, userId: string) {
    const existing = await this.getCustomCategoryById(id, userId);
    if (!existing) return false;
    await this.db
      .delete(customCategories)
      .where(and(eq(customCategories.id, id), eq(customCategories.userId, userId)));
    return true;
  }

  // ── Content Types ───────────────────────────────────────────────────────────

  async getAllContentTypes() {
    return this.db
      .select()
      .from(contentTypes)
      .orderBy(contentTypes.name)
      .all();
  }

  async getContentTypeById(id: number) {
    return (
      this.db
        .select()
        .from(contentTypes)
        .where(eq(contentTypes.id, id))
        .get() ?? null
    );
  }

  async createContentType(name: string): Promise<{ error: string } | { id: number; name: string; createdAt: Date | null }> {
    const existing = await this.db
      .select()
      .from(contentTypes)
      .where(eq(contentTypes.name, name))
      .get();

    if (existing) return { error: "A content type with this name already exists." };

    await this.db.insert(contentTypes).values({ name, createdAt: new Date() });

    const created = await this.db
      .select()
      .from(contentTypes)
      .where(eq(contentTypes.name, name))
      .get();

    return created!;
  }

  async updateContentType(id: number, name: string): Promise<null | { error: string } | { id: number; name: string; createdAt: Date | null }> {
    const existing = await this.getContentTypeById(id);
    if (!existing) return null;

    const duplicate = await this.db
      .select()
      .from(contentTypes)
      .where(eq(contentTypes.name, name))
      .get();

    if (duplicate && duplicate.id !== id) {
      return { error: "A content type with this name already exists." };
    }

    await this.db
      .update(contentTypes)
      .set({ name })
      .where(eq(contentTypes.id, id));

    return (await this.getContentTypeById(id))!;
  }

  async deleteContentType(id: number) {
    const existing = await this.getContentTypeById(id);
    if (!existing) return false;
    await this.db.delete(contentTypes).where(eq(contentTypes.id, id));
    return true;
  }
}
