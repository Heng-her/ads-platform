<script setup lang="ts">
import type { CategoryItem } from '~/composables/useCategories'

defineProps<{
  categories: CategoryItem[]
  selectedCategory: string
  searchQuery: string
  selectedContentType: string
  activeFilterCount: number
}>()

const emit = defineEmits<{
  (e: 'set-query', patch: Record<string, string | undefined>): void
  (e: 'clear-all'): void
}>()
</script>

<template>
  <div class="space-y-3">
    <!-- Mobile Filter Chips (Sticky Glassmorphic Bar on Mobile) -->
    <div
      class="lg:hidden sticky top-0 z-30 bg-white/95 dark:bg-gray-900/95 backdrop-blur-md border-b border-gray-200/80 dark:border-gray-800/80 py-2.5 -mx-4 px-4 shadow-sm transition-all duration-300 mb-3">
      <div class="flex gap-2 overflow-x-auto no-scrollbar scroll-smooth">
        <button class="shrink-0 text-xs px-3.5 py-1.5 rounded-full transition-all active:scale-95 shadow-sm"
          :class="!selectedCategory
            ? 'bg-primary text-white dark:text-gray-950 font-bold shadow-primary/20'
            : 'bg-gray-100 dark:bg-gray-800 border border-gray-200 dark:border-gray-700 text-gray-600 dark:text-gray-300 hover:bg-gray-200 dark:hover:bg-gray-700'" @click="emit('set-query', { category: undefined })">
          All Categories
        </button>
        <button v-for="cat in categories" :key="cat.name"
          class="shrink-0 text-xs px-3.5 py-1.5 rounded-full transition-all active:scale-95 shadow-sm uppercase font-semibold"
          :class="selectedCategory === cat.name
            ? 'bg-primary text-white dark:text-gray-950 font-bold shadow-primary/20'
            : 'bg-gray-100 dark:bg-gray-800 border border-gray-200 dark:border-gray-700 text-gray-600 dark:text-gray-300 hover:bg-gray-200 dark:hover:bg-gray-700'"
          @click="emit('set-query', { category: cat.name })">
          {{ cat.name }}
        </button>
      </div>
    </div>

    <!-- Active Filter Tags Bar -->
    <div v-if="activeFilterCount > 0"
      class="flex flex-wrap items-center gap-2 p-3 rounded-2xl border bg-white dark:bg-gray-900 border-gray-200 dark:border-gray-800 shadow-sm">
      <span class="text-[11px] text-gray-500 dark:text-gray-400 font-semibold">Active Filters:</span>

      <UBadge v-if="searchQuery" color="neutral" variant="outline" size="sm" class="gap-1.5 px-3 py-1 font-semibold">
        Search: "{{ searchQuery }}"
        <button @click="emit('set-query', { search: undefined })"
          class="text-gray-400 hover:text-gray-900 dark:hover:text-white transition-colors cursor-pointer">
          <UIcon name="i-heroicons-x-mark" class="w-3.5 h-3.5" />
        </button>
      </UBadge>

      <UBadge v-if="selectedCategory" color="neutral" variant="outline" size="sm"
        class="gap-1.5 px-3 py-1 font-semibold">
        Category: {{ selectedCategory }}
        <button @click="emit('set-query', { category: undefined })"
          class="text-gray-400 hover:text-gray-900 dark:hover:text-white transition-colors cursor-pointer">
          <UIcon name="i-heroicons-x-mark" class="w-3.5 h-3.5" />
        </button>
      </UBadge>

      <UBadge v-if="selectedContentType" color="neutral" variant="outline" size="sm"
        class="gap-1.5 px-3 py-1 font-semibold">
        Type: {{ selectedContentType }}
        <button @click="emit('set-query', { contentType: undefined })"
          class="text-gray-400 hover:text-gray-900 dark:hover:text-white transition-colors cursor-pointer">
          <UIcon name="i-heroicons-x-mark" class="w-3.5 h-3.5" />
        </button>
      </UBadge>

      <UButton @click="emit('clear-all')" color="error" variant="soft" size="xs" icon="i-heroicons-x-mark"
        class="ml-auto font-bold cursor-pointer" title="Clear all filters" />
    </div>
  </div>
</template>
