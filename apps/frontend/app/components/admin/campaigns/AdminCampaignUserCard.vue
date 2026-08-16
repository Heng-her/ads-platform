<script setup lang="ts">
import type { AdminCampaignUser } from '~/composables/useCampaigns'
import { getArticleUrl } from '~/lib/utils'

defineProps<{
  user: AdminCampaignUser
}>()
</script>

<template>
  <article
    class="overflow-hidden rounded-2xl border border-gray-200 bg-white dark:border-gray-800 dark:bg-gray-900 shadow-sm transition hover:border-gray-700">
    <!-- User Card Header -->
    <header class="flex flex-col gap-3 p-4 sm:flex-row sm:items-center sm:justify-between border-b border-gray-100 dark:border-gray-800/60">
      <div class="flex min-w-0 items-center gap-3">
        <img v-if="user.avatar" :src="user.avatar" :alt="user.username"
          class="h-10 w-10 rounded-full object-cover border border-gray-700 shrink-0" />
        <div v-else
          class="flex h-10 w-10 items-center justify-center rounded-full bg-primary-100 font-bold text-primary-700 dark:bg-primary-950 dark:text-primary-300 shrink-0 text-sm">
          {{ user.username.charAt(0).toUpperCase() }}
        </div>
        <div class="min-w-0">
          <div class="flex flex-wrap items-center gap-2">
            <h2 class="truncate font-bold text-gray-900 dark:text-gray-100 text-sm sm:text-base">{{ user.username }}</h2>
            <UBadge :color="user.status === 'ACTIVE' ? 'success' : 'warning'" variant="soft" size="xs" class="font-semibold">
              {{ user.status }}
            </UBadge>
          </div>
          <p class="truncate text-xs text-gray-500 dark:text-gray-400 font-mono">{{ user.email }}</p>
        </div>
      </div>

      <!-- Manage Campaigns Button -> Direct Navigation Page -->
      <NuxtLink :to="`/admin/campaigns/user/${user.id}`"
        class="inline-flex items-center justify-center gap-1.5 rounded-xl bg-primary-600 px-3.5 py-1.5 text-xs font-bold text-white hover:bg-primary-500 active:scale-95 transition-all shadow-xs shrink-0">
        <UIcon name="i-heroicons-squares-2x2" class="w-4 h-4" />
        <span>Manage Campaigns</span>
        <UIcon name="i-heroicons-arrow-right" class="w-3.5 h-3.5" />
      </NuxtLink>
    </header>

    <!-- Compact Latest Public Posts Strip (Slim UI) -->
    <section class="bg-gray-50/50 p-3.5 dark:bg-gray-950/40">
      <div class="mb-2 flex items-center justify-between">
        <span class="text-[11px] font-bold uppercase tracking-wider text-gray-400">Latest Public Posts</span>
        <span class="text-[10px] text-gray-500 font-mono">Max 3</span>
      </div>

      <div v-if="user.publicPosts.length" class="space-y-2">
        <NuxtLink v-for="post in user.publicPosts" :key="post.id" :to="getArticleUrl(post)" target="_blank"
          class="group flex items-center justify-between gap-3 p-2 rounded-lg bg-white dark:bg-gray-900/80 border border-gray-200/80 dark:border-gray-800 hover:border-primary-500/40 transition-all">
          <div class="flex items-center gap-2.5 min-w-0">
            <img v-if="post.imageUrl" :src="post.imageUrl" :alt="post.title"
              class="h-7 w-7 rounded-md object-cover border border-gray-800 shrink-0" />
            <div v-else class="h-7 w-7 rounded-md bg-gray-800 flex items-center justify-center text-gray-500 shrink-0">
              <UIcon name="i-heroicons-photo" class="w-3.5 h-3.5" />
            </div>
            <p class="truncate text-xs font-semibold text-gray-800 dark:text-gray-200 group-hover:text-primary-400 transition-colors">
              {{ post.title }}
            </p>
          </div>

          <div class="flex items-center gap-2 shrink-0 text-[10px]">
            <span class="px-2 py-0.5 rounded bg-gray-100 dark:bg-gray-800 text-gray-400 font-medium">
              {{ post.category || 'General' }}
            </span>
            <span class="text-gray-500 font-mono hidden sm:inline">
              {{ new Date(post.createdAt).toLocaleDateString() }}
            </span>
            <UIcon name="i-heroicons-arrow-top-right-on-square" class="w-3.5 h-3.5 text-gray-500 group-hover:text-primary-400 transition-colors" />
          </div>
        </NuxtLink>
      </div>

      <p v-else class="text-center text-xs text-gray-500 italic py-1">
        No public posts published yet.
      </p>
    </section>
  </article>
</template>
