<script setup lang="ts">
import { ref } from 'vue'
import { useRouteSeo } from '~/composables/useRouteSeo'

useRouteSeo('trending', {
  title: 'Trending Posts & Top Performing Campaigns',
  description: 'Track top converting ad streams, engagement rates, highest CTR announcements, and viral community posts on Signal Ads Platform.',
  path: '/trending',
  image: '/images/seo/og-trending.svg'
})

definePageMeta({
  layout: 'default'
})

const activeFilter = ref<'all' | 'ctr' | 'viral'>('all')

const trendingItems = [
  {
    rank: 1,
    title: 'Top 10 High-Yield Web3 Staking Protocols for Q3',
    ctr: '4.85% CTR',
    impressions: '142,500 views',
    author: 'CryptoSentinel',
    time: '2 hours ago',
    tag: 'Highest CTR',
    icon: 'i-heroicons-fire',
    tagColor: 'amber'
  },
  {
    rank: 2,
    title: 'Layer-2 Gas Fee Optimization Guide & Benchmark',
    ctr: '4.12% CTR',
    impressions: '98,200 views',
    author: 'EthInfraLab',
    time: '5 hours ago',
    tag: 'Trending Guide',
    icon: 'i-heroicons-chart-bar',
    tagColor: 'primary'
  },
  {
    rank: 3,
    title: 'Zero-Knowledge Proofs in Decentralized Advertising',
    ctr: '3.90% CTR',
    impressions: '76,400 views',
    author: 'PrivacyDev',
    time: '1 day ago',
    tag: 'Community Pick',
    icon: 'i-heroicons-star',
    tagColor: 'emerald'
  }
]
</script>

<template>
  <UContainer class="py-10 max-w-5xl space-y-8">
    <!-- Header Banner -->
    <div class="space-y-3 max-w-3xl">
      <div class="inline-flex items-center gap-2 px-3 py-1 rounded-full text-xs font-semibold bg-amber-500/10 text-amber-400 border border-amber-500/20">
        <UIcon name="i-heroicons-fire" class="w-4 h-4" />
        <span>Trending Content</span>
      </div>
      <h1 class="text-3xl font-extrabold tracking-tight text-gray-900 dark:text-gray-100">
        Trending Posts &amp; High-CTR Campaigns
      </h1>
      <p class="text-gray-600 dark:text-gray-400 text-lg">
        Discover top converting promotional posts, viral publisher content, and real-time CTR leaderboard rankings.
      </p>
    </div>

    <!-- Filter Pills -->
    <div class="flex items-center gap-2 border-b border-gray-200 dark:border-gray-800 pb-3">
      <UButton
        size="sm"
        :color="activeFilter === 'all' ? 'primary' : 'neutral'"
        :variant="activeFilter === 'all' ? 'solid' : 'ghost'"
        @click="activeFilter = 'all'"
      >
        🔥 All Trending
      </UButton>
      <UButton
        size="sm"
        :color="activeFilter === 'ctr' ? 'primary' : 'neutral'"
        :variant="activeFilter === 'ctr' ? 'solid' : 'ghost'"
        @click="activeFilter = 'ctr'"
      >
        📈 Highest CTR
      </UButton>
      <UButton
        size="sm"
        :color="activeFilter === 'viral' ? 'primary' : 'neutral'"
        :variant="activeFilter === 'viral' ? 'solid' : 'ghost'"
        @click="activeFilter = 'viral'"
      >
        ⚡ Most Shared
      </UButton>
    </div>

    <!-- Leaderboard List -->
    <div class="space-y-4">
      <UCard
        v-for="item in trendingItems"
        :key="item.rank"
        class="hover:shadow-md transition-shadow border border-gray-200 dark:border-gray-800"
      >
        <div class="flex flex-col md:flex-row items-start md:items-center justify-between gap-4">
          <div class="flex items-center gap-4">
            <!-- Rank Badge -->
            <div class="w-10 h-10 rounded-xl bg-amber-500/10 text-amber-400 font-extrabold text-lg flex items-center justify-center border border-amber-500/20 shrink-0">
              #{{ item.rank }}
            </div>

            <div class="space-y-1">
              <div class="flex items-center gap-2">
                <UBadge color="warning" variant="subtle" size="xs">{{ item.tag }}</UBadge>
                <span class="text-xs text-gray-400">by {{ item.author }} &bull; {{ item.time }}</span>
              </div>
              <h2 class="text-lg font-bold text-gray-900 dark:text-gray-100 hover:text-primary transition-colors cursor-pointer">
                {{ item.title }}
              </h2>
            </div>
          </div>

          <div class="flex items-center gap-6 self-end md:self-center shrink-0">
            <div class="text-right">
              <div class="text-sm font-extrabold text-emerald-400">{{ item.ctr }}</div>
              <div class="text-[11px] font-medium text-gray-400">{{ item.impressions }}</div>
            </div>
            <UButton size="sm" variant="ghost" color="neutral" icon="i-heroicons-arrow-up-right-20-solid" />
          </div>
        </div>
      </UCard>
    </div>
  </UContainer>
</template>
