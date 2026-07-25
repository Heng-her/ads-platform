// Re-export Response Envelope interface
export type { ApiResponseEnvelope as ApiResponse } from "@backend/utils/response";

// Re-export backend Drizzle DB Schemas & Model Types
export * from "@backend/db/schema/index";

// Re-export Zod Validation Schemas & DTO Types
export { registerSchema, loginSchema } from "@backend/routes/authRoutes";
export { updateUserStatusSchema } from "@backend/routes/userRoutes";
export { createCampaignSchema, updateCampaignStatusSchema } from "@backend/routes/campaignRoutes";

// Re-export Hono RPC AppType for Frontend end-to-end type safety
export type { AppType } from "@backend/routes/index";
