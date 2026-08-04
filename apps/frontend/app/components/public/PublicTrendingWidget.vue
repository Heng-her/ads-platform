<script setup lang="ts">
import { getArticleUrl } from '~/lib/utils'

const props = defineProps<{
  item: any
}>()
</script>

<template>
  <div v-if="item" class="rounded-2xl overflow-hidden border shadow-sm transition-all bg-white dark:bg-gray-900 border-gray-200 dark:border-gray-800 hover:border-gray-900 dark:hover:border-white">
    <NuxtLink :to="getArticleUrl(item)">
      <div class="relative h-28 w-full bg-gray-900 cursor-pointer">
        <img v-if="item.imageUrl" :src="item.imageUrl" :alt="item.title" class="h-full w-full object-cover" />
        <div class="absolute inset-0 bg-gradient-to-t from-gray-950 via-gray-950/40 to-transparent"></div>
        <span class="absolute top-2.5 left-2.5 text-[9px] font-mono uppercase tracking-wider font-extrabold px-2 py-0.5 rounded-md bg-gray-900 text-white dark:bg-white dark:text-gray-950 shadow-sm flex items-center gap-1">
          <UIcon name="i-heroicons-fire" class="w-3 h-3" /> Relevant News
        </span>
      </div>
    </NuxtLink>
    <div class="p-3.5">
      <h4 class="text-[11px] font-mono font-semibold text-gray-500 dark:text-gray-400 mb-1">
        {{ item.category || 'Industry Report' }}
      </h4>
      <NuxtLink :to="getArticleUrl(item)">
        <p class="text-xs font-display font-bold text-gray-900 dark:text-white leading-snug line-clamp-2 hover:underline transition-all cursor-pointer">
          {{ item.title }}
        </p>
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
