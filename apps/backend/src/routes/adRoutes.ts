import { Hono } from "hono";
import { zValidator } from "@hono/zod-validator";
import type { HonoEnv } from "../types/env";
import { getDb } from "../db/index";
import { AdClickService } from "../services/adClickService";
import { trackAdClickSchema } from "../schemas/ads";
import { sendSuccess } from "../utils/response";
import { getClientIp } from "../utils/ip";
import { zodErrorHandler } from "../utils/validation";

export const adRoutes = new Hono<HonoEnv>()

  // ── POST /api/ads/click — First-party ad click tracking ─────────────────────
  .post(
    "/click",
    zValidator("json", trackAdClickSchema, (result, c) => {
      if (!result.success) return zodErrorHandler(result, c);
    }),
    async (c) => {
      const body = c.req.valid("json");
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
