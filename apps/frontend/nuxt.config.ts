// https://nuxt.com/docs/api/configuration/nuxt-config
import { fileURLToPath } from "node:url";
import { defineNuxtConfig } from "nuxt/config";

export default defineNuxtConfig({
  future: {
    compatibilityVersion: 4,
  },
  app: {
    head: {
      link: [
        { rel: "manifest", href: "/manifest.json" },
        { rel: "apple-touch-icon", href: "/ads-platform.png" },
      ],
      meta: [
        { name: "theme-color", content: "#4f46e5" },
        { name: "mobile-web-app-capable", content: "yes" },
        { name: "apple-mobile-web-app-capable", content: "yes" },
        {
          name: "apple-mobile-web-app-status-bar-style",
          content: "black-translucent",
        },
        {
          name: "google-site-verification",
          content: "QXb7kpfY3LB59LMNF32p2mzYo20JCvsArwVBH1aR4wg",
        },
      ],
    },
  },
  runtimeConfig: {
    // server secrets (not available in browser or public config)
    cryptoSecret:
      process.env.NUXT_CRYPTO_SECRET || "ads-platform-secure-secret-key",

    // public config (available in browser and server)
    public: {
      apiBase: process.env.NUXT_PUBLIC_API_BASE,
      googleClientId: process.env.NUXT_PUBLIC_GOOGLE_CLIENT_ID,
    },
  },

  alias: {
    "@backend": fileURLToPath(new URL("../backend/src", import.meta.url)),
  },

  modules: [
    "@pinia/nuxt",
    "@nuxt/eslint",
    "@nuxt/ui",
    "@nuxt/image",
    "@nuxt/scripts",
    "@nuxtjs/seo",
  ],
  routeRules: {
    "/": { prerender: false },
  },
  devServer: {
    host: "0.0.0.0",
    port: 3000,
  },
  linkChecker: {
    enabled: false,
  },
  icon: {
    clientBundle: {
      scan: true,
      includeCustomCollections: true,
    },
    serverBundle: false,
  },

  vite: {
    server: {
      allowedHosts: true,
    },
    optimizeDeps: {
      include: [
        "@tiptap/vue-3",
        "@tiptap/starter-kit",
        "@tiptap/extension-image",
        "@tiptap/extension-link",
        "@tiptap/extension-text-style",
        "crypto-js",
        "sanitize-html",
        "ethers",
        "hono",
        "vue",
        "vue-router",
        "@unhead/vue",
        "pinia",
        "clsx",
        "tailwind-merge",
      ],
    },
  },
  nitro: {
    preset:
      process.env.NITRO_PRESET ||
      (process.env.NODE_ENV === "production" ? "cloudflare-module" : undefined),
    prerender: {
      crawlLinks: false,
      routes: [],
      failOnError: false,
    },
  },

  ogImage: {
    enabled: false,
  },

  devtools: {
    enabled: false,
  },

  css: ["~/assets/css/main.css"],

  site: {
    url: "https://ads-platform.crypten.workers.dev",
    name: "New Platform",
    description:
      "New Platform is a modern advertising network connecting advertisers and publishers with smart targeting and real-time analytics.",
    defaultLocale: "en",
  },

  compatibilityDate: "2026-06-30",

  eslint: {
    config: {
      stylistic: {
        commaDangle: "never",
        braceStyle: "1tbs",
      },
    },
  },

  robots: {
    allow: "/",
    disallow: ["/api/", "/admin/"],
    sitemap: "/sitemap.xml",
  },
});
