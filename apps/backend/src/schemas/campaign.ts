import { z } from "zod";

export const imageItemSchema = z.object({
  url: z.string().url("Invalid image URL"),
  title: z.string().optional(),
  description: z.string().optional(),
});

const optionalStringSchema = z
  .string()
  .optional()
  .or(z.null())
  .transform((val) => (val === null || val === "" ? undefined : val));

const optionalUrlSchema = z
  .string()
  .url("Invalid URL format")
  .optional()
  .or(z.literal(""))
  .or(z.null())
  .transform((val) => (val === "" || val === null ? undefined : val));

export const createCampaignSchema = z.object({
  title: z.string().min(3, "Title must be at least 3 characters"),
  description: optionalStringSchema,
  category: optionalStringSchema,
  contentType: z.string().optional().default("ARTICLE"),
  content: optionalStringSchema,
  imageUrl: optionalUrlSchema,
  imageTitle: optionalStringSchema,
  imageDescription: optionalStringSchema,
  images: z.array(imageItemSchema).optional().or(z.null()).transform((arr) => arr ?? undefined),
  videoUrls: z
    .array(optionalUrlSchema)
    .optional()
    .or(z.null())
    .transform((arr) => arr?.filter((item): item is string => typeof item === "string" && item.length > 0) ?? undefined),
  adNetwork: optionalStringSchema,
  adUnitCode: optionalStringSchema,
  status: z.enum(["DRAFT", "PUBLIC"]).optional().default("PUBLIC"),
});

export const updateCampaignSchema = z.object({
  title: z.string().min(3, "Title must be at least 3 characters").optional(),
  description: optionalStringSchema,
  category: optionalStringSchema,
  contentType: z.string().optional(),
  content: optionalStringSchema,
  imageUrl: optionalUrlSchema,
  imageTitle: optionalStringSchema,
  imageDescription: optionalStringSchema,
  images: z.array(imageItemSchema).optional().or(z.null()).transform((arr) => arr ?? undefined),
  videoUrls: z
    .array(optionalUrlSchema)
    .optional()
    .or(z.null())
    .transform((arr) => arr?.filter((item): item is string => typeof item === "string" && item.length > 0) ?? undefined),
  adNetwork: optionalStringSchema,
  adUnitCode: optionalStringSchema,
  status: z.enum(["DRAFT", "PUBLIC"]).optional(),
});

export const updateCampaignStatusSchema = z.object({
  status: z.enum(["DRAFT", "PUBLIC"]),
});

export const createCampaignTranslationSchema = z.object({
  locale: z.string().regex(/^[a-z]{2,3}(?:-[A-Z]{2})?$/, "Use a language code such as km, th, or vi"),
  sourceLocale: z.string().regex(/^[a-z]{2,3}(?:-[A-Z]{2})?$/).optional().default("en"),
});

const campaignFeedFiltersSchema = z.object({
  category: z.string().optional(),
  contentType: z.string().optional(),
  search: z.string().optional(),
  customCategoryId: z.coerce.number().int().positive().optional(),
});

export const publicCampaignFeedQuerySchema = campaignFeedFiltersSchema.extend({
  limit: z.coerce.number().int().min(1).max(100).optional().default(10),
  cursor: z.string().optional(),
  snapshotAt: z.string().datetime().optional(),
}).superRefine(({ cursor, snapshotAt }, context) => {
  if (cursor && !snapshotAt) {
    context.addIssue({
      code: z.ZodIssueCode.custom,
      path: ["snapshotAt"],
      message: "snapshotAt is required when cursor is provided",
    });
  }

  if (snapshotAt && !cursor) {
    context.addIssue({
      code: z.ZodIssueCode.custom,
      path: ["cursor"],
      message: "cursor is required when snapshotAt is provided",
    });
  }
});

export const newCampaignCountQuerySchema = campaignFeedFiltersSchema.extend({
  snapshotAt: z.string().datetime(),
});

export const listCampaignsQuerySchema = campaignFeedFiltersSchema.extend({
  page: z.coerce.number().int().min(1).optional().default(1),
  limit: z.coerce.number().int().min(1).max(100).optional().default(10),
  status: z.enum(["DRAFT", "PUBLIC"]).optional(),
});

export const meCampaignsQuerySchema = z.object({
  page: z.coerce.number().int().min(1).optional().default(1),
  limit: z.coerce.number().int().min(1).max(100).optional().default(10),
  status: z.enum(["DRAFT", "PUBLIC"]).optional(),
  category: z.string().optional(),
  search: z.string().optional(),
});

export type CreateCampaignInput = z.infer<typeof createCampaignSchema>;
export type UpdateCampaignInput = z.infer<typeof updateCampaignSchema>;
