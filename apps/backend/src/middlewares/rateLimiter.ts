import type { MiddlewareHandler, Context } from "hono";
import type { HonoEnv } from "../types/env";
import { sendError } from "../utils/response";
import { getClientIp } from "../utils/ip";
import { getDb } from "../db/index";
import {
  SystemSettingsService,
  DEFAULT_POST_CONFIG,
  type PostConfig,
} from "../services/systemSettingsService";

export interface RateLimitOptions {
  limit?: number;
  windowSeconds?: number;
  keyPrefix?: string;
  message?: string;
}

/**
 * Core rate limit checker helper using Cloudflare KV Cache
 */
export async function checkRateLimit(c: Context<HonoEnv>, options: RateLimitOptions = {}): Promise<string | null> {
  const limit = options.limit ?? 60;
  const windowSeconds = options.windowSeconds ?? 60;
  const keyPrefix = options.keyPrefix ?? "global";
  const customMessage = options.message;

  const clientIp = getClientIp(c);
  const kv = c.env.CACHE_KV;

  if (!kv) {
    return null; // Bypass rate limit if KV is not bound
  }

  const currentWindow = Math.floor(Date.now() / 1000 / windowSeconds);
  const key = `ratelimit:${keyPrefix}:${clientIp}:${currentWindow}`;

  const currentCountStr = await kv.get(key);
  const currentCount = currentCountStr ? parseInt(currentCountStr, 10) : 0;

  if (currentCount >= limit) {
    c.header("Retry-After", windowSeconds.toString());
    const windowText = windowSeconds >= 86400 ? `${Math.round(windowSeconds / 86400)} day(s)` : `${windowSeconds}s`;
    return customMessage || `Rate limit exceeded. Maximum ${limit} requests allowed per ${windowText} from your IP.`;
  }

  await kv.put(key, (currentCount + 1).toString(), {
    expirationTtl: windowSeconds + 10,
  });

  c.header("X-RateLimit-Limit", limit.toString());
  c.header(
    "X-RateLimit-Remaining",
    Math.max(0, limit - (currentCount + 1)).toString()
  );

  return null;
}

export const rateLimiter = (options: RateLimitOptions = {}): MiddlewareHandler<HonoEnv> => {
  return async (c, next) => {
    const errorMsg = await checkRateLimit(c, options);
    if (errorMsg) {
      return sendError(c, errorMsg, null, 429);
    }
    await next();
  };
};

/**
 * Dynamic User Registration Rate Limiter: Dynamic account registrations per 24 hours per IP from system settings.
 * Skipped entirely in development (ENVIRONMENT === "development").
 */
export const registerRateLimiter = (): MiddlewareHandler<HonoEnv> => {
  return async (c, next) => {
    if (c.env.ENVIRONMENT === "development") {
      return next();
    }
    let limit = DEFAULT_POST_CONFIG.maxRegisterPerDay || 5;
    if (c.env?.DB) {
      try {
        const db = getDb(c.env.DB);
        const settingsService = new SystemSettingsService({ db });
        const postConfig = await settingsService.getSetting<PostConfig>("post", DEFAULT_POST_CONFIG);
        if (postConfig?.maxRegisterPerDay && postConfig.maxRegisterPerDay > 0) {
          limit = postConfig.maxRegisterPerDay;
        }
      } catch {
        // Fallback to default limit if DB read fails
      }
    }

    const errorMsg = await checkRateLimit(c, {
      limit,
      windowSeconds: 86400, // 24 hours
      keyPrefix: "register",
      message: `Registration limit reached. You can only create a maximum of ${limit} accounts per day from your IP address.`,
    });
    if (errorMsg) {
      return sendError(c, errorMsg, null, 429);
    }
    await next();
  };
};

/**
 * Post Creation Rate Limiter: Dynamic post limit per 24 hours per IP from system settings
 */
export const createCampaignRateLimiter = (): MiddlewareHandler<HonoEnv> => {
  return async (c, next) => {
    let limit = DEFAULT_POST_CONFIG.maxPostPerDay;
    if (c.env?.DB) {
      try {
        const db = getDb(c.env.DB);
        const settingsService = new SystemSettingsService({ db });
        const postConfig = await settingsService.getSetting<PostConfig>("post", DEFAULT_POST_CONFIG);
        if (postConfig?.maxPostPerDay && postConfig.maxPostPerDay > 0) {
          limit = postConfig.maxPostPerDay;
        }
      } catch {
        // Fallback to default limit if DB read fails
      }
    }

    const errorMsg = await checkRateLimit(c, {
      limit,
      windowSeconds: 86400, // 24 hours
      keyPrefix: "campaign_create",
      message: `Post limit reached. You can only publish a maximum of ${limit} posts per day from your IP address.`,
    });
    if (errorMsg) {
      return sendError(c, errorMsg, null, 429);
    }
    await next();
  };
};
