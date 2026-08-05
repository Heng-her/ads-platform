<script setup lang="ts">
import { getArticleUrl } from '~/lib/utils'
import type { CampaignItem } from '~/types/campaign'

const props = defineProps<{
  sponsoredAds: CampaignItem[]
}>()
</script>

<template>
  <div
    class="rounded-2xl border p-4 shadow-sm space-y-3 bg-white dark:bg-[#122131] border-gray-200 dark:border-[#273647]">
    <div class="flex items-center justify-between pb-2 border-b border-gray-100 dark:border-[#273647]">
      <span
        class="text-[10px] font-mono uppercase tracking-wider font-extrabold px-2.5 py-1 rounded-lg bg-gray-100 dark:bg-[#18293c] text-gray-900 dark:text-white border border-gray-200/60 dark:border-[#273647] flex items-center gap-1.5 shadow-sm">
        <UIcon name="i-heroicons-megaphone" class="w-3.5 h-3.5" /> Sponsored Ads
      </span>
      <span class="text-[10px] font-mono font-bold text-gray-400 dark:text-gray-500">Ad Network</span>
    </div>

    <!-- Render active sponsored ad if available -->
    <div v-if="sponsoredAds.length > 0" class="space-y-3">
      <div v-for="ad in sponsoredAds.slice(0, 2)" :key="ad.id"
        class="p-3 rounded-xl bg-gray-50 dark:bg-[#0d1c2d] border border-gray-200 dark:border-[#273647] space-y-2.5 hover:border-primary/50 transition-all group">
        <NuxtLink :to="getArticleUrl(ad)" class="block">
          <div
            class="w-full h-32 bg-gray-900 rounded-lg overflow-hidden relative border border-gray-200 dark:border-[#273647]">
            <img v-if="ad.imageUrl" :src="ad.imageUrl" :alt="ad.title"
              class="w-full h-full object-cover opacity-90 group-hover:scale-105 transition-transform duration-300" />
            <div v-else class="w-full h-full bg-gray-800 flex items-center justify-center">
              <UIcon name="i-heroicons-megaphone" class="w-8 h-8 text-gray-500" />
            </div>
            <div
              class="absolute inset-0 bg-gradient-to-t from-gray-950/90 via-gray-950/30 to-transparent flex flex-col justify-end p-2.5">
              <h5 class="text-xs font-bold text-white drop-shadow-md line-clamp-2">
                {{ ad.title }}
              </h5>
            </div>
          </div>
        </NuxtLink>

        <div
          class="flex items-center justify-between text-[10px] font-mono font-semibold text-gray-600 dark:text-gray-300 px-1">
          <span class="text-primary font-bold">{{ ad.adNetwork || 'Partner Ad' }}</span>
          <span class="flex items-center gap-1 text-gray-500 dark:text-gray-400">
            <UIcon name="i-heroicons-eye" class="w-3.5 h-3.5 text-primary" /> {{ (ad.totalImpressions ??
              0).toLocaleString() }}
          </span>
        </div>
      </div>
    </div>

    <!-- Default Ad Partner Callout if no sponsored ad currently in list -->
    <div v-else
      class="p-4 rounded-xl bg-gray-50 dark:bg-[#0d1c2d] border border-gray-200 dark:border-[#273647] text-center space-y-2.5">
      <div
        class="h-10 w-10 rounded-xl bg-gray-100 dark:bg-[#18293c] text-gray-900 dark:text-white border border-gray-200/60 dark:border-[#273647] flex items-center justify-center mx-auto shadow-sm">
        <UIcon name="i-heroicons-cursor-arrow-rays" class="w-5 h-5 text-gray-900 dark:text-white" />
      </div>
      <h5 class="text-xs font-extrabold text-gray-900 dark:text-white">Place Your Ad Unit Here</h5>
      <p class="text-[11px] font-medium text-gray-600 dark:text-gray-400 leading-relaxed">
        Reach targeted audiences across the Signal Network with instant campaign placement.
      </p>
      <NuxtLink to="/creator"
        class="inline-flex items-center gap-1 text-[11px] font-mono font-bold px-3 py-1.5 rounded-lg bg-gray-100 dark:bg-[#18293c] text-gray-900 dark:text-white hover:bg-gray-200 dark:hover:bg-[#20344b] border border-gray-200/60 dark:border-[#273647] transition-all shadow-sm">
        <span>Promote Campaign</span>
        <UIcon name="i-heroicons-arrow-right" class="w-3.5 h-3.5" />
      </NuxtLink>
    </div>
  </div>
</template>

<style scoped>
.line-clamp-2 {
  display: -webkit-box;
  /* -webkit-line-clamp: 2; */
  -webkit-box-orient: vertical;
  overflow: hidden;
}
</style>
