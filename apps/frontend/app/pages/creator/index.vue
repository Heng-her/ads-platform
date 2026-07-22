<script setup lang="ts">
definePageMeta({
  layout: 'creator'
})
</script>

<template>
  <div class="space-y-6">
    <div class="flex items-center justify-between">
      <h1 class="text-2xl font-bold">Creator Dashboard</h1>
      <UButton icon="i-heroicons-plus" color="primary">Create Campaign</UButton>
    </div>

    <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
      <UCard>
        <template #header>
          <span class="text-sm font-medium text-gray-500">Active Ads</span>
        </template>
        <p class="text-3xl font-extrabold">12</p>
      </UCard>

      <UCard>
        <template #header>
          <span class="text-sm font-medium text-gray-500">Total Impressions</span>
        </template>
        <p class="text-3xl font-extrabold text-emerald-600 dark:text-emerald-400">148.5K</p>
      </UCard>

      <UCard>
        <template #header>
          <span class="text-sm font-medium text-gray-500">Estimated Revenue</span>
        </template>
        <p class="text-3xl font-extrabold text-amber-600 dark:text-amber-400">$3,420.00</p>
      </UCard>
    </div>
  </div>
</template>
