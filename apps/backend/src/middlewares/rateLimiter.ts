import type { MiddlewareHandler } from "hono";
import type { HonoEnv } from "../types/env";
import { sendError } from "../utils/response";

interface RateLimitOptions {
  limit?: number;
  windowSeconds?: number;
}

export const rateLimiter = (options: RateLimitOptions = {}): MiddlewareHandler<HonoEnv> => {
  const limit = options.limit ?? 60;
  const windowSeconds = options.windowSeconds ?? 60;

  return async (c, next) => {
    const clientIp = c.req.header("cf-connecting-ip") || c.req.header("x-forwarded-for") || "127.0.0.1";
    const kv = c.env.CACHE_KV;

    if (!kv) {
      await next();
      return;
    }

    const currentMinute = Math.floor(Date.now() / 1000 / windowSeconds);
    const key = `ratelimit:${clientIp}:${currentMinute}`;

    const currentCountStr = await kv.get(key);
    const currentCount = currentCountStr ? parseInt(currentCountStr, 10) : 0;

    if (currentCount >= limit) {
      c.header("Retry-After", windowSeconds.toString());
      return sendError(
        c,
        `Too many requests. Rate limit exceeded. Maximum ${limit} requests per ${windowSeconds}s allowed.`,
        null,
        429
      );
    }

    await kv.put(key, (currentCount + 1).toString(), { expirationTtl: windowSeconds + 10 });

    c.header("X-RateLimit-Limit", limit.toString());
    c.header("X-RateLimit-Remaining", Math.max(0, limit - (currentCount + 1)).toString());

    await next();
  };
};
