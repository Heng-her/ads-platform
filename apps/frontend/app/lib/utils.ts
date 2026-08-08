import type { CampaignItem } from '~/types/campaign'

export type CampaignSort = 'newest' | 'impressions' | 'viewers'

export interface CampaignListQueryOptions {
  page: number
  limit: number
  category?: string
  contentType?: string
  customCategoryId?: string
  search?: string
}

/**
 * Convert text into a clean, SEO-friendly URL slug
 */
export function slugify(text: string): string {
  if (!text) return ''
  return text
    .toString()
    .toLowerCase()
    .trim()
    .replace(/[^\w\s-]/g, '')    // Remove all non-word chars
    .replace(/[\s_-]+/g, '-')     // Replace spaces & underscores with -
    .replace(/^-+|-+$/g, '')       // Trim leading & trailing hyphens
}

/**
 * Extract UUID from a combined slug string if present at the end
 */
export function extractIdFromSlug(slug: string): string {
  if (!slug) return ''
  const uuidMatch = slug.match(/[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i)
  if (uuidMatch) return uuidMatch[0]
  return slug
}

/**
 * Generate full SEO-friendly Article URL (slug + ID combo)
 * Example: /article/introducing-next-gen-ai-ad-targeting-c0133b77-4a86-4e76-aa6b-6ff5f0c373c9
 */
export function getArticleUrl(campaign: { id?: string; title?: string } | null | undefined): string {
  if (!campaign || !campaign.id) return '/article'
  const titleSlug = slugify(campaign.title || '')
  return titleSlug ? `/article/${titleSlug}-${campaign.id}` : `/article/${campaign.id}`
}

/** Build the query payload used by the public campaign list action. */
export function buildCampaignListQuery(options: CampaignListQueryOptions): Record<string, string> {
  const query: Record<string, string> = {
    page: options.page.toString(),
    limit: options.limit.toString(),
  }

  if (options.category) query.category = options.category
  if (options.contentType) query.contentType = options.contentType
  if (options.customCategoryId) query.customCategoryId = options.customCategoryId
  if (options.search?.trim()) query.search = options.search.trim()

  return query
}

/** Return a sorted copy so the fetched campaign array is not mutated. */
export function sortCampaigns(campaigns: CampaignItem[], sortBy: CampaignSort): CampaignItem[] {
  const sorted = [...campaigns]

  if (sortBy === 'impressions') {
    return sorted.sort((a, b) => (b.totalImpressions ?? 0) - (a.totalImpressions ?? 0))
  }

  if (sortBy === 'viewers') {
    return sorted.sort((a, b) => (b.uniqueViewers ?? 0) - (a.uniqueViewers ?? 0))
  }

  return sorted.sort((a, b) => new Date(b.createdAt).getTime() - new Date(a.createdAt).getTime())
}

/** Select campaigns that can be displayed in the sponsored-ads rail. */
export function getSponsoredCampaigns(campaigns: CampaignItem[]): CampaignItem[] {
  return campaigns.filter(campaign => (
    campaign.contentType === 'SPONSORED' || campaign.adNetwork || campaign.adUnitCode
  ))
}

/** Count related category names from the campaigns currently loaded in the feed. */
export function getRelatedTopics(
  campaigns: CampaignItem[],
  selectedCategory: string,
  maxTopics = 6,
): string[] {
  const counts: Record<string, number> = {}

  for (const campaign of campaigns) {
    const category = campaign.category || 'General'
    if (category === selectedCategory) continue
    counts[category] = (counts[category] || 0) + 1
  }

  return Object.entries(counts)
    .sort(([, countA], [, countB]) => countB - countA)
    .slice(0, maxTopics)
    .map(([category]) => category)
}

/** Count the active URL filters without coupling the page to route state. */
export function countActiveFilters(filters: Array<string | null | undefined>): number {
  return filters.filter(Boolean).length
}

/**
 * Generate social platform share URLs using image assets from /icon directory
 */
export function getSocialShareLinks(title: string, url: string) {
  const encodedUrl = encodeURIComponent(url)
  const encodedTitle = encodeURIComponent(title)

  return [
    {
      name: 'Telegram',
      iconImg: '/icon/telegram.png',
      shareUrl: `https://t.me/share/url?url=${encodedUrl}&text=${encodedTitle}`
    },
    {
      name: 'Facebook',
      iconImg: '/icon/facebook.png',
      shareUrl: `https://www.facebook.com/sharer/sharer.php?u=${encodedUrl}`
    },
    {
      name: 'Twitter',
      iconImg: '/icon/twitter.png',
      shareUrl: `https://twitter.com/intent/tweet?url=${encodedUrl}&text=${encodedTitle}`
    },
    {
      name: 'LinkedIn',
      iconImg: '/icon/linkedin.png',
      shareUrl: `https://www.linkedin.com/sharing/share-offsite/?url=${encodedUrl}`
    },
    {
      name: 'WhatsApp',
      iconImg: '/icon/whatapp.png',
      shareUrl: `https://api.whatsapp.com/send?text=${encodedTitle}%20${encodedUrl}`
    }
  ]
}

/**
 * Native share or clipboard copy fallback
 */
export async function shareArticleOrCopy(article: { title: string; id: string; description?: string }) {
  if (typeof window === 'undefined') return { method: 'none', success: false }

  const url = `${window.location.origin}${getArticleUrl(article)}`
  const title = article.title

  if (typeof navigator !== 'undefined' && navigator.share) {
    try {
      await navigator.share({
        title: title,
        text: article.description || title,
        url: url
      })
      return { method: 'native', success: true }
    } catch {
      // User cancelled native share
    }
  }

  if (typeof navigator !== 'undefined' && navigator.clipboard) {
    await navigator.clipboard.writeText(url)
    return { method: 'copy', success: true }
  }

  return { method: 'none', success: false }
}
