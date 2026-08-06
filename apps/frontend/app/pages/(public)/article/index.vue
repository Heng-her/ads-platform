<script setup lang="ts">
import { ref, computed, watch, onMounted, onUnmounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import type { InferResponseType } from '@ads-platform/shared'
import { useApi } from '~/composables/useApi'
import { useCategories } from '~/composables/useCategories'
import { useCustomSeoMeta } from '~/lib/seo/metadata'
import { getArticleUrl } from '~/lib/utils'
import type { CampaignItem } from '~/types/campaign'

definePageMeta({
    layout: 'public'
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

// ---- Query state, driven entirely by the URL ----
const page = ref(1)
// Public article feed loads three campaigns at a time. The next page is only
// requested after the user scrolls to the end of the current response.
const limit = ref(3)

const searchQuery = computed(() => (route.query.search as string) || '')
const selectedCategory = computed(() => (route.query.category as string) || '')
const selectedContentType = computed(() => (route.query.contentType as string) || '')
const selectedCustomCategoryId = computed(() => (route.query.customCategoryId as string) || '')

// ---- Local UI state ----
const sortBy = ref<'newest' | 'impressions' | 'viewers'>('newest')
const feedbackGiven = ref<null | boolean>(null)
const copiedId = ref<string | null>(null)

// ---- Available Content Types list ----
const contentTypes = ['ARTICLE', 'BANNER', 'VIDEO', 'SPONSORED', 'NATIVE']

// ---- Data state ----
const campaigns = ref<CampaignItem[]>([])
const isLoading = ref(false)
const isLoadingMore = ref(false)
const hasMore = ref(true)
const totalCount = ref(0)
const totalPages = ref(0)
const errorMessage = ref('')

let sentinelObserver: IntersectionObserver | null = null


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
    const list = [...campaigns.value]
    if (sortBy.value === 'impressions') return list.sort((a, b) => (b.totalImpressions ?? 0) - (a.totalImpressions ?? 0))
    if (sortBy.value === 'viewers') return list.sort((a, b) => (b.uniqueViewers ?? 0) - (a.uniqueViewers ?? 0))
    return list.sort((a, b) => new Date(b.createdAt).getTime() - new Date(a.createdAt).getTime())
})

// Sponsored Ads filtering for the right sidebar
const sponsoredAds = computed(() => {
    return campaigns.value.filter(c => c.contentType === 'SPONSORED' || c.adNetwork || c.adUnitCode)
})

// First item becomes the "Spotlight Answer" box, rest are standard search results
const featured = computed(() => sortedCampaigns.value[0] || null)
const restResults = computed(() => sortedCampaigns.value.slice(1))

// Secondary item for Trending Spotlight card in right rail
const trendingItem = computed(() => sortedCampaigns.value[1] || sortedCampaigns.value[0] || null)

// Related topics: category counts across loaded data
const relatedTopics = computed(() => {
    const counts: Record<string, number> = {}
    for (const c of campaigns.value) {
        const key = c.category || 'General'
        if (key === selectedCategory.value) continue
        counts[key] = (counts[key] || 0) + 1
    }
    return Object.entries(counts).sort((a, b) => b[1] - a[1]).slice(0, 6).map(([name]) => name)
})

const activeFilterCount = computed(() => {
    let count = 0
    if (searchQuery.value) count++
    if (selectedCategory.value) count++
    if (selectedContentType.value) count++
    if (selectedCustomCategoryId.value) count++
    return count
})

function setQuery(patch: Record<string, string | undefined>) {
    router.push({ path: route.path, query: { ...route.query, ...patch } })
}

function clearAllFilters() {
    router.push({ path: route.path, query: {} })
}

function giveFeedback(value: boolean) {
    feedbackGiven.value = value
}

let fetchGeneration = 0

async function fetchCampaigns(targetPage: number, isAppend = false) {
    const myGeneration = ++fetchGeneration

    isLoading.value = true
    if (isAppend) isLoadingMore.value = true
    errorMessage.value = ''

    const queryObj: Record<string, string> = {
        page: targetPage.toString(),
        limit: limit.value.toString(),
    }

    if (selectedCategory.value) queryObj.category = selectedCategory.value
    if (selectedContentType.value) queryObj.contentType = selectedContentType.value
    if (selectedCustomCategoryId.value) queryObj.customCategoryId = selectedCustomCategoryId.value
    if (searchQuery.value.trim()) queryObj.search = searchQuery.value.trim()

    try {
        const res = await api.action.$post({
            json: {
                action: 'campaigns/list',
                data: queryObj
            }
        })
        const json = await res.json()

        if (myGeneration !== fetchGeneration) return

        if (json.code !== 1) throw new Error(json.msg || 'Failed to load campaigns')

        const newItems = json.data?.items || []
        const pagination = json.data?.pagination

        campaigns.value = isAppend ? [...campaigns.value, ...newItems] : newItems
        page.value = targetPage

        if (pagination) {
            totalCount.value = pagination.total ?? campaigns.value.length
            totalPages.value = pagination.totalPages ?? 0
            hasMore.value = Boolean(pagination.hasNextPage)
        } else {
            totalCount.value = campaigns.value.length
            hasMore.value = newItems.length === limit.value
        }
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
    fetchCampaigns(1, false)
}

const sentinel = ref<HTMLElement | null>(null)
const sentinelIsVisible = ref(false)
const userScrolledSinceLastPage = ref(false)

function loadNextPage() {
    if (!userScrolledSinceLastPage.value || isLoading.value || !hasMore.value) return
    userScrolledSinceLastPage.value = false
    fetchCampaigns(page.value + 1, true)
}

function handleWindowScroll() {
    userScrolledSinceLastPage.value = true
    if (sentinelIsVisible.value) loadNextPage()
}

// Fetch initial campaigns and categories immediately when page setup runs
fetchCampaigns(1, false)
fetchCategories()

onMounted(() => {
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
})

// React to changes in route parameters
watch([searchQuery, selectedCategory, selectedContentType, selectedCustomCategoryId], () => {
    hasMore.value = true
    userScrolledSinceLastPage.value = false
    fetchCampaigns(1, false)
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
                            total results</span>
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
            <aside class="hidden lg:flex lg:flex-col lg:w-[280px] shrink-0 gap-5 sticky top-20">
                <PublicSponsoredAds :sponsored-ads="sponsoredAds" />
                <PublicTrendingWidget :item="trendingItem" />
                <PublicRelatedTopics :topics="relatedTopics" @select-topic="(t) => setQuery({ category: t })" />
                <PublicFeedbackWidget :feedback-given="feedbackGiven" @give-feedback="giveFeedback" />
            </aside>
        </div>
    </div>
</template>

<style scoped>
.no-scrollbar::-webkit-scrollbar {
    display: none;
}

.no-scrollbar {
    -ms-overflow-style: none;
    scrollbar-width: none;
}
</style>
