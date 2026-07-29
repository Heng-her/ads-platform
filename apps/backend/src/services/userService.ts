import { eq } from "drizzle-orm";
import type { DbClient } from "../db/index";
import { users } from "../db/schema/index";

export class UserService {
  constructor(private db: DbClient) {}

  async getUserById(id: string) {
    const user = await this.db
      .select({
        id: users.id,
        username: users.username,
        email: users.email,
        avatar: users.avatar,
        role: users.role,
        status: users.status,
        createdAt: users.createdAt,
        updatedAt: users.updatedAt,
      })
      .from(users)
      .where(eq(users.id, id))
      .get();

    return user || null;
  }

  async getPublicUserById(id: string) {
    const user = await this.db
      .select({
        id: users.id,
        username: users.username,
        avatar: users.avatar,
        role: users.role,
        createdAt: users.createdAt,
      })
      .from(users)
      .where(eq(users.id, id))
      .get();

    return user || null;
  }

  async getAllUsers() {
    return await this.db
      .select({
        id: users.id,
        username: users.username,
        email: users.email,
        avatar: users.avatar,
        role: users.role,
        status: users.status,
        createdAt: users.createdAt,
        updatedAt: users.updatedAt,
      })
      .from(users)
      .all();
  }

  async updateUserStatus(
    id: string,
    status: "ACTIVE" | "SUSPENDED" | "PENDING"
  ) {
    await this.db
      .update(users)
      .set({ status, updatedAt: new Date() })
      .where(eq(users.id, id));
    return this.getUserById(id);
  }
}
