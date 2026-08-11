import type { MiddlewareHandler } from "hono";
import type { HonoEnv } from "../types/env";
import { sendError } from "../utils/response";
import { getJwtSecret } from "../utils/env";
import { extractBearerToken, verifyToken } from "../utils/jwt";
import { getDb } from "../db/index";
import { users } from "../db/schema/index";
import { eq } from "drizzle-orm";

// Re-export generateToken so existing imports from this file keep working
export { generateToken } from "../utils/jwt";

const DEV_USER = {
  id: "dev-admin-id",
  email: "dev@admin.local",
  role: "ADMIN" as const,
};

/**
 * Ensures the dev bypass user exists in the database.
 * Called once per request in dev mode to avoid FK constraint failures.
 */
async function ensureDevUser(c: any): Promise<void> {
  try {
    const db = getDb(c.env.DB);
    const existing = await db
      .select({ id: users.id })
      .from(users)
      .where(eq(users.id, DEV_USER.id))
      .get();

    if (!existing) {
      await db.insert(users).values({
        id: DEV_USER.id,
        username: "dev-admin",
        email: DEV_USER.email,
        passwordHash: "dev-bypass",
        role: "ADMIN",
        status: "ACTIVE",
        createdAt: new Date(),
        updatedAt: new Date(),
      });
    }
  } catch {
    // Non-fatal — if upsert fails, the subsequent query will surface the real error
  }
}

interface AuthOptions {
  strict?: boolean;
}

export const authMiddleware = (
  options: AuthOptions = {},
): MiddlewareHandler<HonoEnv> => {
  return async (c, next) => {
    const authHeader = c.req.header("Authorization");

    // Dev Mode Bypass: Allowed only if strict is false
    if (
      !options.strict &&
      !authHeader &&
      c.env?.ENVIRONMENT === "development"
    ) {
      await ensureDevUser(c);
      c.set("user", DEV_USER);
      return await next();
    }

    const token = extractBearerToken(authHeader);
    if (!token) {
      return sendError(
        c,
        "Unauthorized. Authorization token required.",
        null,
        401,
      );
    }

    const user = await verifyToken(token, getJwtSecret(c));
    if (!user) {
      return sendError(c, "Unauthorized. Invalid or expired token.", null, 401);
    }

    const db = getDb(c.env.DB);
    const dbUser = await db
      .select({ status: users.status })
      .from(users)
      .where(eq(users.id, user.id))
      .get();

    if (dbUser?.status === "SUSPENDED") {
      return sendError(
        c,
        "Forbidden. Your account has been suspended by an administrator.",
        null,
        403,
      );
    }

    c.set("user", user);
    await next();
  };
};

export const requireRole = (
  allowedRoles: ("ADMIN" | "CREATOR")[],
): MiddlewareHandler<HonoEnv> => {
  return async (c, next) => {
    const user = c.get("user");
    if (!user) {
      return sendError(c, "Unauthorized.", null, 401);
    }

    if (!allowedRoles.includes(user.role)) {
      return sendError(
        c,
        "Forbidden. Insufficient permissions for this resource.",
        null,
        403,
      );
    }

    await next();
  };
};
