<script setup lang="ts">
import { useCustomSeoMeta } from '~/lib/seo/metadata'

useCustomSeoMeta({
  title: 'Ad Formats Showcase',
  description: 'Explore the high-converting ad styles and native integrations available on AdsPlatform.',
  path: '/formats'
})

const formats = [
  { name: 'Native Banners', desc: 'Seamlessly blends into site article streams. Highest CTR due to contextual matching.', icon: 'i-heroicons-rectangle-group' },
  { name: 'Popunders', desc: 'Highly visible, full-page formats that open in a new tab. Ideal for gaming and utility traffic.', icon: 'i-heroicons-window' },
  { name: 'Sticky Footers', desc: 'Floating footer ads that lock to the screen bottom. Great for high engagement on mobile device screens.', icon: 'i-heroicons-square-3-stack-3d' }
]
</script>

<template>
  <UContainer class="py-10 max-w-4xl space-y-12">
    <!-- Header Section -->
    <div class="space-y-2 text-center max-w-2xl mx-auto">
      <h1 class="text-3xl font-extrabold tracking-tight text-gray-900 dark:text-gray-100">
        Diverse Ad Formats Designed to Engage
      </h1>
      <p class="text-gray-500 dark:text-gray-400 text-lg">
        Choose from our catalog of non-intrusive, native, and high-CTR ad designs.
      </p>
    </div>

    <!-- Formats Showcase List -->
    <div class="space-y-6">
      <div v-for="(format, idx) in formats" :key="idx" class="p-6 bg-white dark:bg-gray-900 border border-gray-100 dark:border-gray-800 rounded-2xl flex flex-col md:flex-row items-start md:items-center justify-between gap-6 hover:shadow-md transition-shadow">
        <div class="flex items-center gap-4">
          <div class="p-4 bg-primary/10 rounded-xl text-primary shrink-0">
            <UIcon :name="format.icon" class="w-8 h-8" />
          </div>
          <div class="space-y-1">
            <h3 class="font-bold text-lg text-gray-900 dark:text-gray-100">{{ format.name }}</h3>
            <p class="text-sm text-gray-500 dark:text-gray-400 max-w-lg leading-relaxed">{{ format.desc }}</p>
          </div>
        </div>
        <UButton color="neutral" variant="soft" size="sm">Preview Demo</UButton>
      </div>
    </div>
  </UContainer>
</template>
