<script setup lang="ts">
import { ref, onMounted, computed } from 'vue'
import { useAuthStore } from '~/stores/auth'
import { useApi } from '~/composables/useApi'
import { useAppToast } from '~/composables/useAppToast'

definePageMeta({
  layout: 'creator'
})

const authStore = useAuthStore()
const api = useApi()
const toast = useAppToast()

const isLoading = ref(true)
const stats = ref<{
  campaigns: { total: number; public: number; draft: number }
  impressions: { total: number; uniqueViewers: number }
  monetization?: { ecpmRate: number; estimatedRevenue: number }
  topCampaign: { id: string; title: string; totalImpressions: number; uniqueViewers: number } | null
  recentCampaigns: { id: string; title: string; status: string; createdAt: string }[]
} | null>(null)

async function fetchCreatorStats() {
  isLoading.value = true
  try {
    const res = await api.dashboard.me.stats.$get()
    const data = await res.json()
    if (res.ok && data.code === 1) {
      stats.value = data.data
    } else {
      toast.error('Failed to load stats', data.msg || 'Error fetching creator dashboard stats')
    }
  } catch (err: any) {
    toast.error('Network Error', err.message || 'Could not connect to API server')
  } finally {
    isLoading.value = false
  }
}

onMounted(() => {
  fetchCreatorStats()
})

const creatorName = computed(() => {
  return authStore.user?.username || authStore.user?.name || 'Creator'
})

function formatNumber(num?: number): string {
  if (num === undefined || num === null) return '0'
  return new Intl.NumberFormat().format(num)
}

function formatCurrency(amount?: number): string {
  if (amount === undefined || amount === null) return '$0.00'
  return new Intl.NumberFormat('en-US', { style: 'currency', currency: 'USD' }).format(amount)
}

function formatDate(dateStr?: string): string {
  if (!dateStr) return 'N/A'
  return new Date(dateStr).toLocaleDateString('en-US', {
    month: 'short',
    day: 'numeric',
    year: 'numeric'
  })
}
</script>

<template>
  <div class="mx-auto max-w-8xl space-y-8 pb-12">
    <!-- Creator Welcome Header -->
    <div class="flex flex-col gap-4 md:flex-row md:items-center md:justify-between">
      <div class="flex items-center gap-4">
        <div>
          <h1 class="text-2xl font-bold tracking-tight text-gray-900 dark:text-white sm:text-3xl">
            Welcome back, {{ creatorName }}! 👋
          </h1>
          <p class="text-xs sm:text-sm text-gray-500 dark:text-gray-400">
            Track your campaign performance, total impression reach, and estimated monetization.
          </p>
        </div>
      </div>

      <div class="flex items-center gap-3">
        <button :disabled="isLoading"
          class="inline-flex items-center gap-2 rounded-lg border border-gray-200 bg-white px-4 py-2.5 text-xs font-semibold text-gray-700 shadow-sm transition hover:bg-gray-50 dark:border-gray-800 dark:bg-gray-900 dark:text-gray-300 dark:hover:bg-gray-800 disabled:opacity-50"
          @click="fetchCreatorStats">
          <UIcon v-if="isLoading" name="i-heroicons-arrow-path" class="h-4 w-4 animate-spin text-primary-500" />
          <UIcon v-else name="i-heroicons-arrow-path" class="h-4 w-4 text-gray-400" />
          <span>{{ isLoading ? 'Refreshing...' : 'Refresh' }}</span>
        </button>

        <NuxtLink to="/creator/campaigns/create"
          class="inline-flex items-center gap-2 rounded-lg bg-primary-600 px-5 py-2.5 text-xs font-semibold text-white shadow-sm transition hover:bg-primary-500">
          <UIcon name="i-heroicons-plus" class="h-4 w-4" />
          <span>Create Campaign</span>
        </NuxtLink>
      </div>
    </div>

    <!-- Skeleton Loading State -->
    <div v-if="isLoading && !stats" class="grid gap-6 md:grid-cols-3">
      <div v-for="i in 3" :key="i"
        class="h-36 animate-pulse rounded-xl border border-gray-200 bg-white p-6 shadow-sm dark:border-gray-800 dark:bg-gray-900" />
    </div>

    <!-- Metric Cards Grid (3 Cards) -->
    <div v-else-if="stats" class="grid gap-6 md:grid-cols-3">
      <!-- Card 1: My Active Campaigns -->
      <div class="rounded-xl border border-gray-200 bg-white p-6 shadow-sm dark:border-gray-800 dark:bg-gray-900">
        <div class="flex items-center justify-between">
          <span
            class="text-xs font-semibold uppercase tracking-wider text-primary-600 dark:text-primary-400">Campaigns</span>
          <div class="flex h-9 w-9 items-center justify-center rounded-lg bg-primary-500/10 text-primary-500">
            <UIcon name="i-heroicons-megaphone" class="h-5 w-5" />
          </div>
        </div>
        <div class="mt-3 flex items-baseline gap-2">
          <span class="text-3xl font-bold tracking-tight text-gray-900 dark:text-white">{{
            formatNumber(stats.campaigns.total) }}</span>
          <span class="text-xs font-medium text-gray-500 dark:text-gray-400">Total Created</span>
        </div>
        <div class="mt-4 flex items-center justify-between border-t border-gray-100 pt-3 text-xs dark:border-gray-800">
          <span class="text-gray-600 dark:text-gray-400">Public: <strong
              class="text-emerald-600 dark:text-emerald-400">{{ formatNumber(stats.campaigns.public) }}</strong></span>
          <span class="text-gray-600 dark:text-gray-400">Draft: <strong class="text-amber-600 dark:text-amber-400">{{
            formatNumber(stats.campaigns.draft) }}</strong></span>
        </div>
      </div>

      <!-- Card 2: Total Impressions & Unique Reach -->
      <div class="rounded-xl border border-gray-200 bg-white p-6 shadow-sm dark:border-gray-800 dark:bg-gray-900">
        <div class="flex items-center justify-between">
          <span class="text-xs font-semibold uppercase tracking-wider text-sky-600 dark:text-sky-400">Total
            Impressions</span>
          <div class="flex h-9 w-9 items-center justify-center rounded-lg bg-sky-500/10 text-sky-500">
            <UIcon name="i-heroicons-chart-bar" class="h-5 w-5" />
          </div>
        </div>
        <div class="mt-3 flex items-baseline gap-2">
          <span class="text-3xl font-bold tracking-tight text-sky-600 dark:text-sky-400">{{
            formatNumber(stats.impressions.total) }}</span>
          <span class="text-xs font-semibold text-emerald-500 flex items-center gap-0.5">
            <UIcon name="i-heroicons-arrow-trending-up" class="h-3.5 w-3.5" />
            Active
          </span>
        </div>
        <div
          class="mt-4 flex items-center justify-between border-t border-gray-100 pt-3 text-xs text-gray-500 dark:border-gray-800 dark:text-gray-400">
          <span>Unique Viewers Reach: <strong class="text-gray-900 dark:text-white">{{
            formatNumber(stats.impressions.uniqueViewers) }}</strong></span>
          <NuxtLink to="/creator/analytics" class="font-medium text-sky-600 hover:text-sky-500 dark:text-sky-400">
            View Analytics &rarr;
          </NuxtLink>
        </div>
      </div>

      <!-- Card 3: Estimated Revenue / Monetization -->
      <div class="rounded-xl border border-gray-200 bg-white p-6 shadow-sm dark:border-gray-800 dark:bg-gray-900">
        <div class="flex items-center justify-between">
          <span class="text-xs font-semibold uppercase tracking-wider text-amber-600 dark:text-amber-400">Est.
            Revenue</span>
          <div class="flex h-9 w-9 items-center justify-center rounded-lg bg-amber-500/10 text-amber-500">
            <UIcon name="i-heroicons-banknotes" class="h-5 w-5" />
          </div>
        </div>
        <div class="mt-3 flex items-baseline gap-2">
          <span class="text-3xl font-bold tracking-tight text-amber-600 dark:text-amber-400">
            {{ formatCurrency(stats.monetization?.estimatedRevenue) }}
          </span>
        </div>
        <div
          class="mt-4 flex items-center justify-between border-t border-gray-100 pt-3 text-xs text-gray-500 dark:border-gray-800 dark:text-gray-400">
          <span>eCPM Rate: <strong class="text-gray-900 dark:text-white">${{ (stats.monetization?.ecpmRate ||
            2.5).toFixed(2) }} / 1k views</strong></span>
        </div>
      </div>
    </div>

    <!-- Main Workspace Section -->
    <div v-if="stats" class="grid gap-8 lg:grid-cols-3">
      <!-- Left Column (2 Cols): Top Campaign Spotlight & Recent Campaigns -->
      <div class="space-y-8 lg:col-span-2">
        <!-- Top Performing Campaign Spotlight Card -->
        <div
          class="relative overflow-hidden rounded-xl border border-primary-500/30 bg-gradient-to-r from-primary-950/20 via-gray-900 to-gray-900 p-6 shadow-sm text-white">
          <div class="flex items-center justify-between border-b border-gray-800 pb-3">
            <div class="flex items-center gap-2">
              <UIcon name="i-heroicons-fire" class="h-5 w-5 text-amber-400" />
              <h2 class="text-base font-bold text-white">Top Performing Campaign Spotlight</h2>
            </div>
            <UBadge color="warning" variant="soft" size="xs" class="font-semibold">
              Highest Impressions
            </UBadge>
          </div>

          <div v-if="!stats.topCampaign" class="py-6 text-center text-sm text-gray-400">
            No active campaigns found. Create your first campaign to start tracking statistics!
          </div>

          <div v-else class="mt-4 flex flex-col sm:flex-row sm:items-center justify-between gap-4">
            <div>
              <h3 class="text-xl font-bold text-white">{{ stats.topCampaign.title }}</h3>
              <p class="text-xs text-gray-400 mt-1">Campaign ID: {{ stats.topCampaign.id }}</p>
            </div>

            <div class="flex items-center gap-6 rounded-lg bg-gray-950/60 p-4 border border-gray-800 shrink-0">
              <div>
                <p class="text-lg font-extrabold text-sky-400">{{ formatNumber(stats.topCampaign.totalImpressions) }}
                </p>
                <p class="text-[10px] text-gray-400 uppercase tracking-wider">Impressions</p>
              </div>
              <div class="h-8 w-px bg-gray-800" />
              <div>
                <p class="text-lg font-bold text-emerald-400">{{ formatNumber(stats.topCampaign.uniqueViewers) }}</p>
                <p class="text-[10px] text-gray-400 uppercase tracking-wider">Unique Reach</p>
              </div>
            </div>
          </div>
        </div>

        <!-- Recent Campaigns Table -->
        <div class="rounded-xl border border-gray-200 bg-white p-6 shadow-sm dark:border-gray-800 dark:bg-gray-900">
          <div class="flex items-center justify-between border-b border-gray-100 pb-4 dark:border-gray-800">
            <div class="flex items-center gap-2">
              <UIcon name="i-heroicons-clock" class="h-5 w-5 text-primary-500" />
              <h2 class="text-lg font-semibold text-gray-900 dark:text-white">Recent Campaigns</h2>
            </div>
            <NuxtLink to="/creator/campaigns"
              class="text-xs font-medium text-primary-600 hover:text-primary-500 dark:text-primary-400">
              View All &rarr;
            </NuxtLink>
          </div>

          <div v-if="stats.recentCampaigns.length === 0" class="py-8 text-center text-sm text-gray-500">
            You haven't created any campaigns yet. Click "Create Campaign" to get started!
          </div>

          <div v-else class="mt-4 divide-y divide-gray-100 dark:divide-gray-800">
            <div v-for="campaign in stats.recentCampaigns" :key="campaign.id"
              class="flex items-center justify-between py-3.5">
              <div class="min-w-0 flex-1">
                <p class="truncate text-sm font-semibold text-gray-900 dark:text-white">{{ campaign.title }}</p>
                <p class="text-xs text-gray-500 dark:text-gray-400">Created {{ formatDate(campaign.createdAt) }}</p>
              </div>

              <div class="flex items-center gap-3 shrink-0 ml-4">
                <UBadge :color="campaign.status === 'PUBLIC' ? 'success' : 'neutral'" variant="soft" size="xs"
                  class="font-semibold">
                  {{ campaign.status }}
                </UBadge>

                <NuxtLink :to="`/creator/campaigns/${campaign.id}/edit`"
                  class="rounded-lg border border-gray-200 px-3 py-1 text-xs font-medium text-gray-700 hover:bg-gray-50 dark:border-gray-700 dark:text-gray-300 dark:hover:bg-gray-800">
                  Manage
                </NuxtLink>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Right Column (1 Col): Creator Hub & Analytics Quick Access -->
      <div class="space-y-8 lg:col-span-1">
        <!-- Quick Action Hub -->
        <div
          class="rounded-xl border border-gray-200 bg-white p-6 shadow-sm dark:border-gray-800 dark:bg-gray-900 space-y-4">
          <h2
            class="text-sm font-bold uppercase tracking-wider text-gray-500 dark:text-gray-400 border-b border-gray-100 pb-3 dark:border-gray-800">
            Studio Navigation Hub
          </h2>

          <div class="grid gap-3">
            <NuxtLink to="/creator/campaigns"
              class="flex items-center justify-between rounded-lg border border-gray-200 bg-gray-50/50 p-3.5 text-xs font-semibold text-gray-800 transition hover:bg-gray-100 dark:border-gray-800 dark:bg-gray-950/60 dark:text-gray-200 dark:hover:bg-gray-800">
              <div class="flex items-center gap-3">
                <div class="flex h-8 w-8 items-center justify-center rounded-lg bg-primary-500/10 text-primary-500">
                  <UIcon name="i-heroicons-megaphone" class="h-4 w-4" />
                </div>
                <span>Campaign Manager</span>
              </div>
              <UIcon name="i-heroicons-chevron-right" class="h-4 w-4 text-gray-400" />
            </NuxtLink>

            <NuxtLink to="/creator/analytics"
              class="flex items-center justify-between rounded-lg border border-gray-200 bg-gray-50/50 p-3.5 text-xs font-semibold text-gray-800 transition hover:bg-gray-100 dark:border-gray-800 dark:bg-gray-950/60 dark:text-gray-200 dark:hover:bg-gray-800">
              <div class="flex items-center gap-3">
                <div class="flex h-8 w-8 items-center justify-center rounded-lg bg-sky-500/10 text-sky-500">
                  <UIcon name="i-heroicons-chart-bar" class="h-4 w-4" />
                </div>
                <span>Analytics & Insights</span>
              </div>
              <UIcon name="i-heroicons-chevron-right" class="h-4 w-4 text-gray-400" />
            </NuxtLink>

            <NuxtLink to="/creator/earnings"
              class="flex items-center justify-between rounded-lg border border-gray-200 bg-gray-50/50 p-3.5 text-xs font-semibold text-gray-800 transition hover:bg-gray-100 dark:border-gray-800 dark:bg-gray-950/60 dark:text-gray-200 dark:hover:bg-gray-800">
              <div class="flex items-center gap-3">
                <div class="flex h-8 w-8 items-center justify-center rounded-lg bg-amber-500/10 text-amber-500">
                  <UIcon name="i-heroicons-banknotes" class="h-4 w-4" />
                </div>
                <span>Earnings & Payouts</span>
              </div>
              <UIcon name="i-heroicons-chevron-right" class="h-4 w-4 text-gray-400" />
            </NuxtLink>

            <NuxtLink to="/creator/settings"
              class="flex items-center justify-between rounded-lg border border-gray-200 bg-gray-50/50 p-3.5 text-xs font-semibold text-gray-800 transition hover:bg-gray-100 dark:border-gray-800 dark:bg-gray-950/60 dark:text-gray-200 dark:hover:bg-gray-800">
              <div class="flex items-center gap-3">
                <div class="flex h-8 w-8 items-center justify-center rounded-lg bg-emerald-500/10 text-emerald-500">
                  <UIcon name="i-heroicons-cog-6-tooth" class="h-4 w-4" />
                </div>
                <span>Profile Settings</span>
              </div>
              <UIcon name="i-heroicons-chevron-right" class="h-4 w-4 text-gray-400" />
            </NuxtLink>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>
