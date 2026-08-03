<script setup lang="ts">
const props = defineProps<{
  totalImpressions?: number
  uniqueViewers?: number
}>()
</script>

<template>
  <div class="rounded-2xl p-5 border shadow-xl bg-white dark:bg-gray-900 border-gray-200 dark:border-gray-800">
    <h4 class="text-xs font-mono uppercase tracking-wider font-bold text-gray-600 dark:text-gray-300 mb-4 flex items-center justify-between">
      <span>Performance Stats</span>
      <UIcon name="i-heroicons-chart-bar" class="w-4 h-4 text-primary" />
    </h4>

    <div class="grid grid-cols-2 gap-3">
      <div class="p-3.5 rounded-xl bg-gray-50 dark:bg-gray-800/80 border border-gray-200 dark:border-gray-700 text-center">
        <span class="text-xs font-mono font-semibold text-gray-600 dark:text-gray-400 block mb-1">Impressions</span>
        <span class="font-display font-extrabold text-lg text-primary">
          {{ (totalImpressions ?? 0).toLocaleString() }}
        </span>
      </div>

      <div class="p-3.5 rounded-xl bg-gray-50 dark:bg-gray-800/80 border border-gray-200 dark:border-gray-700 text-center">
        <span class="text-xs font-mono font-semibold text-gray-600 dark:text-gray-400 block mb-1">Unique Viewers</span>
        <span class="font-display font-extrabold text-lg text-sky-600 dark:text-sky-400">
          {{ (uniqueViewers ?? 0).toLocaleString() }}
        </span>
      </div>
    </div>
  </div>
</template>
