<script setup lang="ts">
import { getArticleUrl } from '~/lib/utils'

const props = defineProps<{
  campaign: any
  copiedId: string | null
}>()

const emit = defineEmits<{
  (e: 'copy-link', campaign: any): void
}>()

function stripHtml(html: string | null | undefined) {
  if (!html) return ''
  return html.replace(/<[^>]*>/g, ' ').replace(/\s+/g, ' ').trim()
}

function timeAgo(iso: string) {
  if (!iso) return 'recently'
  const diffMs = Date.now() - new Date(iso).getTime()
  const mins = Math.floor(diffMs / 60000)
  if (mins < 1) return 'just now'
  if (mins < 60) return `${mins}m ago`
  const hours = Math.floor(mins / 60)
  if (hours < 24) return `${hours}h ago`
  const days = Math.floor(hours / 24)
  if (days < 30) return `${days}d ago`
  const months = Math.floor(days / 30)
  if (months < 12) return `${months}mo ago`
  return `${Math.floor(months / 12)}y ago`
}

function initials(name: string) {
  if (!name) return '?'
  return name.trim().slice(0, 2).toUpperCase()
}
</script>

<template>
  <div v-if="campaign"
    class="rounded-2xl p-6 border shadow-xl relative overflow-hidden transition-all duration-300 bg-white dark:bg-gray-900 border-primary/30 hover:border-primary/60">

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
          <button @click="emit('copy-link', campaign)"
            class="p-2 rounded-xl bg-gray-100 dark:bg-gray-800 hover:bg-gray-200 dark:hover:bg-gray-700 text-gray-700 dark:text-gray-200 transition-all text-xs flex items-center gap-1 font-semibold"
            title="Copy link">
            <span v-if="copiedId === campaign.id" class="text-primary font-mono text-[10px]">Copied!</span>
            <UIcon v-else name="i-heroicons-link" class="w-3.5 h-3.5" />
          </button>
        </div>
      </div>
    </div>
  </div>
</template>
