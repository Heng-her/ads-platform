<script setup lang="ts">
import { ref, computed } from 'vue'
import { useRouteSeo } from '~/composables/useRouteSeo'

useRouteSeo('explore', {
  title: 'Explore Feed — Discover Verified Campaigns & Web3 Channels',
  description: 'Browse real-time ad placements, publisher analytics, verified creator channels, and top-tier Web3 promotional opportunities.',
  path: '/explore',
  image: '/images/seo/og-explore.svg'
})

definePageMeta({
  layout: 'default'
})

const searchQuery = ref('')
const selectedCategory = ref('All')

const categories = ['All', 'DeFi & Trading', 'NFTs & Gaming', 'AI & Infrastructure', 'Web3 Media', 'DAOs']

const campaigns = [
  {
    id: '1',
    title: 'Aegis Security Audit Protocol Launch',
    category: 'DeFi & Trading',
    budget: '$15,000 USDC',
    cpmRate: '$2.40 CPM',
    description: 'Promote our automated smart contract vulnerability scanner to Web3 developers and security auditors.',
    icon: 'i-heroicons-shield-check',
    verified: true,
    color: 'primary'
  },
  {
    id: '2',
    title: 'Vortex DEX Liquidity Aggregator V3',
    category: 'DeFi & Trading',
    budget: '$25,000 USDT',
    cpmRate: '$3.10 CPM',
    description: 'High-conversion banner campaign targeting active crypto traders and yield farmers across top finance blogs.',
    icon: 'i-heroicons-arrow-path-rounded-square',
    verified: true,
    color: 'emerald'
  },
  {
    id: '3',
    title: 'CyberVerse MMORPG Open Beta Registration',
    category: 'NFTs & Gaming',
    budget: '$8,500 USDC',
    cpmRate: '$1.80 CPM',
    description: 'Player acquisition campaign across gaming streams, Discord communities, and Metaverse media outlets.',
    icon: 'i-heroicons-cpu-chip',
    verified: false,
    color: 'purple'
  },
  {
    id: '4',
    title: 'Cognitive AI Autonomous Trading Agent',
    category: 'AI & Infrastructure',
    budget: '$12,000 USDC',
    cpmRate: '$2.90 CPM',
    description: 'Native sponsored article placement targeting algorithmic traders and AI technology enthusiasts.',
    icon: 'i-heroicons-sparkles',
    verified: true,
    color: 'indigo'
  }
]

const filteredCampaigns = computed(() => {
  return campaigns.filter(item => {
    const matchesCat = selectedCategory.value === 'All' || item.category === selectedCategory.value
    const matchesSearch = item.title.toLowerCase().includes(searchQuery.value.toLowerCase()) ||
                          item.description.toLowerCase().includes(searchQuery.value.toLowerCase())
    return matchesCat && matchesSearch
  })
})
</script>

<template>
  <UContainer class="py-10 max-w-5xl space-y-8">
    <!-- Header Banner -->
    <div class="space-y-3 max-w-3xl">
      <div class="inline-flex items-center gap-2 px-3 py-1 rounded-full text-xs font-semibold bg-primary-500/10 text-primary-400 border border-primary-500/20">
        <UIcon name="i-heroicons-magnifying-glass" class="w-4 h-4" />
        <span>Explore Feed</span>
      </div>
      <h1 class="text-3xl font-extrabold tracking-tight text-gray-900 dark:text-gray-100">
        Discover Verified Ad Campaigns &amp; Channels
      </h1>
      <p class="text-gray-600 dark:text-gray-400 text-lg">
        Explore active advertiser bids, publisher channel opportunities, and real-time impression streams on Signal.
      </p>
    </div>

    <!-- Search Bar & Filters -->
    <div class="flex flex-col md:flex-row gap-4 justify-between items-stretch md:items-center">
      <UInput
        v-model="searchQuery"
        icon="i-heroicons-magnifying-glass"
        placeholder="Search campaigns, categories, or keywords..."
        class="w-full md:w-80"
        size="md"
      />

      <div class="flex flex-wrap gap-2">
        <UButton
          v-for="cat in categories"
          :key="cat"
          size="sm"
          :color="selectedCategory === cat ? 'primary' : 'neutral'"
          :variant="selectedCategory === cat ? 'solid' : 'ghost'"
          @click="selectedCategory = cat"
        >
          {{ cat }}
        </UButton>
      </div>
    </div>

    <!-- Campaigns Grid -->
    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
      <UCard
        v-for="campaign in filteredCampaigns"
        :key="campaign.id"
        class="flex flex-col justify-between hover:shadow-lg transition-all border border-gray-200 dark:border-gray-800"
      >
        <div class="space-y-4">
          <div class="flex items-start justify-between">
            <span class="text-xs font-semibold px-2.5 py-1 rounded-md bg-gray-100 dark:bg-gray-800 text-primary-400">
              {{ campaign.category }}
            </span>
            <div v-if="campaign.verified" class="flex items-center gap-1 text-xs font-medium text-emerald-400">
              <UIcon name="i-heroicons-check-badge" class="w-4 h-4" />
              <span>Escrow Verified</span>
            </div>
          </div>

          <h3 class="text-xl font-bold text-gray-900 dark:text-gray-100 flex items-center gap-2">
            <UIcon :name="campaign.icon" class="w-6 h-6 text-primary shrink-0" />
            {{ campaign.title }}
          </h3>

          <p class="text-sm text-gray-600 dark:text-gray-400">
            {{ campaign.description }}
          </p>
        </div>

        <div class="mt-6 pt-4 border-t border-gray-100 dark:border-gray-800 flex items-center justify-between">
          <div>
            <div class="text-[11px] font-semibold text-gray-400 uppercase">CAMPAIGN BUDGET</div>
            <div class="text-lg font-extrabold text-primary-400">{{ campaign.budget }}</div>
          </div>

          <div class="text-right">
            <div class="text-[11px] font-semibold text-gray-400 uppercase">ESTIMATED CPM</div>
            <div class="text-sm font-bold text-gray-200">{{ campaign.cpmRate }}</div>
          </div>
        </div>
      </UCard>
    </div>
  </UContainer>
</template>
