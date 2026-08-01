import type { D1Database, KVNamespace, R2Bucket } from "@cloudflare/workers-types";

export interface CloudflareBindings {
  DB: D1Database;
  CACHE_KV: KVNamespace;
  ASSETS_BUCKET: R2Bucket;
  JWT_SECRET: string;
  ADMIN_SECRET: string;
  ENVIRONMENT: string;
}

export interface UserJwtPayload {
  id: string;
  email: string;
  role: "ADMIN" | "CREATOR";
}

export interface AppVariables {
  user?: UserJwtPayload;
}

export type HonoEnv = {
  Bindings: CloudflareBindings;
  Variables: AppVariables;
};
