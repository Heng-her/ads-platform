import { defineConfig } from "vitest/config";
import vue from "@vitejs/plugin-vue";
import { fileURLToPath } from "url";
import { resolve } from "path";

export default defineConfig({
  plugins: [vue()],
  test: {
    environment: "happy-dom",
    globals: true,
    include: ["tests/**/*.test.ts"],
    alias: {
      "~": fileURLToPath(new URL("./app", import.meta.url)),
      "#app": fileURLToPath(
        new URL("./tests/__mocks__/nuxt-app.ts", import.meta.url),
      ),
    },
  },
  resolve: {
    alias: {
      "~": fileURLToPath(new URL("./app", import.meta.url)),
    },
  },
});
