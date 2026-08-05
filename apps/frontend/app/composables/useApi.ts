import { hc } from "hono/client";
import type { AppType } from "@ads-platform/shared";
import { useAuthStore } from "~/stores/auth";

export interface UseApiOptions {
  /** Custom base API URL endpoint */
  baseUrl?: string;
  /** Custom Bearer token (defaults to authStore.token if logged in) */
  token?: string;
  /** Custom X-ADMIN-SECRET header */
  adminSecret?: string;
  /** Additional custom HTTP headers */
  headers?: Record<string, string>;
  /** Custom fetch function override */
  fetch?: typeof fetch;
}

/**
 * Reusable 100% type-safe Hono RPC API client composable.
 * Automatically injects Bearer auth token and allows custom endpoint/adminSecret overrides.
 */
export function useApi(options?: UseApiOptions) {
  const config = useRuntimeConfig();
  const defaultBaseUrl =
    (config.public as any)?.apiBase || "http://localhost:8787/api";

  const targetBaseUrl = options?.baseUrl || defaultBaseUrl;

  // Create Hono RPC client with dynamic header resolution
  const client = hc<AppType>(targetBaseUrl, {
    headers: async () => {
      const headersMap: Record<string, string> = {};

      // 1. Bearer Token (from options or Pinia auth store)
      let activeToken = options?.token;
      if (!activeToken) {
        try {
          const authStore = useAuthStore();
          activeToken = authStore.token || undefined;
        } catch {
          // If called outside Pinia scope, ignore error
        }
      }

      if (activeToken) {
        headersMap["Authorization"] = `Bearer ${activeToken}`;
      }

      // 2. X-ADMIN-SECRET header
      if (options?.adminSecret) {
        headersMap["x-admin-secret"] = options.adminSecret;
      }

      // 3. Custom extra headers
      if (options?.headers) {
        Object.assign(headersMap, options.headers);
      }

      return headersMap;
    },
    fetch: options?.fetch,
  });

  return client;
}

