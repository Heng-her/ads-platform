<script setup lang="ts">
import { computed } from 'vue'
import type { CategoryItem, CustomCategoryItem } from '~/composables/useCategories'
import CategoryBadge from '~/components/CategoryBadge.vue'

const props = defineProps<{
  activeTab: 'system' | 'creator'
  searchQuery: string
  categoriesCount: number
  customCategoriesCount: number
  filteredSystemCategories: CategoryItem[]
  filteredCreatorCategories: CustomCategoryItem[]
  isLoadingCategories: boolean
  isLoadingAllCustomCategories: boolean
}>()

const emit = defineEmits<{
  (e: 'update:activeTab', val: 'system' | 'creator'): void
  (e: 'update:searchQuery', val: string): void
  (e: 'open-edit', cat: CategoryItem): void
  (e: 'open-delete', cat: CategoryItem): void
  (e: 'open-delete-custom', cat: CustomCategoryItem): void
}>()

const currentTab = computed({
  get: () => props.activeTab,
  set: (val: 'system' | 'creator') => emit('update:activeTab', val)
})

const query = computed({
  get: () => props.searchQuery,
  set: (val: string) => emit('update:searchQuery', val)
})

function formatDate(dateStr?: string | null) {
  if (!dateStr) return 'N/A'
  try {
    return new Date(dateStr).toLocaleDateString('en-US', {
      year: 'numeric',
      month: 'short',
      day: 'numeric'
    })
  } catch {
    return dateStr
  }
}
</script>

<template>
  <div
    class="bg-white dark:bg-gray-900 rounded-2xl border border-gray-200 dark:border-gray-800 overflow-hidden shadow-xs">
    <!-- Toolbar: Tabs & Search -->
    <div
      class="p-4 sm:p-5 border-b border-gray-200 dark:border-gray-800 flex flex-col sm:flex-row sm:items-center justify-between gap-4">
      <!-- Tabs -->
      <div class="flex items-center p-1 bg-gray-100 dark:bg-gray-800 rounded-lg w-fit">
        <button class="px-4 py-1.5 text-xs font-semibold rounded-md transition-all"
          :class="currentTab === 'system' ? 'bg-white dark:bg-gray-900 text-gray-900 dark:text-white shadow-xs' : 'text-gray-500 hover:text-gray-900 dark:hover:text-white'"
          @click="currentTab = 'system'">
          System Categories ({{ categoriesCount }})
        </button>
        <button class="px-4 py-1.5 text-xs font-semibold rounded-md transition-all"
          :class="currentTab === 'creator' ? 'bg-white dark:bg-gray-900 text-gray-900 dark:text-white shadow-xs' : 'text-gray-500 hover:text-gray-900 dark:hover:text-white'"
          @click="currentTab = 'creator'">
          All Creator Categories ({{ customCategoriesCount }})
        </button>
      </div>

      <!-- Search Bar -->
      <div class="w-full sm:w-72">
        <UInput v-model="query" icon="i-heroicons-magnifying-glass" placeholder="Search categories or creator..." size="sm"
          color="neutral" variant="outline" />
      </div>
    </div>

    <!-- Category Data Table -->
    <div class="overflow-x-auto">
      <table class="w-full text-left text-sm border-collapse">
        <thead>
          <tr
            class="border-b border-gray-200 dark:border-gray-800 bg-gray-50/50 dark:bg-gray-800/50 text-gray-500 dark:text-gray-400 uppercase text-[11px] font-semibold tracking-wider">
            <th class="py-3 px-4 sm:px-6">ID</th>
            <th class="py-3 px-4 sm:px-6">Preview Badge</th>
            <th class="py-3 px-4 sm:px-6">Category Name</th>
            <th v-if="currentTab === 'creator'" class="py-3 px-4 sm:px-6">Created By</th>
            <th class="py-3 px-4 sm:px-6">Created Date</th>
            <th class="py-3 px-4 sm:px-6 text-right">Actions</th>
          </tr>
        </thead>

        <!-- System Categories Tab -->
        <tbody v-if="currentTab === 'system'" class="divide-y divide-gray-100 dark:divide-gray-800">
          <tr v-if="isLoadingCategories" class="text-center">
            <td colspan="5" class="py-8 text-gray-500 dark:text-gray-400">
              <UIcon name="i-heroicons-arrow-path" class="w-6 h-6 animate-spin inline-block mr-2 text-primary" />
              Loading system categories...
            </td>
          </tr>

          <tr v-else-if="filteredSystemCategories.length === 0" class="text-center">
            <td colspan="5" class="py-10 text-gray-400 dark:text-gray-500">
              <UIcon name="i-heroicons-tag" class="w-8 h-8 mx-auto mb-2 opacity-50" />
              No categories found matching your query.
            </td>
          </tr>

          <tr v-for="cat in filteredSystemCategories" :key="cat.id"
            class="hover:bg-gray-50/80 dark:hover:bg-gray-800/40 transition-colors">
            <td class="py-3.5 px-4 sm:px-6 font-mono text-xs text-gray-500 dark:text-gray-400">
              #{{ cat.id }}
            </td>
            <td class="py-3.5 px-4 sm:px-6">
              <CategoryBadge :name="cat.name" size="md" />
            </td>
            <td class="py-3.5 px-4 sm:px-6 font-medium text-gray-900 dark:text-white">
              {{ cat.name }}
              <UBadge v-if="cat.id === 999" color="neutral" variant="soft" size="xs" class="ml-2">
                System Virtual
              </UBadge>
            </td>
            <td class="py-3.5 px-4 sm:px-6 text-xs text-gray-500 dark:text-gray-400">
              {{ formatDate(cat.createdAt) }}
            </td>
            <td class="py-3.5 px-4 sm:px-6 text-right">
              <div v-if="cat.id !== 999" class="flex items-center justify-end gap-1">
                <UButton icon="i-heroicons-pencil-square" color="neutral" variant="ghost" size="xs"
                  aria-label="Edit category" @click="emit('open-edit', cat)" />
                <UButton icon="i-heroicons-trash" color="error" variant="ghost" size="xs" aria-label="Delete category"
                  @click="emit('open-delete', cat)" />
              </div>
              <span v-else class="text-xs text-gray-400 italic">Protected</span>
            </td>
          </tr>
        </tbody>

        <!-- Creator Categories Tab (All Creators across platform) -->
        <tbody v-else class="divide-y divide-gray-100 dark:divide-gray-800">
          <tr v-if="isLoadingAllCustomCategories" class="text-center">
            <td colspan="6" class="py-8 text-gray-500 dark:text-gray-400">
              <UIcon name="i-heroicons-arrow-path" class="w-6 h-6 animate-spin inline-block mr-2 text-primary" />
              Loading creator custom categories...
            </td>
          </tr>

          <tr v-else-if="filteredCreatorCategories.length === 0" class="text-center">
            <td colspan="6" class="py-10 text-gray-400 dark:text-gray-500">
              <UIcon name="i-heroicons-user-group" class="w-8 h-8 mx-auto mb-2 opacity-50" />
              No custom creator categories found.
            </td>
          </tr>

          <tr v-for="cat in filteredCreatorCategories" :key="cat.id"
            class="hover:bg-gray-50/80 dark:hover:bg-gray-800/40 transition-colors">
            <td class="py-3.5 px-4 sm:px-6 font-mono text-xs text-gray-500 dark:text-gray-400">
              #{{ cat.id }}
            </td>
            <td class="py-3.5 px-4 sm:px-6">
              <CategoryBadge :name="cat.name" size="md" />
            </td>
            <td class="py-3.5 px-4 sm:px-6 font-medium text-gray-900 dark:text-white">
              {{ cat.name }}
            </td>
            <td class="py-3.5 px-4 sm:px-6 text-xs text-gray-700 dark:text-gray-300">
              <div class="flex items-center gap-1.5">
                <UIcon name="i-heroicons-user-circle" class="w-4 h-4 text-gray-400" />
                <span>{{ cat.userEmail || cat.username || cat.userId || 'Unknown Creator' }}</span>
              </div>
            </td>
            <td class="py-3.5 px-4 sm:px-6 text-xs text-gray-500 dark:text-gray-400">
              {{ formatDate(cat.createdAt) }}
            </td>
            <td class="py-3.5 px-4 sm:px-6 text-right">
              <UButton icon="i-heroicons-trash" color="error" variant="ghost" size="xs" aria-label="Delete custom category"
                @click="emit('open-delete-custom', cat)" />
            </td>
          </tr>
        </tbody>
      </table>
    </div>
  </div>
</template>
