import { desc, lt } from "drizzle-orm";
import type { DbClient } from "../db/index";
import { auditLogs } from "../db/schema/index";

export class AuditLogService {
  constructor(private db: DbClient) {}

  async getAllLogs(limit = 100) {
    // Auto purge logs older than 2 days before fetching
    await this.cleanupOldLogs(2);

    return await this.db
      .select()
      .from(auditLogs)
      .orderBy(desc(auditLogs.createdAt))
      .limit(limit)
      .all();
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
  async cleanupOldLogs(days = 2) {
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
  async clearAllLogs() {
    try {
      await this.db.delete(auditLogs);
      return true;
    } catch (err) {
      console.error("Failed to clear all audit logs:", err);
      return false;
    }
  }
}
