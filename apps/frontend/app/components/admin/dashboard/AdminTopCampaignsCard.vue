<script setup lang="ts">
export interface TopCampaignItem {
  id: string
  title: string
  userId: string
  totalImpressions: number
  uniqueViewers: number
}

defineProps<{
  topCampaigns: TopCampaignItem[]
}>()

function formatNumber(num?: number): string {
  if (num === undefined || num === null) return '0'
  return new Intl.NumberFormat().format(num)
}
</script>

<template>
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

    <div v-if="topCampaigns.length === 0" class="py-8 text-center text-sm text-gray-500">
      No campaigns recorded yet.
    </div>

    <div v-else class="mt-4 divide-y divide-gray-800/60">
      <div
        v-for="(item, idx) in topCampaigns"
        :key="item.id"
        class="flex items-center justify-between py-3.5 transition hover:bg-gray-800/30 px-2 rounded-lg"
      >
        <div class="flex items-center gap-3 min-w-0">
          <span
            class="flex h-7 w-7 shrink-0 items-center justify-center rounded-full bg-gray-800 text-xs font-bold font-mono text-gray-300"
          >
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
</template>
