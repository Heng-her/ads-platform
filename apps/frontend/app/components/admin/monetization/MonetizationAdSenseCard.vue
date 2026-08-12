<script setup lang="ts">
import type { AdNetworkConfig } from './MonetizationAdsterraCard.vue'

const config = defineModel<AdNetworkConfig>({ required: true })
const autoShare = defineModel<boolean>('autoShare', { default: true })

defineProps<{
  isTesting: boolean
}>()

const emit = defineEmits<{
  (e: 'test'): void
}>()
</script>

<template>
  <div class="rounded-xl border border-gray-800 bg-gray-900 p-6 shadow-sm space-y-5">
    <div class="flex flex-col sm:flex-row sm:items-center justify-between gap-4 border-b border-gray-800 pb-4">
      <div class="flex items-center gap-3">
        <div class="flex h-10 w-10 items-center justify-center rounded-xl bg-blue-500/10 text-blue-400 font-bold">
          <UIcon name="i-heroicons-sparkles" class="h-6 w-6 text-blue-400" />
        </div>
        <div>
          <div class="flex items-center gap-2">
            <h2 class="text-lg font-semibold text-white">Google AdSense Integration</h2>
            <UBadge :color="config.enableGoogleAdsense ? 'success' : 'neutral'" variant="soft" size="xs">
              {{ config.enableGoogleAdsense ? 'Active & Monetizing' : 'Disabled' }}
            </UBadge>
          </div>
          <p class="text-xs text-gray-400">Monetize platform traffic with programmatic Google Display & Auto Ads.</p>
        </div>
      </div>

      <div class="flex items-center gap-3">
        <button
          :disabled="isTesting"
          class="inline-flex items-center gap-1.5 rounded-lg border border-blue-500/30 bg-blue-500/10 px-3 py-1.5 text-xs font-semibold text-blue-400 hover:bg-blue-500/20 disabled:opacity-50"
          @click="emit('test')"
        >
          <UIcon v-if="isTesting" name="i-heroicons-arrow-path" class="h-3.5 w-3.5 animate-spin" />
          <UIcon v-else name="i-heroicons-check-circle" class="h-3.5 w-3.5 text-blue-400" />
          <span>Test AdSense API</span>
        </button>

        <label class="relative inline-flex items-center cursor-pointer">
          <input v-model="config.enableGoogleAdsense" type="checkbox" class="sr-only peer" />
          <div
            class="w-11 h-6 bg-gray-700 peer-focus:outline-none rounded-full peer peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:border-gray-300 after:border after:rounded-full after:h-5 after:w-5 after:transition-all peer-checked:bg-blue-600"
          ></div>
          <span class="ml-2 text-xs font-semibold text-gray-300">Enable AdSense</span>
        </label>
      </div>
    </div>

    <div class="grid gap-6 md:grid-cols-2">
      <div class="space-y-1">
        <label class="block text-xs font-semibold text-gray-300">Google Publisher ID (ca-pub-XXXXXXXXXXXX)</label>
        <input
          v-model="config.googlePublisherId"
          type="text"
          placeholder="ca-pub-9876543210987654"
          class="w-full rounded-lg border border-gray-700 bg-gray-800 px-3.5 py-2 text-sm text-white font-mono focus:border-blue-500 focus:outline-none focus:ring-2 focus:ring-blue-500/20"
        />
        <p class="text-[11px] text-gray-500">Your unique Google AdSense client account identifier.</p>
      </div>

      <div class="space-y-1">
        <label class="block text-xs font-semibold text-gray-300">Top Banner Ad Slot ID</label>
        <input
          v-model="config.googleBannerSlotId"
          type="text"
          placeholder="e.g. 1234567890"
          class="w-full rounded-lg border border-gray-700 bg-gray-800 px-3.5 py-2 text-sm text-white font-mono focus:border-blue-500 focus:outline-none focus:ring-2 focus:ring-blue-500/20"
        />
        <p class="text-[11px] text-gray-500">Ad unit slot ID for 728x90 header banner.</p>
      </div>

      <div class="space-y-1">
        <label class="block text-xs font-semibold text-gray-300">In-Article Ad Slot ID</label>
        <input
          v-model="config.googleInArticleSlotId"
          type="text"
          placeholder="e.g. 9876543210"
          class="w-full rounded-lg border border-gray-700 bg-gray-800 px-3.5 py-2 text-sm text-white font-mono focus:border-blue-500 focus:outline-none focus:ring-2 focus:ring-blue-500/20"
        />
        <p class="text-[11px] text-gray-500">Responsive ad slot placed inside creator articles.</p>
      </div>

      <div class="space-y-3 pt-2">
        <label class="flex items-center gap-2 cursor-pointer">
          <input
            v-model="config.googleAutoAds"
            type="checkbox"
            class="rounded border-gray-700 bg-gray-800 text-blue-600 focus:ring-blue-500"
          />
          <span class="text-xs font-medium text-gray-300">Enable Google Auto Ads Script Injection</span>
        </label>

        <label class="flex items-center gap-2 cursor-pointer">
          <input
            v-model="autoShare"
            type="checkbox"
            class="rounded border-gray-700 bg-gray-800 text-emerald-500 focus:ring-emerald-500"
          />
          <span class="text-xs font-medium text-emerald-400 font-semibold">
            Auto-Share Google AdSense Payouts with Creators
          </span>
        </label>
      </div>
    </div>
  </div>
</template>
