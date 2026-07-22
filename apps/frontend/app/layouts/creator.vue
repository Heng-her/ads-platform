<script setup lang="ts">
const creatorNav = [
  { label: 'Dashboard', icon: 'i-heroicons-squares-2x2', to: '/creator' },
  { label: 'Campaigns', icon: 'i-heroicons-megaphone', to: '/creator/campaigns' },
  { label: 'Analytics', icon: 'i-heroicons-chart-bar', to: '/creator/analytics' },
  { label: 'Earnings', icon: 'i-heroicons-banknotes', to: '/creator/earnings' },
  { label: 'Settings', icon: 'i-heroicons-cog-6-tooth', to: '/creator/settings' },
]
</script>

<template>
  <div class="min-h-screen flex bg-gray-50 dark:bg-gray-950">
    <!-- Creator Sidebar -->
    <aside class="w-64 border-r border-gray-200 dark:border-gray-800 bg-white dark:bg-gray-900 p-4 flex flex-col">
      <div class="mb-6 flex items-center gap-2 px-2">
        <UIcon name="i-heroicons-sparkles" class="w-6 h-6 text-amber-500" />
        <span class="font-bold text-lg">Creator Studio</span>
      </div>

      <nav class="flex-1 space-y-1">
        <NuxtLink v-for="item in creatorNav" :key="item.to" :to="item.to"
          class="flex items-center gap-3 px-3 py-2 text-sm font-medium rounded-md text-gray-700 dark:text-gray-200 hover:bg-amber-50 dark:hover:bg-amber-950/40 hover:text-amber-600 dark:hover:text-amber-400 transition-colors"
          active-class="bg-amber-50 dark:bg-amber-950/60 text-amber-600 dark:text-amber-400 font-semibold">
          <UIcon :name="item.icon" class="w-5 h-5" />
          {{ item.label }}
        </NuxtLink>
      </nav>

      <div class="border-t border-gray-200 dark:border-gray-800 pt-4 px-2 flex items-center justify-between">
        <NuxtLink to="/" class="text-xs text-gray-500 hover:underline">
          ← Public Site
        </NuxtLink>
        <UColorModeButton />
      </div>
    </aside>

    <!-- Workspace Main Content -->
    <div class="flex-1 flex flex-col">
      <!-- Creator Header -->
      <header
        class="h-16 border-b border-gray-200 dark:border-gray-800 px-6 flex items-center justify-between bg-white dark:bg-gray-900">
        <h2 class="text-lg font-semibold text-gray-900 dark:text-gray-100">Creator Workspace</h2>
        <div class="flex items-center gap-3">
          <UButton icon="i-heroicons-bell" color="neutral" variant="ghost" />
          <UButton to="/admin" color="neutral" variant="subtle" size="xs">Switch to Admin</UButton>
          <UAvatar alt="Creator User" size="sm" />
        </div>
      </header>

      <main class="flex-1 p-6">
        <slot />
      </main>
    </div>
  </div>
</template>
