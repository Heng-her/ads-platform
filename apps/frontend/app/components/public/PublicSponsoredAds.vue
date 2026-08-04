<script setup lang="ts">
import { getArticleUrl } from '~/lib/utils'

const props = defineProps<{
  sponsoredAds: any[]
}>()
</script>

<template>
  <div class="rounded-2xl border p-4 shadow-lg space-y-3 bg-white dark:bg-gray-900 border-amber-500/30">
    <div class="flex items-center justify-between">
      <span class="text-[10px] font-mono uppercase tracking-wider font-bold px-2 py-0.5 rounded bg-amber-500/10 text-amber-600 dark:text-amber-400 border border-amber-500/30 flex items-center gap-1">
        <UIcon name="i-heroicons-megaphone" class="w-3.5 h-3.5" /> Sponsored Ads
      </span>
      <span class="text-[10px] font-mono font-semibold text-gray-500 dark:text-gray-400">Ad Network</span>
    </div>

    <!-- Render active sponsored ad if available -->
    <div v-if="sponsoredAds.length > 0" class="space-y-3">
      <div v-for="ad in sponsoredAds.slice(0, 2)" :key="ad.id"
        class="p-3 rounded-xl bg-gray-50 dark:bg-gray-800/60 border border-gray-200 dark:border-gray-700 space-y-2 hover:border-amber-500/40 transition-colors">
        <NuxtLink :to="getArticleUrl(ad)" class="block">
          <img v-if="ad.imageUrl" :src="ad.imageUrl" :alt="ad.title" class="h-24 w-full object-cover rounded-lg mb-2" />
          <h5 class="text-xs font-bold text-gray-900 dark:text-white hover:text-amber-500 transition-colors line-clamp-2">
            {{ ad.title }}
          </h5>
        </NuxtLink>
        <div class="flex items-center justify-between text-[10px] font-mono font-semibold text-gray-600 dark:text-gray-300">
          <span class="text-amber-500 font-bold">{{ ad.adNetwork || 'Partner Ad' }}</span>
          <span class="flex items-center gap-1">
            <UIcon name="i-heroicons-eye" class="w-3 h-3 text-primary" /> {{ (ad.totalImpressions ?? 0).toLocaleString() }}
          </span>
        </div>
      </div>
    </div>

    <!-- Default Ad Partner Callout if no sponsored ad currently in list -->
    <div v-else class="p-4 rounded-xl bg-gray-50 dark:bg-gray-800/60 border border-gray-200 dark:border-gray-700 text-center space-y-2">
      <div class="h-10 w-10 rounded-xl bg-amber-500/10 text-amber-500 flex items-center justify-center mx-auto border border-amber-500/20">
        <UIcon name="i-heroicons-cursor-arrow-rays" class="w-5 h-5 text-amber-500" />
      </div>
      <h5 class="text-xs font-bold text-gray-900 dark:text-white">Place Your Ad Unit Here</h5>
      <p class="text-[11px] font-medium text-gray-600 dark:text-gray-300 leading-relaxed">
        Reach targeted audiences across the Signal Network with instant campaign placement.
      </p>
      <NuxtLink to="/creator" class="inline-flex items-center gap-1 text-[11px] font-mono font-bold px-3 py-1.5 rounded-lg bg-amber-500 text-white hover:bg-amber-600 transition-all">
        <span>Promote Campaign</span>
        <UIcon name="i-heroicons-arrow-right" class="w-3.5 h-3.5" />
      </NuxtLink>
    </div>
  </div>
</template>

<style scoped>
.line-clamp-2 {
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}
</style>
