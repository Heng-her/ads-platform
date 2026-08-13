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

interface AuthOptions {
  strict?: boolean;
}

export const authMiddleware = (
  _options: AuthOptions = {},
): MiddlewareHandler<HonoEnv> => {
  return async (c, next) => {
    const authHeader = c.req.header("Authorization");

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

    if (!dbUser) {
      return sendError(
        c,
        "Unauthorized. User account no longer exists.",
        null,
        401,
      );
    }

    if (dbUser.status === "SUSPENDED") {
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
