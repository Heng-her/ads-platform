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
export function getArticleUrl(campaign: { id: string; title?: string } | null | undefined): string {
  if (!campaign || !campaign.id) return '/article'
  const titleSlug = slugify(campaign.title || '')
  return titleSlug ? `/article/${titleSlug}-${campaign.id}` : `/article/${campaign.id}`
}
