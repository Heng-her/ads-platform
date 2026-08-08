<script setup lang="ts">
import { ref, computed, watch, onMounted, onUnmounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { useApi } from '~/composables/useApi'
import { useCategories } from '~/composables/useCategories'
import { useCustomSeoMeta } from '~/lib/seo/metadata'
import {
    countActiveFilters,
    getArticleUrl,
    getRelatedTopics,
    getSponsoredCampaigns,
    sortCampaigns,
} from '~/lib/utils'
import type { CampaignItem } from '~/types/campaign'

definePageMeta({
    layout: 'public',
    fullWidth: true
})

useCustomSeoMeta({
    title: 'Explore Articles & Campaigns',
    description: 'Discover featured articles, product updates, and ad campaigns on Signal Platform.',
    path: '/article'
})

const route = useRoute()
const router = useRouter()
const api = useApi()
const { categories, fetchCategories } = useCategories()

const feedLimit = 3
const feedStoragePrefix = 'signal:article-feed:v1'

const searchQuery = computed(() => (route.query.search as string) || '')
const selectedCategory = computed(() => (route.query.category as string) || '')
const selectedContentType = computed(() => (route.query.contentType as string) || '')
const selectedCustomCategoryId = computed(() => (route.query.customCategoryId as string) || '')

// ---- Local UI state ----
const sortBy = ref<'newest' | 'impressions' | 'viewers'>('newest')
const feedbackGiven = ref<null | boolean>(null)
const copiedId = ref<string | null>(null)

// ---- Data state ----
const campaigns = ref<CampaignItem[]>([])
const isLoading = ref(false)
const isLoadingMore = ref(false)
const hasMore = ref(true)
const totalCount = ref(0)
const errorMessage = ref('')
const nextCursor = ref<string | null>(null)
const snapshotAt = ref<string | null>(null)
const newCampaignCount = ref(0)

let sentinelObserver: IntersectionObserver | null = null
let newCampaignPollTimer: ReturnType<typeof setInterval> | null = null

type FeedFilters = {
    category: string
    contentType: string
    customCategoryId: string
    search: string
}

type StoredFeed = {
    filters: FeedFilters
    items: CampaignItem[]
    nextCursor: string | null
    snapshotAt: string
    hasMore: boolean
}


function copyCampaignLink(campaign: CampaignItem) {
    const url = `${window.location.origin}${getArticleUrl(campaign)}`
    navigator.clipboard.writeText(url).then(() => {
        copiedId.value = campaign.id
        setTimeout(() => {
            if (copiedId.value === campaign.id) copiedId.value = null
        }, 2000)
    })
}

// Client-side sort — cheap reordering of fetched campaigns
const sortedCampaigns = computed(() => {
    return sortCampaigns(campaigns.value, sortBy.value)
})

// Sponsored Ads filtering for the right sidebar
const sponsoredAds = computed(() => {
    return getSponsoredCampaigns(campaigns.value)
})

// First item becomes the "Spotlight Answer" box, rest are standard search results
const featured = computed(() => sortedCampaigns.value[0] || null)
const restResults = computed(() => sortedCampaigns.value.slice(1))

// Secondary item for Trending Spotlight card in right rail
const trendingItem = computed(() => sortedCampaigns.value[1] || sortedCampaigns.value[0] || null)

// Related topics: category counts across loaded data
const relatedTopics = computed(() => {
    return getRelatedTopics(campaigns.value, selectedCategory.value)
})

const activeFilterCount = computed(() => countActiveFilters([
    searchQuery.value,
    selectedCategory.value,
    selectedContentType.value,
    selectedCustomCategoryId.value,
]))

const feedFilters = computed<FeedFilters>(() => ({
    category: selectedCategory.value,
    contentType: selectedContentType.value,
    customCategoryId: selectedCustomCategoryId.value,
    search: searchQuery.value,
}))

const feedStorageKey = computed(() => `${feedStoragePrefix}:${encodeURIComponent(JSON.stringify(feedFilters.value))}`)

function setQuery(patch: Record<string, string | undefined>) {
    router.push({ path: route.path, query: { ...route.query, ...patch } })
}

function clearAllFilters() {
    router.push({ path: route.path, query: {} })
}

function giveFeedback(value: boolean) {
    feedbackGiven.value = value
}

function buildFeedQuery(cursor?: string, stableSnapshotAt?: string) {
    const query: Record<string, string> = {
        limit: feedLimit.toString(),
    }

    if (selectedCategory.value) query.category = selectedCategory.value
    if (selectedContentType.value) query.contentType = selectedContentType.value
    if (selectedCustomCategoryId.value) query.customCategoryId = selectedCustomCategoryId.value
    if (searchQuery.value) query.search = searchQuery.value
    if (cursor) query.cursor = cursor
    if (stableSnapshotAt) query.snapshotAt = stableSnapshotAt

    return query
}

function deduplicateCampaigns(items: CampaignItem[]) {
    const campaignIds = new Set<string>()
    return items.filter((campaign) => {
        if (campaignIds.has(campaign.id)) return false
        campaignIds.add(campaign.id)
        return true
    })
}

function persistFeed() {
    if (typeof window === 'undefined' || !snapshotAt.value) return

    const state: StoredFeed = {
        filters: feedFilters.value,
        items: campaigns.value,
        nextCursor: nextCursor.value,
        snapshotAt: snapshotAt.value,
        hasMore: hasMore.value,
    }
    window.sessionStorage.setItem(feedStorageKey.value, JSON.stringify(state))
}

function restoreFeed() {
    if (typeof window === 'undefined') return false

    const rawState = window.sessionStorage.getItem(feedStorageKey.value)
    if (!rawState) return false

    try {
        const state = JSON.parse(rawState) as StoredFeed
        if (
            !state.snapshotAt ||
            JSON.stringify(state.filters) !== JSON.stringify(feedFilters.value) ||
            !Array.isArray(state.items)
        ) {
            return false
        }

        campaigns.value = deduplicateCampaigns(state.items)
        nextCursor.value = state.nextCursor || null
        snapshotAt.value = state.snapshotAt
        hasMore.value = Boolean(state.hasMore)
        totalCount.value = campaigns.value.length
        return true
    } catch {
        window.sessionStorage.removeItem(feedStorageKey.value)
        return false
    }
}

function clearFeedState() {
    if (typeof window !== 'undefined') window.sessionStorage.removeItem(feedStorageKey.value)
    campaigns.value = []
    nextCursor.value = null
    snapshotAt.value = null
    hasMore.value = true
    totalCount.value = 0
    newCampaignCount.value = 0
}

let fetchGeneration = 0

async function fetchCampaigns(isAppend = false) {
    if (isAppend && (!nextCursor.value || !snapshotAt.value)) return

    const myGeneration = ++fetchGeneration

    isLoading.value = true
    if (isAppend) isLoadingMore.value = true
    errorMessage.value = ''

    try {
        const res = await api.campaigns.$get({
            query: buildFeedQuery(
                isAppend ? nextCursor.value || undefined : undefined,
                isAppend ? snapshotAt.value || undefined : undefined,
            )
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
        const activeSnapshotAt = snapshotAt.value
        const query = { ...buildFeedQuery(), snapshotAt: activeSnapshotAt }
        const response = await api.campaigns['new-count'].$get({ query })
        const json = await response.json()
        if (response.ok && json.code === 1) {
            newCampaignCount.value = json.data?.count || 0
        }
    } catch {
        // New campaign polling should never interrupt the active feed.
    }
}

const sentinel = ref<HTMLElement | null>(null)
const sentinelIsVisible = ref(false)
const userScrolledSinceLastPage = ref(false)

function loadNextPage() {
    if (!userScrolledSinceLastPage.value || isLoading.value || !hasMore.value) return
    userScrolledSinceLastPage.value = false
    fetchCampaigns(true)
}

function handleWindowScroll() {
    userScrolledSinceLastPage.value = true
    if (sentinelIsVisible.value) loadNextPage()
}

fetchCategories()

onMounted(() => {
    if (!restoreFeed()) startNewFeed()
    checkNewCampaigns()
    newCampaignPollTimer = setInterval(checkNewCampaigns, 30000)
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

// React to changes in route parameters
watch([searchQuery, selectedCategory, selectedContentType, selectedCustomCategoryId], () => {
    userScrolledSinceLastPage.value = false
    startNewFeed()
})

// If the user reaches the end while a request is finishing, complete the
// scroll-triggered request once loading ends. Visibility alone is not enough.
watch([isLoading, sentinelIsVisible, hasMore], ([loading, isVisible, more]) => {
    if (!loading && isVisible && more && userScrolledSinceLastPage.value) {
        loadNextPage()
    }
})
</script>

<template>
    <div class="pb-12 pt-2 font-body text-foreground">
        <!-- Mobile Filter Chips (Horizontal Scroll on Mobile) -->
        <div class="lg:hidden flex gap-2 overflow-x-auto pb-3 mb-3 no-scrollbar -mx-1 px-1">
            <button class="shrink-0 text-xs px-3.5 py-1.5 rounded-full transition-all"
                :class="!selectedCategory
                    ? 'bg-primary text-white dark:text-gray-950 font-bold'
                    : 'bg-gray-100 dark:bg-gray-800 border border-gray-200 dark:border-gray-700 text-gray-600 dark:text-gray-300'" @click="setQuery({ category: undefined })">
                All Categories
            </button>
            <button v-for="cat in categories" :key="cat.name"
                class="shrink-0 text-xs px-3.5 py-1.5 rounded-full transition-all"
                :class="selectedCategory === cat.name
                    ? 'bg-primary text-white dark:text-gray-950 font-bold'
                    : 'bg-gray-100 dark:bg-gray-800 border border-gray-200 dark:border-gray-700 text-gray-600 dark:text-gray-300'" @click="setQuery({ category: cat.name })">
                {{ cat.name }}
            </button>
        </div>

        <div class="flex gap-6 items-start">

            <!-- ================= LEFT RAIL: FILTERS & NAVIGATION (Desktop Sticky) ================= -->
            <PublicFilterSidebar :categories="categories" :selected-category="selectedCategory"
                :active-filter-count="activeFilterCount" @select-category="(cat) => setQuery({ category: cat })"
                @reset-filters="clearAllFilters" />

            <!-- ================= CENTER SECTION: SPOTLIGHT + RESULTS ================= -->
            <section class="flex-1 min-w-0 flex flex-col gap-6">

                <button v-if="newCampaignCount > 0" type="button" @click="startNewFeed"
                    class="w-full rounded-xl border border-primary/30 bg-primary-50 px-4 py-3 text-sm font-semibold text-primary transition-colors hover:bg-primary-100 dark:bg-primary-950/30 dark:hover:bg-primary-950/50">
                    {{ newCampaignCount }} new campaign{{ newCampaignCount === 1 ? '' : 's' }} available. Refresh feed
                </button>

                <!-- Active Filter Tags Bar -->
                <div v-if="activeFilterCount > 0"
                    class="flex flex-wrap items-center gap-2 p-3 rounded-2xl border bg-white dark:bg-gray-900 border-gray-200 dark:border-gray-800 shadow-sm">
                    <span class="text-[11px] text-gray-500 dark:text-gray-400 font-semibold">Active
                        Filters:</span>

                    <span v-if="searchQuery"
                        class="inline-flex items-center gap-1.5 px-3 py-1 rounded-xl text-xs bg-white dark:bg-gray-900 border border-gray-200 dark:border-gray-800 text-gray-900 dark:text-gray-100 font-semibold shadow-sm">
                        Search: "{{ searchQuery }}"
                        <button @click="setQuery({ search: undefined })"
                            class="text-gray-400 hover:text-gray-900 dark:hover:text-white transition-colors">
                            <UIcon name="i-heroicons-x-mark" class="w-3.5 h-3.5" />
                        </button>
                    </span>

                    <span v-if="selectedCategory"
                        class="inline-flex items-center gap-1.5 px-3 py-1 rounded-xl text-xs bg-white dark:bg-gray-900 border border-gray-200 dark:border-gray-800 text-gray-900 dark:text-gray-100 font-semibold shadow-sm">
                        Category: {{ selectedCategory }}
                        <button @click="setQuery({ category: undefined })"
                            class="text-gray-400 hover:text-gray-900 dark:hover:text-white transition-colors">
                            <UIcon name="i-heroicons-x-mark" class="w-3.5 h-3.5" />
                        </button>
                    </span>

                    <span v-if="selectedContentType"
                        class="inline-flex items-center gap-1.5 px-3 py-1 rounded-xl text-xs bg-white dark:bg-gray-900 border border-gray-200 dark:border-gray-800 text-gray-900 dark:text-gray-100 font-semibold shadow-sm">
                        Type: {{ selectedContentType }}
                        <button @click="setQuery({ contentType: undefined })"
                            class="text-gray-400 hover:text-gray-900 dark:hover:text-white transition-colors">
                            <UIcon name="i-heroicons-x-mark" class="w-3.5 h-3.5" />
                        </button>
                    </span>

                    <button @click="clearAllFilters"
                        class="ml-auto inline-flex items-center gap-1.5 px-3 py-1.5 rounded-xl text-xs font-bold text-red-600 dark:text-red-400 bg-red-50 dark:bg-red-950/40 hover:bg-red-100 dark:hover:bg-red-900/60 border border-red-200 dark:border-red-800/80 transition-all cursor-pointer group shadow-sm"
                        title="Clear all filters">
                        <UIcon name="i-heroicons-x-mark"
                            class="w-5 h-5 group-hover:scale-110 transition-transform" />
                    </button>
                </div>

                <!-- Error State -->
                <div v-if="errorMessage && !campaigns.length"
                    class="rounded-2xl p-8 flex flex-col items-center text-center gap-3 border shadow-xl bg-white dark:bg-gray-900 border-red-200 dark:border-red-900/50">
                    <p class="text-sm text-red-500 font-medium">{{ errorMessage }}</p>
                    <UButton @click="retry" color="primary" size="xs" font-semibold>
                        Try again
                    </UButton>
                </div>

                <!-- Initial Loading Skeletons -->
                <template v-else-if="isLoading && !campaigns.length">
                    <div
                        class="rounded-2xl p-6 border animate-pulse space-y-4 bg-white dark:bg-gray-900 border-gray-200 dark:border-gray-800">
                        <div class="flex items-center gap-3">
                            <div class="h-8 w-8 rounded-xl bg-gray-200 dark:bg-gray-800"></div>
                            <div class="h-4 w-32 rounded bg-gray-200 dark:bg-gray-800"></div>
                        </div>
                        <div class="h-6 w-3/4 rounded bg-gray-200 dark:bg-gray-800"></div>
                        <div class="h-4 w-full rounded bg-gray-200 dark:bg-gray-800"></div>
                        <div class="h-4 w-5/6 rounded bg-gray-200 dark:bg-gray-800"></div>
                    </div>
                    <div v-for="n in 3" :key="n"
                        class="rounded-2xl p-5 border animate-pulse flex gap-4 bg-white dark:bg-gray-900 border-gray-200 dark:border-gray-800">
                        <div class="flex-1 space-y-2">
                            <div class="h-3 w-28 rounded bg-gray-200 dark:bg-gray-800"></div>
                            <div class="h-4 w-2/3 rounded bg-gray-200 dark:bg-gray-800"></div>
                            <div class="h-3 w-full rounded bg-gray-200 dark:bg-gray-800"></div>
                        </div>
                        <div class="h-16 w-16 rounded-xl bg-gray-200 dark:bg-gray-800 shrink-0"></div>
                    </div>
                </template>

                <!-- Empty State -->
                <div v-else-if="!campaigns.length"
                    class="rounded-2xl p-12 flex flex-col items-center text-center gap-3 border border-dashed bg-white dark:bg-gray-900 border-gray-200 dark:border-gray-800">
                    <div
                        class="h-12 w-12 rounded-2xl flex items-center justify-center bg-gray-100 dark:bg-gray-800 text-gray-500">
                        <UIcon name="i-heroicons-magnifying-glass" class="w-6 h-6 text-primary" />
                    </div>
                    <p class="font-bold text-base text-gray-900 dark:text-white">No campaigns match your
                        search query</p>
                    <p class="text-xs font-medium text-gray-600 dark:text-gray-400 max-w-sm">Try adjusting your filters,
                        category
                        parameters, or keyword terms.</p>
                    <UButton @click="clearAllFilters" color="neutral" variant="subtle" size="xs">
                        Reset Filters
                    </UButton>
                </div>

                <template v-else>
                    <!-- ================= SPOTLIGHT CARD ================= -->
                    <PublicSpotlightCard :campaign="featured" :copied-id="copiedId" @copy-link="copyCampaignLink" />

                    <!-- ORGANIC RESULTS HEADER -->
                    <div class="flex items-center justify-between pt-2">
                        <h4
                            class="text-xs uppercase tracking-wider font-bold text-gray-600 dark:text-gray-300">
                            CAMPAIGN SEARCH RESULTS
                        </h4>
                        <span class="text-xs font-medium text-gray-500 dark:text-gray-400">{{ totalCount }}
                            loaded</span>
                    </div>

                    <!-- RESULT ROWS -->
                    <PublicCampaignCard v-for="c in restResults" :key="c.id" :campaign="c" />

                    <!-- Infinite Scroll / Pagination Controls -->
                    <div v-if="isLoadingMore" class="flex justify-center py-4">
                        <span class="text-xs font-semibold text-primary flex items-center gap-2">
                            <UIcon name="i-lucide-loader-2" class="w-4 h-4 animate-spin text-primary" />
                            Loading more campaigns…
                        </span>
                    </div>
                </template>

                <div ref="sentinel" class="h-2 w-full" />
            </section>

            <!-- ================= RIGHT RAIL: ADS & SPONSORED CAMPAIGNS (Desktop Sticky) ================= -->
            <aside class="hidden lg:flex lg:flex-col lg:w-[350px] shrink-0 gap-5 sticky top-20">
                <PublicSponsoredAds :sponsored-ads="sponsoredAds" />
                <PublicTrendingWidget :item="trendingItem" />
                <PublicRelatedTopics :topics="relatedTopics" @select-topic="(t) => setQuery({ category: t })" />
                <PublicFeedbackWidget :feedback-given="feedbackGiven" @give-feedback="giveFeedback" />
            </aside>
        </div>
    </div>
</template>
