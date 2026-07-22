<script setup lang="ts">
import { useCustomSeoMeta } from '~/lib/seo/metadata'

useCustomSeoMeta({
  title: 'Publishers - Monetize Traffic',
  description: 'Earn maximum revenue from your website or app with AdsPlatform.',
  path: '/publishers'
})

const benefits = [
  { title: 'Maximum CPM Rates', desc: 'Our smart bidding network forces advertisers to compete for your inventory, driving up CPMs.', icon: 'i-heroicons-banknotes' },
  { title: 'Easy Integration', desc: 'Just copy and paste a single script tag onto your site. Works with WordPress, React, HTML, and more.', icon: 'i-heroicons-code-bracket' },
  { title: 'Automated Payouts', desc: 'Receive your earnings automatically every 15 days. Minimum withdrawal is only $50.', icon: 'i-heroicons-calendar-days' }
]
</script>

<template>
  <UContainer class="py-10 max-w-4xl space-y-12">
    <!-- Hero Section -->
    <div class="text-center space-y-4 max-w-2xl mx-auto">
      <UBadge color="primary" variant="soft" size="lg">For Publishers</UBadge>
      <h1 class="text-4xl font-extrabold tracking-tight text-gray-900 dark:text-gray-100">
        Turn Your Traffic Into Stable Income
      </h1>
      <p class="text-gray-500 dark:text-gray-400 text-lg">
        Monetize your website traffic, blog views, or mobile app users with smart contextual ad placements.
      </p>
      <div class="flex items-center justify-center gap-4 pt-2">
        <UButton color="primary" size="lg" to="/creator">Start Monetization</UButton>
        <UButton color="neutral" variant="outline" size="lg" to="/pricing">Earnings Calculator</UButton>
      </div>
    </div>

    <!-- Benefits Grid -->
    <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
      <UCard v-for="(ben, idx) in benefits" :key="idx" class="border border-gray-100 dark:border-gray-800">
        <div class="space-y-4">
          <div class="p-3 bg-primary/10 rounded-xl w-fit text-primary">
            <UIcon :name="ben.icon" class="w-6 h-6" />
          </div>
          <h3 class="text-lg font-bold text-gray-900 dark:text-gray-100">{{ ben.title }}</h3>
          <p class="text-sm text-gray-500 dark:text-gray-400 leading-relaxed">{{ ben.desc }}</p>
        </div>
      </UCard>
    </div>

    <!-- FAQ Banner -->
    <div class="rounded-2xl bg-gradient-to-br from-primary-500/5 to-indigo-500/5 border border-primary-200/50 dark:border-primary-900/50 p-8 flex flex-col md:flex-row gap-8 items-center">
      <div class="flex-1 space-y-2">
        <h3 class="text-xl font-bold text-gray-900 dark:text-gray-100">How long does approval take?</h3>
        <p class="text-sm text-gray-600 dark:text-gray-400">
          Our manual compliance team checks new domain approvals within 24 hours. Once approved, ads begin delivering immediately.
        </p>
      </div>
      <UButton color="neutral" variant="soft" size="lg">Read FAQ Documentation</UButton>
    </div>
  </UContainer>
</template>
