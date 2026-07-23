<script setup lang="ts">
import { useCustomSeoMeta } from '~/lib/seo/metadata'

useCustomSeoMeta({
  title: 'Advertisers - Build Campaigns',
  description: 'Drive high-converting traffic and grow your brand with AdsPlatform.',
  path: '/advertisers'
})

const features = [
  { title: 'Global Targeting', desc: 'Reach users by country, region, device, OS, browser, and custom carrier connections.', icon: 'i-heroicons-globe-asia-australia' },
  { title: 'Anti-Fraud Filtering', desc: 'Our multi-layer verification system filters bot traffic, ensuring only real human views.', icon: 'i-heroicons-shield-check' },
  { title: 'Real-time Bidding (RTB)', desc: 'Optimize your budget with dynamic CPC and CPM pricing models that match you with ideal placements.', icon: 'i-heroicons-cpu-chip' }
]
</script>

<template>
  <UContainer class="py-10 max-w-4xl space-y-12">
    <!-- Hero Section -->
    <div class="text-center space-y-4 max-w-2xl mx-auto">
      <UBadge color="primary" variant="soft" size="lg">For Advertisers</UBadge>
      <h1 class="text-4xl font-extrabold tracking-tight text-gray-900 dark:text-gray-100">
        Acquire High-Quality Traffic That Converts
      </h1>
      <p class="text-gray-500 dark:text-gray-400 text-lg">
        Target your audience with surgical precision. Manage budgets, track ROI, and scale your conversions in real time.
      </p>
      <div class="flex items-center justify-center gap-4 pt-2">
        <UButton color="primary" size="lg" to="/creator">Create Ad Campaign</UButton>
        <UButton color="neutral" variant="outline" size="lg" to="/pricing">View Traffic Rates</UButton>
      </div>
    </div>

    <!-- Features Grid -->
    <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
      <UCard v-for="(feat, idx) in features" :key="idx" class="border border-gray-100 dark:border-gray-800">
        <div class="space-y-4">
          <div class="p-3 bg-primary/10 rounded-xl w-fit text-primary">
            <UIcon :name="feat.icon" class="w-6 h-6" />
          </div>
          <h3 class="text-lg font-bold text-gray-900 dark:text-gray-100">{{ feat.title }}</h3>
          <p class="text-sm text-gray-500 dark:text-gray-400 leading-relaxed">{{ feat.desc }}</p>
        </div>
      </UCard>
    </div>

    <!-- CTA Stats Card -->
    <div class="rounded-2xl bg-gray-900 dark:bg-gray-900/50 border border-gray-800 p-8 text-center space-y-6">
      <h2 class="text-2xl font-bold text-gray-100">Ready to boost your ROI?</h2>
      <p class="text-gray-400 max-w-md mx-auto text-sm">
        Start with as little as $50 minimum deposit. Select your ad format, choose your countries, and go live in less than 10 minutes.
      </p>
      <UButton color="primary" size="lg" icon="i-heroicons-bolt">Get Started Now</UButton>
    </div>
  </UContainer>
</template>
