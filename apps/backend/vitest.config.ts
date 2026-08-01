import { defineConfig } from "vitest/config";
import { cloudflarePool } from "@cloudflare/vitest-pool-workers";

export default defineConfig({
  test: {
    pool: cloudflarePool({
      wrangler: { configPath: "./wrangler.jsonc" },
      miniflare: {
        // Provide test values for bindings declared in wrangler.jsonc
        kvNamespaces: ["CACHE_KV"],
        d1Databases: ["DB"],
        bindings: {
          JWT_SECRET: "test-jwt-secret-for-exploration",
          ADMIN_SECRET: "test-admin-secret",
          ENVIRONMENT: "test",
        },
      },
    }),
    include: ["tests/**/*.test.ts"],
  },
});
