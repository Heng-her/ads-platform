import { z } from "zod";

export const trackAdClickSchema = z.object({
  campaignId: z.string().optional().nullable(),
  creatorId: z.string().optional().nullable(),
  provider: z.enum(["ADSTERRA", "GOOGLE_ADSENSE"]).default("ADSTERRA"),
  format: z.enum(["SMARTLINK", "BANNER", "NATIVE"]).default("SMARTLINK"),
  placement: z
    .enum([
      "header",
      "inArticle",
      "in-article",
      "sidebar",
      "articleTop",
      "articleSidebar",
      "categoryFeed",
    ])
    .default("header"),
});

export type TrackAdClickInput = z.infer<typeof trackAdClickSchema>;
