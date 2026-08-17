import { Hono } from "hono";
import { zValidator } from "@hono/zod-validator";
import type { HonoEnv } from "../types/env";
import { getDb } from "../db/index";
import { AdClickService } from "../services/adClickService";
import { trackAdClickSchema } from "../schemas/ads";
import { sendSuccess, sendError } from "../utils/response";
import { getClientIp } from "../utils/ip";
import { zodErrorHandler } from "../utils/validation";

export const adRoutes = new Hono<HonoEnv>()

  // ── POST /api/ads/click — First-party ad click tracking ─────────────────────
  .post(
    "/click",
    async (c) => {
      let rawData: any = {};
      try {
        const contentType = c.req.header("Content-Type") || "";
        if (contentType.includes("application/json")) {
          rawData = await c.req.json();
        } else {
          const text = await c.req.text();
          rawData = JSON.parse(text);
        }
      } catch {
        rawData = {};
      }

      const parseResult = trackAdClickSchema.safeParse(rawData);
      if (!parseResult.success) {
        return sendError(c, "Invalid click tracking payload", parseResult.error.flatten(), 400);
      }

      const body = parseResult.data;
      const db = getDb(c.env.DB);
      const adClickService = new AdClickService(db, c.env.CACHE_KV);

      const ip = getClientIp(c);
      const userAgent = c.req.header("User-Agent") || "unknown";
      const viewerHash = await AdClickService.buildViewerHash(ip, userAgent);

      const result = await adClickService.recordClick(body, viewerHash);

      return sendSuccess(c, {
        recorded: true,
        creatorId: result.creatorId,
      });
    }
  );
