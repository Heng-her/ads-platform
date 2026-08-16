<script setup lang="ts">
defineProps<{
  systemCount: number
  creatorCount: number
}>()
</script>

<template>
  <div class="grid grid-cols-1 sm:grid-cols-3 gap-4">
    <div
      class="bg-white dark:bg-gray-900 p-5 rounded-xl border border-gray-200 dark:border-gray-800 flex items-center gap-4">
      <div class="p-3 rounded-lg bg-blue-500/10 text-blue-600 dark:text-blue-400">
        <UIcon name="i-heroicons-globe-alt" class="w-6 h-6" />
      </div>
      <div>
        <p class="text-xs font-medium text-gray-500 dark:text-gray-400">System Categories</p>
        <p class="text-2xl font-bold text-gray-900 dark:text-white">{{ systemCount }}</p>
      </div>
    </div>

    <div
      class="bg-white dark:bg-gray-900 p-5 rounded-xl border border-gray-200 dark:border-gray-800 flex items-center gap-4">
      <div class="p-3 rounded-lg bg-purple-500/10 text-purple-600 dark:text-purple-400">
        <UIcon name="i-heroicons-user-group" class="w-6 h-6" />
      </div>
      <div>
        <p class="text-xs font-medium text-gray-500 dark:text-gray-400">All Creator Categories</p>
        <p class="text-2xl font-bold text-gray-900 dark:text-white">{{ creatorCount }}</p>
      </div>
    </div>

    <div
      class="bg-white dark:bg-gray-900 p-5 rounded-xl border border-gray-200 dark:border-gray-800 flex items-center gap-4">
      <div class="p-3 rounded-lg bg-amber-500/10 text-amber-600 dark:text-amber-400">
        <UIcon name="i-heroicons-check-circle" class="w-6 h-6" />
      </div>
      <div>
        <p class="text-xs font-medium text-gray-500 dark:text-gray-400">Status</p>
        <p class="text-base font-bold text-emerald-600 dark:text-emerald-400 flex items-center gap-1">
          <span class="w-2 h-2 rounded-full bg-emerald-500 animate-pulse"></span>
          Global Sync Active
        </p>
      </div>
    </div>
  </div>
</template>
