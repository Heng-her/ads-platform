<script setup lang="ts">
import { ref, computed, watch, watchEffect } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { useApi } from '~/composables/useApi'
import { useCategories } from '~/composables/useCategories'
import { useCustomSeoMeta, useArticleSeo } from '~/lib/seo/metadata'
import { getVideoEmbedUrl } from '~/lib/videoEmbed'
import { useClipboard } from '~/composables/useClipboard'
import { extractIdFromSlug, getArticleUrl, timeAgo, formatDate, initials } from '~/lib/utils'
import type { CampaignItem } from '~/types/campaign'

definePageMeta({
    layout: 'public',
    fullWidth: true
})

const route = useRoute()
const router = useRouter()
const api = useApi()
const runtimeConfig = useRuntimeConfig()
const { categories } = useCategories()
const { isCopied: copied, copy } = useClipboard()

const slug = computed(() => (route.params.slug as string) || '')

const renderedContent = computed(() => {
    return campaign.value?.content || campaign.value?.description || ''
})

const { data: campaign, pending: isLoading, error: asyncError } = await useAsyncData(
    () => `campaign-${slug.value}`,
    async () => {
        if (!slug.value) return null
        const targetId = extractIdFromSlug(slug.value)
        const response = await $fetch.raw<any>(`${runtimeConfig.public.apiBase}/campaigns/${targetId}`)
        const json = response._data
        if (response.ok && json.code === 1 && json.data) {
            return json.data
        }
        throw new Error(json.msg || `Campaign with ID "${slug.value}" was not found.`)
    },
    { watch: [slug] }
)

const errorMessage = computed(() => {
    if (asyncError.value) {
        return (asyncError.value as any)?.message || `Campaign "${slug.value}" was not found or is restricted.`
    }
    return ''
})

const feedbackGiven = ref<boolean | null>(null)
const isShareModalOpen = ref(false)
const relatedCampaigns = ref<CampaignItem[]>([])
const relatedPage = ref(1)
const relatedHasMore = ref(false)
const isLoadingRelated = ref(false)

// SEO Metadata and Structured Data (JSON-LD) for Search Engines & Social Cards
watchEffect(() => {
    if (campaign.value) {
        useArticleSeo(campaign.value)
    } else {
        useCustomSeoMeta({
            title: 'Article Details',
            description: 'Explore detailed campaign and article metrics on Signal Platform.',
            path: `/article/${slug.value}`
        })
    }
})

function copyLink() {
    if (!campaign.value || typeof window === 'undefined') return
    const fullUrl = `${window.location.origin}${getArticleUrl(campaign.value)}`
    copy(fullUrl)
}

function giveFeedback(val: boolean) {
    feedbackGiven.value = val
}

const galleryImages = computed(() => {
    if (!campaign.value) return []
    const images = [campaign.value.imageUrl, ...(campaign.value.images || []).map((image: any) => image.url)]
    return [...new Set(images.filter(Boolean))] as string[]
})

async function loadRelatedCampaigns(targetPage = 1, append = false) {
    if (!campaign.value?.category) return
    isLoadingRelated.value = true
    try {
        const response = await api.action.$post({
            json: { action: 'campaigns/list', data: { category: campaign.value.category, page: targetPage, limit: 3 } }
        })
        const json: any = await response.json()
        if (json.code !== 1) throw new Error(json.msg || 'Failed to load related campaigns')
        const items = (json.data?.items || []).filter((item: CampaignItem) => item.id !== campaign.value?.id)
        relatedCampaigns.value = append ? [...relatedCampaigns.value, ...items] : items
        relatedPage.value = targetPage
        relatedHasMore.value = Boolean(json.data?.pagination?.hasNextPage)
    } finally {
        isLoadingRelated.value = false
    }
}

watch(campaign, (currentCampaign) => {
    relatedCampaigns.value = []
    relatedPage.value = 1
    relatedHasMore.value = false
    if (currentCampaign) loadRelatedCampaigns()
}, { immediate: true })

</script>

<template>
    <div class="py-6 w-full font-body text-foreground">

        <!-- Breadcrumb & Back Button -->
        <div class="flex items-center justify-between mb-6">
            <NuxtLink to="/article"
                class="inline-flex items-center gap-2 text-xs font-mono font-semibold text-gray-600 dark:text-gray-300 hover:text-primary transition-colors">
                <UIcon name="i-heroicons-arrow-left" class="w-6 h-6" />
            </NuxtLink>

            <div v-if="campaign"
                class="flex items-center gap-2 text-xs font-mono font-semibold text-gray-600 dark:text-gray-300">
                <span>Category:</span>
                <NuxtLink :to="`/article?category=${encodeURIComponent(campaign.category || '')}`"
                    class="text-primary hover:underline font-bold">
                    {{ campaign.category || 'General' }}
                </NuxtLink>
            </div>
        </div>

        <!-- Loading Skeleton -->
        <div v-if="isLoading" class="space-y-6">
            <div
                class="rounded-2xl p-8 border animate-pulse space-y-4 bg-white dark:bg-gray-900 border-gray-200 dark:border-gray-800">
                <div class="h-4 w-32 rounded bg-gray-200 dark:bg-gray-800"></div>
                <div class="h-8 w-3/4 rounded bg-gray-200 dark:bg-gray-800"></div>
                <div class="h-4 w-48 rounded bg-gray-200 dark:bg-gray-800"></div>
            </div>
            <div class="h-64 rounded-2xl bg-gray-200 dark:bg-gray-800/50 animate-pulse"></div>
        </div>

        <!-- Error / Not Found State -->
        <div v-else-if="errorMessage || !campaign"
            class="rounded-2xl p-12 text-center border border-dashed flex flex-col items-center gap-3 bg-white dark:bg-gray-900 border-gray-200 dark:border-gray-800">
            <div
                class="h-12 w-12 rounded-2xl flex items-center justify-center bg-primary-50 dark:bg-primary-950/40 text-primary border border-primary/20">
                <UIcon name="i-heroicons-bolt" class="w-6 h-6 text-primary" />
            </div>
            <h2 class="font-display font-bold text-lg text-gray-900 dark:text-white">Campaign Not Found</h2>
            <p class="text-xs font-medium text-gray-600 dark:text-gray-300 max-w-sm">{{ errorMessage }}</p>
            <NuxtLink to="/article"
                class="mt-2 text-xs font-mono px-4 py-2 rounded-xl font-bold text-white bg-primary hover:bg-primary-600 transition-all">
                Return to Search & Discover
            </NuxtLink>
        </div>

        <!-- Main Content Grid -->
        <div v-else class="flex gap-6 items-start">
            <PublicFilterSidebar width-class="w-86" :categories="categories"
                :selected-category="campaign.category || ''" :active-filter-count="campaign.category ? 1 : 0"
                @select-category="(category) => router.push({ path: '/article', query: category ? { category } : {} })"
                @reset-filters="router.push('/article')">
                <template #bottom>
                    <AdBanner provider="google" slot-type="sidebar"
                        :campaign-id="campaign?.id"
                        :creator-id="campaign?.creatorId || campaign?.userId" />
                </template>
            </PublicFilterSidebar>
            <div class="min-w-0 flex-1 grid grid-cols-1 lg:grid-cols-12 gap-8 items-start">

                <!-- Center Main Column (Details & Article Content) -->
                <article class="lg:col-span-8 space-y-6">

                    <!-- Hero Header Card -->
                    <header
                        class="rounded-2xl p-6 sm:p-8 border shadow-xl relative overflow-hidden bg-white dark:bg-gray-900 border-gray-200 dark:border-gray-800">

                        <!-- Glow decoration -->
                        <div
                            class="absolute -top-12 -right-12 w-48 h-48 rounded-full bg-primary/10 blur-3xl pointer-events-none">
                        </div>

                        <!-- Campaign Title -->
                        <h1
                            class="font-display font-extrabold text-2xl sm:text-4xl text-gray-900 dark:text-white leading-tight mb-4 tracking-tight">
                            {{ campaign.title }}
                        </h1>

                        <!-- Author Metadata & Publication Info -->
                        <div
                            class="flex flex-wrap items-center justify-between gap-4 pt-4 border-t border-gray-200 dark:border-gray-800">
                            <div class="flex items-center gap-3">
                                <NuxtImg v-if="campaign.creator?.avatar" :src="campaign.creator.avatar"
                                    :alt="campaign.creator?.username || 'Creator avatar'" loading="lazy"
                                    class="h-8 w-8 rounded-full object-cover ring-2 ring-primary/40" />
                                <span v-else
                                    class="h-8 w-8 rounded-full flex items-center justify-center text-xs font-bold bg-primary-100 dark:bg-primary-950/60 text-primary ring-2 ring-primary/30">
                                    {{ initials(campaign.creator?.username) }}
                                </span>
                                <div>
                                    <div
                                        class="text-xs font-bold text-gray-900 dark:text-white flex items-center gap-1.5">
                                        {{ campaign.creator?.username || 'Verified Creator' }}
                                        <UIcon name="i-heroicons-check-circle" class="w-4 h-4 text-primary shrink-0"
                                            title="Verified Publisher" />
                                    </div>
                                    <div class="text-[11px] font-mono font-medium text-gray-600 dark:text-gray-400">
                                        Published {{ formatDate(campaign.createdAt) }} ({{ timeAgo(campaign.createdAt)
                                        }})
                                    </div>
                                </div>
                            </div>

                            <!-- Action Controls -->
                            <div class="flex items-center gap-2">
                                <UButton @click="isShareModalOpen = true" color="neutral" variant="outline" size="sm"
                                    icon="i-heroicons-share" class="font-mono font-bold cursor-pointer">
                                    Share / Copy Link
                                </UButton>
                            </div>
                        </div>
                    </header>

                    <!-- Mobile-Only High-Visibility Ad Banner (Right below Hero Header) -->
                    <div class="block lg:hidden my-4">
                        <AdBanner slot-type="in-article"
                            :campaign-id="campaign?.id"
                            :creator-id="campaign?.creatorId || campaign?.userId" />
                    </div>

                    <!-- Full media gallery -->
                    <section v-if="galleryImages.length || campaign.videoUrls?.length" class="space-y-3">
                        <div v-if="galleryImages.length" class="grid gap-3"
                            :class="galleryImages.length > 1 ? 'sm:grid-cols-2' : ''">
                            <figure v-for="(image, index) in galleryImages" :key="image"
                                class="overflow-hidden rounded-2xl border border-gray-200 bg-gray-100 shadow-sm dark:border-gray-800 dark:bg-gray-950">
                                <NuxtImg :src="image"
                                    :alt="index === 0 ? (campaign.imageTitle || campaign.title) : `${campaign.title} image ${index + 1}`"
                                    loading="lazy" class="h-full max-h-[480px] w-full object-cover" />
                                <figcaption v-if="index === 0 && (campaign.imageTitle || campaign.imageDescription)"
                                    class="border-t border-gray-200 bg-gray-50 p-3 text-xs font-medium text-gray-600 dark:border-gray-800 dark:bg-gray-900 dark:text-gray-300">
                                    <strong v-if="campaign.imageTitle" class="text-gray-900 dark:text-white">{{
                                        campaign.imageTitle }}: </strong>{{ campaign.imageDescription }}
                                </figcaption>
                            </figure>
                        </div>
                        <div v-if="campaign.videoUrls?.length" class="grid gap-3 sm:grid-cols-2">
                            <template v-for="videoUrl in campaign.videoUrls" :key="videoUrl">
                                <iframe v-if="getVideoEmbedUrl(videoUrl)" :src="getVideoEmbedUrl(videoUrl)"
                                    :title="`${campaign.title} video`"
                                    class="aspect-video w-full rounded-2xl border border-gray-200 bg-black shadow-sm dark:border-gray-800"
                                    allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share"
                                    allowfullscreen />
                                <video v-else :src="videoUrl" controls preload="metadata"
                                    class="w-full rounded-2xl border border-gray-200 bg-black shadow-sm dark:border-gray-800" />
                            </template>
                        </div>
                    </section>

                    <!-- Top Category Hero Sponsor Banner -->
                    <CategoryHeroAdBanner :category="campaign?.category" :campaign-id="campaign?.id" :creator-id="campaign?.creatorId || campaign?.userId" />

                    <!-- Main Content Body -->
                    <div
                        class="rounded-2xl p-6 sm:p-8 border leading-relaxed text-gray-800 dark:text-gray-200 font-body space-y-4 bg-white dark:bg-gray-900 border-gray-200 dark:border-gray-800">

                        <h3 class="font-display font-bold text-sm uppercase tracking-wider text-primary mb-2">
                            Campaign Overview
                        </h3>

                        <!-- Render Content / Description -->
                        <div v-if="renderedContent" v-html="renderedContent"
                            class="article-content prose dark:prose-invert max-w-none text-sm sm:text-base leading-relaxed font-medium text-gray-700 dark:text-gray-200">
                        </div>
                        <div v-else class="text-sm sm:text-base font-medium text-gray-700 dark:text-gray-200">
                            No detailed content provided for this campaign.
                        </div>
                    </div>

                    <!-- Interactive Feedback Widget -->
                    <PublicFeedbackWidget :feedback-given="feedbackGiven" @give-feedback="giveFeedback" />


                    <section v-if="campaign.category"
                        class="rounded-2xl border border-gray-200 bg-white p-5 dark:border-gray-800 dark:bg-gray-900">
                        <div class="mb-4 flex items-center justify-between gap-3">
                            <div>
                                <p class="text-xs font-semibold uppercase tracking-wider text-primary">More to explore
                                </p>
                                <h2 class="mt-1 font-display text-lg font-bold text-gray-900 dark:text-white">More {{
                                    campaign.category }}
                                    campaigns</h2>
                            </div>
                            <NuxtLink :to="`/article?category=${encodeURIComponent(campaign.category)}`"
                                class="text-xs font-semibold text-primary hover:underline">View category</NuxtLink>
                        </div>
                        <div v-if="relatedCampaigns.length" class="grid gap-3 sm:grid-cols-3">
                            <NuxtLink v-for="item in relatedCampaigns" :key="item.id" :to="getArticleUrl(item)"
                                class="group overflow-hidden rounded-xl border border-gray-200 dark:border-gray-800">
                                <NuxtImg v-if="item.imageUrl" :src="item.imageUrl" :alt="item.title" loading="lazy"
                                    class="h-24 w-full object-cover" />
                                <div v-else
                                    class="flex h-24 items-center justify-center bg-gray-100 text-gray-400 dark:bg-gray-800">
                                    <UIcon name="i-heroicons-photo" class="h-5 w-5" />
                                </div>
                                <p
                                    class="line-clamp-2 p-3 text-sm font-semibold text-gray-900 group-hover:text-primary dark:text-white">
                                    {{
                                        item.title }}</p>
                            </NuxtLink>
                        </div>
                        <p v-else-if="!isLoadingRelated" class="text-sm text-gray-500">No other campaigns in this
                            category yet.</p>
                        <div v-if="relatedHasMore" class="mt-4 text-center">
                            <UButton color="neutral" variant="outline" size="sm" :loading="isLoadingRelated"
                                @click="loadRelatedCampaigns(relatedPage + 1, true)">Load more {{ campaign.category }}
                                campaigns</UButton>
                        </div>
                    </section>
                </article>

                <!-- Right Sidebar Column (Ads & Category Link) -->
                <aside class="lg:col-span-4 space-y-6 sticky top-20">
                    <AdBanner provider="adsterra" slot-type="sidebar"
                        :campaign-id="campaign?.id"
                        :creator-id="campaign?.creatorId || campaign?.userId" />
                </aside>
            </div>
        </div>

        <!-- Social Share Modal -->
        <PublicShareModal v-model="isShareModalOpen" :article="campaign" />
    </div>
</template>

<style scoped>
.prose {
    color: var(--text);
}

.article-content :deep(img),
.article-content :deep(video) {
    max-width: 100%;
    height: auto;
    border-radius: 0.5rem;
    margin: 1rem 0;
}

.article-content :deep(a) {
    color: var(--color-primary-600);
    text-decoration: underline;
    font-weight: 600;
}

.article-content :deep(pre) {
    overflow-x: auto;
    border-radius: 0.5rem;
    padding: 1rem;
}
</style>
