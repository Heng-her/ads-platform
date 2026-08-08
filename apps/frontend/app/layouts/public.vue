<script setup lang="ts">
import { ref, computed, watch, onMounted, onUnmounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { useCategories } from '~/composables/useCategories'
import { useApi } from '~/composables/useApi'

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
        const json = await res.json()
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
    pushQuery({ search: query || undefined })
}

function selectSuggestion(item: SuggestionItem) {
    isSearchFocused.value = false
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
    <div class="min-h-screen w-full flex flex-col bg-background text-foreground">
        <!-- ================= TOP HEADER / NAVIGATION ================= -->
        <AppHeader :class="[
            'will-change-transform transition-transform duration-300 ease-out',
            isHeaderHidden ? '-translate-y-full' : 'translate-y-0'
        ]">
            <template #left>
                <NuxtLink to="/article" class="flex items-center gap-2 text-xl font-bold text-primary group">
                    <div
                        class="h-9 w-9 rounded-xl flex items-center justify-center bg-primary-500/10 text-primary border border-primary/20 transition-transform group-hover:scale-105">
                        <img src="/article.webp" alt="Article" class="h-full w-full rounded-xl object-cover" />
                    </div>
                    <div class="hidden sm:flex flex-col">
                        <span
                            class="font-display font-bold text-base tracking-tight text-gray-900 dark:text-white group-hover:text-primary transition-colors">
                            SIGNAL
                        </span>
                        <span
                            class="text-[10px] font-mono tracking-wider text-gray-500 dark:text-gray-400 uppercase -mt-1">
                            Ads Platform
                        </span>
                    </div>
                </NuxtLink>
            </template>

            <!-- Right: Search Box, Color Mode Toggle & Actions -->
            <template #right>
                <div class="flex items-center gap-2 md:gap-3">
                    <!-- Search Input Wrapper -->
                    <div class="relative w-52 sm:w-72 lg:w-[22rem]">
                        <div
                            class="relative flex h-11 items-center rounded-2xl border border-gray-200 bg-gray-50 shadow-sm transition-all duration-200 focus-within:border-primary/50 focus-within:bg-white focus-within:ring-4 focus-within:ring-primary/10 dark:border-gray-800 dark:bg-gray-900 dark:focus-within:bg-gray-950">
                            <!-- Search Icon -->
                            <span class="flex shrink-0 items-center pl-4 pr-2.5 text-gray-400">
                                <UIcon name="i-heroicons-magnifying-glass" class="h-4.5 w-4.5 text-primary" />
                            </span>

                            <!-- Input -->
                            <input ref="searchInputRef" v-model="searchQuery" type="text"
                                placeholder="Search campaigns... (/)"
                                class="w-full bg-transparent py-2 pr-7 text-sm font-medium text-gray-900 outline-none placeholder:text-gray-400 dark:text-white font-body"
                                @input="onSearchInput" @focus="isSearchFocused = true" @blur="onSearchBlur"
                                @keydown.enter="handleSearchSubmit" />

                            <!-- Clear button or shortcut -->
                            <div class="flex shrink-0 items-center pr-3">
                                <button v-if="searchQuery" type="button" @click="clearSearch"
                                    class="flex h-6 w-6 items-center justify-center rounded-lg text-gray-400 transition-all hover:bg-gray-200 hover:text-gray-900 dark:hover:bg-gray-800 dark:hover:text-white"
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

                    <!-- Action Buttons -->
                    <UButton to="/login" color="neutral" variant="ghost" class="hidden sm:inline-flex text-xs">
                        Sign In
                    </UButton>
                    <UButton to="/creator" color="primary" size="xs" class="sm:inline-flex font-semibold text-xs">
                        Creator Studio
                    </UButton>
                </div>
            </template>
        </AppHeader>

        <!-- Main Body Container -->
        <main :class="[
            'mx-auto px-4 sm:px-6 flex-1 w-full py-6',
            route.meta.fullWidth ? 'max-w-none' : 'max-w-[1400px]'
        ]">
            <slot />
        </main>

        <!-- Footer -->
        <footer
            class="border-t border-gray-200 dark:border-gray-800 py-6 bg-gray-50/50 dark:bg-gray-900/50 hidden md:block">
            <div class="max-w-[1400px] mx-auto px-4 text-center text-xs text-gray-500">
                © {{ new Date().getFullYear() }} Signal Ads Platform. All rights reserved.
            </div>
        </footer>
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
