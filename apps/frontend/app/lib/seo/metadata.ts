import { seoConfig } from "./config";
import { generateArticleJsonLd, generateBreadcrumbsJsonLd } from "./jsonld";
import { getArticleUrl } from "~/lib/utils";

interface MetadataOptions {
  title?: string;
  description?: string;
  path?: string;
  image?: string;
  noIndex?: boolean;
}

/**
 * Applies SEO meta tags using Nuxt SEO composable functions (useSeoMeta & useSiteConfig).
 * Integrates directly with @nuxtjs/seo and @nuxtjs/robots modules.
 */
export function useCustomSeoMeta({
  title,
  description = seoConfig.defaultDescription,
  path = "",
  image = seoConfig.defaultImage,
  noIndex = false,
}: MetadataOptions = {}) {
  const site = useSiteConfig();
  const siteName = site.name || seoConfig.siteName;
  const siteUrl = site.url || seoConfig.siteUrl;

  const fullTitle = title ? `${title} | ${siteName}` : seoConfig.defaultTitle;
  const url = `${siteUrl}${path}`;

  useSeoMeta({
    title: fullTitle,
    description,
    ogTitle: fullTitle,
    ogDescription: description,
    ogUrl: url,
    ogSiteName: siteName,
    ogImage: image,
    twitterCard: "summary_large_image",
    twitterTitle: fullTitle,
    twitterDescription: description,
    twitterImage: image,
    robots: noIndex ? "noindex, nofollow" : "index, follow",
  });
}

/**
 * Reusable SEO composable specifically for Article detail pages.
 * Sets Meta Tags (OG, Twitter) and Schema.org JSON-LD (Article & Breadcrumbs).
 */
export function useArticleSeo(item: {
  id: string;
  title: string;
  description?: string | null;
  content?: string | null;
  imageUrl?: string | null;
  createdAt: string;
  creator?: { username?: string } | null;
}) {
  const cleanExcerpt = (item.description || item.content || item.title || "")
    .replace(/<[^>]*>/g, "")
    .trim()
    .slice(0, 160);

  const canonicalPath = getArticleUrl(item);

  useCustomSeoMeta({
    title: item.title,
    description: cleanExcerpt,
    path: canonicalPath,
    image: item.imageUrl || undefined,
  });

  const articleSchema = generateArticleJsonLd({
    slug: item.id,
    title: item.title,
    excerpt: cleanExcerpt,
    coverImage: item.imageUrl || "",
    author: item.creator?.username || "Verified Creator",
    publishedAt: item.createdAt,
  });

  const breadcrumbsSchema = generateBreadcrumbsJsonLd([
    { name: "Home", item: "/" },
    { name: "Articles", item: "/article" },
    { name: item.title, item: canonicalPath },
  ]);

  useHead({
    script: [
      {
        type: "application/ld+json" as any,
        innerHTML: JSON.stringify(articleSchema),
      },
      {
        type: "application/ld+json" as any,
        innerHTML: JSON.stringify(breadcrumbsSchema),
      },
    ],
  });
}
