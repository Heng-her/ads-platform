import { jwtVerify, SignJWT } from "jose";
import type { UserJwtPayload } from "../types/env";

/**
 * Extracts the raw Bearer token string from an Authorization header value.
 * Returns null if the header is missing or not a Bearer token.
 */
export function extractBearerToken(authHeader: string | undefined): string | null {
  if (!authHeader || !authHeader.startsWith("Bearer ")) return null;
  return authHeader.substring(7);
}

/**
 * Verifies a JWT token and returns the decoded UserJwtPayload.
 * Returns null if the token is invalid or expired.
 */
export async function verifyToken(token: string, secretStr: string): Promise<UserJwtPayload | null> {
  try {
    const secret = new TextEncoder().encode(secretStr);
    const { payload } = await jwtVerify(token, secret);
    return {
      id: payload.id as string,
      email: (payload.email as string) ?? null,
      role: payload.role as "ADMIN" | "CREATOR",
    };
  } catch {
    return null;
  }
}

/**
 * Signs and returns a JWT token for the given user payload.
 * Moved here from middlewares/auth.ts to fix a layer violation
 * (auth middleware should not generate tokens — that's a utility concern).
 */
export async function generateToken(
  payload: UserJwtPayload,
  secretStr: string,
  expiresIn: string = "7d",
): Promise<string> {
  const secret = new TextEncoder().encode(secretStr);
  return new SignJWT({ ...payload })
    .setProtectedHeader({ alg: "HS256" })
    .setIssuedAt()
    .setExpirationTime(expiresIn)
    .sign(secret);
}
