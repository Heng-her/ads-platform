<script setup lang="ts">
import { useSidebar } from '~/composables/useSidebar'

const creatorNav = [
  { label: 'Dashboard', icon: 'i-heroicons-squares-2x2', to: '/creator' },
  { label: 'Campaigns', icon: 'i-heroicons-megaphone', to: '/creator/campaigns' },
  { label: 'Analytics', icon: 'i-heroicons-chart-bar', to: '/creator/analytics' },
  { label: 'Earnings', icon: 'i-heroicons-banknotes', to: '/creator/earnings' },
  { label: 'Settings', icon: 'i-heroicons-cog-6-tooth', to: '/creator/settings' }
]

const { isMobileOpen } = useSidebar()
</script>

<template>
  <div class="min-h-screen flex bg-gray-50 dark:bg-gray-950 text-gray-900 dark:text-gray-100">
    <!-- Creator Sidebar (Desktop/Tablet) -->
    <AppSidebar
      :links="creatorNav"
      role="creator"
      title="Creator Studio"
      icon="i-heroicons-sparkles"
      icon-class="text-amber-500"
    />

    <!-- Workspace Main Content -->
    <div class="flex-1 flex flex-col min-w-0">
      <!-- Creator Header -->
      <AppHeader class="bg-white dark:bg-gray-900 border-b border-gray-200 dark:border-gray-800">
        <template #left>
          <!-- Mobile Sidebar Toggle -->
          <UButton
            icon="i-heroicons-bars-3"
            color="neutral"
            variant="ghost"
            class="md:hidden"
            aria-label="Open navigation"
            @click="isMobileOpen = true"
          />
          <h2 class="text-base sm:text-lg font-semibold text-gray-900 dark:text-gray-100 truncate">
            Creator Workspace
          </h2>
        </template>

        <template #right>
          <div class="flex items-center gap-3">
            <UButton
              icon="i-heroicons-bell"
              color="neutral"
              variant="ghost"
              aria-label="Notifications"
            />
            <UButton
              to="/admin"
              color="neutral"
              variant="subtle"
              size="xs"
              class="hidden sm:inline-flex"
            >
              Switch to Admin
            </UButton>
            <UserMenu role="creator" />
          </div>
        </template>
      </AppHeader>

      <main class="flex-1 p-6">
        <slot />
      </main>
    </div>

    <!-- Mobile Drawer -->
    <MobileDrawer
      v-model:open="isMobileOpen"
      side="left"
      title="Creator Studio"
      icon="i-heroicons-sparkles"
      icon-class="text-amber-500"
      :links="creatorNav"
      role="creator"
    />
  </div>
</template>
