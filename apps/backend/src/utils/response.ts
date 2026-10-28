import type { Context } from "hono";
import type { ContentfulStatusCode } from "hono/utils/http-status";

/**
 * Standard Unified API Response Envelope shared across Backend and Frontend
 */
export interface ApiResponseEnvelope<T = unknown> {
  code: 1 | 0;
  msg: string;
  time: number;
  data: T;
}

export type ApiResponse<T = unknown> = ApiResponseEnvelope<T>;

export function sendResponse<T>(
  c: Context,
  code: 1 | 0,
  msg: string,
  data: T = null as T,
  httpStatus: ContentfulStatusCode = 200
) {
  const envelope: ApiResponseEnvelope<T> = {
    code,
    msg,
    time: Math.floor(Date.now() / 1000),
    data,
  };
  return c.json(envelope, httpStatus);
}

export function sendSuccess<T>(
  c: Context,
  data: T = null as T,
  msg: string = "success"
) {
  return sendResponse(c, 1, msg, data, 200);
}

export function sendError<T = null>(
  c: Context,
  msg: string = "failed",
  data: T = null as T,
  httpStatus: ContentfulStatusCode = 400
) {
  return sendResponse(c, 0, msg, data, httpStatus);
}
