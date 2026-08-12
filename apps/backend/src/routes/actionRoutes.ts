import { Hono, type Context } from "hono";
import type { HonoEnv, UserJwtPayload } from "../types/env";
import { getDb } from "../db/index";
import { dispatchAction } from "../actions/index";
import { sendError } from "../utils/response";
import { getJwtSecret } from "../utils/env";
import { extractBearerToken, verifyToken } from "../utils/jwt";

import { users } from "../db/schema/index";
import { eq } from "drizzle-orm";

/**
 * Helper to verify JWT token dynamically for actions requiring authentication
 */
async function authenticate(
  c: Context<HonoEnv>,
  _strict: boolean = false,
): Promise<UserJwtPayload> {
  const authHeader = c.req.header("Authorization");

  const token = extractBearerToken(authHeader);
  if (!token) throw new Error("Unauthorized. Authorization token required.");

  const user = await verifyToken(token, getJwtSecret(c));
  if (!user) throw new Error("Unauthorized. Invalid or expired token.");

  // Check user status in DB
  const db = getDb(c.env.DB);
  const dbUser = await db
    .select({ status: users.status })
    .from(users)
    .where(eq(users.id, user.id))
    .get();

  if (dbUser?.status === "SUSPENDED") {
    throw new Error("Your account has been suspended by an administrator.");
  }

  return user;
}

export const actionRoutes = new Hono<HonoEnv>()
  /**
   * Unified POST Method Gateway: Handles all Create/Read/Update action dispatches
   */
  .post("/", async (c) => {
    try {
      const body = await c.req.json();
      const action = body?.action;
      const payloadData = body?.data || {};

      if (!action || typeof action !== "string") {
        return sendError(
          c,
          "Missing or invalid 'action' field in request body.",
        );
      }

      const db = getDb(c.env.DB);
      return await dispatchAction(c, db, action, payloadData, authenticate);
    } catch (err: any) {
      if (err.message?.startsWith("Unauthorized")) {
        return sendError(c, err.message, null, 401);
      }
      return sendError(c, err.message || "Failed to process request");
    }
  })
  /**
   * Unified DELETE Method Gateway: Handles all Delete action dispatches
   */
  .delete("/", async (c) => {
    try {
      const body = await c.req.json();
      const action = body?.action;
      const payloadData = body?.data || {};

      if (!action || typeof action !== "string") {
        return sendError(
          c,
          "Missing or invalid 'action' field in request body.",
        );
      }

      const db = getDb(c.env.DB);
      return await dispatchAction(c, db, action, payloadData, authenticate);
    } catch (err: any) {
      if (err.message?.startsWith("Unauthorized")) {
        return sendError(c, err.message, null, 401);
      }
      return sendError(c, err.message || "Failed to process delete action");
    }
  });
