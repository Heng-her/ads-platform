import { useRuntimeConfig, useAsyncData } from '#imports'

export interface PublicAdConfig {
  googleAdsense: {
    enabled: boolean
    publisherId: string
    autoAds: boolean
    slots: {
      header: string
      articleTop: string
      inArticle: string
      sidebar: string
      articleSidebar: string
      categoryFeed: string
      [key: string]: string
    }
  }
  adsterra: {
    enabled: boolean
    smartlinkEnabled: boolean
    smartlinkUrl: string
    slots: {
      banner728x90: string
      nativeBanner: string
      [key: string]: string
    }
  }
}

const DEFAULT_CONFIG: PublicAdConfig = {
  googleAdsense: {
    enabled: false,
    publisherId: '',
    autoAds: false,
    slots: {
      header: '',
      articleTop: '',
      inArticle: '',
      sidebar: '',
      articleSidebar: '',
      categoryFeed: ''
    }
  },
  adsterra: {
    enabled: true,
    smartlinkEnabled: true,
    smartlinkUrl: 'https://ironcomparable.com/gh6u2ftq6?key=a3904ecfe67c81deb37177a2588649a9',
    slots: {
      banner728x90: '',
      nativeBanner: ''
    }
  }
}

export function usePublicAdConfig() {
  const runtimeConfig = useRuntimeConfig()

  const { data: configData, pending: isLoading, error } = useAsyncData<PublicAdConfig>(
    'public-ad-config',
    async () => {
      try {
        const response = await $fetch.raw<any>(`${runtimeConfig.public.apiBase}/monetization/config`)
        const json = response._data
        if (response.ok && json.code === 1 && json.data) {
          return json.data as PublicAdConfig
        }
      } catch (e) {
        console.warn('Failed to fetch public ad config from backend, using default fallback:', e)
      }
      return DEFAULT_CONFIG
    },
    {
      lazy: false,
      server: true,
      default: () => DEFAULT_CONFIG
    }
  )

  return {
    adConfig: configData,
    isLoading,
    error
  }
}
