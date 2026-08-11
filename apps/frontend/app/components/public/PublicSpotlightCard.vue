<script setup lang="ts">
import { ref } from 'vue'
import { getArticleUrl, stripHtml } from '~/lib/utils'
import type { CampaignItem } from '~/types/campaign'

const props = defineProps<{
  campaign: CampaignItem | null
  copiedId: string | null
}>()

const isShareModalOpen = ref(false)

const emit = defineEmits<{
  (e: 'copy-link', campaign: CampaignItem): void
}>()

</script>

<template>
  <div v-if="campaign"
    class="rounded-2xl p-5 sm:p-6 border shadow-lg relative overflow-hidden transition-all duration-300 bg-white dark:bg-[#122131] border-gray-200 dark:border-[#273647] hover:border-primary/60">

    <!-- Top Accent Glow -->
    <div class="absolute -top-12 -right-12 w-48 h-48 rounded-full bg-primary/10 blur-3xl pointer-events-none" />

    <!-- Card Header -->
    <div class="flex items-center justify-between gap-3 mb-4">
      <div class="flex items-center gap-2.5">
        <div
          class="h-8 w-8 rounded-xl flex items-center justify-center font-bold text-sm bg-primary/10 text-primary border border-primary/20 shadow-sm">
          <UIcon name="i-heroicons-bolt" class="w-4 h-4 text-primary" />
        </div>
        <div>
          <h3 class="font-display font-bold text-sm tracking-tight text-primary">
            Signal Spotlight
          </h3>
          <span class="text-[10px] font-mono font-medium text-gray-500 dark:text-gray-400">
            Featured Campaign Result
          </span>
        </div>
      </div>
    </div>

    <!-- Title & Content -->
    <NuxtLink :to="getArticleUrl(campaign)">
      <h2
        class="font-display font-extrabold text-xl sm:text-2xl text-gray-900 dark:text-white hover:text-primary transition-colors mb-3 leading-snug cursor-pointer">
        {{ campaign.title }}
      </h2>
    </NuxtLink>

    <p class="text-sm leading-relaxed font-medium text-gray-700 dark:text-gray-200 line-clamp-3 mb-5 font-body">
      {{ stripHtml(campaign.content || campaign.description) }}
    </p>

    <!-- Footer Info & Actions -->
    <div class="flex flex-wrap items-center justify-between gap-4 pt-4 border-t border-gray-200 dark:border-gray-800">
      <div class="flex items-center gap-4 shrink-0">
        <div
          class="flex items-center gap-3 font-mono text-xs font-semibold text-gray-700 dark:text-gray-200 bg-gray-50 dark:bg-gray-800/80 px-3 py-1.5 rounded-xl border border-gray-200 dark:border-gray-700">
          <span title="Total Impressions" class="flex items-center gap-1">
            <UIcon name="i-heroicons-eye" class="w-3.5 h-3.5 text-primary shrink-0" />
            <span>{{ (campaign.totalImpressions ?? 0).toLocaleString() }}</span>
          </span>
          <span class="text-gray-300 dark:text-gray-700">|</span>
          <span title="Unique Viewers" class="flex items-center gap-1">
            <UIcon name="i-heroicons-users" class="w-3.5 h-3.5 text-sky-500 shrink-0" />
            <span>{{ (campaign.uniqueViewers ?? 0).toLocaleString() }}</span>
          </span>
        </div>

        <div class="flex items-center gap-1.5">
          <button @click="isShareModalOpen = true"
            class="px-3 py-1.5 rounded-xl bg-gray-100 dark:bg-gray-800 hover:bg-gray-200 dark:hover:bg-gray-700 text-gray-800 dark:text-gray-200 transition-all text-xs flex items-center gap-1.5 font-bold"
            title="Share article">
            <UIcon name="i-heroicons-share" class="w-3.5 h-3.5 text-primary" />
            <span>Share</span>
          </button>
        </div>
      </div>
    </div>

    <!-- Share Modal -->
    <PublicShareModal v-model="isShareModalOpen" :article="campaign" />
  </div>
</template>
