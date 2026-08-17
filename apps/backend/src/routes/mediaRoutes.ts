import { Hono } from "hono";
import { authMiddleware, requireRole } from "../middlewares/auth";
import type { HonoEnv } from "../types/env";
import { getDb } from "../db/index";
import {
  SystemSettingsService,
  DEFAULT_UPLOAD_CONFIG,
  type UploadConfig,
} from "../services/systemSettingsService";
import { sendError } from "../utils/response";

const allowedFolders = new Set([
  "avatars",
  "profiles",
  "users",
  "logos",
  "system",
  "seo",
  "campaigns",
  "campaigns/covers",
  "campaigns/gallery",
  "campaigns/videos",
]);

export const mediaRoutes = new Hono<HonoEnv>().post(
  "/upload",
  authMiddleware({ strict: true }),
  requireRole(["ADMIN", "CREATOR"]),
  async (c) => {
    const folder = c.req.query("folder");
    if (!folder || !allowedFolders.has(folder)) {
      return sendError(c, "Unsupported upload folder", null, 400);
    }

    const contentType = c.req.header("Content-Type");
    if (!contentType?.startsWith("multipart/form-data")) {
      return sendError(c, "Multipart form data is required", null, 400);
    }

    // Load upload configuration from system_settings (or fallback to environment variables)
    const db = getDb(c.env.DB);
    const service = new SystemSettingsService({ db });
    const uploadConfig = await service.getSetting<UploadConfig>(
      "upload",
      DEFAULT_UPLOAD_CONFIG,
    );

    const baseUrl =
      (uploadConfig?.uploadApiBaseUrl || c.env.UPLOAD_API_BASE_URL || "").trim();
    const apiKey =
      (uploadConfig?.uploadApiKey || c.env.UPLOAD_API_KEY || "").trim();
    const bypassSecret =
      (uploadConfig?.uploadApiBypassSecret || c.env.UPLOAD_API_BYPASS_SECRET || "").trim();

    if (!baseUrl || !apiKey || !bypassSecret) {
      return sendError(c, "Admin upload proxy is not configured", null, 503);
    }

    const upstreamUrl = new URL(`/api/${folder}`, baseUrl).toString();
    const upstreamResponse = await fetch(upstreamUrl, {
      method: "POST",
      headers: {
        "Content-Type": contentType,
        "x-api-key": apiKey,
        "x-api-bypass": bypassSecret,
      },
      body: c.req.raw.body,
    });

    return new Response(upstreamResponse.body, {
      status: upstreamResponse.status,
      headers: {
        "Content-Type":
          upstreamResponse.headers.get("Content-Type") || "application/json",
      },
    });
  },
);
