import type { MiddlewareHandler } from "hono";
import { jwtVerify, SignJWT } from "jose";
import type { HonoEnv, UserJwtPayload } from "../types/env";
import { sendError } from "../utils/response";

export async function generateToken(payload: UserJwtPayload, secretStr: string, expiresIn: string = "7d"): Promise<string> {
  const secret = new TextEncoder().encode(secretStr);
  return new SignJWT({ ...payload })
    .setProtectedHeader({ alg: "HS256" })
    .setIssuedAt()
    .setExpirationTime(expiresIn)
    .sign(secret);
}

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
        role: "ADMIN"
      });
      return await next();
    }

    if (!authHeader || !authHeader.startsWith("Bearer ")) {
      return sendError(c, "Unauthorized. Authorization token required.", null, 401);
    }

    const token = authHeader.substring(7);
    try {
      const secret = new TextEncoder().encode(c.env.JWT_SECRET || "fallback-secret-key");
      const { payload } = await jwtVerify(token, secret);

      c.set("user", {
        id: payload.id as string,
        email: payload.email as string,
        role: payload.role as "ADMIN" | "CREATOR"
      });

      await next();
    } catch {
      return sendError(c, "Unauthorized. Invalid or expired token.", null, 401);
    }
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
