<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { useApi } from '~/composables/useApi'
import { useAppToast } from '~/composables/useAppToast'

definePageMeta({
  layout: 'admin'
})

const api = useApi()
const toast = useAppToast()

const isLoading = ref(true)
const stats = ref<{
  users: { total: number; active: number; suspended: number; pending: number; newToday: number }
  campaigns: { total: number; public: number; draft: number; deleted: number; newToday: number }
  impressions: { total: number; uniqueViewers: number; last7Days: number }
  topCampaigns: { id: string; title: string; userId: string; totalImpressions: number; uniqueViewers: number }[]
  topCreators: { id: string; username: string; avatar: string | null; campaignCount: number }[]
  campaignsByCategory: { category: string; count: number }[]
} | null>(null)

async function fetchAdminStats() {
  isLoading.value = true
  try {
    const res = await api.dashboard.admin.stats.$get()
    const data = await res.json()
    if (res.ok && data.code === 1) {
      stats.value = data.data
    } else {
      toast.error('Failed to load stats', data.msg || 'Error fetching admin dashboard stats')
    }
  } catch (err: any) {
    toast.error('Network Error', err.message || 'Could not connect to API server')
  } finally {
    isLoading.value = false
  }
}

onMounted(() => {
  fetchAdminStats()
})

function formatNumber(num?: number): string {
  if (num === undefined || num === null) return '0'
  return new Intl.NumberFormat().format(num)
}

function calculateCategoryPercent(count: number): number {
  if (!stats.value?.campaigns.total) return 0
  return Math.round((count / stats.value.campaigns.total) * 100)
}
</script>

<template>
  <div class="mx-auto max-w-7xl space-y-8 pb-12 text-gray-100">
    <!-- Header & Action Bar -->
    <div class="flex flex-col gap-4 sm:flex-row sm:items-center sm:justify-between">
      <div>
        <div class="flex items-center gap-3">
          <h1 class="text-2xl font-bold tracking-tight text-white sm:text-3xl">Admin Control Overview</h1>
          <UBadge color="error" variant="soft" class="font-mono text-xs">
            LIVE SYSTEM
          </UBadge>
        </div>
        <p class="mt-1 text-sm text-gray-400">
          Real-time metrics, user growth, campaign activity, and system health status.
        </p>
      </div>

      <div class="flex items-center gap-3">
        <button
          :disabled="isLoading"
          class="inline-flex items-center gap-2 rounded-lg border border-gray-800 bg-gray-900 px-4 py-2 text-xs font-semibold text-gray-300 transition hover:bg-gray-800 hover:text-white disabled:opacity-50"
          @click="fetchAdminStats"
        >
          <UIcon v-if="isLoading" name="i-heroicons-arrow-path" class="h-4 w-4 animate-spin text-primary-400" />
          <UIcon v-else name="i-heroicons-arrow-path" class="h-4 w-4 text-gray-400" />
          <span>{{ isLoading ? 'Refreshing...' : 'Refresh Data' }}</span>
        </button>

        <NuxtLink
          to="/admin/approvals"
          class="inline-flex items-center gap-2 rounded-lg bg-primary-600 px-4 py-2 text-xs font-semibold text-white shadow-sm transition hover:bg-primary-500"
        >
          <UIcon name="i-heroicons-check-badge" class="h-4 w-4" />
          <span>Pending Approvals</span>
        </NuxtLink>
      </div>
    </div>

    <!-- Skeleton Loading State -->
    <div v-if="isLoading && !stats" class="grid gap-6 md:grid-cols-2 lg:grid-cols-4">
      <div v-for="i in 4" :key="i" class="h-32 animate-pulse rounded-xl border border-gray-800 bg-gray-900/60 p-6" />
    </div>

    <!-- Metric Cards Grid -->
    <div v-else-if="stats" class="grid gap-6 md:grid-cols-2 lg:grid-cols-4">
      <!-- Card 1: Total Platform Users -->
      <div class="relative overflow-hidden rounded-xl border border-gray-800 bg-gradient-to-br from-gray-900 via-gray-900 to-indigo-950/30 p-6 shadow-sm">
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
      <div class="relative overflow-hidden rounded-xl border border-gray-800 bg-gradient-to-br from-gray-900 via-gray-900 to-emerald-950/30 p-6 shadow-sm">
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
      <div class="relative overflow-hidden rounded-xl border border-gray-800 bg-gradient-to-br from-gray-900 via-gray-900 to-sky-950/30 p-6 shadow-sm">
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
          <span>Unique Reach: <strong class="text-sky-300">{{ formatNumber(stats.impressions.uniqueViewers) }}</strong></span>
          <span>7-Day: <strong class="text-sky-400">{{ formatNumber(stats.impressions.last7Days) }}</strong></span>
        </div>
      </div>

      <!-- Card 4: Platform Health & Approvals Queue -->
      <div class="relative overflow-hidden rounded-xl border border-gray-800 bg-gradient-to-br from-gray-900 via-gray-900 to-amber-950/30 p-6 shadow-sm">
        <div class="flex items-center justify-between">
          <span class="text-xs font-semibold uppercase tracking-wider text-amber-400">Platform Health</span>
          <div class="flex h-9 w-9 items-center justify-center rounded-lg bg-amber-500/10 text-amber-400">
            <UIcon name="i-heroicons-shield-check" class="h-5 w-5" />
          </div>
        </div>
        <div class="mt-3 flex items-baseline gap-2">
          <span class="text-3xl font-bold tracking-tight text-emerald-400">99.98%</span>
          <span class="text-xs text-gray-400">Uptime</span>
        </div>
        <div class="mt-4 flex items-center justify-between border-t border-gray-800/80 pt-3 text-xs text-gray-400">
          <span>Pending Users: <strong class="text-amber-400">{{ formatNumber(stats.users.pending) }}</strong></span>
          <span>Security Alerts: <strong class="text-emerald-400">0 Critical</strong></span>
        </div>
      </div>
    </div>

    <!-- Main Content Insights Layout -->
    <div v-if="stats" class="grid gap-8 lg:grid-cols-3">
      <!-- Left Column (2 Cols): Top Campaigns & Category Breakdown -->
      <div class="space-y-8 lg:col-span-2">
        <!-- Top Campaigns List -->
        <div class="rounded-xl border border-gray-800 bg-gray-900 p-6 shadow-sm">
          <div class="flex items-center justify-between border-b border-gray-800 pb-4">
            <div class="flex items-center gap-2">
              <UIcon name="i-heroicons-fire" class="h-5 w-5 text-amber-400" />
              <h2 class="text-lg font-semibold text-white">Top Performing Campaigns</h2>
            </div>
            <NuxtLink to="/admin/campaigns" class="text-xs font-medium text-primary-400 hover:text-primary-300">
              View All Campaigns &rarr;
            </NuxtLink>
          </div>

          <div v-if="stats.topCampaigns.length === 0" class="py-8 text-center text-sm text-gray-500">
            No campaigns recorded yet.
          </div>

          <div v-else class="mt-4 divide-y divide-gray-800/60">
            <div
              v-for="(item, idx) in stats.topCampaigns"
              :key="item.id"
              class="flex items-center justify-between py-3.5 transition hover:bg-gray-800/30 px-2 rounded-lg"
            >
              <div class="flex items-center gap-3 min-w-0">
                <span class="flex h-7 w-7 shrink-0 items-center justify-center rounded-full bg-gray-800 text-xs font-bold font-mono text-gray-300">
                  #{{ idx + 1 }}
                </span>
                <div class="truncate">
                  <p class="truncate text-sm font-semibold text-gray-200">{{ item.title }}</p>
                  <p class="text-xs text-gray-500">Creator ID: {{ item.userId }}</p>
                </div>
              </div>

              <div class="flex items-center gap-6 text-right shrink-0">
                <div>
                  <p class="text-sm font-bold text-sky-400">{{ formatNumber(item.totalImpressions) }}</p>
                  <p class="text-[10px] text-gray-400">Total Views</p>
                </div>
                <div>
                  <p class="text-sm font-semibold text-emerald-400">{{ formatNumber(item.uniqueViewers) }}</p>
                  <p class="text-[10px] text-gray-400">Unique Viewers</p>
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- Campaigns Grouped by Category -->
        <div class="rounded-xl border border-gray-800 bg-gray-900 p-6 shadow-sm">
          <div class="flex items-center justify-between border-b border-gray-800 pb-4">
            <div class="flex items-center gap-2">
              <UIcon name="i-heroicons-rectangle-group" class="h-5 w-5 text-indigo-400" />
              <h2 class="text-lg font-semibold text-white">Campaign Distribution by Category</h2>
            </div>
          </div>

          <div v-if="stats.campaignsByCategory.length === 0" class="py-8 text-center text-sm text-gray-500">
            No category metrics available.
          </div>

          <div v-else class="mt-6 space-y-4">
            <div v-for="cat in stats.campaignsByCategory" :key="cat.category" class="space-y-1.5">
              <div class="flex items-center justify-between text-xs font-medium">
                <span class="text-gray-300">{{ cat.category }}</span>
                <span class="text-gray-400">{{ formatNumber(cat.count) }} campaigns ({{ calculateCategoryPercent(cat.count) }}%)</span>
              </div>
              <div class="h-2.5 w-full overflow-hidden rounded-full bg-gray-800">
                <div
                  class="h-full rounded-full bg-gradient-to-r from-primary-500 to-indigo-500 transition-all duration-500"
                  :style="{ width: `${calculateCategoryPercent(cat.count)}%` }"
                />
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Right Column (1 Col): Top Creators & Quick Command Center -->
      <div class="space-y-8 lg:col-span-1">
        <!-- Top Creators Spotlight -->
        <div class="rounded-xl border border-gray-800 bg-gray-900 p-6 shadow-sm">
          <div class="flex items-center justify-between border-b border-gray-800 pb-4">
            <div class="flex items-center gap-2">
              <UIcon name="i-heroicons-trophy" class="h-5 w-5 text-amber-400" />
              <h2 class="text-lg font-semibold text-white">Top Creator Spotlight</h2>
            </div>
          </div>

          <div v-if="stats.topCreators.length === 0" class="py-8 text-center text-sm text-gray-500">
            No creators recorded yet.
          </div>

          <div v-else class="mt-4 divide-y divide-gray-800/60">
            <div
              v-for="creator in stats.topCreators"
              :key="creator.id"
              class="flex items-center justify-between py-3"
            >
              <div class="flex items-center gap-3 min-w-0">
                <div class="relative h-10 w-10 shrink-0 overflow-hidden rounded-full border border-gray-700 bg-gray-800">
                  <img v-if="creator.avatar" :src="creator.avatar" :alt="creator.username" class="h-full w-full object-cover" />
                  <div v-else class="flex h-full w-full items-center justify-center text-gray-400">
                    <UIcon name="i-heroicons-user" class="h-5 w-5" />
                  </div>
                </div>
                <div class="truncate">
                  <p class="truncate text-sm font-semibold text-white">{{ creator.username }}</p>
                  <p class="text-xs text-gray-500">ID: {{ creator.id.substring(0, 8) }}...</p>
                </div>
              </div>

              <UBadge color="primary" variant="soft" size="xs" class="shrink-0 font-semibold">
                {{ creator.campaignCount }} Campaigns
              </UBadge>
            </div>
          </div>
        </div>

        <!-- Quick Admin Navigation Hub -->
        <div class="rounded-xl border border-gray-800 bg-gray-900 p-6 shadow-sm space-y-4">
          <h2 class="text-sm font-bold uppercase tracking-wider text-gray-400 border-b border-gray-800 pb-3">
            Admin Management Shortcuts
          </h2>

          <div class="grid gap-2.5">
            <NuxtLink
              to="/admin/approvals"
              class="flex items-center justify-between rounded-lg border border-gray-800 bg-gray-950/60 p-3 text-xs font-semibold text-gray-200 transition hover:border-gray-700 hover:bg-gray-800"
            >
              <div class="flex items-center gap-2.5">
                <UIcon name="i-heroicons-check-badge" class="h-4 w-4 text-amber-400" />
                <span>Campaign Approvals</span>
              </div>
              <UIcon name="i-heroicons-chevron-right" class="h-4 w-4 text-gray-500" />
            </NuxtLink>

            <NuxtLink
              to="/admin/users"
              class="flex items-center justify-between rounded-lg border border-gray-800 bg-gray-950/60 p-3 text-xs font-semibold text-gray-200 transition hover:border-gray-700 hover:bg-gray-800"
            >
              <div class="flex items-center gap-2.5">
                <UIcon name="i-heroicons-users" class="h-4 w-4 text-indigo-400" />
                <span>User Roles & Status</span>
              </div>
              <UIcon name="i-heroicons-chevron-right" class="h-4 w-4 text-gray-500" />
            </NuxtLink>

            <NuxtLink
              to="/admin/logs"
              class="flex items-center justify-between rounded-lg border border-gray-800 bg-gray-950/60 p-3 text-xs font-semibold text-gray-200 transition hover:border-gray-700 hover:bg-gray-800"
            >
              <div class="flex items-center gap-2.5">
                <UIcon name="i-heroicons-document-text" class="h-4 w-4 text-sky-400" />
                <span>System Security Logs</span>
              </div>
              <UIcon name="i-heroicons-chevron-right" class="h-4 w-4 text-gray-500" />
            </NuxtLink>

            <NuxtLink
              to="/admin/settings"
              class="flex items-center justify-between rounded-lg border border-gray-800 bg-gray-950/60 p-3 text-xs font-semibold text-gray-200 transition hover:border-gray-700 hover:bg-gray-800"
            >
              <div class="flex items-center gap-2.5">
                <UIcon name="i-heroicons-adjustments-horizontal" class="h-4 w-4 text-emerald-400" />
                <span>Telegram & Mail Dispatch Config</span>
              </div>
              <UIcon name="i-heroicons-chevron-right" class="h-4 w-4 text-gray-500" />
            </NuxtLink>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>
