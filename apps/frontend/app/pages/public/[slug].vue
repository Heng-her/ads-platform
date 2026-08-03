<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { useApi } from '~/composables/useApi'
import { useAuthStore } from '~/stores/auth'

definePageMeta({
    layout: 'public'
})

const route = useRoute()
const router = useRouter()
const api = useApi()
const authStore = useAuthStore()

const slug = computed(() => (route.params.slug as string) || '')

const campaign = ref<any>(null)
const isLoading = ref(true)
const errorMessage = ref('')
const copied = ref(false)
const feedbackGiven = ref<boolean | null>(null)

function timeAgo(iso: string) {
    if (!iso) return 'recently'
    const diffMs = Date.now() - new Date(iso).getTime()
    const mins = Math.floor(diffMs / 60000)
    if (mins < 1) return 'just now'
    if (mins < 60) return `${mins}m ago`
    const hours = Math.floor(mins / 60)
    if (hours < 24) return `${hours}h ago`
    const days = Math.floor(hours / 24)
    if (days < 30) return `${days}d ago`
    const months = Math.floor(days / 30)
    if (months < 12) return `${months}mo ago`
    return `${Math.floor(months / 12)}y ago`
}

function formatDate(iso: string) {
    if (!iso) return ''
    return new Date(iso).toLocaleDateString('en-US', {
        year: 'numeric',
        month: 'long',
        day: 'numeric'
    })
}

function initials(name: string) {
    if (!name) return '?'
    return name.trim().slice(0, 2).toUpperCase()
}

function copyLink() {
    navigator.clipboard.writeText(window.location.href).then(() => {
        copied.value = true
        setTimeout(() => {
            copied.value = false
        }, 2000)
    })
}

function giveFeedback(val: boolean) {
    feedbackGiven.value = val
}

async function fetchCampaign() {
    if (!slug.value) return
    isLoading.value = true
    errorMessage.value = ''
    authStore.initAuth()

    const config = useRuntimeConfig()
    const baseUrl = (config.public as any)?.apiBase || 'http://localhost:8787/api'
    const headers: Record<string, string> = {}
    if (authStore.token) {
        headers['Authorization'] = `Bearer ${authStore.token}`
    }

    try {
        const response = await fetch(`${baseUrl}/campaigns/${encodeURIComponent(slug.value)}`, { headers })
        const json: any = await response.json()

        if (response.ok && json?.code === 1 && json?.data) {
            campaign.value = json.data
            useHead({
                title: `${json.data.title} — Signal Platform`,
                meta: [
                    { name: 'description', content: json.data.description || json.data.title }
                ]
            })
        } else {
            throw new Error(json?.msg || `Campaign with ID "${slug.value}" was not found.`)
        }
    } catch (e: any) {
        console.error('[GET /campaigns/:id] failed:', e)
        errorMessage.value = e?.message || `Campaign "${slug.value}" was not found or is restricted.`
    } finally {
        isLoading.value = false
    }
}

onMounted(fetchCampaign)
</script>

<template>
    <div class="py-6 max-w-[1100px] mx-auto font-body text-foreground">

        <!-- Breadcrumb & Back Button -->
        <div class="flex items-center justify-between mb-6">
            <NuxtLink to="/public"
                class="inline-flex items-center gap-2 text-xs font-mono font-semibold text-gray-600 dark:text-gray-300 hover:text-primary transition-colors">
                <UIcon name="i-heroicons-arrow-left" class="w-4 h-4" /> Back to All Campaigns
            </NuxtLink>

            <div v-if="campaign"
                class="flex items-center gap-2 text-xs font-mono font-semibold text-gray-600 dark:text-gray-300">
                <span>Category:</span>
                <NuxtLink :to="`/public?category=${encodeURIComponent(campaign.category || '')}`"
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
            <NuxtLink to="/public"
                class="mt-2 text-xs font-mono px-4 py-2 rounded-xl font-bold text-white bg-primary hover:bg-primary-600 transition-all">
                Return to Search & Discover
            </NuxtLink>
        </div>

        <!-- Main Content Grid -->
        <div v-else class="grid grid-cols-1 lg:grid-cols-12 gap-8 items-start">

            <!-- Left Main Column (Details & Article Content) -->
            <article class="lg:col-span-8 space-y-6">

                <!-- Hero Header Card -->
                <header
                    class="rounded-2xl p-6 sm:p-8 border shadow-xl relative overflow-hidden bg-white dark:bg-gray-900 border-gray-200 dark:border-gray-800">

                    <!-- Glow decoration -->
                    <div
                        class="absolute -top-12 -right-12 w-48 h-48 rounded-full bg-primary/10 blur-3xl pointer-events-none">
                    </div>

                    <!-- Category & Type Badges -->
                    <div class="flex flex-wrap items-center gap-2 mb-4">
                        <CategoryBadge :name="campaign.category" size="sm" />
                        <CategoryBadge v-if="campaign.contentType" :contentType="campaign.contentType" size="sm" />
                        <span v-if="campaign.adNetwork"
                            class="text-[10px] font-mono font-bold px-2.5 py-1 rounded-full bg-amber-500/10 border border-amber-500/30 text-amber-600 dark:text-amber-400">
                            {{ campaign.adNetwork }}
                        </span>
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
                            <img v-if="campaign.creator?.avatar" :src="campaign.creator.avatar"
                                :alt="campaign.creator?.username"
                                class="h-8 w-8 rounded-full object-cover ring-2 ring-primary/40" />
                            <span v-else
                                class="h-8 w-8 rounded-full flex items-center justify-center text-xs font-bold bg-primary-100 dark:bg-primary-950/60 text-primary ring-2 ring-primary/30">
                                {{ initials(campaign.creator?.username) }}
                            </span>
                            <div>
                                <div class="text-xs font-bold text-gray-900 dark:text-white flex items-center gap-1.5">
                                    {{ campaign.creator?.username || 'Verified Creator' }}
                                    <UIcon name="i-heroicons-check-circle" class="w-4 h-4 text-primary shrink-0"
                                        title="Verified Publisher" />
                                </div>
                                <div class="text-[11px] font-mono font-medium text-gray-600 dark:text-gray-400">
                                    Published {{ formatDate(campaign.createdAt) }} ({{ timeAgo(campaign.createdAt) }})
                                </div>
                            </div>
                        </div>

                        <!-- Action Controls -->
                        <div class="flex items-center gap-2">
                            <button @click="copyLink"
                                class="px-3.5 py-1.5 rounded-xl bg-gray-100 dark:bg-gray-800 hover:bg-gray-200 dark:hover:bg-gray-700 text-gray-800 dark:text-gray-200 text-xs font-mono font-semibold transition-all flex items-center gap-1.5">
                                <UIcon name="i-heroicons-link" class="w-4 h-4 text-primary shrink-0" />
                                <span>{{ copied ? 'Copied Link!' : 'Copy Link' }}</span>
                            </button>
                        </div>
                    </div>
                </header>

                <!-- Cover Image Banner -->
                <div v-if="campaign.imageUrl"
                    class="rounded-2xl overflow-hidden border border-gray-200 dark:border-gray-800 shadow-xl bg-gray-100 dark:bg-gray-950">
                    <img :src="campaign.imageUrl" :alt="campaign.imageTitle || campaign.title"
                        class="w-full max-h-[480px] object-cover" />
                    <div v-if="campaign.imageTitle || campaign.imageDescription"
                        class="p-3 bg-gray-50 dark:bg-gray-900/90 text-xs font-mono font-medium text-gray-600 dark:text-gray-300 border-t border-gray-200 dark:border-gray-800">
                        <span class="font-bold text-gray-900 dark:text-white" v-if="campaign.imageTitle">{{
                            campaign.imageTitle }}: </span>
                        <span>{{ campaign.imageDescription }}</span>
                    </div>
                </div>

                <!-- Main Content Body -->
                <div
                    class="rounded-2xl p-6 sm:p-8 border leading-relaxed text-gray-800 dark:text-gray-200 font-body space-y-4 bg-white dark:bg-gray-900 border-gray-200 dark:border-gray-800">

                    <h3 class="font-display font-bold text-sm uppercase tracking-wider text-primary mb-2">
                        Campaign Overview
                    </h3>

                    <!-- Render Content / Description -->
                    <div
                        class="prose dark:prose-invert max-w-none text-sm sm:text-base leading-relaxed whitespace-pre-line font-medium text-gray-700 dark:text-gray-200">
                        {{ campaign.content || campaign.description || 'No detailed content provided for this campaign.'
                        }}
                    </div>
                </div>

                <!-- Interactive Feedback Widget -->
                <PublicFeedbackWidget :feedback-given="feedbackGiven" @give-feedback="giveFeedback" />
            </article>

            <!-- Right Sidebar Column (Metrics & Ad Info) -->
            <aside class="lg:col-span-4 space-y-6 sticky top-20">
                <PublicPerformanceStats
                    :total-impressions="campaign.totalImpressions"
                    :unique-viewers="campaign.uniqueViewers"
                />

                <PublicPublisherCard :creator="campaign.creator" />

                <PublicAdIntegrationCard
                    :ad-network="campaign.adNetwork"
                    :ad-unit-code="campaign.adUnitCode"
                />

                <!-- Explore Category Button -->
                <NuxtLink :to="`/public?category=${encodeURIComponent(campaign.category || '')}`"
                    class="w-full text-center flex items-center justify-center gap-1.5 text-xs font-mono font-bold py-3 rounded-xl transition-all text-white bg-primary hover:bg-primary-600 shadow-md">
                    <span>Explore {{ campaign.category || 'General' }} Campaigns</span>
                    <UIcon name="i-heroicons-arrow-right" class="w-4 h-4" />
                </NuxtLink>
            </aside>
        </div>
    </div>
</template>

<style scoped>
.prose {
    color: var(--text);
}
</style>
