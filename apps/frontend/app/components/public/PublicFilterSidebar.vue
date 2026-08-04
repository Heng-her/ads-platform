<script setup lang="ts">
import { onMounted } from 'vue'
import { useCategories } from '~/composables/useCategories'

const props = defineProps<{
  categories?: Array<{ id?: string | number; name: string }>
  selectedCategory: string
  selectedContentType: string
  contentTypes: string[]
  sortBy?: 'newest' | 'impressions' | 'viewers'
  activeFilterCount: number
}>()

const emit = defineEmits<{
  (e: 'select-category', category?: string): void
  (e: 'select-content-type', contentType?: string): void
  (e: 'update:sortBy', value: 'newest' | 'impressions' | 'viewers'): void
  (e: 'reset-filters'): void
}>()

const { categories: apiCategories, fetchCategories } = useCategories()

onMounted(() => {
  fetchCategories()
})

function formatText(val?: string) {
  if (!val) return ''
  return val.charAt(0).toUpperCase() + val.slice(1).toLowerCase()
}
</script>

<template>
  <aside class="hidden lg:flex lg:flex-col lg:w-[250px] shrink-0 gap-6 sticky top-20">
    <!-- Main Filter Box Container -->
    <div
      class="rounded-2xl p-5 border shadow-sm bg-white dark:bg-[#122131] border-gray-200 dark:border-[#273647] space-y-6">

      <!-- Category Filters Section -->
      <div>
        <div class="flex items-center justify-between mb-3.5 pb-2.5 border-b border-gray-200 dark:border-[#273647]">
          <h4 class="text-xs uppercase tracking-wider font-extrabold text-gray-900 dark:text-white">
            Categories
          </h4>
          <button v-if="activeFilterCount > 0" @click="emit('reset-filters')"
            class="text-xs text-gray-500 dark:text-gray-400 hover:text-gray-900 dark:hover:text-white hover:underline font-bold transition-all cursor-pointer">
            Reset
          </button>
        </div>

        <nav class="flex flex-col gap-1.5">
          <!-- All Categories Option -->
          <button
            class="text-left text-sm px-3.5 py-2.5 rounded-xl font-semibold transition-all flex items-center justify-between group cursor-pointer"
            :class="!selectedCategory
              ? 'bg-gray-900 text-white dark:bg-white dark:text-gray-950 font-bold shadow-sm'
              : 'text-gray-700 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-[#0d1c2d] hover:text-gray-900 dark:hover:text-white'"
            @click="emit('select-category', undefined)">
            <span>All Categories</span>
            <span v-if="!selectedCategory" class="h-2 w-2 rounded-full bg-white dark:bg-gray-950" />
          </button>

          <!-- Dynamic Categories fetched directly from GET /api/categories -->
          <button v-for="cat in (props.categories && props.categories.length ? props.categories : apiCategories)" :key="cat.name"
            class="text-left text-sm px-3.5 py-2.5 rounded-xl font-medium transition-all flex items-center justify-between group cursor-pointer"
            :class="selectedCategory === cat.name
              ? 'bg-gray-900 text-white dark:bg-white dark:text-gray-950 font-bold shadow-sm'
              : 'text-gray-700 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-[#0d1c2d] hover:text-gray-900 dark:hover:text-white'"
            @click="emit('select-category', cat.name)">
            <span>{{ formatText(cat.name) }}</span>
            <span v-if="selectedCategory === cat.name" class="h-2 w-2 rounded-full bg-white dark:bg-gray-950" />
          </button>
        </nav>
      </div>

      <!-- Content Type Selector Section -->
      <div class="pt-4 border-t border-gray-200 dark:border-[#273647]">
        <div class="flex items-center justify-between mb-3">
          <h4 class="text-xs uppercase tracking-wider font-extrabold text-gray-900 dark:text-white">
            Content Type
          </h4>
        </div>

        <!-- Clean Grid Filter Options Without Icons -->
        <div class="grid grid-cols-2 gap-2">
          <!-- All Types Option -->
          <button class="text-center text-xs px-2.5 py-2 rounded-xl font-bold transition-all cursor-pointer border"
            :class="!selectedContentType
              ? 'bg-gray-900 text-white dark:bg-white dark:text-gray-950 border-gray-900 dark:border-white shadow-sm'
              : 'bg-gray-50 dark:bg-[#0d1c2d] border-gray-200 dark:border-[#273647] text-gray-700 dark:text-gray-300 hover:border-gray-400 dark:hover:border-gray-600 hover:text-gray-900 dark:hover:text-white'"
            @click="emit('select-content-type', undefined)">
            <span class="truncate">All Types</span>
          </button>

          <!-- Specific Content Types Options -->
          <button v-for="ct in contentTypes" :key="ct"
            class="text-center text-xs px-2.5 py-2 rounded-xl font-bold transition-all cursor-pointer border"
            :class="selectedContentType === ct
              ? 'bg-gray-900 text-white dark:bg-white dark:text-gray-950 border-gray-900 dark:border-white shadow-sm'
              : 'bg-gray-50 dark:bg-[#0d1c2d] border-gray-200 dark:border-[#273647] text-gray-700 dark:text-gray-300 hover:border-gray-400 dark:hover:border-gray-600 hover:text-gray-900 dark:hover:text-white'"
            @click="emit('select-content-type', ct)">
            <span class="truncate">{{ formatText(ct) }}</span>
          </button>
        </div>
      </div>

    </div>
  </aside>
</template>
