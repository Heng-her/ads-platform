import { seoConfig } from './config'

interface MetadataOptions {
  title?: string
  description?: string
  path?: string
  image?: string
  noIndex?: boolean
}

/**
 * Applies SEO meta tags using Nuxt SEO composable functions (useSeoMeta & useSiteConfig).
 * Integrates directly with @nuxtjs/seo and @nuxtjs/robots modules.
 */
export function useCustomSeoMeta({
  title,
  description = seoConfig.defaultDescription,
  path = '',
  image = seoConfig.defaultImage,
  noIndex = false
}: MetadataOptions = {}) {
  const site = useSiteConfig()
  const siteName = site.name || seoConfig.siteName
  const siteUrl = site.url || seoConfig.siteUrl

  const fullTitle = title ? `${title} | ${siteName}` : seoConfig.defaultTitle
  const url = `${siteUrl}${path}`

  useSeoMeta({
    title: fullTitle,
    description,
    ogTitle: fullTitle,
    ogDescription: description,
    ogUrl: url,
    ogSiteName: siteName,
    ogImage: image,
    twitterCard: 'summary_large_image',
    twitterTitle: fullTitle,
    twitterDescription: description,
    twitterImage: image,
    robots: noIndex ? 'noindex, nofollow' : 'index, follow'
  })
}
