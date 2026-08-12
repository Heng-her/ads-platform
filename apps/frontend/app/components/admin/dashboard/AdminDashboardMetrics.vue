<script setup lang="ts">
export interface AdminDashboardStats {
  users: { total: number; active: number; suspended: number; pending: number; newToday: number }
  campaigns: { total: number; public: number; draft: number; deleted: number; newToday: number }
  impressions: { total: number; uniqueViewers: number; last7Days: number }
  topCampaigns: { id: string; title: string; userId: string; totalImpressions: number; uniqueViewers: number }[]
  topCreators: { id: string; username: string; avatar: string | null; campaignCount: number }[]
  campaignsByCategory: { category: string; count: number }[]
  health?: { uptime: number; criticalAlerts: number }
}

defineProps<{
  isLoading: boolean
  stats: AdminDashboardStats | null
}>()

function formatNumber(num?: number): string {
  if (num === undefined || num === null) return '0'
  return new Intl.NumberFormat().format(num)
}
</script>

<template>
  <!-- Skeleton Loading State -->
  <div v-if="isLoading && !stats" class="grid gap-6 md:grid-cols-2 lg:grid-cols-4">
    <div v-for="i in 4" :key="i" class="h-32 animate-pulse rounded-xl border border-gray-800 bg-gray-900/60 p-6" />
  </div>

  <!-- Metric Cards Grid -->
  <div v-else-if="stats" class="grid gap-6 md:grid-cols-2 lg:grid-cols-4">
    <!-- Card 1: Total Platform Users -->
    <div
      class="relative overflow-hidden rounded-xl border border-gray-800 bg-gradient-to-br from-gray-900 via-gray-900 to-indigo-950/30 p-6 shadow-sm">
      <div class="flex items-center justify-between">
        <span class="text-xs font-semibold uppercase tracking-wider text-indigo-400">Total Users</span>
        <div class="flex h-9 w-9 items-center justify-center rounded-lg bg-indigo-500/10 text-indigo-400">
          <UIcon name="i-heroicons-users" class="h-5 w-5" />
        </div>
      </div>
      <div class="mt-3 flex items-baseline gap-2">
        <span class="text-3xl font-bold tracking-tight text-white">{{ formatNumber(stats.users.total) }}</span>
        <span v-if="stats.users.newToday > 0" class="text-xs font-semibold text-emerald-400">
          +{{ stats.users.newToday }} today
        </span>
      </div>
      <div class="mt-4 flex items-center justify-between border-t border-gray-800/80 pt-3 text-xs text-gray-400">
        <span>Active: <strong class="text-emerald-400">{{ formatNumber(stats.users.active) }}</strong></span>
        <span>Pending: <strong class="text-amber-400">{{ formatNumber(stats.users.pending) }}</strong></span>
        <span>Suspended: <strong class="text-red-400">{{ formatNumber(stats.users.suspended) }}</strong></span>
      </div>
    </div>

    <!-- Card 2: Total Campaigns -->
    <div
      class="relative overflow-hidden rounded-xl border border-gray-800 bg-gradient-to-br from-gray-900 via-gray-900 to-emerald-950/30 p-6 shadow-sm">
      <div class="flex items-center justify-between">
        <span class="text-xs font-semibold uppercase tracking-wider text-emerald-400">Total Campaigns</span>
        <div class="flex h-9 w-9 items-center justify-center rounded-lg bg-emerald-500/10 text-emerald-400">
          <UIcon name="i-heroicons-megaphone" class="h-5 w-5" />
        </div>
      </div>
      <div class="mt-3 flex items-baseline gap-2">
        <span class="text-3xl font-bold tracking-tight text-white">{{ formatNumber(stats.campaigns.total) }}</span>
        <span v-if="stats.campaigns.newToday > 0" class="text-xs font-semibold text-emerald-400">
          +{{ stats.campaigns.newToday }} today
        </span>
      </div>
      <div class="mt-4 flex items-center justify-between border-t border-gray-800/80 pt-3 text-xs text-gray-400">
        <span>Public: <strong class="text-emerald-400">{{ formatNumber(stats.campaigns.public) }}</strong></span>
        <span>Draft: <strong class="text-gray-300">{{ formatNumber(stats.campaigns.draft) }}</strong></span>
        <span>Deleted: <strong class="text-gray-500">{{ formatNumber(stats.campaigns.deleted) }}</strong></span>
      </div>
    </div>

    <!-- Card 3: Total Impressions & Viewers -->
    <div
      class="relative overflow-hidden rounded-xl border border-gray-800 bg-gradient-to-br from-gray-900 via-gray-900 to-sky-950/30 p-6 shadow-sm">
      <div class="flex items-center justify-between">
        <span class="text-xs font-semibold uppercase tracking-wider text-sky-400">Total Impressions</span>
        <div class="flex h-9 w-9 items-center justify-center rounded-lg bg-sky-500/10 text-sky-400">
          <UIcon name="i-heroicons-chart-bar" class="h-5 w-5" />
        </div>
      </div>
      <div class="mt-3 flex items-baseline gap-2">
        <span class="text-3xl font-bold tracking-tight text-white">{{ formatNumber(stats.impressions.total) }}</span>
      </div>
      <div class="mt-4 flex items-center justify-between border-t border-gray-800/80 pt-3 text-xs text-gray-400">
        <span>Unique Reach: <strong class="text-sky-300">{{ formatNumber(stats.impressions.uniqueViewers)
            }}</strong></span>
        <span>7-Day: <strong class="text-sky-400">{{ formatNumber(stats.impressions.last7Days) }}</strong></span>
      </div>
    </div>

    <!-- Card 4: Platform Health & Approvals Queue -->
    <div
      class="relative overflow-hidden rounded-xl border border-gray-800 bg-gradient-to-br from-gray-900 via-gray-900 to-amber-950/30 p-6 shadow-sm">
      <div class="flex items-center justify-between">
        <span class="text-xs font-semibold uppercase tracking-wider text-amber-400">Platform Health</span>
        <div class="flex h-9 w-9 items-center justify-center rounded-lg bg-amber-500/10 text-amber-400">
          <UIcon name="i-heroicons-shield-check" class="h-5 w-5" />
        </div>
      </div>
      <div class="mt-3 flex items-baseline gap-2">
        <span class="text-3xl font-bold tracking-tight text-emerald-400">
          {{ stats.health?.uptime ?? 0 }}%
        </span>
        <span class="text-xs text-gray-400">Uptime</span>
      </div>
      <div class="mt-4 flex items-center justify-between border-t border-gray-800/80 pt-3 text-xs text-gray-400">
        <span>Pending Users: <strong class="text-amber-400">{{ formatNumber(stats.users.pending) }}</strong></span>
        <span>Security Alerts:
          <strong :class="(stats.health?.criticalAlerts ?? 0) > 0 ? 'text-red-400' : 'text-emerald-400'">
            {{ stats.health?.criticalAlerts ?? 0 }} Critical
          </strong>
        </span>
      </div>
    </div>
  </div>
</template>
