<script setup lang="ts">
const props = defineProps<{
  adNetwork?: string
  adUnitCode?: string
}>()
</script>

<template>
  <div v-if="adUnitCode || adNetwork" class="rounded-2xl p-5 border shadow-xl space-y-3 bg-white dark:bg-gray-900 border-gray-200 dark:border-gray-800">
    <h4 class="text-xs font-mono uppercase tracking-wider font-bold text-amber-500 flex items-center gap-1.5">
      <UIcon name="i-heroicons-bolt" class="w-4 h-4 text-amber-500" />
      <span>Ad Network Integration</span>
    </h4>

    <div v-if="adNetwork"
      class="text-xs font-mono font-semibold text-gray-700 dark:text-gray-300 flex justify-between py-1 border-b border-gray-200 dark:border-gray-800">
      <span class="text-gray-500">Ad Network:</span>
      <span class="font-bold text-gray-900 dark:text-white">{{ adNetwork }}</span>
    </div>

    <div v-if="adUnitCode" class="space-y-1 pt-1">
      <span class="text-[10px] font-mono font-bold text-gray-500 block uppercase">Ad Unit Code:</span>
      <pre class="text-[11px] font-mono font-semibold p-2.5 rounded-xl bg-gray-900 border border-gray-800 text-primary overflow-x-auto">{{ adUnitCode }}</pre>
    </div>
  </div>
</template>
