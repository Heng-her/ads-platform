import type { Context } from "hono";
import type { HonoEnv, UserJwtPayload } from "../types/env";
import type { DbClient } from "../db/index";
import { CategoryService } from "../services/categoryService";
import {
  createSystemCategorySchema,
  updateSystemCategorySchema,
  createContentTypeSchema,
  updateContentTypeSchema,
  createCustomCategorySchema,
  updateCustomCategorySchema,
} from "../schemas/category";
import { sendSuccess, sendError } from "../utils/response";

export async function handleCategoryAction(
  c: Context<HonoEnv>,
  db: DbClient,
  action: string,
  payloadData: any,
  authenticate: (c: Context<HonoEnv>, strict?: boolean) => Promise<UserJwtPayload>,
) {
  switch (action) {
    // -------------------------------------------------------------
    // System Category Actions
    // -------------------------------------------------------------
    case "categories/list": {
      const categoryService = new CategoryService(db);
      const systemCats = await categoryService.getAllSystemCategories();
      const response = [
        ...systemCats,
        { id: 999, name: "OTHER", createdAt: null },
      ];
      return sendSuccess(c, response);
    }

    case "categories/create": {
      const currentUser = await authenticate(c);
      if (currentUser.role !== "ADMIN") return sendError(c, "Forbidden", null, 403);
      const parseResult = createSystemCategorySchema.safeParse(payloadData);
      if (!parseResult.success) {
        return sendError(
          c,
          parseResult.error.errors[0]?.message || "Validation error",
          parseResult.error.format(),
        );
      }
      const categoryService = new CategoryService(db);
      const result = await categoryService.createSystemCategory(
        parseResult.data.name,
        parseResult.data.adsterraSmartlinkUrl,
        parseResult.data.adsterraBannerKey
      );
      if (!result || "error" in result) {
        return sendError(c, "error" in result ? result.error : "Failed to create system category", null, 409);
      }
      return sendSuccess(c, result, "System category created successfully");
    }

    case "categories/update": {
      const currentUser = await authenticate(c);
      if (currentUser.role !== "ADMIN") return sendError(c, "Forbidden", null, 403);
      const catId = payloadData?.id ? Number(payloadData.id) : null;
      if (!catId) return sendError(c, "Category ID is required");
      const parseResult = updateSystemCategorySchema.safeParse(payloadData);
      if (!parseResult.success) {
        return sendError(
          c,
          parseResult.error.errors[0]?.message || "Validation error",
          parseResult.error.format(),
        );
      }
      const categoryService = new CategoryService(db);
      const result = await categoryService.updateSystemCategory(
        catId,
        parseResult.data.name,
        parseResult.data.adsterraSmartlinkUrl,
        parseResult.data.adsterraBannerKey
      );
      if (result === null) return sendError(c, "System category not found", null, 404);
      if ("error" in result) return sendError(c, result.error, null, 409);
      return sendSuccess(c, result, "System category updated successfully");
    }

    case "categories/delete": {
      const currentUser = await authenticate(c);
      if (currentUser.role !== "ADMIN") return sendError(c, "Forbidden", null, 403);
      const catId = payloadData?.id ? Number(payloadData.id) : null;
      if (!catId) return sendError(c, "Category ID is required");
      const categoryService = new CategoryService(db);
      const deleted = await categoryService.deleteSystemCategory(catId);
      if (!deleted) return sendError(c, "System category not found", null, 404);
      return sendSuccess(c, null, "System category deleted successfully");
    }

    // -------------------------------------------------------------
    // Content Type Actions
    // -------------------------------------------------------------
    case "content-types/list": {
      const categoryService = new CategoryService(db);
      const types = await categoryService.getAllContentTypes();
      return sendSuccess(c, types);
    }

    case "content-types/create": {
      const currentUser = await authenticate(c);
      if (currentUser.role !== "ADMIN") return sendError(c, "Forbidden", null, 403);
      const parseResult = createContentTypeSchema.safeParse(payloadData);
      if (!parseResult.success) {
        return sendError(
          c,
          parseResult.error.errors[0]?.message || "Validation error",
          parseResult.error.format(),
        );
      }
      const categoryService = new CategoryService(db);
      const result = await categoryService.createContentType(parseResult.data.name);
      if ("error" in result) return sendError(c, result.error, null, 409);
      return sendSuccess(c, result, "Content type created successfully");
    }

    case "content-types/update": {
      const currentUser = await authenticate(c);
      if (currentUser.role !== "ADMIN") return sendError(c, "Forbidden", null, 403);
      const typeId = payloadData?.id ? Number(payloadData.id) : null;
      if (!typeId) return sendError(c, "Content Type ID is required");
      const parseResult = updateContentTypeSchema.safeParse(payloadData);
      if (!parseResult.success) {
        return sendError(
          c,
          parseResult.error.errors[0]?.message || "Validation error",
          parseResult.error.format(),
        );
      }
      const categoryService = new CategoryService(db);
      const result = await categoryService.updateContentType(typeId, parseResult.data.name);
      if (result === null) return sendError(c, "Content type not found", null, 404);
      if ("error" in result) return sendError(c, result.error, null, 409);
      return sendSuccess(c, result, "Content type updated successfully");
    }

    case "content-types/delete": {
      const currentUser = await authenticate(c);
      if (currentUser.role !== "ADMIN") return sendError(c, "Forbidden", null, 403);
      const typeId = payloadData?.id ? Number(payloadData.id) : null;
      if (!typeId) return sendError(c, "Content Type ID is required");
      const categoryService = new CategoryService(db);
      const deleted = await categoryService.deleteContentType(typeId);
      if (!deleted) return sendError(c, "Content type not found", null, 404);
      return sendSuccess(c, null, "Content type deleted successfully");
    }

    // -------------------------------------------------------------
    // Admin All Custom Category Actions
    // -------------------------------------------------------------
    case "categories/all-custom-list": {
      const currentUser = await authenticate(c);
      if (currentUser.role !== "ADMIN") return sendError(c, "Forbidden", null, 403);
      const categoryService = new CategoryService(db);
      const categories = await categoryService.getAllCustomCategoriesWithUser();
      return sendSuccess(c, categories);
    }

    case "categories/delete-custom": {
      const currentUser = await authenticate(c);
      if (currentUser.role !== "ADMIN") return sendError(c, "Forbidden", null, 403);
      const catId = payloadData?.id ? Number(payloadData.id) : null;
      if (!catId) return sendError(c, "Custom Category ID is required");
      const categoryService = new CategoryService(db);
      const deleted = await categoryService.deleteCustomCategoryByAdmin(catId);
      if (!deleted) return sendError(c, "Custom category not found", null, 404);
      return sendSuccess(c, null, "Custom category deleted successfully");
    }

    // -------------------------------------------------------------
    // Creator Custom Category Actions (/my/categories)
    // -------------------------------------------------------------
    case "my/categories/list": {
      const currentUser = await authenticate(c);
      const categoryService = new CategoryService(db);
      const categories = await categoryService.getCustomCategoriesByUser(currentUser.id);
      return sendSuccess(c, categories);
    }

    case "my/categories/create": {
      const currentUser = await authenticate(c);
      const parseResult = createCustomCategorySchema.safeParse(payloadData);
      if (!parseResult.success) {
        return sendError(
          c,
          parseResult.error.errors[0]?.message || "Validation error",
          parseResult.error.format(),
        );
      }
      const categoryService = new CategoryService(db);
      const result = await categoryService.createCustomCategory(
        currentUser.id,
        parseResult.data.name,
        parseResult.data.adsterraSmartlinkUrl,
        parseResult.data.adsterraBannerKey
      );
      if ("error" in result) return sendError(c, result.error, null, 409);
      return sendSuccess(c, result, "Custom category created successfully");
    }

    case "my/categories/update": {
      const currentUser = await authenticate(c);
      const catId = payloadData?.id ? Number(payloadData.id) : null;
      if (!catId) return sendError(c, "Custom Category ID is required");
      const parseResult = updateCustomCategorySchema.safeParse(payloadData);
      if (!parseResult.success) {
        return sendError(
          c,
          parseResult.error.errors[0]?.message || "Validation error",
          parseResult.error.format(),
        );
      }
      const categoryService = new CategoryService(db);
      const result = await categoryService.updateCustomCategory(
        catId,
        currentUser.id,
        parseResult.data.name,
        parseResult.data.adsterraSmartlinkUrl,
        parseResult.data.adsterraBannerKey
      );
      if (result === null) return sendError(c, "Custom category not found", null, 404);
      if ("error" in result) return sendError(c, result.error, null, 409);
      return sendSuccess(c, result, "Custom category updated successfully");
    }

    case "my/categories/delete": {
      const currentUser = await authenticate(c);
      const catId = payloadData?.id ? Number(payloadData.id) : null;
      if (!catId) return sendError(c, "Custom Category ID is required");
      const categoryService = new CategoryService(db);
      const deleted = await categoryService.deleteCustomCategory(catId, currentUser.id);
      if (!deleted) return sendError(c, "Custom category not found", null, 404);
      return sendSuccess(c, null, "Custom category deleted successfully");
    }

    default:
      return null;
  }
}
