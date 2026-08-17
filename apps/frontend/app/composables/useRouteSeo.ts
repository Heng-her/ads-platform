import { onMounted } from 'vue'
import { useCustomSeoMeta } from '~/lib/seo/metadata'
import { useApi } from '~/composables/useApi'
import { decryptData } from '~/lib/crypto'

export type RouteSeoKey = 'home' | 'explore' | 'trending' | 'pricing' | 'news'

export interface RouteSeoOptions {
  title?: string
  description?: string
  path?: string
  image?: string
  imageAlt?: string
  noIndex?: boolean
}

/**
 * Dynamic SEO composable that fetches Admin configured SEO & Open Graph images
 * from backend settings (/api/action settings/get-all) and falls back to route defaults.
 */
export function useRouteSeo(routeKey: RouteSeoKey, defaultOptions: RouteSeoOptions = {}) {
  const { fetchSettings } = useSystemSettings()

  // Apply default options first for immediate SSR rendering
  useCustomSeoMeta({
    title: defaultOptions.title,
    description: defaultOptions.description,
    path: defaultOptions.path || '',
    image: defaultOptions.image,
    imageAlt: defaultOptions.imageAlt || defaultOptions.title,
    noIndex: defaultOptions.noIndex,
  })

  // Function to apply dynamic settings when available
  const applySettings = (dataPayload: any) => {
    if (!dataPayload?.platform?.seo) return

    const routeSeo = dataPayload.platform.seo[routeKey]
    const globalOgImage = dataPayload.platform.ogImage

    if (routeSeo) {
      const resolvedTitle = routeSeo.title?.trim() || defaultOptions.title
      useCustomSeoMeta({
        title: resolvedTitle,
        description: routeSeo.description?.trim() || defaultOptions.description,
        path: defaultOptions.path || '',
        image: routeSeo.image?.trim() || globalOgImage || defaultOptions.image,
        imageAlt: resolvedTitle,
        noIndex: defaultOptions.noIndex,
      })
    }
  }

  // Fetch settings from API on mount or use cached state
  onMounted(async () => {
    const data = await fetchSettings()
    if (data) {
      applySettings(data)
    }
  })
}
