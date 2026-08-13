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
          JWT_SECRET: "ads-platform-jwt-secret-key",
          ADMIN_SECRET: "ads-platform-admin-secret-key",
          ENVIRONMENT: "test",
        },
      },
    }),
    include: ["tests/**/*.test.ts"],
  },
});
