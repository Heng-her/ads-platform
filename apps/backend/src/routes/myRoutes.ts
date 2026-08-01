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
  createCustomCategorySchema,
  updateCustomCategorySchema,
} from "../schemas/category";

const idParamSchema = z.object({
  id: z.coerce.number().int().positive("ID must be a positive integer"),
});

// ─── /api/my/* — Creator-scoped routes ───────────────────────────────────────

export const myRoutes = new Hono<HonoEnv>()

  // ── GET /api/my/categories — Own custom categories ────────────────────────
  .get(
    "/categories",
    authMiddleware(),
    requireRole(["CREATOR", "ADMIN"]),
    async (c) => {
      const userPayload = c.get("user")!;
      const db = getDb(c.env.DB);
      const categoryService = new CategoryService(db);
      const categories = await categoryService.getCustomCategoriesByUser(userPayload.id);
      return sendSuccess(c, categories);
    },
  )

  // ── POST /api/my/categories — Create a custom category ───────────────────
  .post(
    "/categories",
    authMiddleware(),
    requireRole(["CREATOR", "ADMIN"]),
    zValidator("json", createCustomCategorySchema, (result, c) => {
      if (!result.success) return zodErrorHandler(result, c);
    }),
    async (c) => {
      const userPayload = c.get("user")!;
      const { name } = c.req.valid("json");
      const db = getDb(c.env.DB);
      const categoryService = new CategoryService(db);
      const result = await categoryService.createCustomCategory(userPayload.id, name);

      if ("error" in result) return sendError(c, result.error, null, 409);
      return sendSuccess(c, result, "Custom category created successfully");
    },
  )

  // ── PATCH /api/my/categories/:id — Update own custom category ────────────
  .patch(
    "/categories/:id",
    authMiddleware(),
    requireRole(["CREATOR", "ADMIN"]),
    zValidator("param", idParamSchema, (result, c) => {
      if (!result.success) return zodErrorHandler(result, c);
    }),
    zValidator("json", updateCustomCategorySchema, (result, c) => {
      if (!result.success) return zodErrorHandler(result, c);
    }),
    async (c) => {
      const userPayload = c.get("user")!;
      const { id } = c.req.valid("param");
      const { name } = c.req.valid("json");
      const db = getDb(c.env.DB);
      const categoryService = new CategoryService(db);
      const result = await categoryService.updateCustomCategory(id, userPayload.id, name);

      if (result === null) return sendError(c, "Custom category not found", null, 404);
      if ("error" in result) return sendError(c, result.error, null, 409);
      return sendSuccess(c, result, "Custom category updated successfully");
    },
  )

  // ── DELETE /api/my/categories/:id — Delete own custom category ───────────
  .delete(
    "/categories/:id",
    authMiddleware(),
    requireRole(["CREATOR", "ADMIN"]),
    zValidator("param", idParamSchema, (result, c) => {
      if (!result.success) return zodErrorHandler(result, c);
    }),
    async (c) => {
      const userPayload = c.get("user")!;
      const { id } = c.req.valid("param");
      const db = getDb(c.env.DB);
      const categoryService = new CategoryService(db);
      const deleted = await categoryService.deleteCustomCategory(id, userPayload.id);

      if (!deleted) return sendError(c, "Custom category not found", null, 404);
      return sendSuccess(c, null, "Custom category deleted successfully");
    },
  );
