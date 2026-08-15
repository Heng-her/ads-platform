import type { D1Database, KVNamespace, R2Bucket } from "@cloudflare/workers-types";

export interface CloudflareBindings {
  DB: D1Database;
  CACHE_KV: KVNamespace;
  ASSETS_BUCKET: R2Bucket;
  JWT_SECRET: string;
  ADMIN_SECRET: string;
  ENVIRONMENT: string;
  UPLOAD_API_BASE_URL: string;
  UPLOAD_API_KEY: string;
  UPLOAD_API_BYPASS_SECRET: string;
  GOOGLE_TRANSLATE_API_KEY?: string;
}

export interface UserJwtPayload {
  id: string;
  email: string | null;
  role: "ADMIN" | "CREATOR";
}

export interface AppVariables {
  user?: UserJwtPayload;
}

export type HonoEnv = {
  Bindings: CloudflareBindings;
  Variables: AppVariables;
};
