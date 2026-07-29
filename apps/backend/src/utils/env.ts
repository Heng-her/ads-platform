import type { HonoEnv } from "../types/env";

/**
 * Safely extracts the JWT_SECRET from Cloudflare environment bindings.
 * Throws a fatal error if JWT_SECRET is missing in non-development environments.
 */
export function getJwtSecret(c: { env: HonoEnv["Bindings"] }): string {
  const secret = c.env?.JWT_SECRET;
  if (!secret) {
    if (c.env?.ENVIRONMENT === "development") {
      return "dev_secure_jwt_secret_key_min_32_characters_long";
    }
    throw new Error("FATAL SECURITY ERROR: JWT_SECRET environment variable is missing in production!");
  }
  return secret;
}
