import { desc, eq } from "drizzle-orm";
import type { DbClient } from "../db/index";
import { auditLogs } from "../db/schema/index";

export class AuditLogService {
  constructor(private db: DbClient) {}

  async getAllLogs(limit = 100) {
    return await this.db
      .select()
      .from(auditLogs)
      .orderBy(desc(auditLogs.createdAt))
      .limit(limit)
      .all();
  }

  async createLog(action: string, userId?: string, ipAddress?: string, details?: string) {
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
  }
}
