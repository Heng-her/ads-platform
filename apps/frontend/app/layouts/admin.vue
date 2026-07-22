<script setup lang="ts">
const adminNav = [
  { label: 'Overview', icon: 'i-heroicons-chart-pie', to: '/admin' },
  { label: 'Users & Roles', icon: 'i-heroicons-users', to: '/admin/users' },
  { label: 'Approvals', icon: 'i-heroicons-check-badge', to: '/admin/approvals' },
  { label: 'System Logs', icon: 'i-heroicons-document-text', to: '/admin/logs' },
  { label: 'Settings', icon: 'i-heroicons-adjustments-horizontal', to: '/admin/settings' },
]
</script>

<template>
  <div class="min-h-screen flex bg-gray-950 text-gray-100">
    <!-- Admin Sidebar -->
    <aside class="w-64 border-r border-gray-800 bg-gray-900 p-4 flex flex-col">
      <div class="mb-6 flex items-center gap-2 px-2">
        <UIcon name="i-heroicons-shield-check" class="w-6 h-6 text-red-500" />
        <span class="font-bold text-lg tracking-wide">Admin Control</span>
      </div>

      <nav class="flex-1 space-y-1">
        <NuxtLink v-for="item in adminNav" :key="item.to" :to="item.to"
          class="flex items-center gap-3 px-3 py-2 text-sm font-medium rounded-md text-gray-300 hover:bg-gray-800 hover:text-white transition-colors"
          active-class="bg-red-500/20 text-red-400 font-semibold border-l-2 border-red-500">
          <UIcon :name="item.icon" class="w-5 h-5" />
          {{ item.label }}
        </NuxtLink>
      </nav>

      <div class="border-t border-gray-800 pt-4 px-2 flex items-center justify-between text-xs text-gray-400">
        <NuxtLink to="/" class="hover:underline">Exit Admin</NuxtLink>
        <UColorModeButton />
      </div>
    </aside>

    <!-- Admin Content Area -->
    <div class="flex-1 flex flex-col">
      <header class="h-16 border-b border-gray-800 px-6 flex items-center justify-between bg-gray-900">
        <div class="flex items-center gap-2">
          <UBadge color="error" variant="soft">System Admin Mode</UBadge>
        </div>
        <div class="flex items-center gap-4">
          <UButton to="/creator" color="neutral" variant="subtle" size="xs">Switch to Creator</UButton>
          <UButton icon="i-heroicons-cog-8-tooth" color="neutral" variant="ghost" />
          <UAvatar alt="Admin User" size="sm" />
        </div>
      </header>

      <main class="flex-1 p-6 bg-gray-950">
        <slot />
      </main>
    </div>
  </div>
</template>
