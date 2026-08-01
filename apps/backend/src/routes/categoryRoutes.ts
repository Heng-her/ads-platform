import { Hono } from "hono";
import { zValidator } from "@hono/zod-validator";
import { z } from "zod";
import type { HonoEnv } from "../types/env";
import { getDb } from "../db/index";
import { CategoryService } from "../services/categoryService";
import { authMiddleware, requireRole } from "../middlewares/auth";
import { sendSuccess, sendError } from "../utils/response";
import { zodErrorHandler } from "../utils/validation";
import {
  createSystemCategorySchema,
  updateSystemCategorySchema,
  createContentTypeSchema,
  updateContentTypeSchema,
} from "../schemas/category";

const idParamSchema = z.object({
  id: z.coerce.number().int().positive("ID must be a positive integer"),
});

// ─── Routes ──────────────────────────────────────────────────────────────────

export const categoryRoutes = new Hono<HonoEnv>()

  // ── GET /api/categories — Public: all system categories + virtual OTHER ─────
  .get("/", async (c) => {
    const db = getDb(c.env.DB);
    const categoryService = new CategoryService(db);
    const systemCats = await categoryService.getAllSystemCategories();

    // Append virtual "OTHER" entry for frontend routing to custom categories
    const response = [
      ...systemCats,
      { id: 999, name: "OTHER", createdAt: null },
    ];

    return sendSuccess(c, response);
  })

  // ── POST /api/categories — ADMIN only: create system category ──────────────
  .post(
    "/",
    authMiddleware(),
    requireRole(["ADMIN"]),
    zValidator("json", createSystemCategorySchema, (result, c) => {
      if (!result.success) return zodErrorHandler(result, c);
    }),
    async (c) => {
      const { name } = c.req.valid("json");
      const db = getDb(c.env.DB);
      const categoryService = new CategoryService(db);
      const result = await categoryService.createSystemCategory(name);

      if (!result || "error" in result) {
        return sendError(c, "error" in result ? result.error : "Failed to create system category", null, 409);
      }
      return sendSuccess(c, result, "System category created successfully");
    },
  )

  // ── PATCH /api/categories/:id — ADMIN only: update system category ─────────
  .patch(
    "/:id",
    authMiddleware(),
    requireRole(["ADMIN"]),
    zValidator("param", idParamSchema, (result, c) => {
      if (!result.success) return zodErrorHandler(result, c);
    }),
    zValidator("json", updateSystemCategorySchema, (result, c) => {
      if (!result.success) return zodErrorHandler(result, c);
    }),
    async (c) => {
      const { id } = c.req.valid("param");
      const { name } = c.req.valid("json");
      const db = getDb(c.env.DB);
      const categoryService = new CategoryService(db);
      const result = await categoryService.updateSystemCategory(id, name);

      if (result === null) return sendError(c, "System category not found", null, 404);
      if ("error" in result) return sendError(c, result.error, null, 409);
      return sendSuccess(c, result, "System category updated successfully");
    },
  )

  // ── DELETE /api/categories/:id — ADMIN only: delete system category ─────────
  .delete(
    "/:id",
    authMiddleware(),
    requireRole(["ADMIN"]),
    zValidator("param", idParamSchema, (result, c) => {
      if (!result.success) return zodErrorHandler(result, c);
    }),
    async (c) => {
      const { id } = c.req.valid("param");
      const db = getDb(c.env.DB);
      const categoryService = new CategoryService(db);
      const deleted = await categoryService.deleteSystemCategory(id);

      if (!deleted) return sendError(c, "System category not found", null, 404);
      return sendSuccess(c, null, "System category deleted successfully");
    },
  );

// ─── Content Type Routes ──────────────────────────────────────────────────────

export const contentTypeRoutes = new Hono<HonoEnv>()

  // ── GET /api/content-types — Public: list all content types ──────────────
  .get("/", async (c) => {
    const db = getDb(c.env.DB);
    const categoryService = new CategoryService(db);
    const types = await categoryService.getAllContentTypes();
    return sendSuccess(c, types);
  })

  // ── POST /api/content-types — ADMIN only: create content type ────────────
  .post(
    "/",
    authMiddleware(),
    requireRole(["ADMIN"]),
    zValidator("json", createContentTypeSchema, (result, c) => {
      if (!result.success) return zodErrorHandler(result, c);
    }),
    async (c) => {
      const { name } = c.req.valid("json");
      const db = getDb(c.env.DB);
      const categoryService = new CategoryService(db);
      const result = await categoryService.createContentType(name);

      if ("error" in result) return sendError(c, result.error, null, 409);
      return sendSuccess(c, result, "Content type created successfully");
    },
  )

  // ── PATCH /api/content-types/:id — ADMIN only: update content type ────────
  .patch(
    "/:id",
    authMiddleware(),
    requireRole(["ADMIN"]),
    zValidator("param", idParamSchema, (result, c) => {
      if (!result.success) return zodErrorHandler(result, c);
    }),
    zValidator("json", updateContentTypeSchema, (result, c) => {
      if (!result.success) return zodErrorHandler(result, c);
    }),
    async (c) => {
      const { id } = c.req.valid("param");
      const { name } = c.req.valid("json");
      const db = getDb(c.env.DB);
      const categoryService = new CategoryService(db);
      const result = await categoryService.updateContentType(id, name);

      if (result === null) return sendError(c, "Content type not found", null, 404);
      if ("error" in result) return sendError(c, result.error, null, 409);
      return sendSuccess(c, result, "Content type updated successfully");
    },
  )

  // ── DELETE /api/content-types/:id — ADMIN only: delete content type ────────
  .delete(
    "/:id",
    authMiddleware(),
    requireRole(["ADMIN"]),
    zValidator("param", idParamSchema, (result, c) => {
      if (!result.success) return zodErrorHandler(result, c);
    }),
    async (c) => {
      const { id } = c.req.valid("param");
      const db = getDb(c.env.DB);
      const categoryService = new CategoryService(db);
      const deleted = await categoryService.deleteContentType(id);

      if (!deleted) return sendError(c, "Content type not found", null, 404);
      return sendSuccess(c, null, "Content type deleted successfully");
    },
  );
