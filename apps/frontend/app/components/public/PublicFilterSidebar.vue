<script setup lang="ts">
const props = defineProps<{
  categories: Array<{ id?: string | number; name: string }>
  selectedCategory: string
  selectedContentType: string
  contentTypes: string[]
  sortBy: 'newest' | 'impressions' | 'viewers'
  activeFilterCount: number
}>()

const emit = defineEmits<{
  (e: 'select-category', category?: string): void
  (e: 'select-content-type', contentType?: string): void
  (e: 'update:sortBy', value: 'newest' | 'impressions' | 'viewers'): void
  (e: 'reset-filters'): void
}>()
</script>

<template>
  <aside class="hidden lg:flex lg:flex-col lg:w-[210px] shrink-0 gap-5 sticky top-20">
    <!-- Category Filters Section -->
    <div>
      <div class="flex items-center justify-between mb-2.5">
        <h4 class="text-[11px] font-mono uppercase tracking-wider font-semibold text-gray-500 dark:text-gray-400">
          Filters
        </h4>
        <button v-if="activeFilterCount > 0" @click="emit('reset-filters')"
          class="text-[10px] font-mono text-primary hover:underline font-semibold">
          Reset
        </button>
      </div>

      <nav class="flex flex-col gap-1">
        <button
          class="text-left text-xs px-3 py-2 rounded-xl font-medium transition-all flex items-center justify-between"
          :class="!selectedCategory
            ? 'bg-primary-50 dark:bg-primary-950/40 text-primary border border-primary/30 font-bold'
            : 'text-gray-700 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-800/60'"
          @click="emit('select-category', undefined)">
          <span class="flex items-center gap-2">
            <UIcon name="i-heroicons-bolt" class="w-4 h-4 text-primary shrink-0" />
            <span>All Results</span>
          </span>
        </button>

        <button v-for="cat in categories" :key="cat.name"
          class="text-left text-xs px-3 py-2 rounded-xl transition-all flex items-center justify-between"
          :class="selectedCategory === cat.name
            ? 'bg-primary-50 dark:bg-primary-950/40 text-primary border border-primary/30 font-bold'
            : 'text-gray-600 dark:text-gray-400 hover:text-gray-900 dark:hover:text-white'"
          @click="emit('select-category', cat.name)">
          <span>{{ cat.name }}</span>
        </button>
      </nav>
    </div>

    <!-- Content Type Selector -->
    <div class="pt-3 border-t border-gray-200 dark:border-gray-800">
      <h4 class="text-[11px] font-mono uppercase tracking-wider mb-2 font-semibold text-gray-500 dark:text-gray-400">
        Content Type
      </h4>
      <div class="flex flex-wrap gap-1.5">
        <button class="text-[11px] font-mono px-2.5 py-1 rounded-lg transition-all"
          :class="!selectedContentType
            ? 'bg-primary text-white dark:text-gray-950 font-bold'
            : 'bg-gray-100 dark:bg-gray-800 border border-gray-200 dark:border-gray-700 text-gray-600 dark:text-gray-400'"
          @click="emit('select-content-type', undefined)">
          ANY
        </button>
        <button v-for="ct in contentTypes" :key="ct"
          class="text-[11px] font-mono px-2.5 py-1 rounded-lg transition-all"
          :class="selectedContentType === ct
            ? 'bg-primary text-white dark:text-gray-950 font-bold'
            : 'bg-gray-100 dark:bg-gray-800 border border-gray-200 dark:border-gray-700 text-gray-600 dark:text-gray-400'"
          @click="emit('select-content-type', ct)">
          {{ ct }}
        </button>
      </div>
    </div>

    <!-- Sort By Control -->
    <div class="pt-3 border-t border-gray-200 dark:border-gray-800">
      <h4 class="text-[11px] font-mono uppercase tracking-wider mb-2 font-semibold text-gray-500 dark:text-gray-400">
        Sort Results
      </h4>
      <select :value="sortBy"
        @change="emit('update:sortBy', ($event.target as HTMLSelectElement).value as any)"
        class="w-full text-xs rounded-xl px-3 py-2 outline-none font-mono cursor-pointer transition-all bg-white dark:bg-gray-900 border border-gray-200 dark:border-gray-800 text-gray-900 dark:text-gray-100 font-semibold">
        <option value="newest">Newest First</option>
        <option value="impressions">Most Impressions</option>
        <option value="viewers">Most Viewers</option>
      </select>
    </div>
  </aside>
</template>
