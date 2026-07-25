import type { Context } from "hono";
import type { ContentfulStatusCode } from "hono/utils/http-status";

export interface ApiResponseEnvelope<T = any> {
  code: 1 | 0;
  msg: string;
  time: number;
  data: T;
}

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
    data
  };
  return c.json(envelope, httpStatus);
}

export function sendSuccess<T>(c: Context, data: T = {} as T, msg: string = "success") {
  return sendResponse(c, 1, msg, data, 200);
}

export function sendError(
  c: Context,
  msg: string = "failed",
  data: any = null,
  httpStatus: ContentfulStatusCode = 400
) {
  return sendResponse(c, 0, msg, data, httpStatus);
}
