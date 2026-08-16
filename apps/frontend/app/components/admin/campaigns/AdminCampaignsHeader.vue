<script setup lang="ts">
// Admin Campaign Oversight Header
</script>

<template>
  <div
    class="flex flex-col gap-4 border-b border-gray-200 pb-4 sm:flex-row sm:items-center sm:justify-between dark:border-gray-800">
    <div>
      <p class="text-xs font-semibold uppercase tracking-wider text-primary-600 dark:text-primary-400">Campaign
        oversight</p>
      <h1 class="mt-1 text-xl font-bold text-gray-900 dark:text-gray-100">Users &amp; published posts</h1>
      <p class="mt-1 text-sm text-gray-500 dark:text-gray-400">Review every user, their three latest public posts, and
        their complete campaign history.</p>
    </div>
    <UButton to="/creator/campaigns/create" color="primary" icon="i-heroicons-plus" size="sm">New Campaign</UButton>
  </div>
</template>
