// https://nuxt.com/docs/api/configuration/nuxt-config
import { defineNuxtConfig } from "nuxt/config";

export default defineNuxtConfig({
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

  nitro: {
    preset: process.env.NITRO_PRESET || (process.env.NODE_ENV === "production" ? "cloudflare-module" : undefined),
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
    enabled: true,
  },

  css: ["~/assets/css/main.css"],

  site: {
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
