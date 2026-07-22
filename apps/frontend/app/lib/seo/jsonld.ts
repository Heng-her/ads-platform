import { seoConfig } from './config'

interface BreadcrumbItem {
  name: string
  item: string
}

/**
 * Returns Schema.org BreadcrumbList payload for useJsonld() or useHead()
 */
export function generateBreadcrumbsJsonLd(items: BreadcrumbItem[]) {
  return {
    '@context': 'https://schema.org',
    '@type': 'BreadcrumbList',
    'itemListElement': items.map((item, index) => ({
      '@type': 'ListItem',
      'position': index + 1,
      'name': item.name,
      'item': item.item.startsWith('http') ? item.item : `${seoConfig.siteUrl}${item.item}`
    }))
  }
}

/**
 * Schema.org Article / NewsArticle for blog/article pages
 */
export function generateArticleJsonLd(article: {
  slug: string
  title: string
  excerpt: string
  coverImage: string
  author: string
  publishedAt: string
  updatedAt?: string
}) {
  return {
    '@context': 'https://schema.org',
    '@type': 'NewsArticle',
    'headline': article.title,
    'description': article.excerpt,
    'image': [article.coverImage],
    'datePublished': article.publishedAt,
    'dateModified': article.updatedAt ?? article.publishedAt,
    'author': [{ '@type': 'Person', 'name': article.author }],
    'publisher': {
      '@type': 'Organization',
      'name': seoConfig.siteName,
      'logo': { '@type': 'ImageObject', 'url': `${seoConfig.siteUrl}/logo.png` }
    },
    'mainEntityOfPage': `${seoConfig.siteUrl}/article/${article.slug}`
  }
}

/**
 * Schema.org SoftwareApplication / Service entry
 */
export function generateServiceJsonLd(service: {
  id: string
  name: string
  description: string
  category: string
}) {
  return {
    '@context': 'https://schema.org',
    '@type': 'SoftwareApplication',
    'name': service.name,
    'description': service.description,
    'applicationCategory': service.category
  }
}
