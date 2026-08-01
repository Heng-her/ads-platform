import { z } from "zod";

export const createCampaignSchema = z.object({
  title: z.string().min(3, "Title must be at least 3 characters"),
  description: z.string().optional(),
  category: z.string().optional(),
  contentType: z.string().optional().default("ARTICLE"),
  content: z.string().optional(),
  imageUrl: z.string().url("Invalid image URL").optional(),
  imageTitle: z.string().optional(),
  imageDescription: z.string().optional(),
  adNetwork: z.string().optional(),
  adUnitCode: z.string().optional(),
  status: z.enum(["DRAFT", "PUBLIC"]).optional().default("PUBLIC"),
});

export const updateCampaignSchema = z.object({
  title: z.string().min(3, "Title must be at least 3 characters").optional(),
  description: z.string().optional(),
  category: z.string().optional(),
  contentType: z.string().optional(),
  content: z.string().optional(),
  imageUrl: z.string().url("Invalid image URL").optional(),
  imageTitle: z.string().optional(),
  imageDescription: z.string().optional(),
  adNetwork: z.string().optional(),
  adUnitCode: z.string().optional(),
  status: z.enum(["DRAFT", "PUBLIC"]).optional(),
});

export const updateCampaignStatusSchema = z.object({
  status: z.enum(["DRAFT", "PUBLIC"]),
});

export const listCampaignsQuerySchema = z.object({
  page: z.coerce.number().int().min(1).optional().default(1),
  limit: z.coerce.number().int().min(1).max(100).optional().default(10),
  category: z.string().optional(),
  contentType: z.string().optional(),
  search: z.string().optional(),
  status: z.enum(["DRAFT", "PUBLIC"]).optional(),
  customCategoryId: z.coerce.number().int().positive().optional(),
});

export const meCampaignsQuerySchema = z.object({
  page: z.coerce.number().int().min(1).optional().default(1),
  limit: z.coerce.number().int().min(1).max(100).optional().default(10),
  status: z.enum(["DRAFT", "PUBLIC"]).optional(),
});

export type CreateCampaignInput = z.infer<typeof createCampaignSchema>;
export type UpdateCampaignInput = z.infer<typeof updateCampaignSchema>;
