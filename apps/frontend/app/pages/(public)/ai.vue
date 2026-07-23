<script setup lang="ts">
import { useCustomSeoMeta } from '~/lib/seo/metadata'

useCustomSeoMeta({
  title: 'AI Optimizations',
  description: 'AI-driven ad campaigns optimization suggestions on AdsPlatform.',
  path: '/ai'
})

const recommendations = [
  {
    type: 'Bid Adjustment',
    impact: 'High',
    description: 'Increase the target CPC bid for "Tech Enthusiasts" segment by $0.05. Model projects a 24% increase in conversion volume.',
    action: 'Apply Bid Change'
  },
  {
    type: 'Ad Copy Generation',
    impact: 'Medium',
    description: 'Generate fresh copy variations using GPT-context models to combat audience ad fatigue on current banner ads.',
    action: 'Generate Copy'
  },
  {
    type: 'Negative Placement',
    impact: 'Medium',
    description: 'Auto-exclude low-engagement placements in mobile gaming networks to reduce ad waste by $45/day.',
    action: 'Exclude Placements'
  }
]
</script>

<template>
  <UContainer class="py-10 max-w-4xl space-y-8">
    <div class="space-y-2">
      <h1 class="text-3xl font-extrabold tracking-tight text-gray-900 dark:text-gray-100 flex items-center gap-2">
        <UIcon name="i-heroicons-sparkles" class="w-8 h-8 text-primary" />
        AI Engine Optimizations
      </h1>
      <p class="text-gray-500 dark:text-gray-400 text-lg">
        Leverage machine learning to boost performance and reduce CPC ad spend.
      </p>
    </div>

    <!-- AI Banner -->
    <div
      class="rounded-2xl border border-primary-500/30 bg-primary-50/50 dark:bg-primary-950/20 p-6 flex flex-col md:flex-row gap-6 items-center">
      <div class="flex-1 space-y-3">
        <div class="flex items-center gap-2">
          <UBadge color="primary" variant="subtle" size="sm">Smart Mode Active</UBadge>
          <span class="text-xs text-gray-500 font-medium">Updated 5m ago</span>
        </div>
        <h2 class="text-xl font-bold text-gray-900 dark:text-gray-100">
          Optimization score is 88/100
        </h2>
        <p class="text-sm text-gray-600 dark:text-gray-400">
          Your campaigns are performing well, but we detected 3 new optimization suggestions that could increase your
          click-through rates.
        </p>
      </div>
      <div
        class="flex items-center justify-center shrink-0 w-24 h-24 bg-primary/10 rounded-xl relative border border-primary/20">
        <span class="text-3xl font-extrabold text-primary">88</span>
      </div>
    </div>

    <!-- Suggestions List -->
    <div class="space-y-4">
      <h3 class="text-lg font-bold text-gray-900 dark:text-gray-100">
        Recommended Recommendations
      </h3>

      <div class="space-y-3">
        <UCard v-for="(rec, idx) in recommendations" :key="idx" class="hover:border-primary-500/40 transition-colors">
          <div class="flex flex-col md:flex-row justify-between items-start md:items-center gap-4">
            <div class="space-y-1.5 flex-1">
              <div class="flex items-center gap-2">
                <span class="font-bold text-gray-900 dark:text-gray-100">{{ rec.type }}</span>
                <UBadge :color="rec.impact === 'High' ? 'error' : 'warning'" size="xs" variant="subtle">
                  {{ rec.impact }} Impact
                </UBadge>
              </div>
              <p class="text-sm text-gray-600 dark:text-gray-400">
                {{ rec.description }}
              </p>
            </div>
            <UButton size="sm" color="primary" class="shrink-0">
              {{ rec.action }}
            </UButton>
          </div>
        </UCard>
      </div>
    </div>
  </UContainer>
</template>
