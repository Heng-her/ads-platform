<script setup lang="ts">
import { useSidebar } from '~/composables/useSidebar'

const adminNav = [
  { label: 'Overview', icon: 'i-heroicons-chart-pie', to: '/admin' },
  { label: 'Campaigns', icon: 'i-heroicons-megaphone', to: '/admin/campaigns' },
  { label: 'Users & Roles', icon: 'i-heroicons-users', to: '/admin/users' },
  { label: 'Approvals', icon: 'i-heroicons-check-badge', to: '/admin/approvals' },
  { label: 'System Logs', icon: 'i-heroicons-document-text', to: '/admin/logs' },
  { label: 'Settings', icon: 'i-heroicons-adjustments-horizontal', to: '/admin/settings' }
]

const { isMobileOpen } = useSidebar()
</script>

<template>
  <div class="min-h-screen flex bg-gray-50 dark:bg-gray-950 text-gray-900 dark:text-gray-100">
    <!-- Admin Sidebar (Desktop/Tablet) -->
    <AppSidebar
      :links="adminNav"
      role="admin"
      title="Admin Control"
      icon="i-heroicons-shield-check"
      icon-class="text-red-500"
    />

    <!-- Admin Content Area -->
    <div class="flex-1 flex flex-col min-w-0">
      <AppHeader class="bg-white dark:bg-gray-900 border-b border-gray-200 dark:border-gray-800 text-gray-900 dark:text-gray-100">
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
          <UBadge
            color="error"
            variant="soft"
            class="font-semibold"
          >
            System Admin Mode
          </UBadge>
        </template>

        <template #right>
          <UButton
            to="/creator"
            color="neutral"
            variant="subtle"
            size="xs"
            class="hidden sm:inline-flex"
          >
            Switch to Creator
          </UButton>
          <UserMenu role="admin" />
        </template>
      </AppHeader>

      <main class="flex-1 p-6 bg-gray-50 dark:bg-gray-950 overflow-y-auto">
        <slot />
      </main>
    </div>


    <!-- Mobile Drawer -->
    <MobileDrawer
      v-model:open="isMobileOpen"
      side="left"
      title="Admin Control"
      icon="i-heroicons-shield-check"
      icon-class="text-red-500"
      :links="adminNav"
      role="admin"
    />
  </div>
</template>
