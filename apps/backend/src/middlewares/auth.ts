import type { MiddlewareHandler } from "hono";
import type { HonoEnv } from "../types/env";
import { sendError } from "../utils/response";
import { getJwtSecret } from "../utils/env";
import { extractBearerToken, verifyToken } from "../utils/jwt";

// Re-export generateToken so existing imports from this file keep working
export { generateToken } from "../utils/jwt";

interface AuthOptions {
  strict?: boolean;
}

export const authMiddleware = (options: AuthOptions = {}): MiddlewareHandler<HonoEnv> => {
  return async (c, next) => {
    const authHeader = c.req.header("Authorization");

    // Dev Mode Bypass: Allowed only if strict is false
    if (!options.strict && !authHeader && c.env?.ENVIRONMENT === "development") {
      c.set("user", {
        id: "dev-admin-id",
        email: "dev@admin.local",
        role: "ADMIN",
      });
      return await next();
    }

    const token = extractBearerToken(authHeader);
    if (!token) {
      return sendError(c, "Unauthorized. Authorization token required.", null, 401);
    }

    const user = await verifyToken(token, getJwtSecret(c));
    if (!user) {
      return sendError(c, "Unauthorized. Invalid or expired token.", null, 401);
    }

    c.set("user", user);
    await next();
  };
};

export const requireRole = (allowedRoles: ("ADMIN" | "CREATOR")[]): MiddlewareHandler<HonoEnv> => {
  return async (c, next) => {
    const user = c.get("user");
    if (!user) {
      return sendError(c, "Unauthorized.", null, 401);
    }

    if (!allowedRoles.includes(user.role)) {
      return sendError(c, "Forbidden. Insufficient permissions for this resource.", null, 403);
    }

    await next();
  };
};
