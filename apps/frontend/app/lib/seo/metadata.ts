import { seoConfig } from "./config";
import { generateArticleJsonLd, generateBreadcrumbsJsonLd } from "./jsonld";
import { getArticleUrl } from "~/lib/utils";

interface MetadataOptions {
  title?: string;
  description?: string;
  path?: string;
  image?: string;
  type?: "website" | "article";
  noIndex?: boolean;
}

/**
 * Applies SEO meta tags using Nuxt SEO composable functions (useSeoMeta, useHead & useSiteConfig).
 * Resolves absolute Open Graph, Twitter card, Google SERP thumbnail images, canonical tags, and structured data.
 */
export function useCustomSeoMeta({
  title,
  description = seoConfig.defaultDescription,
  path = "",
  image = seoConfig.defaultImage,
  type = "website",
  noIndex = false,
}: MetadataOptions = {}) {
  const site = useSiteConfig();
  const siteName = site.name || seoConfig.siteName;
  const siteUrl = (site.url || seoConfig.siteUrl).replace(/\/$/, "");

  const fullTitle = title
    ? title.includes(siteName) ? title : `${title} | ${siteName}`
    : seoConfig.defaultTitle;
  
  const canonicalUrl = `${siteUrl}${path.startsWith("/") ? path : `/${path}`}`;

  // Resolve absolute image URL if relative path is provided
  const absoluteImageUrl = image.startsWith("http://") || image.startsWith("https://")
    ? image
    : `${siteUrl}${image.startsWith("/") ? image : `/${image}`}`;

  useSeoMeta({
    title: fullTitle,
    description,
    ogTitle: fullTitle,
    ogDescription: description,
    ogUrl: canonicalUrl,
    ogSiteName: siteName,
    ogType: type,
    ogImage: absoluteImageUrl,
    ogImageAlt: title || siteName,
    twitterCard: "summary_large_image",
    twitterTitle: fullTitle,
    twitterDescription: description,
    twitterImage: absoluteImageUrl,
    robots: noIndex ? "noindex, nofollow" : "index, follow",
  });

  // Attach Canonical URL, Google SERP thumbnail meta, & WebSite/WebPage Schema.org JSON-LD
  const pageSchema = {
    "@context": "https://schema.org",
    "@type": type === "article" ? "Article" : "WebPage",
    "name": fullTitle,
    "description": description,
    "url": canonicalUrl,
    "image": absoluteImageUrl,
    "primaryImageOfPage": {
      "@type": "ImageObject",
      "url": absoluteImageUrl,
    },
    "isPartOf": {
      "@type": "WebSite",
      "name": siteName,
      "url": siteUrl
    }
  };

  useHead({
    link: [
      {
        rel: "canonical",
        href: canonicalUrl,
      },
    ],
    meta: [
      {
        name: "thumbnail",
        content: absoluteImageUrl,
      },
      {
        property: "image",
        content: absoluteImageUrl,
      },
    ],
    script: [
      {
        type: "application/ld+json" as any,
        innerHTML: JSON.stringify(pageSchema),
      },
    ],
  });
}

/**
 * Reusable SEO composable specifically for Article detail pages.
 * Sets Meta Tags (OG, Twitter, Google Thumbnail) and Schema.org JSON-LD (Article & Breadcrumbs).
 */
export function useArticleSeo(item: {
  id: string;
  title: string;
  description?: string | null;
  content?: string | null;
  imageUrl?: string | null;
  createdAt: string;
  creator?: { username?: string; avatar?: string | null } | null;
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
    image: item.imageUrl || seoConfig.defaultImage,
    type: "article",
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
