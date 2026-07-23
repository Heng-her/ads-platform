// https://nuxt.com/docs/api/configuration/nuxt-config
import { defineNuxtConfig } from "nuxt/config";

export default defineNuxtConfig({
  modules: [
    "@nuxt/eslint",
    "@nuxt/ui",
    "@nuxt/image",
    "@nuxt/scripts",
    "@nuxtjs/seo",
    "@nuxtjs/robots",
    "@pinia/nuxt",
  ],

  nitro: {
    preset: "cloudflare_pages"
  },

  devtools: {
    enabled: true,
  },

  css: ["~/assets/css/main.css"],

  site: {
    url:
      process.env.NUXT_PUBLIC_SITE_URL ||
      "https://ads-platform.crypten.workers.dev",
    name: "Ads Platform",
    description:
      "Ads Platform is a modern advertising network connecting advertisers and publishers with smart targeting and real-time analytics.",
    defaultLocale: "en",
  },

  routeRules: {
    "/": { prerender: true },
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
