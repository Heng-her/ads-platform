<script setup lang="ts">
import { computed, ref } from 'vue'
import { getArticleUrl } from '~/lib/utils'
import type { CampaignItem } from '~/types/campaign'

const props = defineProps<{
  campaign: CampaignItem
}>()

const isShareModalOpen = ref(false)
const galleryImages = computed(() => [...new Set([
  props.campaign.imageUrl,
  ...(props.campaign.images || []).map((image: any) => image.url)
].filter(Boolean))] as string[])

function stripHtml(html: string | null | undefined) {
  if (!html) return ''
  return html.replace(/<[^>]*>/g, ' ').replace(/\s+/g, ' ').trim()
}
</script>

<template>
  <div class="block">
    <article
      class="bg-white dark:bg-[#122131] rounded-2xl p-4 sm:p-5 border border-gray-200 dark:border-[#273647] hover:border-primary/50 transition-all duration-200 shadow-sm hover:shadow-md group flex flex-col gap-3">

      <!-- Top Content & Details Section -->
      <div class="flex flex-col gap-2.5">
        <NuxtLink :to="getArticleUrl(campaign)">
          <h3
            class="font-bold text-base sm:text-lg text-gray-900 dark:text-white group-hover:text-primary transition-colors mb-1 leading-snug line-clamp-2">
            {{ campaign.title }}
          </h3>
        </NuxtLink>

        <p class="text-xs sm:text-sm text-gray-600 dark:text-gray-400 line-clamp-2 mb-2 leading-relaxed">
          {{ stripHtml(campaign.content || campaign.description) }}
        </p>

        <!-- Stats & Share Action Row -->
        <div class="flex items-center gap-3 text-xs font-medium text-gray-500 dark:text-gray-400 mb-1">
          <span class="flex items-center gap-1.5 text-primary font-bold" title="Total Impressions">
            <UIcon name="i-heroicons-eye" class="w-4 h-4 text-primary" />
            <span>{{ (campaign.totalImpressions ?? 0).toLocaleString() }}</span>
          </span>

          <span class="w-1 h-1 rounded-full bg-gray-300 dark:bg-gray-700" />

          <span class="flex items-center gap-1.5 text-sky-500 dark:text-sky-400 font-semibold" title="Unique Viewers">
            <UIcon name="i-heroicons-user-group" class="w-4 h-4" />
            <span>{{ (campaign.uniqueViewers ?? 0).toLocaleString() }}</span>
          </span>

          <span class="w-1 h-1 rounded-full bg-gray-300 dark:bg-gray-700" />

          <button @click.stop.prevent="isShareModalOpen = true"
            class="flex items-center gap-1.5 text-gray-500 dark:text-gray-400 hover:text-primary dark:hover:text-primary transition-colors font-semibold cursor-pointer"
            title="Share article">
            <UIcon name="i-heroicons-share" class="w-4 h-4 text-primary" />
            <span>Share</span>
          </button>
        </div>
      </div>

      <!-- Full-Width Media Image Banner Container -->
      <NuxtLink :to="getArticleUrl(campaign)" class="block w-full">
        <div
          class="w-full h-56 sm:h-72 bg-gray-100 dark:bg-[#0d1c2d] rounded-xl overflow-hidden shrink-0 border border-gray-200 dark:border-[#273647] flex items-center justify-center shadow-inner relative group/img">
          <img v-if="galleryImages[0]" :src="galleryImages[0]" :alt="campaign.imageTitle || campaign.title"
            loading="lazy"
            class="w-full h-full object-cover group-hover/img:scale-105 transition-transform duration-300" />
          <div v-else class="flex flex-col items-center gap-1 text-gray-400 dark:text-gray-600">
            <UIcon name="i-heroicons-photo" class="w-10 h-10" />
            <span class="text-[11px] font-mono font-medium">Image Preview</span>
          </div>
          <span v-if="galleryImages.length > 1"
            class="absolute bottom-2 left-2 rounded-md bg-black/70 px-2 py-1 text-[10px] font-semibold text-white">{{
              galleryImages.length }} images</span>
          <span v-if="campaign.videoUrls?.length"
            class="absolute bottom-2 right-2 inline-flex items-center gap-1 rounded-md bg-black/70 px-2 py-1 text-[10px] font-semibold text-white">
            <UIcon name="i-heroicons-play" class="h-3 w-3" />{{ campaign.videoUrls.length }}
          </span>
        </div>
      </NuxtLink>

    </article>

    <!-- Social Share Modal -->
    <PublicShareModal v-model="isShareModalOpen" :article="campaign" />
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
