<script setup lang="ts">
defineEmits<{
  (e: 'open-add'): void
}>()
</script>

<template>
  <div
    class="flex flex-col sm:flex-row sm:items-center justify-between gap-4 bg-white dark:bg-gray-900 p-6 rounded-2xl border border-gray-200 dark:border-gray-800 shadow-xs">
    <div>
      <div class="flex items-center gap-2">
        <UIcon name="i-heroicons-tag" class="w-7 h-7 text-primary" />
        <h1 class="text-2xl font-bold tracking-tight text-gray-900 dark:text-white">
          Category Management
        </h1>
      </div>
      <p class="mt-1 text-sm text-gray-500 dark:text-gray-400">
        Manage system-wide campaign categories and review all custom categories created by platform creators.
      </p>
    </div>

    <div class="flex items-center gap-3">
      <UButton color="primary" variant="solid" icon="i-heroicons-plus" size="md" class="font-semibold shadow-xs"
        @click="$emit('open-add')">
        Add System Category
      </UButton>
    </div>
  </div>
</template>
