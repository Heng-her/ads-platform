<script setup lang="ts">
export interface AdNetworkConfig {
  enableGoogleAdsense: boolean
  googlePublisherId: string
  googleAutoAds: boolean
  googleBannerSlotId: string
  googleInArticleSlotId: string

  enableAdsterra: boolean
  adsterraPublisherKey: string
  adsterraDirectLinkUrl: string
  adsterraBanner728x90Key: string
  adsterraNativeBannerKey: string
  adsterraPopunderEnabled: boolean

  customHeaderScript: string
  customArticleAdScript: string
}

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
        <div class="flex h-10 w-10 items-center justify-center rounded-xl bg-amber-500/10 text-amber-400 font-bold">
          <UIcon name="i-heroicons-bolt" class="h-6 w-6 text-amber-400" />
        </div>
        <div>
          <div class="flex items-center gap-2">
            <h2 class="text-lg font-semibold text-white">Adsterra Network Monetization</h2>
            <UBadge :color="config.enableAdsterra ? 'success' : 'neutral'" variant="soft" size="xs">
              {{ config.enableAdsterra ? 'Active & Monetizing' : 'Disabled' }}
            </UBadge>
          </div>
          <p class="text-xs text-gray-400">High-CPM ad format provider (Native Banners, Popunder, Direct Links, Social Bar).</p>
        </div>
      </div>

      <div class="flex items-center gap-3">
        <button
          :disabled="isTesting"
          class="inline-flex items-center gap-1.5 rounded-lg border border-amber-500/30 bg-amber-500/10 px-3 py-1.5 text-xs font-semibold text-amber-400 hover:bg-amber-500/20 disabled:opacity-50"
          @click="emit('test')"
        >
          <UIcon v-if="isTesting" name="i-heroicons-arrow-path" class="h-3.5 w-3.5 animate-spin" />
          <UIcon v-else name="i-heroicons-check-circle" class="h-3.5 w-3.5 text-amber-400" />
          <span>Test Adsterra API</span>
        </button>

        <label class="relative inline-flex items-center cursor-pointer">
          <input v-model="config.enableAdsterra" type="checkbox" class="sr-only peer" />
          <div
            class="w-11 h-6 bg-gray-700 peer-focus:outline-none rounded-full peer peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:border-gray-300 after:border after:rounded-full after:h-5 after:w-5 after:transition-all peer-checked:bg-amber-600"
          ></div>
          <span class="ml-2 text-xs font-semibold text-gray-300">Enable Adsterra</span>
        </label>
      </div>
    </div>

    <div class="grid gap-6 md:grid-cols-2">
      <div class="space-y-1">
        <label class="block text-xs font-semibold text-gray-300">Adsterra Publisher Key</label>
        <input
          v-model="config.adsterraPublisherKey"
          type="text"
          placeholder="adsterra_pub_key_xxx"
          class="w-full rounded-lg border border-gray-700 bg-gray-800 px-3.5 py-2 text-sm text-white font-mono focus:border-amber-500 focus:outline-none focus:ring-2 focus:ring-amber-500/20"
        />
        <p class="text-[11px] text-gray-500">Your Adsterra publisher account security token.</p>
      </div>

      <div class="space-y-1">
        <label class="block text-xs font-semibold text-gray-300">Adsterra Direct Link Offer URL</label>
        <input
          v-model="config.adsterraDirectLinkUrl"
          type="text"
          placeholder="https://www.highperformancecpmgate.com/..."
          class="w-full rounded-lg border border-gray-700 bg-gray-800 px-3.5 py-2 text-sm text-white font-mono focus:border-amber-500 focus:outline-none focus:ring-2 focus:ring-amber-500/20"
        />
        <p class="text-[11px] text-gray-500">Direct Link offer URL for high CPM impression redirects.</p>
      </div>

      <div class="space-y-1">
        <label class="block text-xs font-semibold text-gray-300">Leaderboard Banner (728x90) Zone Key</label>
        <input
          v-model="config.adsterraBanner728x90Key"
          type="text"
          placeholder="e.g. 10928374"
          class="w-full rounded-lg border border-gray-700 bg-gray-800 px-3.5 py-2 text-sm text-white font-mono focus:border-amber-500 focus:outline-none focus:ring-2 focus:ring-amber-500/20"
        />
      </div>

      <div class="space-y-1">
        <label class="block text-xs font-semibold text-gray-300">Native Banner (300x250) Zone Key</label>
        <input
          v-model="config.adsterraNativeBannerKey"
          type="text"
          placeholder="e.g. 56473829"
          class="w-full rounded-lg border border-gray-700 bg-gray-800 px-3.5 py-2 text-sm text-white font-mono focus:border-amber-500 focus:outline-none focus:ring-2 focus:ring-amber-500/20"
        />
      </div>

      <div class="col-span-2 pt-1">
        <label class="flex items-center gap-2 cursor-pointer">
          <input
            v-model="autoShare"
            type="checkbox"
            class="rounded border-gray-700 bg-gray-800 text-amber-500 focus:ring-amber-500"
          />
          <span class="text-xs font-medium text-amber-400 font-semibold">
            Auto-Share Adsterra Payouts with Creators
          </span>
        </label>
      </div>
    </div>
  </div>
</template>
