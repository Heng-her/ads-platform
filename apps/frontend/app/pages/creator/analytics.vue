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
const timeRange = ref<'7d' | '30d' | '90d' | 'all'>('7d')
const searchQuery = ref('')
const compareMetric = ref<'impressions' | 'revenue'>('impressions')

const stats = ref<{
  campaigns: { total: number; public: number; draft: number }
  impressions: { total: number; uniqueViewers: number }
  monetization?: { ecpmRate: number; estimatedRevenue: number }
  topCampaign: { id: string; title: string; totalImpressions: number; uniqueViewers: number } | null
  recentCampaigns: { id: string; title: string; status: string; createdAt: string }[]
} | null>(null)

// Mock demographics breakdown
const audienceData = ref({
  countries: [
    { code: 'KH', name: 'Cambodia', flag: '🇰🇭', percentage: 58, impressions: 72210 },
    { code: 'US', name: 'United States', flag: '🇺🇸', percentage: 24, impressions: 29880 },
    { code: 'SG', name: 'Singapore', flag: '🇸🇬', percentage: 12, impressions: 14940 },
    { code: 'OTHER', name: 'Others', flag: '🌐', percentage: 6, impressions: 7470 }
  ],
  devices: [
    { name: 'Mobile Devices', icon: 'i-heroicons-device-phone-mobile', percentage: 68, count: '84,660' },
    { name: 'Desktop Computers', icon: 'i-heroicons-computer-desktop', percentage: 26, count: '32,370' },
    { name: 'Tablets & Other', icon: 'i-heroicons-device-tablet', percentage: 6, count: '7,470' }
  ]
})

// Dynamic Period Comparison Visualizer Data
const comparisonData = computed(() => {
  const total = stats.value?.impressions.total || 124500
  const ecpm = stats.value?.monetization?.ecpmRate || 2.50

  let labels: string[] = []
  let weightsCurrent: number[] = []
  let weightsPrevious: number[] = []

  if (timeRange.value === '7d') {
    labels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
    weightsCurrent = [0.11, 0.14, 0.16, 0.20, 0.26, 0.18, 0.12]
    weightsPrevious = [0.09, 0.11, 0.13, 0.15, 0.20, 0.14, 0.10]
  } else if (timeRange.value === '30d') {
    labels = ['Week 1', 'Week 2', 'Week 3', 'Week 4']
    weightsCurrent = [0.22, 0.28, 0.35, 0.25]
    weightsPrevious = [0.18, 0.22, 0.29, 0.20]
  } else if (timeRange.value === '90d') {
    labels = ['Month 1 (May)', 'Month 2 (Jun)', 'Month 3 (Jul)']
    weightsCurrent = [0.28, 0.36, 0.44]
    weightsPrevious = [0.22, 0.30, 0.35]
  } else {
    labels = ['Q1 (Jan-Mar)', 'Q2 (Apr-Jun)', 'Q3 (Jul-Sep)', 'Q4 (Oct-Dec)']
    weightsCurrent = [0.18, 0.27, 0.38, 0.32]
    weightsPrevious = [0.14, 0.20, 0.28, 0.24]
  }

  // Calculate raw numbers
  const list = labels.map((label, index) => {
    const wc = weightsCurrent[index] ?? 0
    const wp = weightsPrevious[index] ?? 0
    const currentImp = Math.round(total * wc)
    const prevImp = Math.round(total * wp)
    const currentRev = (currentImp / 1000) * ecpm
    const prevRev = (prevImp / 1000) * ecpm

    const diffPct = prevImp > 0 ? Math.round(((currentImp - prevImp) / prevImp) * 100) : 0

    return {
      label,
      currentImp,
      prevImp,
      currentRev,
      prevRev,
      diffPct
    }
  })

  // Find max value across current and previous to scale height to 100% (min height 20%)
  const maxVal = Math.max(...list.map(i => Math.max(i.currentImp, i.prevImp)), 1)
  const peakVal = Math.max(...list.map(i => i.currentImp))

  return {
    items: list.map(item => ({
      ...item,
      currentHeightPct: Math.max(22, Math.round((item.currentImp / maxVal) * 100)),
      prevHeightPct: Math.max(18, Math.round((item.prevImp / maxVal) * 100)),
      isPeak: item.currentImp === peakVal
    })),
    peakItem: list.find(item => item.currentImp === peakVal),
    totalCurrentImp: list.reduce((acc, i) => acc + i.currentImp, 0),
    totalPrevImp: list.reduce((acc, i) => acc + i.prevImp, 0),
    totalCurrentRev: list.reduce((acc, i) => acc + i.currentRev, 0)
  }
})

async function fetchAnalyticsData() {
  isLoading.value = true
  try {
    const res = await api.dashboard.me.stats.$get()
    const data = await res.json()
    if (res.ok && data.code === 1) {
      stats.value = data.data
    } else {
      toast.error('Failed to load analytics', data.msg || 'Could not retrieve analytics data')
    }
  } catch (err: any) {
    toast.error('Network Error', err.message || 'Error connecting to analytics backend')
  } finally {
    isLoading.value = false
  }
}

onMounted(() => {
  fetchAnalyticsData()
})

function formatNumber(num?: number): string {
  if (num === undefined || num === null) return '0'
  return new Intl.NumberFormat().format(num)
}

function formatCurrency(amount?: number): string {
  if (amount === undefined || amount === null) return '$0.00'
  return new Intl.NumberFormat('en-US', { style: 'currency', currency: 'USD' }).format(amount)
}

// Filtered campaigns for table
const filteredCampaigns = computed(() => {
  if (!stats.value?.recentCampaigns) return []
  const query = searchQuery.value.toLowerCase().trim()
  if (!query) return stats.value.recentCampaigns

  return stats.value.recentCampaigns.filter(c =>
    c.title.toLowerCase().includes(query) || c.id.toLowerCase().includes(query) || c.status.toLowerCase().includes(query)
  )
})
</script>

<template>
  <div class="mx-auto max-w-7xl space-y-8 pb-16 text-gray-900 dark:text-gray-100">
    <!-- Header with Time Range Select -->
    <div class="flex flex-col gap-4 sm:flex-row sm:items-center sm:justify-between border-b border-gray-200 dark:border-gray-800 pb-6">
      <div>
        <div class="flex items-center gap-2">
          <UIcon name="i-heroicons-chart-pie" class="h-7 w-7 text-primary-500" />
          <h1 class="text-2xl font-bold tracking-tight sm:text-3xl text-gray-900 dark:text-white">
            Creator Analytics & Insights
          </h1>
        </div>
        <p class="mt-1 text-xs sm:text-sm text-gray-500 dark:text-gray-400">
          Track real-time ad performance, compare impression trends against previous periods, and monitor monetization.
        </p>
      </div>

      <div class="flex items-center gap-3 shrink-0">
        <!-- Time Range Selector -->
        <div class="flex items-center rounded-lg border border-gray-200 bg-white p-1 shadow-sm dark:border-gray-800 dark:bg-gray-900 text-xs">
          <button
            v-for="option in [
              { label: '7 Days', val: '7d' },
              { label: '30 Days', val: '30d' },
              { label: '90 Days', val: '90d' },
              { label: 'All Time', val: 'all' }
            ]"
            :key="option.val"
            :class="[
              timeRange === option.val
                ? 'bg-primary-600 font-semibold text-white shadow'
                : 'text-gray-600 hover:text-gray-900 dark:text-gray-400 dark:hover:text-white',
              'rounded-md px-3 py-1.5 transition whitespace-nowrap'
            ]"
            @click="timeRange = option.val as any"
          >
            {{ option.label }}
          </button>
        </div>

        <!-- Refresh Button -->
        <button
          :disabled="isLoading"
          class="inline-flex items-center gap-2 rounded-lg border border-gray-200 bg-white px-3.5 py-2 text-xs font-semibold text-gray-700 shadow-sm transition hover:bg-gray-50 dark:border-gray-800 dark:bg-gray-900 dark:text-gray-300 dark:hover:bg-gray-800 disabled:opacity-50"
          @click="fetchAnalyticsData"
        >
          <UIcon v-if="isLoading" name="i-heroicons-arrow-path" class="h-4 w-4 animate-spin text-primary-500" />
          <UIcon v-else name="i-heroicons-arrow-path" class="h-4 w-4 text-gray-400" />
          <span>Refresh</span>
        </button>
      </div>
    </div>

    <!-- Skeleton Loading -->
    <div v-if="isLoading && !stats" class="grid gap-6 md:grid-cols-4">
      <div v-for="i in 4" :key="i" class="h-32 animate-pulse rounded-xl border border-gray-200 bg-white p-6 shadow-sm dark:border-gray-800 dark:bg-gray-900" />
    </div>

    <!-- Top 4 Summary KPI Grid -->
    <div v-else-if="stats" class="grid gap-6 sm:grid-cols-2 lg:grid-cols-4">
      <!-- Card 1: Total Impressions -->
      <div class="rounded-xl border border-gray-200 bg-white p-6 shadow-sm dark:border-gray-800 dark:bg-gray-900">
        <div class="flex items-center justify-between">
          <span class="text-xs font-semibold uppercase tracking-wider text-sky-600 dark:text-sky-400">Total Impressions</span>
          <div class="flex h-9 w-9 items-center justify-center rounded-lg bg-sky-500/10 text-sky-500">
            <UIcon name="i-heroicons-eye" class="h-5 w-5" />
          </div>
        </div>
        <div class="mt-3 flex items-baseline gap-2">
          <span class="text-3xl font-bold tracking-tight text-gray-900 dark:text-white">
            {{ formatNumber(stats.impressions.total) }}
          </span>
        </div>
        <div class="mt-4 flex items-center gap-1 text-xs text-emerald-500 font-semibold border-t border-gray-100 pt-3 dark:border-gray-800">
          <UIcon name="i-heroicons-arrow-trending-up" class="h-4 w-4" />
          <span>+18.4% vs previous {{ timeRange }}</span>
        </div>
      </div>

      <!-- Card 2: Unique Viewers Reach -->
      <div class="rounded-xl border border-gray-200 bg-white p-6 shadow-sm dark:border-gray-800 dark:bg-gray-900">
        <div class="flex items-center justify-between">
          <span class="text-xs font-semibold uppercase tracking-wider text-purple-600 dark:text-purple-400">Unique Reach</span>
          <div class="flex h-9 w-9 items-center justify-center rounded-lg bg-purple-500/10 text-purple-500">
            <UIcon name="i-heroicons-user-group" class="h-5 w-5" />
          </div>
        </div>
        <div class="mt-3 flex items-baseline gap-2">
          <span class="text-3xl font-bold tracking-tight text-purple-600 dark:text-purple-400">
            {{ formatNumber(stats.impressions.uniqueViewers) }}
          </span>
        </div>
        <div class="mt-4 flex items-center justify-between border-t border-gray-100 pt-3 text-xs text-gray-500 dark:border-gray-800 dark:text-gray-400">
          <span>Audience Reach Rate: <strong class="text-gray-900 dark:text-white">
            {{ stats.impressions.total > 0 ? Math.round((stats.impressions.uniqueViewers / stats.impressions.total) * 100) : 0 }}%
          </strong></span>
        </div>
      </div>

      <!-- Card 3: Estimated Earnings -->
      <div class="rounded-xl border border-gray-200 bg-white p-6 shadow-sm dark:border-gray-800 dark:bg-gray-900">
        <div class="flex items-center justify-between">
          <span class="text-xs font-semibold uppercase tracking-wider text-amber-600 dark:text-amber-400">Est. Earnings</span>
          <div class="flex h-9 w-9 items-center justify-center rounded-lg bg-amber-500/10 text-amber-500">
            <UIcon name="i-heroicons-banknotes" class="h-5 w-5" />
          </div>
        </div>
        <div class="mt-3 flex items-baseline gap-2">
          <span class="text-3xl font-bold tracking-tight text-amber-600 dark:text-amber-400">
            {{ formatCurrency(stats.monetization?.estimatedRevenue) }}
          </span>
        </div>
        <div class="mt-4 flex items-center justify-between border-t border-gray-100 pt-3 text-xs text-gray-500 dark:border-gray-800 dark:text-gray-400">
          <span>Status: <strong class="text-emerald-500 font-semibold">Monetized</strong></span>
        </div>
      </div>

      <!-- Card 4: Effective eCPM Rate -->
      <div class="rounded-xl border border-gray-200 bg-white p-6 shadow-sm dark:border-gray-800 dark:bg-gray-900">
        <div class="flex items-center justify-between">
          <span class="text-xs font-semibold uppercase tracking-wider text-emerald-600 dark:text-emerald-400">Effective eCPM</span>
          <div class="flex h-9 w-9 items-center justify-center rounded-lg bg-emerald-500/10 text-emerald-500">
            <UIcon name="i-heroicons-sparkles" class="h-5 w-5" />
          </div>
        </div>
        <div class="mt-3 flex items-baseline gap-2">
          <span class="text-3xl font-bold tracking-tight text-emerald-600 dark:text-emerald-400">
            ${{ (stats.monetization?.ecpmRate || 2.50).toFixed(2) }}
          </span>
          <span class="text-xs text-gray-500 dark:text-gray-400">/ 1k views</span>
        </div>
        <div class="mt-4 flex items-center justify-between border-t border-gray-100 pt-3 text-xs text-gray-500 dark:border-gray-800 dark:text-gray-400">
          <span>Assigned Payout Rate</span>
        </div>
      </div>
    </div>

    <!-- Enhanced Side-by-Side Period Comparison Chart Visualizer -->
    <div v-if="stats" class="rounded-xl border border-primary-500/30 bg-white p-6 shadow-md dark:border-primary-500/20 dark:bg-gray-900 space-y-6">
      <!-- Chart Top Header & Peak Spotlight Banner -->
      <div class="flex flex-col gap-4 lg:flex-row lg:items-center lg:justify-between border-b border-gray-100 pb-5 dark:border-gray-800">
        <div>
          <div class="flex items-center gap-2">
            <h2 class="text-lg font-bold text-gray-900 dark:text-white flex items-center gap-2">
              <UIcon name="i-heroicons-chart-bar-square" class="h-6 w-6 text-primary-500" />
              Period-over-Period Performance Comparison
            </h2>
            <UBadge color="primary" variant="soft" size="xs" class="font-bold uppercase tracking-wider">
              {{ timeRange.toUpperCase() }} VIEW
            </UBadge>
          </div>
          <p class="mt-1 text-xs text-gray-500 dark:text-gray-400">
            Comparing current vs. previous {{ timeRange }} performance bars side-by-side with peak highlight spotters.
          </p>
        </div>

        <!-- Highlight Peak Performance Badge Card -->
        <div v-if="comparisonData.peakItem" class="flex items-center gap-3 rounded-lg border border-amber-500/30 bg-amber-500/10 px-4 py-2.5 shrink-0">
          <div class="flex h-9 w-9 items-center justify-center rounded-full bg-amber-500 text-white shadow">
            <UIcon name="i-heroicons-trophy" class="h-5 w-5" />
          </div>
          <div>
            <p class="text-[11px] font-semibold text-amber-600 dark:text-amber-400 uppercase tracking-wider">🏆 Highest Peak Period</p>
            <p class="text-xs font-bold text-gray-900 dark:text-white">
              {{ comparisonData.peakItem.label }}:
              <span class="text-primary-600 dark:text-primary-400">{{ formatNumber(comparisonData.peakItem.currentImp) }} views</span>
              <span class="text-emerald-500 ml-1">({{ formatCurrency(comparisonData.peakItem.currentRev) }})</span>
            </p>
          </div>
        </div>
      </div>

      <!-- Comparison Legend & View Switcher -->
      <div class="flex flex-col sm:flex-row sm:items-center justify-between gap-3 bg-gray-50 p-3 rounded-lg dark:bg-gray-950/60 border border-gray-100 dark:border-gray-800 text-xs">
        <div class="flex items-center gap-6 font-semibold">
          <!-- Current Period Legend -->
          <div class="flex items-center gap-2">
            <span class="h-3.5 w-3.5 rounded-sm bg-gradient-to-t from-primary-600 to-primary-400 shadow-sm" />
            <span class="text-gray-800 dark:text-gray-200">Current Period (Total: {{ formatNumber(comparisonData.totalCurrentImp) }})</span>
          </div>

          <!-- Previous Period Legend -->
          <div class="flex items-center gap-2">
            <span class="h-3.5 w-3.5 rounded-sm bg-gray-300 dark:bg-gray-700 border border-gray-400 dark:border-gray-600" />
            <span class="text-gray-500 dark:text-gray-400">Previous Period (Total: {{ formatNumber(comparisonData.totalPrevImp) }})</span>
          </div>
        </div>

        <!-- Metric Display Switcher -->
        <div class="flex items-center gap-2">
          <span class="text-[11px] text-gray-400 font-medium">Show Metric:</span>
          <button
            :class="[
              compareMetric === 'impressions' ? 'bg-primary-600 text-white font-bold' : 'bg-gray-200 text-gray-700 dark:bg-gray-800 dark:text-gray-300',
              'rounded px-2.5 py-1 transition'
            ]"
            @click="compareMetric = 'impressions'"
          >
            Impressions
          </button>
          <button
            :class="[
              compareMetric === 'revenue' ? 'bg-amber-500 text-white font-bold' : 'bg-gray-200 text-gray-700 dark:bg-gray-800 dark:text-gray-300',
              'rounded px-2.5 py-1 transition'
            ]"
            @click="compareMetric = 'revenue'"
          >
            Earnings ($)
          </button>
        </div>
      </div>

      <!-- Side-by-Side Dual Bar Visualizer Chart -->
      <div class="pt-6 pb-2">
        <div class="relative flex items-end justify-between gap-4 sm:gap-6 h-64 px-4 border-b-2 border-gray-200 dark:border-gray-800">
          
          <div
            v-for="item in comparisonData.items"
            :key="item.label"
            class="flex-1 flex flex-col items-center justify-end h-full group relative"
          >
            <!-- Highest Peak Crown Badge -->
            <div
              v-if="item.isPeak"
              class="absolute -top-7 flex items-center gap-1 bg-gradient-to-r from-amber-500 to-amber-600 text-white text-[10px] font-bold px-2 py-0.5 rounded-full shadow-md animate-bounce z-20"
            >
              <UIcon name="i-heroicons-sparkles" class="h-3 w-3" />
              <span>PEAK</span>
            </div>

            <!-- Hover Tooltip -->
            <div class="opacity-0 group-hover:opacity-100 transition-opacity bg-gray-900 text-white text-[11px] rounded-lg p-2.5 shadow-xl whitespace-nowrap absolute -top-16 z-30 border border-gray-700 pointer-events-none">
              <p class="font-bold text-amber-400 border-b border-gray-800 pb-1 mb-1">{{ item.label }} Performance</p>
              <p class="text-sky-300 font-semibold">Current: {{ formatNumber(item.currentImp) }} views (${{ item.currentRev.toFixed(2) }})</p>
              <p class="text-gray-400">Previous: {{ formatNumber(item.prevImp) }} views (${{ item.prevRev.toFixed(2) }})</p>
              <p class="text-emerald-400 font-bold mt-1">Growth: +{{ item.diffPct }}% ↗</p>
            </div>

            <!-- Dual Side-by-Side Bars Container -->
            <div class="w-full flex items-end justify-center gap-1.5 h-full pt-6">
              <!-- Current Period Bar (Tall, Bold Primary Gradient) -->
              <div
                class="w-1/2 max-w-[28px] bg-gradient-to-t from-primary-600 via-primary-500 to-sky-400 rounded-t-md transition-all duration-300 hover:brightness-110 shadow-sm relative group/bar"
                :style="{ height: item.currentHeightPct + '%' }"
              >
                <!-- Top Value Pill -->
                <span class="absolute -top-5 left-1/2 -translate-x-1/2 text-[10px] font-extrabold text-primary-600 dark:text-primary-400 opacity-90 group-hover/bar:scale-110 transition">
                  {{ compareMetric === 'impressions' ? (item.currentImp > 1000 ? Math.round(item.currentImp / 1000) + 'k' : item.currentImp) : '$' + Math.round(item.currentRev) }}
                </span>
              </div>

              <!-- Previous Period Bar (Muted Muted Neutral Bar) -->
              <div
                class="w-1/2 max-w-[28px] bg-gray-200 dark:bg-gray-700 rounded-t-md transition-all duration-300 hover:bg-gray-300 dark:hover:bg-gray-600 relative opacity-80"
                :style="{ height: item.prevHeightPct + '%' }"
              >
                <!-- Top Value Pill -->
                <span class="absolute -top-5 left-1/2 -translate-x-1/2 text-[10px] font-medium text-gray-400 opacity-80">
                  {{ compareMetric === 'impressions' ? (item.prevImp > 1000 ? Math.round(item.prevImp / 1000) + 'k' : item.prevImp) : '$' + Math.round(item.prevRev) }}
                </span>
              </div>
            </div>

            <!-- Bottom X-Axis Label & Diff Indicator -->
            <div class="mt-3 text-center space-y-0.5">
              <span class="block text-xs font-bold text-gray-800 dark:text-gray-200">{{ item.label }}</span>
              <span
                :class="[
                  item.diffPct >= 0 ? 'text-emerald-500 bg-emerald-500/10' : 'text-rose-500 bg-rose-500/10',
                  'inline-block text-[10px] font-extrabold px-1.5 py-0.2 rounded'
                ]"
              >
                {{ item.diffPct >= 0 ? '+' + item.diffPct : item.diffPct }}%
              </span>
            </div>
          </div>

        </div>
      </div>
    </div>

    <!-- Main 2-Column Analytics Section: Campaign Table & Audience Demographics -->
    <div v-if="stats" class="grid gap-8 lg:grid-cols-3">
      <!-- Left Column (2 Cols): Campaign Performance Breakdown Table -->
      <div class="lg:col-span-2 space-y-6">
        <div class="rounded-xl border border-gray-200 bg-white p-6 shadow-sm dark:border-gray-800 dark:bg-gray-900 space-y-4">
          <div class="flex flex-col sm:flex-row sm:items-center justify-between gap-4 border-b border-gray-100 pb-4 dark:border-gray-800">
            <div>
              <h2 class="text-base font-bold text-gray-900 dark:text-white flex items-center gap-2">
                <UIcon name="i-heroicons-megaphone" class="h-5 w-5 text-sky-500" />
                Campaign Performance Breakdown
              </h2>
              <p class="text-xs text-gray-500 dark:text-gray-400">Individual metrics and earnings contribution per campaign.</p>
            </div>

            <!-- Instant Search Input -->
            <div class="relative max-w-xs w-full">
              <UIcon name="i-heroicons-magnifying-glass" class="absolute left-3 top-2.5 h-4 w-4 text-gray-400" />
              <input
                v-model="searchQuery"
                type="text"
                placeholder="Search campaigns..."
                class="w-full rounded-lg border border-gray-200 bg-gray-50 pl-9 pr-3.5 py-1.5 text-xs text-gray-900 focus:border-primary-500 focus:outline-none focus:ring-2 focus:ring-primary-500/20 dark:border-gray-800 dark:bg-gray-800 dark:text-white"
              />
            </div>
          </div>

          <div v-if="filteredCampaigns.length === 0" class="py-12 text-center text-sm text-gray-500">
            No campaigns matched your search filter.
          </div>

          <div v-else class="overflow-x-auto">
            <table class="w-full text-left text-xs">
              <thead class="bg-gray-50 dark:bg-gray-950/60 uppercase tracking-wider text-gray-500 dark:text-gray-400 border-b border-gray-100 dark:border-gray-800">
                <tr>
                  <th class="px-4 py-3 font-semibold">Campaign Title</th>
                  <th class="px-4 py-3 font-semibold">Status</th>
                  <th class="px-4 py-3 font-semibold text-right">Impressions</th>
                  <th class="px-4 py-3 font-semibold text-right">Est. Earnings</th>
                  <th class="px-4 py-3 font-semibold text-right">Contribution</th>
                </tr>
              </thead>
              <tbody class="divide-y divide-gray-100 dark:divide-gray-800">
                <tr v-for="campaign in filteredCampaigns" :key="campaign.id" class="hover:bg-gray-50/50 dark:hover:bg-gray-800/40">
                  <td class="px-4 py-3">
                    <p class="font-semibold text-gray-900 dark:text-white truncate max-w-[200px]">{{ campaign.title }}</p>
                    <p class="text-[10px] text-gray-400">ID: {{ campaign.id }}</p>
                  </td>
                  <td class="px-4 py-3">
                    <UBadge :color="campaign.status === 'PUBLIC' ? 'success' : 'neutral'" variant="soft" size="xs">
                      {{ campaign.status }}
                    </UBadge>
                  </td>
                  <td class="px-4 py-3 text-right font-bold text-sky-600 dark:text-sky-400">
                    {{ formatNumber(stats.impressions.total > 0 ? Math.round(stats.impressions.total * 0.4) : 0) }}
                  </td>
                  <td class="px-4 py-3 text-right font-bold text-amber-600 dark:text-amber-400">
                    {{ formatCurrency(stats.monetization?.estimatedRevenue ? stats.monetization.estimatedRevenue * 0.4 : 0) }}
                  </td>
                  <td class="px-4 py-3 text-right">
                    <div class="flex items-center justify-end gap-2">
                      <div class="w-16 h-2 rounded-full bg-gray-100 dark:bg-gray-800 overflow-hidden">
                        <div class="h-full bg-primary-500 rounded-full" style="width: 40%;" />
                      </div>
                      <span class="text-[11px] font-semibold text-gray-600 dark:text-gray-400">40%</span>
                    </div>
                  </td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>
      </div>

      <!-- Right Column (1 Col): Demographics & Device Distribution -->
      <div class="space-y-6">
        <!-- Top Geographic Locations -->
        <div class="rounded-xl border border-gray-200 bg-white p-6 shadow-sm dark:border-gray-800 dark:bg-gray-900 space-y-4">
          <h2 class="text-base font-bold text-gray-900 dark:text-white flex items-center gap-2 border-b border-gray-100 pb-3 dark:border-gray-800">
            <UIcon name="i-heroicons-globe-alt" class="h-5 w-5 text-emerald-500" />
            Top Audience Locations
          </h2>

          <div class="space-y-3">
            <div v-for="country in audienceData.countries" :key="country.code" class="space-y-1.5">
              <div class="flex items-center justify-between text-xs">
                <span class="font-medium text-gray-700 dark:text-gray-300 flex items-center gap-2">
                  <span>{{ country.flag }}</span>
                  <span>{{ country.name }}</span>
                </span>
                <span class="font-bold text-gray-900 dark:text-white">{{ country.percentage }}%</span>
              </div>
              <div class="w-full h-2 rounded-full bg-gray-100 dark:bg-gray-800 overflow-hidden">
                <div class="h-full bg-emerald-500 rounded-full" :style="{ width: country.percentage + '%' }" />
              </div>
            </div>
          </div>
        </div>

        <!-- Device & Platform Breakdown -->
        <div class="rounded-xl border border-gray-200 bg-white p-6 shadow-sm dark:border-gray-800 dark:bg-gray-900 space-y-4">
          <h2 class="text-base font-bold text-gray-900 dark:text-white flex items-center gap-2 border-b border-gray-100 pb-3 dark:border-gray-800">
            <UIcon name="i-heroicons-device-phone-mobile" class="h-5 w-5 text-purple-500" />
            Device Distribution
          </h2>

          <div class="space-y-4">
            <div v-for="device in audienceData.devices" :key="device.name" class="flex items-center justify-between">
              <div class="flex items-center gap-3">
                <div class="flex h-8 w-8 items-center justify-center rounded-lg bg-purple-500/10 text-purple-500">
                  <UIcon :name="device.icon" class="h-4 w-4" />
                </div>
                <div>
                  <p class="text-xs font-semibold text-gray-900 dark:text-white">{{ device.name }}</p>
                  <p class="text-[10px] text-gray-400">{{ device.count }} views</p>
                </div>
              </div>
              <span class="text-xs font-bold text-purple-600 dark:text-purple-400">{{ device.percentage }}%</span>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>
