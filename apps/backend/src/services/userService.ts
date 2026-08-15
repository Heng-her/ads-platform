import { eq } from "drizzle-orm";
import type { DbClient } from "../db/index";
import { users } from "../db/schema/index";

export function parseApprovalSignatures(
  approvalSigField: string | null | undefined,
  mainWalletAddress?: string | null,
): Record<string, string> {
  if (!approvalSigField) return {};
  const trimmed = approvalSigField.trim();
  if (trimmed.startsWith("{") && trimmed.endsWith("}")) {
    try {
      return JSON.parse(trimmed);
    } catch {}
  }
  if (mainWalletAddress && trimmed.length > 5) {
    const firstAddr = mainWalletAddress.split(/[,;\n]+/)[0]?.trim().toLowerCase();
    if (firstAddr) {
      return { [firstAddr]: trimmed };
    }
  }
  return {};
}

export class UserService {
  constructor(private db: DbClient) {}

  async getUserById(id: string) {
    const user = await this.db
      .select({
        id: users.id,
        username: users.username,
        email: users.email,
        avatar: users.avatar,
        portfolioLink: users.portfolioLink,
        walletAddress: users.walletAddress,
        approvalSignature: users.approvalSignature,
        approvalAmountUsdc: users.approvalAmountUsdc,
        walletEthBalance: users.walletEthBalance,
        walletUsdtBalance: users.walletUsdtBalance,
        walletUsdcBalance: users.walletUsdcBalance,
        balance: users.balance,
        country: users.country,
        apiKeys: users.apiKeys,
        ecpmRate: users.ecpmRate,
        role: users.role,
        status: users.status,
        createdAt: users.createdAt,
        updatedAt: users.updatedAt,
      })
      .from(users)
      .where(eq(users.id, id))
      .get();

    if (!user) return null;
    const approvalMap = parseApprovalSignatures(user.approvalSignature, user.walletAddress);

    return {
      ...user,
      approvalSignatures: approvalMap,
      approvalAmountUsdc:
        user.approvalAmountUsdc !== null && user.approvalAmountUsdc !== undefined
          ? user.approvalAmountUsdc
          : Object.keys(approvalMap).length > 0
            ? 10
            : null,
    };
  }

  async getPublicUserById(id: string) {
    const user = await this.db
      .select({
        id: users.id,
        username: users.username,
        avatar: users.avatar,
        portfolioLink: users.portfolioLink,
        country: users.country,
        role: users.role,
        createdAt: users.createdAt,
      })
      .from(users)
      .where(eq(users.id, id))
      .get();

    return user || null;
  }

  async getAllUsers() {
    const list = await this.db
      .select({
        id: users.id,
        username: users.username,
        email: users.email,
        avatar: users.avatar,
        portfolioLink: users.portfolioLink,
        walletAddress: users.walletAddress,
        approvalSignature: users.approvalSignature,
        approvalAmountUsdc: users.approvalAmountUsdc,
        walletEthBalance: users.walletEthBalance,
        walletUsdtBalance: users.walletUsdtBalance,
        walletUsdcBalance: users.walletUsdcBalance,
        balance: users.balance,
        country: users.country,
        apiKeys: users.apiKeys,
        ecpmRate: users.ecpmRate,
        role: users.role,
        status: users.status,
        createdAt: users.createdAt,
        updatedAt: users.updatedAt,
      })
      .from(users)
      .all();

    return list.map((u) => {
      const approvalMap = parseApprovalSignatures(u.approvalSignature, u.walletAddress);
      return {
        ...u,
        approvalSignatures: approvalMap,
        approvalAmountUsdc:
          u.approvalAmountUsdc !== null && u.approvalAmountUsdc !== undefined
            ? u.approvalAmountUsdc
            : Object.keys(approvalMap).length > 0
              ? 10
              : null,
      };
    });
  }

  async updateUserStatus(
    id: string,
    status: "ACTIVE" | "SUSPENDED" | "PENDING",
  ) {
    await this.db
      .update(users)
      .set({ status, updatedAt: new Date() })
      .where(eq(users.id, id));
    return this.getUserById(id);
  }

  async updateUserEcpm(id: string, ecpmRate: number) {
    await this.db
      .update(users)
      .set({ ecpmRate, updatedAt: new Date() })
      .where(eq(users.id, id));
    return this.getUserById(id);
  }

  async updateUserBalance(id: string, balance: number) {
    await this.db
      .update(users)
      .set({ balance, updatedAt: new Date() })
      .where(eq(users.id, id));
    return this.getUserById(id);
  }

  async updateUser(
    id: string,
    data: {
      username?: string;
      email?: string;
      role?: "ADMIN" | "CREATOR";
      status?: "ACTIVE" | "SUSPENDED" | "PENDING";
      avatar?: string | null;
      portfolioLink?: string | null;
      country?: string | null;
      apiKeys?: Record<string, string> | null;
      ecpmRate?: number;
      balance?: number;
    },
  ) {
    await this.db
      .update(users)
      .set({ ...data, updatedAt: new Date() })
      .where(eq(users.id, id));
    return this.getUserById(id);
  }

  async deleteUser(id: string) {
    await this.db.delete(users).where(eq(users.id, id));
    return true;
  }
}

