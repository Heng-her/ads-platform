import { hc } from "hono/client";
import type { AppType } from "@ads-platform/shared";

export function useApi() {
  const config = useRuntimeConfig();
  const baseUrl =
    (config.public as any)?.apiBase || "http://localhost:8787/api";

  // Create 100% type-safe Hono RPC client
  const client = hc<AppType>(baseUrl);

  return client;
}
