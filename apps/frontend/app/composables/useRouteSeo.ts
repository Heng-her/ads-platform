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
  noIndex?: boolean
}

/**
 * Dynamic SEO composable that fetches Admin configured SEO & Open Graph images
 * from backend settings (/api/action settings/get-all) and falls back to route defaults.
 */
export function useRouteSeo(routeKey: RouteSeoKey, defaultOptions: RouteSeoOptions = {}) {
  const settingsState = useState<any>('admin_platform_system_settings', () => null)
  const api = useApi()

  // Apply default options first for immediate SSR rendering
  useCustomSeoMeta({
    title: defaultOptions.title,
    description: defaultOptions.description,
    path: defaultOptions.path || '',
    image: defaultOptions.image,
    noIndex: defaultOptions.noIndex,
  })

  // Function to apply dynamic settings when available
  const applySettings = (dataPayload: any) => {
    if (!dataPayload?.platform?.seo) return

    const routeSeo = dataPayload.platform.seo[routeKey]
    const globalOgImage = dataPayload.platform.ogImage
    const globalSiteName = dataPayload.platform.siteName
    const globalSiteUrl = dataPayload.platform.siteUrl

    if (routeSeo) {
      useCustomSeoMeta({
        title: routeSeo.title?.trim() || defaultOptions.title,
        description: routeSeo.description?.trim() || defaultOptions.description,
        path: defaultOptions.path || '',
        image: routeSeo.image?.trim() || globalOgImage || defaultOptions.image,
        noIndex: defaultOptions.noIndex,
      })
    }
  }

  // Fetch settings from API on mount or use cached state
  onMounted(async () => {
    // If state is already loaded
    if (settingsState.value) {
      applySettings(settingsState.value)
      return
    }

    // Try offline cache from localStorage
    if (import.meta.client) {
      const savedConfig = localStorage.getItem('admin_platform_config')
      if (savedConfig) {
        try {
          const parsed = JSON.parse(savedConfig)
          if (parsed) {
            settingsState.value = parsed
            applySettings(parsed)
          }
        } catch {}
      }
    }

    try {
      const res = await api.action.$post({
        json: { action: 'settings/get-all' }
      })
      const result: any = await res.json()
      if (res.ok && result.code === 1 && result.data) {
        let dataPayload = result.data
        if (result.encrypted && typeof result.data === 'string') {
          dataPayload = decryptData(result.data) || {}
        }
        settingsState.value = dataPayload
        applySettings(dataPayload)
      }
    } catch (err) {
      // Silently fall back to default options on error
    }
  })
}
