import { and, count, desc, gte, like, lt, lte } from "drizzle-orm";
import type { DbClient } from "../db/index";
import { auditLogs } from "../db/schema/index";

export class AuditLogService {
  constructor(private db: DbClient) {}

  async getLogs(options: {
    page?: number;
    limit?: number;
    ipAddress?: string;
    device?: string;
    from?: Date;
    to?: Date;
  } = {}) {
    const page = Math.max(1, options.page ?? 1);
    const limit = Math.min(100, Math.max(1, options.limit ?? 25));
    const conditions = [];

    if (options.ipAddress) conditions.push(like(auditLogs.ipAddress, `%${options.ipAddress}%`));
    if (options.device) conditions.push(like(auditLogs.details, `%${options.device}%`));
    if (options.from) conditions.push(gte(auditLogs.createdAt, options.from));
    if (options.to) conditions.push(lte(auditLogs.createdAt, options.to));
    const whereClause = conditions.length ? and(...conditions) : undefined;

    const totalResult = await this.db
      .select({ total: count() })
      .from(auditLogs)
      .where(whereClause)
      .get();
    const total = totalResult?.total ?? 0;

    const items = await this.db
      .select()
      .from(auditLogs)
      .where(whereClause)
      .orderBy(desc(auditLogs.createdAt))
      .limit(limit)
      .offset((page - 1) * limit)
      .all();

    return {
      items,
      pagination: {
        page,
        limit,
        total,
        totalPages: Math.max(1, Math.ceil(total / limit)),
      },
    };
  }

  async createLog(
    action: string,
    userId?: string,
    ipAddress?: string,
    details?: string,
  ) {
    try {
      const id = crypto.randomUUID();
      await this.db.insert(auditLogs).values({
        id,
        userId,
        ipAddress,
        action,
        details,
        createdAt: new Date(),
      });
      return { id, action };
    } catch (err) {
      console.error("Failed to create audit log:", err);
      return null;
    }
  }

  /**
   * Automatically deletes audit logs older than the specified number of days (default: 2 days)
   */
  async cleanupOldLogs(days = 30) {
    try {
      const cutoffDate = new Date(Date.now() - days * 24 * 60 * 60 * 1000);
      await this.db
        .delete(auditLogs)
        .where(lt(auditLogs.createdAt, cutoffDate));
    } catch (err) {
      console.error("Failed to cleanup old audit logs:", err);
    }
  }

  /**
   * Manually clears all audit logs from the database
   */
  async clearLogs(before?: Date) {
    try {
      const whereClause = before ? lt(auditLogs.createdAt, before) : undefined;
      const totalResult = await this.db
        .select({ total: count() })
        .from(auditLogs)
        .where(whereClause)
        .get();
      await this.db.delete(auditLogs).where(whereClause);
      return { deleted: totalResult?.total ?? 0 };
    } catch (err) {
      console.error("Failed to clear all audit logs:", err);
      return false;
    }
  }
}
