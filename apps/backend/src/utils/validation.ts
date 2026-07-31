import type { Context } from "hono";
import type { ZodError } from "zod";
import { sendError } from "./response";

/**
 * Standard Zod validation error handler for use with @hono/zod-validator callbacks.
 * Extracts the first error message and returns a 400 response with the formatted errors.
 *
 * Usage:
 *   zValidator("json", mySchema, (result, c) => {
 *     if (!result.success) return zodErrorHandler(result, c);
 *   })
 */
export function zodErrorHandler(
  result: { success: false; error: ZodError },
  c: Context,
) {
  return sendError(
    c,
    result.error.errors[0]?.message || "Validation error",
    result.error.format(),
  );
}
