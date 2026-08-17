import { ref, computed, watch, onMounted, onUnmounted, type Ref } from 'vue'
import { useApi } from '~/composables/useApi'
import { getRelatedTopics, sortCampaigns, type CampaignSort } from '~/lib/utils'
import type { CampaignItem } from '~/types/campaign'

export interface FeedFilters {
  category: string
  contentType: string
  customCategoryId: string
  search: string
}

export interface StoredFeed {
  filters: FeedFilters
  items: CampaignItem[]
  nextCursor: string | null
  snapshotAt: string
  hasMore: boolean
}

export interface UseArticleFeedOptions {
  filters: Ref<FeedFilters>
  limit?: number
  storagePrefix?: string
  pollIntervalMs?: number
}

export function useArticleFeed(options: UseArticleFeedOptions) {
  const {
    filters,
    limit = 3,
    storagePrefix = 'signal:article-feed:v1',
    pollIntervalMs = 30000,
  } = options

  const api = useApi()

  // State
  const sortBy = ref<CampaignSort>('newest')
  const campaigns = ref<CampaignItem[]>([])
  const isLoading = ref(true)
  const isLoadingMore = ref(false)
  const hasMore = ref(true)
  const totalCount = ref(0)
  const errorMessage = ref('')
  const nextCursor = ref<string | null>(null)
  const snapshotAt = ref<string | null>(null)
  const newCampaignCount = ref(0)

  // Infinite Scroll Sentinel
  const sentinel = ref<HTMLElement | null>(null)
  const sentinelIsVisible = ref(false)
  const userScrolledSinceLastPage = ref(false)

  let sentinelObserver: IntersectionObserver | null = null
  let newCampaignPollTimer: ReturnType<typeof setInterval> | null = null
  let fetchGeneration = 0

  // Storage Key
  const storageKey = computed(() => `${storagePrefix}:${encodeURIComponent(JSON.stringify(filters.value))}`)

  // Computed views
  const sortedCampaigns = computed(() => sortCampaigns(campaigns.value, sortBy.value))
  const featured = computed(() => sortedCampaigns.value[0] || null)
  const restResults = computed(() => sortedCampaigns.value.slice(1))
  const trendingItem = computed(() => sortedCampaigns.value[1] || sortedCampaigns.value[0] || null)
  const relatedTopics = computed(() => getRelatedTopics(campaigns.value, filters.value.category))

  function buildQuery(cursor?: string, stableSnapshotAt?: string) {
    const query: Record<string, string> = {
      limit: limit.toString(),
    }
    if (filters.value.category) query.category = filters.value.category
    if (filters.value.contentType) query.contentType = filters.value.contentType
    if (filters.value.customCategoryId) query.customCategoryId = filters.value.customCategoryId
    if (filters.value.search) query.search = filters.value.search
    if (cursor) query.cursor = cursor
    if (stableSnapshotAt) query.snapshotAt = stableSnapshotAt

    return query
  }

  function deduplicateCampaigns(items: CampaignItem[]) {
    const ids = new Set<string>()
    return items.filter((item) => {
      if (ids.has(item.id)) return false
      ids.add(item.id)
      return true
    })
  }

  function persistFeed() {
    if (typeof window === 'undefined' || !snapshotAt.value) return
    const state: StoredFeed = {
      filters: filters.value,
      items: campaigns.value,
      nextCursor: nextCursor.value,
      snapshotAt: snapshotAt.value,
      hasMore: hasMore.value,
    }
    window.sessionStorage.setItem(storageKey.value, JSON.stringify(state))
  }

  function restoreFeed(): boolean {
    if (typeof window === 'undefined') return false
    const raw = window.sessionStorage.getItem(storageKey.value)
    if (!raw) return false

    try {
      const state = JSON.parse(raw) as StoredFeed
      if (
        !state.snapshotAt ||
        JSON.stringify(state.filters) !== JSON.stringify(filters.value) ||
        !Array.isArray(state.items)
      ) {
        return false
      }

      campaigns.value = deduplicateCampaigns(state.items)
      nextCursor.value = state.nextCursor || null
      snapshotAt.value = state.snapshotAt
      hasMore.value = Boolean(state.hasMore)
      totalCount.value = campaigns.value.length
      isLoading.value = false
      return true
    } catch {
      window.sessionStorage.removeItem(storageKey.value)
      return false
    }
  }

  function clearFeedState() {
    if (typeof window !== 'undefined') window.sessionStorage.removeItem(storageKey.value)
    campaigns.value = []
    nextCursor.value = null
    snapshotAt.value = null
    hasMore.value = true
    totalCount.value = 0
    newCampaignCount.value = 0
  }

  async function fetchCampaigns(isAppend = false) {
    if (isAppend && (!nextCursor.value || !snapshotAt.value)) return

    const myGeneration = ++fetchGeneration
    isLoading.value = true
    if (isAppend) isLoadingMore.value = true
    errorMessage.value = ''

    try {
      const res = await api.campaigns.$get({
        query: buildQuery(
          isAppend ? nextCursor.value || undefined : undefined,
          isAppend ? snapshotAt.value || undefined : undefined,
        ),
      })
      const json = await res.json()

      if (myGeneration !== fetchGeneration) return
      if (json.code !== 1) throw new Error(json.msg || 'Failed to load campaigns')

      const newItems = json.data?.items || []
      campaigns.value = deduplicateCampaigns(isAppend ? [...campaigns.value, ...newItems] : newItems)
      nextCursor.value = json.data?.nextCursor || null
      snapshotAt.value = json.data?.snapshotAt || snapshotAt.value
      hasMore.value = Boolean(json.data?.hasMore)
      totalCount.value = campaigns.value.length
      persistFeed()
      checkNewCampaigns()
    } catch (error: unknown) {
      if (myGeneration !== fetchGeneration) return
      const err = error as Error
      errorMessage.value = err?.message || 'Something went wrong loading campaigns.'
      if (!isAppend) {
        campaigns.value = []
        totalCount.value = 0
        hasMore.value = false
      }
    } finally {
      if (myGeneration === fetchGeneration) {
        isLoading.value = false
        isLoadingMore.value = false
      }
    }
  }

  function retry() {
    fetchCampaigns(false)
  }

  function startNewFeed() {
    fetchGeneration += 1
    clearFeedState()
    fetchCampaigns(false)
  }

  async function checkNewCampaigns() {
    if (!snapshotAt.value) return
    try {
      const query = { ...buildQuery(), snapshotAt: snapshotAt.value }
      const response = await api.campaigns['new-count'].$get({ query })
      const json = await response.json()
      if (response.ok && json.code === 1) {
        newCampaignCount.value = json.data?.count || 0
      }
    } catch {
      // Background polling fails silently
    }
  }

  function loadNextPage() {
    if (!userScrolledSinceLastPage.value || isLoading.value || !hasMore.value) return
    userScrolledSinceLastPage.value = false
    fetchCampaigns(true)
  }

  function handleWindowScroll() {
    userScrolledSinceLastPage.value = true
    if (sentinelIsVisible.value) loadNextPage()
  }

  onMounted(() => {
    if (!restoreFeed()) startNewFeed()
    checkNewCampaigns()
    newCampaignPollTimer = setInterval(checkNewCampaigns, pollIntervalMs)
    window.addEventListener('scroll', handleWindowScroll, { passive: true })

    if (typeof IntersectionObserver !== 'undefined' && sentinel.value) {
      sentinelObserver = new IntersectionObserver((entries) => {
        sentinelIsVisible.value = Boolean(entries[0]?.isIntersecting)
        if (sentinelIsVisible.value) loadNextPage()
      })
      sentinelObserver.observe(sentinel.value)
    }
  })

  onUnmounted(() => {
    window.removeEventListener('scroll', handleWindowScroll)
    sentinelObserver?.disconnect()
    if (newCampaignPollTimer) clearInterval(newCampaignPollTimer)
  })

  watch(filters, () => {
    userScrolledSinceLastPage.value = false
    startNewFeed()
  }, { deep: true })

  watch([isLoading, sentinelIsVisible, hasMore], ([loading, isVisible, more]) => {
    if (!loading && isVisible && more && userScrolledSinceLastPage.value) {
      loadNextPage()
    }
  })

  return {
    sortBy,
    campaigns,
    sortedCampaigns,
    featured,
    restResults,
    trendingItem,
    relatedTopics,
    isLoading,
    isLoadingMore,
    hasMore,
    totalCount,
    errorMessage,
    newCampaignCount,
    sentinel,
    fetchCampaigns,
    retry,
    startNewFeed,
  }
}
