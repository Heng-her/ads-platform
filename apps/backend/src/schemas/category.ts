import { z } from "zod";

// ── System Category ───────────────────────────────────────────────────────────
export const createSystemCategorySchema = z.object({
  name: z
    .string()
    .min(2, "Name must be at least 2 characters")
    .max(50, "Name must be at most 50 characters")
    .transform((v) => v.trim().toUpperCase()),
});

export const updateSystemCategorySchema = z.object({
  name: z
    .string()
    .min(2, "Name must be at least 2 characters")
    .max(50, "Name must be at most 50 characters")
    .transform((v) => v.trim().toUpperCase()),
});

// ── Custom Category ───────────────────────────────────────────────────────────
export const createCustomCategorySchema = z.object({
  name: z
    .string()
    .min(2, "Name must be at least 2 characters")
    .max(50, "Name must be at most 50 characters")
    .transform((v) => v.trim()),
});

export const updateCustomCategorySchema = z.object({
  name: z
    .string()
    .min(2, "Name must be at least 2 characters")
    .max(50, "Name must be at most 50 characters")
    .transform((v) => v.trim()),
});

// ── Content Type ──────────────────────────────────────────────────────────────
export const createContentTypeSchema = z.object({
  name: z
    .string()
    .min(2, "Name must be at least 2 characters")
    .max(50, "Name must be at most 50 characters")
    .transform((v) => v.trim().toUpperCase()),
});

export const updateContentTypeSchema = z.object({
  name: z
    .string()
    .min(2, "Name must be at least 2 characters")
    .max(50, "Name must be at most 50 characters")
    .transform((v) => v.trim().toUpperCase()),
});

export type CreateSystemCategoryInput  = z.infer<typeof createSystemCategorySchema>;
export type CreateCustomCategoryInput  = z.infer<typeof createCustomCategorySchema>;
export type CreateContentTypeInput     = z.infer<typeof createContentTypeSchema>;
