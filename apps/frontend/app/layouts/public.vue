<script setup lang="ts">
import { ref, computed, watch, onMounted, onUnmounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { useCategories } from '~/composables/useCategories'
import { useApi } from '~/composables/useApi'

import { usePublicAdConfig } from '~/composables/usePublicAdConfig'

useHead({
    title: 'Signal — Ads Platform Search & Discover',
    link: [
        { rel: 'preconnect', href: 'https://fonts.googleapis.com' },
        { rel: 'preconnect', href: 'https://fonts.gstatic.com', crossorigin: 'anonymous' },
        {
            rel: 'stylesheet',
            href: 'https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap'
        }
    ],
})

const route = useRoute()
const router = useRouter()
const api = useApi()
const { categories } = useCategories()
const { adConfig } = usePublicAdConfig()

const isArticleRoute = computed(() => route.path.startsWith('/article'))
const isMobileSponsorDismissed = ref(false)

const adsterraMobileUrl = computed(() => {
    const baseUrl = adConfig.value?.adsterra?.smartlinkUrl
    if (!baseUrl) return '#'
    const separator = baseUrl.includes('?') ? '&' : '?'
    return `${baseUrl}${separator}subid=mobile_anchor`
})

function handleMobileSponsorClick() {
    if (!import.meta.client) return
    try {
        const payload = JSON.stringify({
            provider: 'ADSTERRA',
            format: 'SMARTLINK',
            placement: 'categoryFeed'
        })
        if (navigator.sendBeacon) {
            const blob = new Blob([payload], { type: 'application/json' })
            navigator.sendBeacon('/api/ads/click', blob)
        } else {
            fetch('/api/ads/click', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: payload,
                keepalive: true
            }).catch(() => { })
        }
    } catch (e) { }
}

// Mobile drawer & search overlay state
const isMobileOpen = ref(false)
const showMobileSearch = ref(false)

const publicNavLinks = [
    { label: 'Articles & Feed', icon: 'i-heroicons-newspaper', to: '/article' },
    { label: 'Explore Campaigns', icon: 'i-heroicons-sparkles', to: '/explore' },
    { label: 'Trending Ads', icon: 'i-heroicons-fire', to: '/trending' },
    { label: 'Monetization', icon: 'i-heroicons-banknotes', to: '/pricing' },
    { label: 'News & Updates', icon: 'i-heroicons-rss', to: '/news' },
    { label: 'AI Insights', icon: 'i-heroicons-cpu-chip', to: '/ai' },
    { label: 'Crypto Finance', icon: 'i-heroicons-wallet', to: '/finance' },
    { label: 'Advertisers', icon: 'i-heroicons-user-group', to: '/advertisers' }
]

// ---- Search & Filter state ----
const searchQuery = ref((route.query.search as string) || '')
const isSearchFocused = ref(false)
const searchInputRef = ref<HTMLInputElement | null>(null)
const isHeaderHidden = ref(false)
let lastScrollY = 0

// Suggestions state from backend GET /api/campaigns/search/suggestions?q=
type SuggestionItem = {
    type: 'category' | 'customCategory' | 'contentType' | 'title' | string
    label: string
    filter: string
    campaignId?: string
}

type GroupedSuggestions = {
    category: SuggestionItem[]
    customCategory: SuggestionItem[]
    contentType: SuggestionItem[]
    title: SuggestionItem[]
}

const suggestions = ref<SuggestionItem[]>([])
const isLoadingSuggestions = ref(false)
let searchDebounceTimer: ReturnType<typeof setTimeout> | null = null

// Group suggestions by type for clean presentation
const groupedSuggestions = computed<GroupedSuggestions>(() => {
    const groups: GroupedSuggestions = {
        category: [],
        customCategory: [],
        contentType: [],
        title: []
    }
    for (const item of suggestions.value) {
        if (item.type in groups) {
            groups[item.type as keyof GroupedSuggestions].push(item)
        }
    }
    return groups
})

const hasSuggestions = computed(() => suggestions.value.length > 0)

// Sync input if URL updates externally
watch(
    () => route.query.search,
    (newSearch) => {
        searchQuery.value = (newSearch as string) || ''
    }
)

function pushQuery(patch: Record<string, string | undefined>) {
    router.push({
        path: route.path.startsWith('/article') ? route.path : '/article',
        query: { ...route.query, ...patch }
    })
}

async function fetchSuggestions(query: string) {
    const q = query.trim()
    if (!q) {
        suggestions.value = []
        isLoadingSuggestions.value = false
        return
    }
    isLoadingSuggestions.value = true
    try {
        const res = await api.action.$post({
            json: {
                action: 'campaigns/search-suggestions',
                data: { q }
            }
        })
        const json: any = await res.json()
        if (json?.code === 1 && Array.isArray(json?.data)) {
            suggestions.value = json.data
        } else {
            suggestions.value = []
        }
    } catch (e) {
        console.error('[POST /action campaigns/search-suggestions] failed:', e)
        suggestions.value = []
    } finally {
        isLoadingSuggestions.value = false
    }
}

function onSearchInput() {
    if (searchDebounceTimer) clearTimeout(searchDebounceTimer)
    searchDebounceTimer = setTimeout(() => {
        const query = searchQuery.value.trim()
        fetchSuggestions(query)
        pushQuery({ search: query || undefined })
    }, 300)
}

function handleSearchSubmit() {
    const query = searchQuery.value.trim()
    isSearchFocused.value = false
    showMobileSearch.value = false
    pushQuery({ search: query || undefined })
}

function selectSuggestion(item: SuggestionItem) {
    isSearchFocused.value = false
    showMobileSearch.value = false
    searchQuery.value = item.type === 'title' ? item.label : searchQuery.value

    const [key, val] = item.filter.split('=')
    if (key && val) {
        const decodedVal = decodeURIComponent(val)
        pushQuery({ [key]: decodedVal })
    } else {
        pushQuery({ search: item.label })
    }
}

function onSearchBlur() {
    setTimeout(() => {
        isSearchFocused.value = false
    }, 200)
}

function clearSearch() {
    searchQuery.value = ''
    suggestions.value = []
    pushQuery({ search: undefined })
    if (searchInputRef.value) searchInputRef.value.focus()
}

// Global keydown shortcut '/' to focus search input
function onKeyDown(e: KeyboardEvent) {
    if (e.key === '/' && document.activeElement !== searchInputRef.value && !['INPUT', 'TEXTAREA'].includes((document.activeElement as HTMLElement)?.tagName)) {
        e.preventDefault()
        searchInputRef.value?.focus()
    }
    if (e.key === 'Escape' && isSearchFocused.value) {
        isSearchFocused.value = false
    }
}

function onWindowScroll() {
    const currentScrollY = window.scrollY

    if (currentScrollY <= 12) {
        isHeaderHidden.value = false
    } else if (currentScrollY > lastScrollY + 8) {
        isHeaderHidden.value = true
    } else if (currentScrollY < lastScrollY - 8) {
        isHeaderHidden.value = false
    }

    lastScrollY = currentScrollY
}

onMounted(() => {
    lastScrollY = window.scrollY
    window.addEventListener('keydown', onKeyDown)
    window.addEventListener('scroll', onWindowScroll, { passive: true })
})

onUnmounted(() => {
    if (searchDebounceTimer) clearTimeout(searchDebounceTimer)
    window.removeEventListener('keydown', onKeyDown)
    window.removeEventListener('scroll', onWindowScroll)
})
</script>

<template>
    <div class="min-h-screen w-full flex flex-col bg-background text-foreground pb-16 md:pb-0">
        <!-- ================= TOP HEADER / NAVIGATION ================= -->
        <AppHeader :class="[
            'will-change-transform transition-transform duration-300 ease-out',
            isHeaderHidden ? '-translate-y-full' : 'translate-y-0'
        ]">
            <template #left>
                <div class="flex items-center gap-2">
                    <!-- Mobile Hamburger Drawer Toggle Button -->
                    <UButton
                        icon="i-heroicons-bars-3"
                        color="neutral"
                        variant="ghost"
                        class="md:hidden"
                        aria-label="Open mobile menu"
                        @click="isMobileOpen = true"
                    />

                    <!-- Brand Logo -->
                    <NuxtLink to="/article" class="flex items-center gap-2 text-xl font-bold text-primary group">
                        <div
                            class="h-9 w-9 rounded-xl flex items-center justify-center bg-primary-500/10 text-primary border border-primary/20 transition-transform group-hover:scale-105 shrink-0">
                            <img src="/article.webp" alt="Article" class="h-full w-full rounded-xl object-cover" />
                        </div>
                        <div class="flex flex-col">
                            <span
                                class="font-display font-bold text-base tracking-tight text-gray-900 dark:text-white group-hover:text-primary transition-colors">
                                SIGNAL
                            </span>
                            <span
                                class="text-[9px] sm:text-[10px] font-mono tracking-wider text-gray-500 dark:text-gray-400 uppercase -mt-1">
                                Ads Platform
                            </span>
                        </div>
                    </NuxtLink>
                </div>
            </template>

            <!-- Right: Search Box, Color Mode Toggle & Actions -->
            <template #right>
                <div class="flex items-center gap-1.5 sm:gap-2 md:gap-3">
                    <!-- Mobile Search Toggle Button -->
                    <UButton
                        icon="i-heroicons-magnifying-glass"
                        color="neutral"
                        variant="ghost"
                        class="md:hidden"
                        aria-label="Search"
                        @click="showMobileSearch = !showMobileSearch"
                    />

                    <!-- Desktop Search Input Wrapper -->
                    <div class="relative hidden md:block w-52 sm:w-64 lg:w-80">
                        <div
                            class="relative flex h-10 lg:h-11 items-center rounded-2xl border border-gray-200 bg-gray-50 shadow-sm transition-all duration-200 focus-within:border-primary/50 focus-within:bg-white focus-within:ring-4 focus-within:ring-primary/10 dark:border-gray-800 dark:bg-gray-900 dark:focus-within:bg-gray-950">
                            <!-- Search Icon -->
                            <span class="flex shrink-0 items-center pl-3.5 pr-2 text-gray-400">
                                <UIcon name="i-heroicons-magnifying-glass" class="h-4 w-4 text-primary" />
                            </span>

                            <!-- Input -->
                            <input ref="searchInputRef" v-model="searchQuery" type="text"
                                placeholder="Search campaigns... (/)"
                                class="w-full bg-transparent py-2 pr-7 text-xs sm:text-sm font-medium text-gray-900 outline-none placeholder:text-gray-400 dark:text-white font-body"
                                @input="onSearchInput" @focus="isSearchFocused = true" @blur="onSearchBlur"
                                @keydown.enter="handleSearchSubmit" />

                            <!-- Clear button or shortcut -->
                            <div class="flex shrink-0 items-center pr-3">
                                <button v-if="searchQuery" type="button" @click="clearSearch"
                                    class="flex h-5 w-5 items-center justify-center rounded-lg text-gray-400 transition-all hover:bg-gray-200 hover:text-gray-900 dark:hover:bg-gray-800 dark:hover:text-white"
                                    title="Clear search">
                                    <UIcon name="i-heroicons-x-mark" class="w-3.5 h-3.5" />
                                </button>
                                <kbd v-else
                                    class="hidden rounded-md border border-gray-200 bg-white px-1.5 py-0.5 text-[10px] font-mono text-gray-400 shadow-sm dark:border-gray-700 dark:bg-gray-800 md:inline-block">
                                    /
                                </kbd>
                            </div>
                        </div>

                        <!-- Autocomplete Suggestions Popover Dropdown -->
                        <transition name="fade-slide">
                            <div v-if="isSearchFocused && (hasSuggestions || isLoadingSuggestions)"
                                class="absolute top-full left-0 right-0 mt-2 rounded-xl overflow-hidden z-50 shadow-2xl bg-white dark:bg-gray-900 border border-gray-200 dark:border-gray-800">
                                <!-- Loading state -->
                                <div v-if="isLoadingSuggestions"
                                    class="p-3 text-center text-xs font-mono text-gray-400 flex items-center justify-center gap-2">
                                    <UIcon name="i-lucide-loader-2" class="h-4 w-4 text-primary animate-spin" />
                                    Searching suggestions...
                                </div>

                                <div v-else
                                    class="max-h-[360px] overflow-y-auto divide-y divide-gray-100 dark:divide-gray-800 p-2">
                                    <!-- Category Suggestions -->
                                    <div v-if="groupedSuggestions.category?.length" class="py-1">
                                        <div
                                            class="px-2.5 py-1 text-[10px] font-mono uppercase tracking-wider text-primary font-semibold flex items-center gap-1.5">
                                            <UIcon name="i-heroicons-tag" class="w-3.5 h-3.5" /> Categories
                                        </div>
                                        <button v-for="s in groupedSuggestions.category" :key="s.filter"
                                            class="w-full text-left px-3 py-2 rounded-lg text-xs flex items-center justify-between hover:bg-primary-50 dark:hover:bg-primary-950/30 text-gray-700 dark:text-gray-200 transition-all"
                                            @mousedown.prevent="selectSuggestion(s)">
                                            <span>{{ s.label }}</span>
                                            <CategoryBadge :name="s.label" size="sm" />
                                        </button>
                                    </div>

                                    <!-- Custom Category Suggestions -->
                                    <div v-if="groupedSuggestions.customCategory?.length" class="py-1">
                                        <div
                                            class="px-2.5 py-1 text-[10px] font-mono uppercase tracking-wider text-amber-500 font-semibold flex items-center gap-1.5">
                                            <UIcon name="i-heroicons-folder" class="w-3.5 h-3.5" /> Custom Categories
                                        </div>
                                        <button v-for="s in groupedSuggestions.customCategory" :key="s.filter"
                                            class="w-full text-left px-3 py-2 rounded-lg text-xs flex items-center justify-between hover:bg-amber-50 dark:hover:bg-amber-950/30 text-gray-700 dark:text-gray-200 transition-all"
                                            @mousedown.prevent="selectSuggestion(s)">
                                            <span>{{ s.label }}</span>
                                            <CategoryBadge :name="s.label" size="sm" />
                                        </button>
                                    </div>

                                    <!-- Content Type Suggestions -->
                                    <div v-if="groupedSuggestions.contentType?.length" class="py-1">
                                        <div
                                            class="px-2.5 py-1 text-[10px] font-mono uppercase tracking-wider text-sky-500 font-semibold flex items-center gap-1.5">
                                            <UIcon name="i-heroicons-document-text" class="w-3.5 h-3.5" /> Content Types
                                        </div>
                                        <button v-for="s in groupedSuggestions.contentType" :key="s.filter"
                                            class="w-full text-left px-3 py-2 rounded-lg text-xs flex items-center justify-between hover:bg-sky-50 dark:hover:bg-sky-950/30 text-gray-700 dark:text-gray-200 transition-all"
                                            @mousedown.prevent="selectSuggestion(s)">
                                            <span>{{ s.label }}</span>
                                            <CategoryBadge :contentType="s.label" size="sm" />
                                        </button>
                                    </div>

                                    <!-- Campaign Title Matches -->
                                    <div v-if="groupedSuggestions.title?.length" class="py-1">
                                        <div
                                            class="px-2.5 py-1 text-[10px] font-mono uppercase tracking-wider text-purple-500 font-semibold flex items-center gap-1.5">
                                            <UIcon name="i-heroicons-magnifying-glass" class="w-3.5 h-3.5" /> Campaign
                                            Titles
                                        </div>
                                        <button v-for="s in groupedSuggestions.title" :key="s.filter"
                                            class="w-full text-left px-3 py-2 rounded-lg text-xs flex items-center justify-between hover:bg-purple-50 dark:hover:bg-purple-950/30 text-gray-700 dark:text-gray-200 transition-all"
                                            @mousedown.prevent="selectSuggestion(s)">
                                            <span class="truncate font-medium">{{ s.label }}</span>
                                            <span
                                                class="text-[10px] font-mono text-purple-500 shrink-0 ml-2">Match</span>
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </transition>
                    </div>

                    <!-- Language Selector & Color Mode Toggle -->
                    <LanguageSwitcher />
                    <UColorModeButton />

                    <!-- Action Buttons (Desktop) -->
                    <UButton to="/login" color="neutral" variant="ghost" class="hidden sm:inline-flex text-xs">
                        Sign In
                    </UButton>
                    <UButton to="/creator" color="primary" size="xs" class="hidden sm:inline-flex font-semibold text-xs">
                        Creator Studio
                    </UButton>
                </div>
            </template>
        </AppHeader>

        <!-- Expandable Mobile Search Bar Overlay -->
        <transition name="fade-slide">
            <div v-if="showMobileSearch" class="md:hidden sticky top-16 z-30 bg-white/95 dark:bg-gray-900/95 backdrop-blur-md border-b border-gray-200 dark:border-gray-800 p-3 shadow-md">
                <div class="relative flex items-center">
                    <UIcon name="i-heroicons-magnifying-glass" class="absolute left-3.5 h-4 w-4 text-primary" />
                    <input
                        v-model="searchQuery"
                        type="text"
                        placeholder="Search campaigns..."
                        class="w-full rounded-xl border border-gray-200 dark:border-gray-800 bg-gray-50 dark:bg-gray-950 py-2 pl-9 pr-9 text-sm text-gray-900 dark:text-white outline-none focus:ring-2 focus:ring-primary/20"
                        @input="onSearchInput"
                        @keydown.enter="handleSearchSubmit"
                    />
                    <button v-if="searchQuery" @click="clearSearch" class="absolute right-3 text-gray-400">
                        <UIcon name="i-heroicons-x-mark" class="h-4 w-4" />
                    </button>
                </div>
            </div>
        </transition>

        <!-- Main Body Container -->
        <main :class="[
            'mx-auto px-4 sm:px-6 flex-1 w-full py-6',
            route.meta.fullWidth ? 'max-w-none' : 'max-w-[1400px]'
        ]">
            <slot />
        </main>

        <!-- Mobile Bottom Section: Adsterra High-CPM Sponsor Bar for Article pages OR Default Nav Dock for non-article pages -->
        <div v-if="isArticleRoute" class="md:hidden">
            <!-- Adsterra High-CPM Sponsor Mobile Floating Anchor Bar -->
            <div v-if="!isMobileSponsorDismissed"
                class="fixed bottom-2 left-2 right-2 z-50 h-14 rounded-2xl bg-gradient-to-r from-amber-500 via-amber-600 to-amber-700 p-2 shadow-2xl shadow-amber-500/30 backdrop-blur-md border border-amber-400/40 flex items-center justify-between transition-all duration-300 active:scale-[0.98]">
                <a :href="adsterraMobileUrl" target="_blank" rel="noopener noreferrer" @click="handleMobileSponsorClick"
                    class="flex-1 flex items-center gap-2.5 min-w-0 pr-2">
                    <div class="h-9 w-9 rounded-xl bg-white/20 text-white flex items-center justify-center shrink-0 border border-white/30 shadow-inner">
                        <UIcon name="i-heroicons-bolt" class="w-5 h-5 animate-pulse text-amber-200" />
                    </div>
                    <div class="flex flex-col min-w-0">
                        <div class="flex items-center gap-1.5 text-[11px] font-extrabold text-white leading-tight truncate">
                            <span>Special Partner Offer</span>
                            <span class="inline-flex items-center rounded-full bg-amber-400/30 px-1.5 py-0.2 text-[9px] font-bold text-amber-100 uppercase tracking-wider">
                                Sponsor
                            </span>
                        </div>
                        <span class="text-[10px] text-amber-100/90 font-medium truncate">
                            Tap to view exclusive partner rewards & deals
                        </span>
                    </div>
                </a>

                <div class="flex items-center gap-1.5 shrink-0">
                    <a :href="adsterraMobileUrl" target="_blank" rel="noopener noreferrer" @click="handleMobileSponsorClick"
                        class="rounded-xl bg-white px-3 py-1.5 text-xs font-extrabold text-amber-600 shadow-md flex items-center gap-1 hover:bg-amber-50 transition-colors">
                        <span>View Deal</span>
                        <UIcon name="i-heroicons-arrow-right" class="w-3.5 h-3.5" />
                    </a>
                    <button @click="isMobileSponsorDismissed = true"
                        class="p-1 rounded-lg text-amber-100 hover:text-white hover:bg-white/20 transition-colors"
                        title="Dismiss banner">
                        <UIcon name="i-heroicons-x-mark" class="w-4 h-4" />
                    </button>
                </div>
            </div>
        </div>

        <!-- Glassmorphic Sticky Mobile Bottom Navigation Bar (For Non-Article Pages) -->
        <div v-else class="md:hidden fixed bottom-3 left-3 right-3 z-40 rounded-2xl bg-white/85 dark:bg-gray-900/85 backdrop-blur-md border border-gray-200/80 dark:border-gray-800/80 shadow-lg px-2 py-1.5 flex items-center justify-around">
            <NuxtLink to="/article" class="flex flex-col items-center gap-0.5 text-[10px] font-medium text-gray-500 dark:text-gray-400 hover:text-primary transition-colors" active-class="text-primary font-bold">
                <UIcon name="i-heroicons-newspaper" class="w-5 h-5" />
                <span>Articles</span>
            </NuxtLink>
            <NuxtLink to="/explore" class="flex flex-col items-center gap-0.5 text-[10px] font-medium text-gray-500 dark:text-gray-400 hover:text-primary transition-colors" active-class="text-primary font-bold">
                <UIcon name="i-heroicons-sparkles" class="w-5 h-5" />
                <span>Explore</span>
            </NuxtLink>
            <NuxtLink to="/trending" class="flex flex-col items-center gap-0.5 text-[10px] font-medium text-gray-500 dark:text-gray-400 hover:text-primary transition-colors" active-class="text-primary font-bold">
                <UIcon name="i-heroicons-fire" class="w-5 h-5" />
                <span>Trending</span>
            </NuxtLink>
            <NuxtLink to="/pricing" class="flex flex-col items-center gap-0.5 text-[10px] font-medium text-gray-500 dark:text-gray-400 hover:text-primary transition-colors" active-class="text-primary font-bold">
                <UIcon name="i-heroicons-banknotes" class="w-5 h-5" />
                <span>Pricing</span>
            </NuxtLink>
            <button @click="isMobileOpen = true" class="flex flex-col items-center gap-0.5 text-[10px] font-medium text-gray-500 dark:text-gray-400 hover:text-primary transition-colors">
                <UIcon name="i-heroicons-bars-3" class="w-5 h-5" />
                <span>Menu</span>
            </button>
        </div>

        <!-- Mobile Side Navigation Drawer -->
        <MobileDrawer
            v-model:open="isMobileOpen"
            side="left"
            title="Signal Ads"
            icon="i-heroicons-globe-alt"
            icon-class="text-primary"
            :links="publicNavLinks"
            role="public"
        />

        <!-- Desktop Footer -->
        <footer
            class="border-t border-gray-200 dark:border-gray-800 py-6 bg-gray-50/50 dark:bg-gray-900/50 hidden md:block">
            <div class="max-w-[1400px] mx-auto px-4 text-center text-xs text-gray-500">
                © {{ new Date().getFullYear() }} Signal Ads Platform. All rights reserved.
            </div>
        </footer>

        <!-- Newsletter Subscriber Modal -->
        <NewsletterModal />
    </div>
</template>

<style>
.font-display {
    font-family: 'Space Grotesk', ui-sans-serif, system-ui, sans-serif;
}

.font-body {
    font-family: 'Inter', ui-sans-serif, system-ui, sans-serif;
}

.font-mono {
    font-family: 'IBM Plex Mono', ui-monospace, monospace;
}

.fade-slide-enter-active,
.fade-slide-leave-active {
    transition: opacity 0.15s ease, transform 0.15s ease;
}

.fade-slide-enter-from,
.fade-slide-leave-to {
    opacity: 0;
    transform: translateY(-6px);
}
</style>
