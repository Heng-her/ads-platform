<script setup lang="ts">
withDefaults(
  defineProps<{
    count?: number
  }>(),
  {
    count: 3,
  }
)
</script>

<template>
  <div class="space-y-6">
    <!-- Spotlight Card Skeleton -->
    <div
      class="rounded-2xl p-6 border animate-pulse space-y-4 bg-white dark:bg-gray-900 border-gray-200 dark:border-gray-800"
    >
      <div class="flex items-center gap-3">
        <div class="h-8 w-8 rounded-xl bg-gray-200 dark:bg-gray-800" />
        <div class="h-4 w-32 rounded bg-gray-200 dark:bg-gray-800" />
      </div>
      <div class="h-6 w-3/4 rounded bg-gray-200 dark:bg-gray-800" />
      <div class="h-4 w-full rounded bg-gray-200 dark:bg-gray-800" />
      <div class="h-4 w-5/6 rounded bg-gray-200 dark:bg-gray-800" />
    </div>

    <!-- Campaign List Skeleton Items -->
    <div
      v-for="n in count"
      :key="n"
      class="rounded-2xl p-5 border animate-pulse flex gap-4 bg-white dark:bg-gray-900 border-gray-200 dark:border-gray-800"
    >
      <div class="flex-1 space-y-2">
        <div class="h-3 w-28 rounded bg-gray-200 dark:bg-gray-800" />
        <div class="h-4 w-2/3 rounded bg-gray-200 dark:bg-gray-800" />
        <div class="h-3 w-full rounded bg-gray-200 dark:bg-gray-800" />
      </div>
      <div class="h-16 w-16 rounded-xl bg-gray-200 dark:bg-gray-800 shrink-0" />
    </div>
  </div>
</template>
