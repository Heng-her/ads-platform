import { Hono } from "hono";
import type { HonoEnv } from "../types/env";
import { getDb } from "../db/index";
import { MonetizationService } from "../services/monetizationService";
import { sendSuccess } from "../utils/response";

export const monetizationRoutes = new Hono<HonoEnv>()

  // ── GET /api/monetization/config — Safe Public Advertisement Config ────────
  .get("/config", async (c) => {
    const db = getDb(c.env.DB);
    const monetizationService = new MonetizationService({ db });
    const rawSettings = await monetizationService.getAdProviderSettings();

    const googleCreds = rawSettings.GOOGLE_ADSENSE?.credentials || {};
    const adsterraCreds = rawSettings.ADSTERRA?.credentials || {};

    const rawPublisherId = (googleCreds.googlePublisherId || "").trim();
    const isRealPublisherId =
      Boolean(rawPublisherId) &&
      rawPublisherId.startsWith("ca-pub-") &&
      rawPublisherId !== "ca-pub-9876543210987654";

    const publisherId = isRealPublisherId ? rawPublisherId : "";
    const googleEnabled =
      Boolean(rawSettings.GOOGLE_ADSENSE?.enabled) && isRealPublisherId;
    const adsterraEnabled = Boolean(rawSettings.ADSTERRA?.enabled ?? true);

    const headerSlot = (googleCreds.googleBannerSlotId || "").trim();
    const inArticleSlot = (googleCreds.googleInArticleSlotId || "").trim();

    const safeConfig = {
      googleAdsense: {
        enabled: googleEnabled,
        publisherId,
        autoAds: Boolean(googleCreds.googleAutoAds ?? false),
        slots: {
          header: headerSlot,
          articleTop: headerSlot,
          inArticle: inArticleSlot,
          sidebar: headerSlot,
          articleSidebar: headerSlot,
          categoryFeed: headerSlot,
        },
      },
      adsterra: {
        enabled: Boolean(adsterraEnabled),
        smartlinkEnabled: Boolean(adsterraEnabled),
        smartlinkUrl:
          adsterraCreds.adsterraDirectLinkUrl ||
          "https://ironcomparable.com/gh6u2ftq6?key=a3904ecfe67c81deb37177a2588649a9",
        slots: {
          banner728x90: adsterraCreds.adsterraBanner728x90Key || "",
          nativeBanner: adsterraCreds.adsterraNativeBannerKey || "",
        },
      },
    };

    return sendSuccess(c, safeConfig);
  });
