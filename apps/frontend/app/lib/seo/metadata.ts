import { seoConfig } from "./config";
import { generateArticleJsonLd, generateBreadcrumbsJsonLd } from "./jsonld";
import { getArticleUrl } from "~/lib/utils";

interface MetadataOptions {
  title?: string;
  description?: string;
  path?: string;
  image?: string;
  noIndex?: boolean;
  type?: "website" | "article";
  publishedTime?: string;
  author?: string;
}

/**
 * Resolves the primary image URL from an article or campaign item.
 * Priority:
 * 1. item.imageUrl
 * 2. First image url from item.images array
 * 3. First img src tag in item.content (if any)
 */
export function resolveArticleImage(item: {
  imageUrl?: string | null;
  images?: Array<{ url: string; title?: string; description?: string }> | null;
  content?: string | null;
}): string | undefined {
  if (item.imageUrl && item.imageUrl.trim()) {
    return item.imageUrl.trim();
  }
  if (item.images && Array.isArray(item.images) && item.images.length > 0) {
    const first = item.images.find((img) => img && img.url && img.url.trim());
    if (first && first.url) return first.url.trim();
  }
  if (item.content) {
    const match = item.content.match(/<img[^>]+src=["']([^"']+)["']/i);
    if (match && match[1]) {
      return match[1].trim();
    }
  }
  return undefined;
}

/**
 * Ensures an image URL is fully-qualified / absolute for social media crawlers
 * (Facebook, Telegram, WhatsApp require absolute http:// or https:// URLs).
 */
export function toAbsoluteUrl(url?: string, baseUrl?: string): string | undefined {
  if (!url) return undefined;
  if (/^https?:\/\//i.test(url)) return url;
  const cleanBase = (baseUrl || seoConfig.siteUrl).replace(/\/+$/, "");
  const cleanPath = url.startsWith("/") ? url : `/${url}`;
  return `${cleanBase}${cleanPath}`;
}

/**
 * Applies SEO meta tags using Nuxt SEO composable functions (useSeoMeta & useSiteConfig).
 * Integrates directly with @nuxtjs/seo and @nuxtjs/robots modules.
 */
export function useCustomSeoMeta({
  title,
  description = seoConfig.defaultDescription,
  path = "",
  image,
  noIndex = false,
  type = "website",
  publishedTime,
  author,
}: MetadataOptions = {}) {
  const site = useSiteConfig();
  let origin = "";
  try {
    const reqUrl = useRequestURL();
    if (reqUrl && reqUrl.origin) {
      origin = reqUrl.origin;
    }
  } catch {
    // Client-side fallback
  }

  const siteName = site.name || seoConfig.siteName;
  const siteUrl = origin || site.url || seoConfig.siteUrl;

  const fullTitle = title ? `${title} | ${siteName}` : seoConfig.defaultTitle;
  const url = `${siteUrl}${path}`;

  // Ensure absolute image URL for Facebook, WhatsApp, and Telegram previews
  const rawImage = image || seoConfig.defaultImage;
  const absoluteImage = toAbsoluteUrl(rawImage, siteUrl);

  useSeoMeta({
    title: fullTitle,
    description,
    ogTitle: fullTitle,
    ogDescription: description,
    ogUrl: url,
    ogSiteName: siteName,
    ogType: type,
    ogImage: absoluteImage,
    ogImageSecureUrl: absoluteImage?.startsWith("https://") ? absoluteImage : undefined,
    ogImageAlt: title || siteName,
    ogImageWidth: 1200,
    ogImageHeight: 630,
    twitterCard: "summary_large_image",
    twitterTitle: fullTitle,
    twitterDescription: description,
    twitterImage: absoluteImage,
    twitterImageAlt: title || siteName,
    articlePublishedTime: publishedTime,
    articleAuthor: author ? [author] : undefined,
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
  images?: Array<{ url: string; title?: string; description?: string }> | null;
  createdAt: string;
  updatedAt?: string;
  creator?: { username?: string; avatar?: string | null } | null;
}) {
  const cleanExcerpt = (item.description || item.content || item.title || "")
    .replace(/<[^>]*>/g, "")
    .trim()
    .slice(0, 160);

  const canonicalPath = getArticleUrl(item);
  const resolvedImage = resolveArticleImage(item);

  useCustomSeoMeta({
    title: item.title,
    description: cleanExcerpt,
    path: canonicalPath,
    image: resolvedImage,
    type: "article",
    publishedTime: item.createdAt ? new Date(item.createdAt).toISOString() : undefined,
    author: item.creator?.username || "Verified Creator",
  });

  const articleSchema = generateArticleJsonLd({
    slug: item.id,
    title: item.title,
    excerpt: cleanExcerpt,
    coverImage: resolvedImage || "",
    author: item.creator?.username || "Verified Creator",
    publishedAt: item.createdAt,
    updatedAt: item.updatedAt,
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
