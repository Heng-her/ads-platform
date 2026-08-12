<script setup lang="ts">
import { ref, computed } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { useCategories } from '~/composables/useCategories'
import { useArticleFeed } from '~/composables/useArticleFeed'
import { useClipboard } from '~/composables/useClipboard'
import { useCustomSeoMeta } from '~/lib/seo/metadata'
import { countActiveFilters, getArticleUrl } from '~/lib/utils'
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
const { categories } = useCategories()

const searchQuery = computed(() => (route.query.search as string) || '')
const selectedCategory = computed(() => (route.query.category as string) || '')
const selectedContentType = computed(() => (route.query.contentType as string) || '')
const selectedCustomCategoryId = computed(() => (route.query.customCategoryId as string) || '')

const feedbackGiven = ref<null | boolean>(null)

const activeFilterCount = computed(() => countActiveFilters([
    searchQuery.value,
    selectedCategory.value,
    selectedContentType.value,
    selectedCustomCategoryId.value,
]))

const feedFilters = computed(() => ({
    category: selectedCategory.value,
    contentType: selectedContentType.value,
    customCategoryId: selectedCustomCategoryId.value,
    search: searchQuery.value,
}))

const {
    campaigns,
    featured,
    restResults,
    trendingItem,
    relatedTopics,
    isLoading,
    isLoadingMore,
    totalCount,
    errorMessage,
    newCampaignCount,
    sentinel,
    retry,
    startNewFeed,
} = useArticleFeed({ filters: feedFilters })

const { copiedId, copy } = useClipboard()

function copyCampaignLink(campaign: CampaignItem) {
    if (typeof window === 'undefined') return
    const url = `${window.location.origin}${getArticleUrl(campaign)}`
    copy(url, campaign.id)
}

function setQuery(patch: Record<string, string | undefined>) {
    router.push({ path: route.path, query: { ...route.query, ...patch } })
}

function clearAllFilters() {
    router.push({ path: route.path, query: {} })
}

function giveFeedback(value: boolean) {
    feedbackGiven.value = value
}
</script>

<template>
    <div class="pb-12 pt-2 font-body text-foreground">
        <!-- Mobile Filter Chips & Active Filters Bar -->
        <ArticleActiveFilters
            :categories="categories"
            :selected-category="selectedCategory"
            :search-query="searchQuery"
            :selected-content-type="selectedContentType"
            :active-filter-count="activeFilterCount"
            @set-query="setQuery"
            @clear-all="clearAllFilters"
        />

        <div class="flex gap-6 items-start mt-3">

            <!-- ================= LEFT RAIL: FILTERS & NAVIGATION (Desktop Sticky) ================= -->
            <PublicFilterSidebar
                width-class="w-86"
                :categories="categories"
                :selected-category="selectedCategory"
                :active-filter-count="activeFilterCount"
                @select-category="(cat) => setQuery({ category: cat })"
                @reset-filters="clearAllFilters"
            >
                <template #bottom>
                    <AdBanner provider="google" slot-type="sidebar" />
                </template>
            </PublicFilterSidebar>

            <!-- ================= CENTER SECTION: SPOTLIGHT + RESULTS ================= -->
            <section class="flex-1 min-w-0 flex flex-col gap-6">

                <!-- New Campaign Feed Notification Banner -->
                <ArticleRefreshBanner :count="newCampaignCount" @refresh="startNewFeed" />

                <!-- Error State -->
                <div
                    v-if="errorMessage && !campaigns.length"
                    class="rounded-2xl p-8 flex flex-col items-center text-center gap-3 border shadow-xl bg-white dark:bg-gray-900 border-red-200 dark:border-red-900/50"
                >
                    <p class="text-sm text-red-500 font-medium">{{ errorMessage }}</p>
                    <UButton @click="retry" color="primary" size="xs" font-semibold>
                        Try again
                    </UButton>
                </div>

                <!-- Initial Loading Skeletons -->
                <ArticleFeedSkeleton v-else-if="isLoading && !campaigns.length" :count="3" />

                <!-- Empty State -->
                <ArticleEmptyFeed v-else-if="!campaigns.length" @clear-all="clearAllFilters" />

                <template v-else>
                    <!-- ================= SPOTLIGHT CARD ================= -->
                    <PublicSpotlightCard :campaign="featured" :copied-id="copiedId" @copy-link="copyCampaignLink" />

                    <!-- ORGANIC RESULTS HEADER -->
                    <div class="flex items-center justify-between pt-2">
                        <h4 class="text-xs uppercase tracking-wider font-bold text-gray-600 dark:text-gray-300">
                            CAMPAIGN SEARCH RESULTS
                        </h4>
                        <span class="text-xs font-medium text-gray-500 dark:text-gray-400">
                            {{ totalCount }} loaded
                        </span>
                    </div>

                    <!-- RESULT ROWS -->
                    <PublicCampaignCard v-for="c in restResults" :key="c.id" :campaign="c" />

                    <!-- Infinite Scroll Loading Spinner -->
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
                <AdBanner provider="adsterra" slot-type="sidebar" />

                <PublicTrendingWidget :item="trendingItem" />
                <PublicRelatedTopics :topics="relatedTopics" @select-topic="(t) => setQuery({ category: t })" />
                <PublicFeedbackWidget :feedback-given="feedbackGiven" @give-feedback="giveFeedback" />
            </aside>
        </div>
    </div>
</template>
