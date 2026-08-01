import { Hono } from "hono";
import type { HonoEnv } from "../types/env";
import { authRoutes } from "./authRoutes";
import { userRoutes } from "./userRoutes";
import { campaignRoutes } from "./campaignRoutes";
import { auditLogRoutes } from "./auditLogRoutes";
import { actionRoutes } from "./actionRoutes";
import { categoryRoutes, contentTypeRoutes } from "./categoryRoutes";
import { myRoutes } from "./myRoutes";
import { dashboardRoutes } from "./dashboardRoutes";

export const routes = new Hono<HonoEnv>()
  .route("/action", actionRoutes)             // Single Gateway Action Dispatcher
  .route("/auth", authRoutes)
  .route("/users", userRoutes)
  .route("/campaigns", campaignRoutes)
  .route("/audit-logs", auditLogRoutes)
  .route("/categories", categoryRoutes)       // System categories (public GET, ADMIN write)
  .route("/content-types", contentTypeRoutes) // Content types (public GET, ADMIN write)
  .route("/my", myRoutes)                     // Creator-scoped: /my/categories
  .route("/dashboard", dashboardRoutes);      // Dashboard stats: /dashboard/me/stats, /dashboard/admin/stats

export type AppType = typeof routes;
