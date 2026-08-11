<script setup lang="ts">
const emit = defineEmits<{
  (e: 'clear-all'): void
}>()
</script>

<template>
  <div
    class="rounded-2xl p-12 flex flex-col items-center text-center gap-3 border border-dashed bg-white dark:bg-gray-900 border-gray-200 dark:border-gray-800"
  >
    <div
      class="h-12 w-12 rounded-2xl flex items-center justify-center bg-gray-100 dark:bg-gray-800 text-gray-500"
    >
      <UIcon name="i-heroicons-magnifying-glass" class="w-6 h-6 text-primary" />
    </div>
    <p class="font-bold text-base text-gray-900 dark:text-white">
      No campaigns match your search query
    </p>
    <p class="text-xs font-medium text-gray-600 dark:text-gray-400 max-w-sm">
      Try adjusting your filters, category parameters, or keyword terms.
    </p>
    <UButton @click="emit('clear-all')" color="neutral" variant="subtle" size="xs">
      Reset Filters
    </UButton>
  </div>
</template>
