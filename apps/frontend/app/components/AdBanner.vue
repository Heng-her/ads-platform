<script setup lang="ts">
import { computed, onMounted, ref, watch } from 'vue'
import { usePublicAdConfig } from '~/composables/usePublicAdConfig'

const props = withDefaults(
  defineProps<{
    slotType?: 'header' | 'in-article' | 'sidebar' | 'articleTop' | 'articleSidebar' | 'categoryFeed'
    creatorId?: string
    campaignId?: string
    provider?: 'all' | 'google' | 'adsterra'
  }>(),
  {
    slotType: 'header',
    provider: 'all'
  }
)

const { adConfig } = usePublicAdConfig()
const adPushed = ref(false)

function handleSmartlinkClick() {
  if (!import.meta.client) return

  try {
    const payload = JSON.stringify({
      campaignId: props.campaignId || undefined,
      creatorId: props.creatorId || undefined,
      provider: 'ADSTERRA',
      format: 'SMARTLINK',
      placement: props.slotType || 'header'
    })

    if (typeof navigator !== 'undefined' && navigator.sendBeacon) {
      navigator.sendBeacon('/api/ads/click', new Blob([payload], { type: 'application/json' }))
    } else {
      $fetch('/api/ads/click', {
        method: 'POST',
        body: JSON.parse(payload),
        keepalive: true
      }).catch(() => { })
    }
  } catch (e) {
    // Non-blocking error handler — user navigation will proceed seamlessly
  }
}

const adsterraTrackingUrl = computed(() => {
  const baseUrl = adConfig.value?.adsterra?.smartlinkUrl
  if (!baseUrl) return '#'
  if (!props.creatorId) return baseUrl
  const separator = baseUrl.includes('?') ? '&' : '?'
  return `${baseUrl}${separator}subid=${encodeURIComponent(props.creatorId)}`
})

const isSidebar = computed(() => props.slotType === 'sidebar' || props.slotType === 'articleSidebar')

const headerTitle = computed(() => {
  if (props.provider === 'google') return 'Google AdSense Monetization'
  if (props.provider === 'adsterra') return 'Adsterra High-CPM Sponsor'
  return isSidebar.value ? 'Sponsored Ads' : 'Dual Ad Network Monetization (Google AdSense + Adsterra Smartlink)'
})

const activeSlotId = computed(() => {
  if (!adConfig.value?.googleAdsense?.slots) return ''
  const slots = adConfig.value.googleAdsense.slots
  if (props.slotType === 'in-article') return slots.inArticle || slots.articleTop || ''
  if (props.slotType === 'sidebar' || props.slotType === 'articleSidebar') return slots.articleSidebar || slots.sidebar || slots.header || ''
  return slots[props.slotType] || slots.header || slots.articleTop || ''
})

const showGoogle = computed(() => {
  const pubId = adConfig.value?.googleAdsense?.publisherId
  const isValidPublisherId =
    Boolean(pubId) &&
    pubId.startsWith('ca-pub-') &&
    pubId !== 'ca-pub-9876543210987654'

  return Boolean(
    adConfig.value?.googleAdsense?.enabled &&
    isValidPublisherId &&
    activeSlotId.value &&
    (props.provider === 'all' || props.provider === 'google')
  )
})

const showAdsterra = computed(() => {
  return Boolean(
    adConfig.value?.adsterra?.enabled &&
    adConfig.value?.adsterra?.smartlinkEnabled &&
    adConfig.value?.adsterra?.smartlinkUrl &&
    (props.provider === 'all' || props.provider === 'adsterra')
  )
})

function initAdSense() {
  if (!import.meta.client || !showGoogle.value || adPushed.value) return

  try {
    const pubId = adConfig.value.googleAdsense.publisherId
    if (!document.querySelector('script[src*="pagead2.googlesyndication.com"]')) {
      const script = document.createElement('script')
      script.async = true
      script.src = `https://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js?client=${pubId}`
      script.crossOrigin = 'anonymous'
      document.head.appendChild(script)
    }

    ; (window as any).adsbygoogle = (window as any).adsbygoogle || []
      ; (window as any).adsbygoogle.push({})
    adPushed.value = true
  } catch (e) {
    console.warn('AdSense push warning:', e)
  }
}

onMounted(() => {
  initAdSense()
})

watch([showGoogle, activeSlotId], () => {
  initAdSense()
})
</script>

<template>
  <div v-if="showGoogle || showAdsterra" :class="isSidebar ? 'space-y-3' : 'my-6 space-y-3'">
    <div
      class="flex items-center justify-between text-[11px] font-semibold text-gray-500 dark:text-gray-400 uppercase tracking-wider px-1">
      <span class="flex items-center gap-1.5 truncate">
        <UIcon name="i-heroicons-banknotes" class="w-4 h-4 text-emerald-500 shrink-0" />
        {{ headerTitle }}
      </span>
    </div>

    <!-- Ad Network Grid (1-column if single provider or sidebar, 2-column if all on wide banner) -->
    <div
      :class="(isSidebar || provider !== 'all') ? 'grid grid-cols-1 gap-3' : 'grid grid-cols-1 md:grid-cols-2 gap-4'">

      <!-- AD NETWORK 1: Real Google AdSense Display Ads -->
      <div v-if="showGoogle"
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
            Slot {{ activeSlotId }}
          </UBadge>
        </div>

        <!-- Real Google AdSense Tag Container -->
        <div
          class="my-2 p-2 rounded-xl bg-white dark:bg-gray-900 border border-blue-200 dark:border-blue-900/50 text-center min-h-[90px] flex items-center justify-center overflow-hidden">
          <ins class="adsbygoogle" style="display:block; width:100%;"
            :data-ad-client="adConfig.googleAdsense.publisherId" :data-ad-slot="activeSlotId" data-ad-format="auto"
            data-full-width-responsive="true" :data-ad-channel="creatorId || undefined"></ins>
        </div>
      </div>

      <!-- AD NETWORK 2: Adsterra High-CPM Smartlink -->
      <a v-if="showAdsterra" :href="adsterraTrackingUrl" target="_blank" rel="noopener noreferrer"
        @click="handleSmartlinkClick"
        class="group relative overflow-hidden rounded-2xl border border-amber-500/30 bg-gradient-to-br from-amber-500/10 via-amber-500/5 to-transparent p-4 transition-all duration-300 active:scale-[0.98] active:duration-100 hover:border-amber-500/60 hover:shadow-lg hover:shadow-amber-500/10 dark:from-amber-950/40 dark:via-gray-900 dark:to-gray-900">
        <!-- Background Ambient Glow Effect -->
        <div
          class="pointer-events-none absolute -right-6 -top-6 h-24 w-24 rounded-full bg-amber-500/10 blur-xl transition-all duration-500 group-hover:bg-amber-500/20">
        </div>

        <!-- Top Header Row -->
        <div class="mb-3 flex items-center justify-between border-b border-amber-500/20 pb-2.5">
          <div class="flex items-center gap-2">
            <div
              class="flex h-7 w-7 items-center justify-center rounded-lg bg-gradient-to-tr from-amber-500 to-amber-400 text-white shadow-sm shadow-amber-500/30">
              <UIcon name="i-heroicons-bolt" class="h-4 w-4 animate-pulse" />
            </div>
            <div>
              <h4
                class="text-xs font-extrabold tracking-tight text-gray-900 transition-colors group-hover:text-amber-500 dark:text-white dark:group-hover:text-amber-400">
                Special Partner Offer
              </h4>
              <p class="text-[10px] font-medium text-gray-500 dark:text-gray-400">
                Featured Sponsor Content
              </p>
            </div>
          </div>
          <span
            class="inline-flex items-center gap-1 rounded-full bg-amber-500/15 px-2.5 py-0.5 text-[10px] font-bold text-amber-600 dark:text-amber-400">
            <span class="h-1.5 w-1.5 rounded-full bg-amber-500 animate-ping"></span>
            Sponsored
          </span>
        </div>

        <!-- Smartlink Interactive Call To Action Box -->
        <div
          class="relative rounded-xl border border-amber-200/80 bg-white/90 p-3.5 text-center backdrop-blur-sm transition-all duration-300 group-hover:border-amber-400 group-hover:bg-white dark:border-amber-900/40 dark:bg-gray-900/90 dark:group-hover:border-amber-500/60 dark:group-hover:bg-gray-900">
          <div
            class="mb-1 flex items-center justify-center gap-1 text-[11px] font-bold uppercase tracking-wider text-amber-600 dark:text-amber-400">
            <span>Exclusive Deal</span>
            <UIcon name="i-heroicons-sparkles" class="h-3.5 w-3.5 text-amber-500" />
          </div>
          <p
            class="text-xs font-bold text-gray-900 transition-colors group-hover:text-amber-600 dark:text-white dark:group-hover:text-amber-400">
            Explore Partner Offers & Rewards
          </p>
          <p class="mt-1 text-[11px] text-gray-500 dark:text-gray-400">
            Click to launch exclusive partner deals and support creator content.
          </p>

          <!-- Interactive Action Button Pill -->
          <div
            class="mt-3 flex items-center justify-center gap-1.5 rounded-lg bg-gradient-to-r from-amber-500 to-amber-600 px-3 py-1.5 text-xs font-bold text-white shadow-md shadow-amber-500/20 transition-all duration-300 group-hover:from-amber-600 group-hover:to-amber-500 group-hover:shadow-amber-500/40">
            <span>View Special Offer</span>
            <UIcon name="i-heroicons-arrow-right"
              class="h-3.5 w-3.5 transition-transform duration-300 group-hover:translate-x-1" />
          </div>
        </div>
      </a>
    </div>
  </div>
</template>
