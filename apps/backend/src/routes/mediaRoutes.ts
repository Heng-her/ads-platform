import { Hono } from "hono";
import { authMiddleware, requireRole } from "../middlewares/auth";
import type { HonoEnv } from "../types/env";
import { sendError } from "../utils/response";

const allowedFolders = new Set(["campaigns", "campaigns/videos"]);

export const mediaRoutes = new Hono<HonoEnv>().post(
  "/upload",
  authMiddleware({ strict: true }),
  requireRole(["ADMIN"]),
  async (c) => {
    const folder = c.req.query("folder");
    if (!folder || !allowedFolders.has(folder)) {
      return sendError(c, "Unsupported upload folder", null, 400);
    }

    const contentType = c.req.header("Content-Type");
    if (!contentType?.startsWith("multipart/form-data")) {
      return sendError(c, "Multipart form data is required", null, 400);
    }

    if (!c.env.UPLOAD_API_BASE_URL || !c.env.UPLOAD_API_KEY || !c.env.UPLOAD_API_BYPASS_SECRET) {
      return sendError(c, "Admin upload proxy is not configured", null, 503);
    }

    const upstreamUrl = new URL(`/api/${folder}`, c.env.UPLOAD_API_BASE_URL).toString();
    const upstreamResponse = await fetch(upstreamUrl, {
      method: "POST",
      headers: {
        "Content-Type": contentType,
        "x-api-key": c.env.UPLOAD_API_KEY,
        "x-api-bypass": c.env.UPLOAD_API_BYPASS_SECRET,
      },
      body: c.req.raw.body,
    });

    return new Response(upstreamResponse.body, {
      status: upstreamResponse.status,
      headers: {
        "Content-Type": upstreamResponse.headers.get("Content-Type") || "application/json",
      },
    });
  },
);
