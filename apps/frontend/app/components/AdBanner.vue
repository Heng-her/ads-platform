<script setup lang="ts">
import { ref, onMounted } from 'vue'

const props = defineProps<{
  slotType?: 'header' | 'in-article' | 'sidebar'
}>()

const adConfig = ref({
  enableGoogleAdsense: true,
  googlePublisherId: 'ca-pub-9876543210987654',
  googleBannerSlotId: '1234567890',
  enableAdsterra: true,
  adsterraDirectLinkUrl: 'https://www.highperformancecpmgate.com/direct-link-hash',
  adsterraBanner728x90Key: '10928374'
})

onMounted(() => {
  if (import.meta.client) {
    const saved = localStorage.getItem('admin_platform_config')
    if (saved) {
      try {
        const parsed = JSON.parse(saved)
        if (parsed.adNetworks) {
          adConfig.value = { ...adConfig.value, ...parsed.adNetworks }
        }
      } catch { }
    }
  }
})
const isSidebar = computed(() => props.slotType === 'sidebar')
</script>

<template>
  <div :class="isSidebar ? 'space-y-3' : 'my-6 space-y-3'">
    <div
      class="flex items-center justify-between text-[11px] font-semibold text-gray-500 dark:text-gray-400 uppercase tracking-wider px-1">
      <span class="flex items-center gap-1.5 truncate">
        <UIcon name="i-heroicons-banknotes" class="w-4 h-4 text-emerald-500 shrink-0" />
        {{ isSidebar ? 'Sponsored Ads' : 'Dual Ad Network Monetization (Google AdSense + Adsterra Smartlink)' }}
      </span>
      <span class="text-[10px] font-mono text-emerald-500 font-bold shrink-0">Active 💰</span>
    </div>

    <!-- Dual Ad Network Grid -->
    <div :class="isSidebar ? 'grid grid-cols-1 gap-3' : 'grid grid-cols-1 md:grid-cols-2 gap-4'">

      <!-- AD NETWORK 1: Google AdSense Display Ads -->
      <div v-if="adConfig.enableGoogleAdsense"
        class="rounded-2xl border border-blue-500/30 bg-blue-500/5 dark:bg-blue-950/20 p-4 relative overflow-hidden flex flex-col justify-between">
        <div class="flex items-center justify-between mb-3 border-b border-blue-500/20 pb-2">
          <div class="flex items-center gap-2">
            <div class="p-1.5 rounded-lg bg-blue-500/20 text-blue-400">
              <UIcon name="i-heroicons-sparkles" class="w-4 h-4" />
            </div>
            <div>
              <h4 class="text-xs font-bold text-gray-900 dark:text-white">Google AdSense</h4>
              <p class="text-[10px] text-gray-500 dark:text-gray-400">Display Ads & Auto-Ads</p>
            </div>
          </div>
          <UBadge color="info" variant="soft" size="xs" class="font-mono text-[10px]">
            Slot {{ adConfig.googleBannerSlotId }}
          </UBadge>
        </div>

        <!-- Google AdSense Banner Simulation Container -->
        <div
          class="my-2 p-3.5 rounded-xl bg-white dark:bg-gray-900 border border-blue-200 dark:border-blue-900/50 text-center space-y-1">
          <div class="text-[10px] text-gray-400 font-mono">
            [Google Ads Unit: {{ adConfig.googlePublisherId }}]
          </div>
          <p class="text-xs font-bold text-blue-600 dark:text-blue-400">
            Responsive Display Ad Banner
          </p>
          <p class="text-[11px] text-gray-500 dark:text-gray-400">
            Programmatic AdSense impressions credited to creator total revenue.
          </p>
        </div>
      </div>

      <!-- AD NETWORK 2: Adsterra High-CPM Smartlink -->
      <a v-if="adConfig.enableAdsterra" :href="adConfig.adsterraDirectLinkUrl" target="_blank" rel="noopener noreferrer"
        class="group rounded-2xl border border-amber-500/30 bg-amber-500/5 dark:bg-amber-950/20 p-4 relative overflow-hidden flex flex-col justify-between hover:border-amber-500/60 transition-all">
        <div class="flex items-center justify-between mb-3 border-b border-amber-500/20 pb-2">
          <div class="flex items-center gap-2">
            <div class="p-1.5 rounded-lg bg-amber-500/20 text-amber-400">
              <UIcon name="i-heroicons-bolt" class="w-4 h-4" />
            </div>
            <div>
              <h4 class="text-xs font-bold text-gray-900 dark:text-white group-hover:text-amber-400 transition-colors">
                Adsterra Smartlink
              </h4>
              <p class="text-[10px] text-gray-500 dark:text-gray-400">High-CPM Direct Offers</p>
            </div>
          </div>
          <UBadge color="warning" variant="soft" size="xs" class="font-mono text-[10px]">
            Zone {{ adConfig.adsterraBanner728x90Key }}
          </UBadge>
        </div>

        <!-- Adsterra Smartlink Click Card -->
        <div
          class="my-2 p-3.5 rounded-xl bg-white dark:bg-gray-900 border border-amber-200 dark:border-amber-900/50 text-center space-y-1">
          <div class="text-[10px] text-amber-500 font-mono font-bold">
            ⚡ High-CPM Offer Gate
          </div>
          <p class="text-xs font-bold text-gray-900 dark:text-white group-hover:text-amber-400 transition-colors">
            Adsterra Direct Sponsor Link
          </p>
          <p class="text-[11px] text-gray-500 dark:text-gray-400">
            Click to launch sponsor offer & generate maximum yield.
          </p>
        </div>
      </a>
    </div>
  </div>
</template>
