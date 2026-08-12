<script setup lang="ts">
export interface CategoryCountItem {
  category: string
  count: number
}

const props = defineProps<{
  campaignsByCategory: CategoryCountItem[]
  totalCampaigns: number
}>()

function formatNumber(num?: number): string {
  if (num === undefined || num === null) return '0'
  return new Intl.NumberFormat().format(num)
}

function calculateCategoryPercent(count: number): number {
  if (!props.totalCampaigns) return 0
  return Math.round((count / props.totalCampaigns) * 100)
}
</script>

<template>
  <div class="rounded-xl border border-gray-800 bg-gray-900 p-6 shadow-sm">
    <div class="flex items-center justify-between border-b border-gray-800 pb-4">
      <div class="flex items-center gap-2">
        <UIcon name="i-heroicons-rectangle-group" class="h-5 w-5 text-indigo-400" />
        <h2 class="text-lg font-semibold text-white">Campaign Distribution by Category</h2>
      </div>
    </div>

    <div v-if="campaignsByCategory.length === 0" class="py-8 text-center text-sm text-gray-500">
      No category metrics available.
    </div>

    <div v-else class="mt-6 space-y-4">
      <div v-for="cat in campaignsByCategory" :key="cat.category" class="space-y-1.5">
        <div class="flex items-center justify-between text-xs font-medium">
          <span class="text-gray-300">{{ cat.category }}</span>
          <span class="text-gray-400 font-mono">
            {{ formatNumber(cat.count) }} campaigns ({{ calculateCategoryPercent(cat.count) }}%)
          </span>
        </div>
        <div class="h-2.5 w-full overflow-hidden rounded-full bg-gray-800">
          <div
            class="h-full rounded-full bg-gradient-to-r from-primary-500 to-indigo-500 transition-all duration-500"
            :style="{ width: `${calculateCategoryPercent(cat.count)}%` }"
          />
        </div>
      </div>
    </div>
  </div>
</template>
