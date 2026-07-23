<script setup lang="ts">
import { useCustomSeoMeta } from '~/lib/seo/metadata'

useCustomSeoMeta({
  title: 'News Hub',
  description: 'Stay updated with the latest trends and announcements on AdsPlatform.',
  path: '/news'
})

const articles = [
  {
    title: 'Introducing Next-Gen AI Ad Targeting',
    category: 'Product Update',
    date: 'July 22, 2026',
    description: 'Learn how our new machine learning models optimize conversion rates up to 40% using contextual semantic matching.',
    icon: 'i-heroicons-sparkles',
    color: 'primary'
  },
  {
    title: 'Global Ad Spend Forecast for Q3 2026',
    category: 'Finance & Markets',
    date: 'July 18, 2026',
    description: 'Digital advertising budgets are projected to grow by 12.4% globally, led by retail media and video advertising streams.',
    icon: 'i-heroicons-chart-bar-square',
    color: 'info'
  },
  {
    title: 'Best Practices for High-Converting Ad Copy',
    category: 'Guides',
    date: 'July 15, 2026',
    description: 'A comprehensive guide on leveraging emotional triggers and clear calls-to-action to double your click-through rates.',
    icon: 'i-heroicons-book-open',
    color: 'warning'
  }
]
</script>

<template>
  <UContainer class="py-10 max-w-4xl space-y-8">
    <div class="space-y-2">
      <h1 class="text-3xl font-extrabold tracking-tight text-gray-900 dark:text-gray-100 flex items-center gap-2">
        <UIcon name="i-heroicons-newspaper" class="w-8 h-8 text-primary" />
        News Hub
      </h1>
      <p class="text-gray-500 dark:text-gray-400 text-lg">
        The latest insights, articles, and product releases from AdsPlatform.
      </p>
    </div>

    <!-- Featured Banner -->
    <div class="rounded-2xl bg-gradient-to-r from-primary-500/10 to-indigo-500/10 border border-primary-200 dark:border-primary-800 p-6 md:p-8 flex flex-col md:flex-row gap-6 items-center">
      <div class="flex-1 space-y-3">
        <UBadge color="primary" variant="solid">Featured Announcement</UBadge>
        <h2 class="text-2xl font-bold text-gray-900 dark:text-gray-100">
          AdsPlatform goes multi-chain & global
        </h2>
        <p class="text-gray-600 dark:text-gray-400">
          We have expanded our payment rails to support automated international settlements, paying out publisher earnings in local currencies and popular stablecoins.
        </p>
        <UButton color="primary" icon="i-heroicons-arrow-right" trailing>Read Article</UButton>
      </div>
      <div class="w-32 h-32 bg-primary/20 rounded-full flex items-center justify-center shrink-0">
        <UIcon name="i-heroicons-globe-alt" class="w-16 h-16 text-primary" />
      </div>
    </div>

    <!-- Articles Grid -->
    <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
      <UCard v-for="(article, idx) in articles" :key="idx" class="flex flex-col h-full hover:shadow-lg transition-shadow">
        <div class="flex-1 space-y-4">
          <div class="flex items-center justify-between">
            <span class="text-xs font-semibold uppercase tracking-wider text-primary">{{ article.category }}</span>
            <span class="text-xs text-gray-400">{{ article.date }}</span>
          </div>
          <h3 class="text-lg font-bold text-gray-900 dark:text-gray-100 line-clamp-2">
            {{ article.title }}
          </h3>
          <p class="text-sm text-gray-500 dark:text-gray-400 line-clamp-3">
            {{ article.description }}
          </p>
        </div>
        <template #footer>
          <div class="flex items-center justify-between">
            <UButton variant="ghost" color="neutral" size="sm" class="p-0 hover:bg-transparent">
              Read More
            </UButton>
            <UIcon :name="article.icon" class="w-5 h-5 text-gray-400" />
          </div>
        </template>
      </UCard>
    </div>
  </UContainer>
</template>
