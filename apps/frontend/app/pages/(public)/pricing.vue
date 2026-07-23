<script setup lang="ts">
import { ref, computed } from 'vue'
import { useCustomSeoMeta } from '~/lib/seo/metadata'

useCustomSeoMeta({
  title: 'Pricing & Earnings Calculator',
  description: 'Calculate your advertising CPC cost and publisher monetization payouts on AdsPlatform.',
  path: '/pricing'
})

// Calculator state
const monthlyPageviews = ref(100000)
const averageCpm = ref(1.50)

const estimatedEarnings = computed(() => {
  return ((monthlyPageviews.value / 1000) * averageCpm.value).toFixed(2)
})

const tiers = [
  { name: 'Starter', minDeposit: '$50', support: 'Standard Email', features: ['Global traffic targeting', 'Standard anti-fraud filter', 'Self-serve panel'] },
  { name: 'Professional', minDeposit: '$500', support: 'Priority 24/7 Support', features: ['Advanced AI auto-bidding', 'Advanced targeting presets', 'Custom API access'] },
  { name: 'Enterprise', minDeposit: '$5,000+', support: 'Dedicated Manager', features: ['Custom publisher channels', 'Direct deal trading', 'Whitelabeled portal'] }
]
</script>

<template>
  <UContainer class="py-10 max-w-4xl space-y-12">
    <!-- Header -->
    <div class="text-center space-y-2 max-w-2xl mx-auto">
      <h1 class="text-3xl font-extrabold tracking-tight text-gray-900 dark:text-gray-100">
        Transparent Pricing & Earnings Estimation
      </h1>
      <p class="text-gray-500 dark:text-gray-400 text-lg">
        Whether you are buying traffic or monetizing views, calculate your value.
      </p>
    </div>

    <!-- Earnings Calculator Card -->
    <UCard class="max-w-xl mx-auto">
      <template #header>
        <h2 class="text-lg font-bold text-gray-900 dark:text-gray-100 flex items-center gap-2">
          <UIcon name="i-heroicons-calculator" class="w-5 h-5 text-primary" />
          Publisher Earnings Calculator
        </h2>
      </template>

      <div class="space-y-6">
        <div class="space-y-2">
          <div class="flex justify-between text-sm">
            <label class="font-medium text-gray-700 dark:text-gray-300">Monthly Pageviews</label>
            <span class="font-bold text-primary">{{ monthlyPageviews.toLocaleString() }} views</span>
          </div>
          <USlider v-model="monthlyPageviews" :min="10000" :max="1000000" :step="10000" />
        </div>

        <div class="space-y-2">
          <div class="flex justify-between text-sm">
            <label class="font-medium text-gray-700 dark:text-gray-300">Estimated CPM Rate</label>
            <span class="font-bold text-primary">${{ averageCpm.toFixed(2) }}</span>
          </div>
          <USlider v-model="averageCpm" :min="0.50" :max="10.00" :step="0.10" />
        </div>

        <div class="pt-6 border-t border-gray-100 dark:border-gray-800 text-center">
          <span class="text-xs uppercase tracking-wider font-bold text-gray-400 dark:text-gray-500">Estimated Monthly
            Income</span>
          <div class="text-4xl font-extrabold text-primary mt-1">
            ${{ estimatedEarnings }}
          </div>
        </div>
      </div>
    </UCard>

    <!-- Pricing Tiers Grid -->
    <div class="space-y-6">
      <h3 class="text-xl font-bold text-gray-900 dark:text-gray-100 text-center">Advertiser Budget Tiers</h3>
      <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
        <UCard v-for="(tier, idx) in tiers" :key="idx"
          class="flex flex-col h-full border border-gray-100 dark:border-gray-800 hover:shadow-md transition-shadow">
          <div class="flex-1 space-y-4">
            <h4 class="text-lg font-bold text-gray-900 dark:text-gray-100">{{ tier.name }}</h4>
            <div class="text-3xl font-extrabold text-primary">{{ tier.minDeposit }} <span
                class="text-xs font-normal text-gray-400 dark:text-gray-500">min deposit</span></div>
            <p class="text-xs text-gray-500 dark:text-gray-400">{{ tier.support }}</p>
            <ul class="space-y-2 pt-4 border-t border-gray-100 dark:border-gray-800">
              <li v-for="(feat, fidx) in tier.features" :key="fidx"
                class="text-xs text-gray-600 dark:text-gray-400 flex items-center gap-2">
                <UIcon name="i-heroicons-check" class="w-4 h-4 text-primary shrink-0" />
                <span>{{ feat }}</span>
              </li>
            </ul>
          </div>
        </UCard>
      </div>
    </div>
  </UContainer>
</template>
