<script setup lang="ts">
const props = defineProps<{
  campaign: any
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
</script>

<template>
  <article
    class="result-row rounded-2xl p-5 border transition-all duration-200 bg-white dark:bg-gray-900 border-gray-200 dark:border-gray-800 hover:border-primary/50 flex flex-col sm:flex-row gap-5">
    <div class="flex-1 min-w-0 flex flex-col justify-between">
      <div>
        <div class="flex items-center gap-2 text-xs font-mono mb-1.5 text-gray-500 dark:text-gray-400 font-medium">
          <span class="text-primary font-bold">{{ campaign.creator?.username || 'publisher' }}</span>
          <span>·</span>
          <span>{{ timeAgo(campaign.createdAt) }}</span>
        </div>

        <NuxtLink :to="`/public/${campaign.id}`">
          <h3
            class="font-display font-bold text-base sm:text-lg text-gray-900 dark:text-white hover:text-primary transition-colors mb-2 leading-snug cursor-pointer">
            {{ campaign.title }}
          </h3>
        </NuxtLink>

        <p
          class="text-xs sm:text-sm leading-relaxed font-medium text-gray-700 dark:text-gray-300 line-clamp-2 font-body">
          {{ stripHtml(campaign.content || campaign.description) }}
        </p>
      </div>

      <div
        class="flex items-center gap-3 mt-4 pt-3 border-t border-gray-100 dark:border-gray-800 font-mono text-[11px] font-semibold text-gray-700 dark:text-gray-300">
        <span title="Impressions" class="flex items-center gap-1">
          <UIcon name="i-heroicons-eye" class="w-3.5 h-3.5 text-primary shrink-0" />
          <span>{{ (campaign.totalImpressions ?? 0).toLocaleString() }}</span>
        </span>
        <span>·</span>
        <span title="Unique Viewers" class="flex items-center gap-1">
          <UIcon name="i-heroicons-users" class="w-3.5 h-3.5 text-sky-500 shrink-0" />
          <span>{{ (campaign.uniqueViewers ?? 0).toLocaleString() }}</span>
        </span>
      </div>
    </div>

    <div v-if="campaign.imageUrl" class="shrink-0">
      <NuxtLink :to="`/public/${campaign.id}`">
        <img :src="campaign.imageUrl" :alt="campaign.imageTitle || campaign.title" loading="lazy"
          class="h-24 w-24 sm:h-28 sm:w-28 rounded-xl object-cover border border-gray-200 dark:border-gray-800 shadow-md hover:opacity-90 transition-opacity cursor-pointer" />
      </NuxtLink>
    </div>
  </article>
</template>

<style scoped>
.result-row:hover {
  box-shadow: 0 10px 30px -10px rgba(45, 212, 191, 0.15);
}

.line-clamp-2 {
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}
</style>
