<script setup lang="ts">
import { computed } from 'vue'
import { useRoute } from 'vue-router'
import { usePublicAdConfig } from '~/composables/usePublicAdConfig'
import { useCategories } from '~/composables/useCategories'

const props = defineProps<{
  category?: string
  creatorId?: string
  campaignId?: string
}>()

const route = useRoute()
const { adConfig } = usePublicAdConfig()
const { categories, myCategories } = useCategories()

const activeCategoryName = computed(() => {
  const cat = props.category || (route.query.category as string) || ''
  return cat.trim()
})

const activeCategoryItem = computed(() => {
  if (!activeCategoryName.value) return null
  const nameLower = activeCategoryName.value.toLowerCase()
  return (
    categories.value.find(c => c.name?.toLowerCase() === nameLower) ||
    myCategories.value.find(c => c.name?.toLowerCase() === nameLower) ||
    null
  )
})

const isEnabled = computed(() => {
  const adsterra = adConfig.value?.adsterra
  const isAdsterraEnabled = adsterra?.enabled ?? true
  const isSmartlinkEnabled = adsterra?.smartlinkEnabled ?? true
  const hasUrl = Boolean(activeCategoryItem.value?.adsterraSmartlinkUrl || adsterra?.smartlinkUrl)

  return Boolean(isAdsterraEnabled && isSmartlinkEnabled && hasUrl)
})

const trackingUrl = computed(() => {
  const customUrl = activeCategoryItem.value?.adsterraSmartlinkUrl
  const baseUrl = customUrl || adConfig.value?.adsterra?.smartlinkUrl
  if (!baseUrl) return '#'
  if (!props.creatorId) return baseUrl
  const separator = baseUrl.includes('?') ? '&' : '?'
  return `${baseUrl}${separator}subid=${encodeURIComponent(props.creatorId)}`
})

function handleCategoryAdClick() {
  if (!import.meta.client) return

  try {
    const config = useRuntimeConfig()
    const apiBase = (config.public as any)?.apiBase || '/api'
    const endpoint = `${apiBase.replace(/\/$/, '')}/ads/click`

    const payload = JSON.stringify({
      campaignId: props.campaignId || undefined,
      creatorId: props.creatorId || undefined,
      provider: 'ADSTERRA',
      format: 'SMARTLINK',
      placement: 'categoryFeed'
    })

    if (typeof fetch !== 'undefined') {
      fetch(endpoint, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: payload,
        keepalive: true,
        mode: 'cors'
      }).catch(() => { })
    }

    if (typeof navigator !== 'undefined' && navigator.sendBeacon) {
      const blob = new Blob([payload], { type: 'text/plain' })
      navigator.sendBeacon(endpoint, blob)
    }
  } catch (e) { }
}
</script>

<template>
  <div v-if="isEnabled" class="w-full my-2">
    <a :href="trackingUrl" target="_blank" rel="noopener noreferrer" @click="handleCategoryAdClick"
      class="group relative overflow-hidden rounded-2xl border border-amber-500/30 bg-gradient-to-r from-amber-500/15 via-amber-500/5 to-transparent p-5 transition-all duration-300 active:scale-[0.99] hover:border-amber-500/60 hover:shadow-xl hover:shadow-amber-500/10 dark:from-amber-950/50 dark:via-gray-900 dark:to-gray-900 flex flex-col sm:flex-row items-start sm:items-center justify-between gap-4">
      
      <!-- Background Ambient Glow Effect -->
      <div class="pointer-events-none absolute -right-10 -top-10 h-32 w-32 rounded-full bg-amber-500/15 blur-2xl transition-all duration-500 group-hover:bg-amber-500/25"></div>

      <!-- Left Info Content -->
      <div class="space-y-1.5 min-w-0 flex-1">
        <div class="flex items-center gap-2 flex-wrap">
          <span class="inline-flex items-center gap-1.5 rounded-full bg-amber-500/20 px-3 py-0.5 text-[11px] font-extrabold uppercase tracking-wider text-amber-600 dark:text-amber-400">
            <span class="h-2 w-2 rounded-full bg-amber-500 animate-ping"></span>
            Category Partner {{ activeCategoryName ? `• ${activeCategoryName}` : '' }}
          </span>
          <span class="text-[11px] font-bold text-gray-500 dark:text-gray-400 uppercase tracking-wider">
            Sponsored Offer
          </span>
        </div>

        <h3 class="text-base sm:text-lg font-black tracking-tight text-gray-900 dark:text-white group-hover:text-amber-500 dark:group-hover:text-amber-400 transition-colors">
          Exclusive {{ activeCategoryName || 'Special' }} Deals & Partner Rewards
        </h3>

        <p class="text-xs text-gray-600 dark:text-gray-300 font-medium line-clamp-1">
          Explore verified partner promotions, special discounts, and high-value rewards tailored for {{ activeCategoryName || 'platform' }} readers.
        </p>
      </div>

      <!-- Right Action CTA Button -->
      <div class="shrink-0 w-full sm:w-auto">
        <div class="inline-flex items-center justify-center gap-2 w-full sm:w-auto px-5 py-2.5 rounded-xl bg-gradient-to-r from-amber-500 to-amber-600 text-white font-bold text-xs shadow-md shadow-amber-500/25 group-hover:shadow-amber-500/40 group-hover:scale-105 transition-all">
          <span>View {{ activeCategoryName ? `${activeCategoryName} Offer` : 'Special Offer' }}</span>
          <UIcon name="i-heroicons-arrow-right" class="w-4 h-4 group-hover:translate-x-1 transition-transform" />
        </div>
      </div>
    </a>
  </div>
</template>
