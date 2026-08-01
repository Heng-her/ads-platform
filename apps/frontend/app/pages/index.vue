<script setup lang="ts">
import { useCustomSeoMeta } from '~/lib/seo/metadata'
import HomeHero from '~/components/home/HomeHero.vue'
import HomePartners from '~/components/home/HomePartners.vue'
import HomePillars from '~/components/home/HomePillars.vue'
import HomeHowItWorks from '~/components/home/HomeHowItWorks.vue'
import HomeComparison from '~/components/home/HomeComparison.vue'
import HomeSecurity from '~/components/home/HomeSecurity.vue'
import HomeSandbox from '~/components/home/HomeSandbox.vue'
import HomeRoadmap from '~/components/home/HomeRoadmap.vue'
import HomeFaq from '~/components/home/HomeFaq.vue'
import HomeCta from '~/components/home/HomeCta.vue'

useCustomSeoMeta({
  title: 'Decentralized Web3 Advertising Platform',
  description: 'Transparent, escrow-backed advertising infrastructure powered by smart contracts. Programmatic payouts, 0.5% protocol fees, zero middleman markups.',
  path: '/'
})
</script>

<template>
  <div class="space-y-24 md:space-y-32 py-4">
    <!-- 1. Hero Section & Web3 dApp Wallet Escrow Deposit -->
    <HomeHero />

    <!-- 2. Network & Infrastructure Compatibility -->
    <HomePartners />

    <!-- 3. Core Architectural Pillars -->
    <HomePillars />

    <!-- 4. How It Works (Dual Perspective Workflow) -->
    <HomeHowItWorks />

    <!-- 5. Financial Efficiency Matrix & ROI Calculator -->
    <HomeComparison />

    <!-- 6. Smart Contract Security Architecture -->
    <HomeSecurity />

    <!-- 7. Interactive Dashboard Sandbox -->
    <HomeSandbox />

    <!-- 8. Protocol Engineering Roadmap -->
    <HomeRoadmap />

    <!-- 9. Technical & Operational FAQ -->
    <HomeFaq />

    <!-- 10. Final Call to Action Banner -->
    <HomeCta />
  </div>
</template>
