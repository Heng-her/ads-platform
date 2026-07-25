import { Hono } from "hono";
import type { HonoEnv } from "../types/env";
import { authRoutes } from "./authRoutes";
import { userRoutes } from "./userRoutes";
import { campaignRoutes } from "./campaignRoutes";
import { auditLogRoutes } from "./auditLogRoutes";
import { actionRoutes } from "./actionRoutes";

export const routes = new Hono<HonoEnv>()
  .route("/action", actionRoutes) // Single Gateway Action Dispatcher (POST /api/action & DELETE /api/action)
  .route("/auth", authRoutes)
  .route("/users", userRoutes)
  .route("/campaigns", campaignRoutes)
  .route("/audit-logs", auditLogRoutes);

export type AppType = typeof routes;
