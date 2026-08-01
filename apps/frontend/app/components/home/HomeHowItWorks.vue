<script setup lang="ts">
import { ref } from 'vue'

const activeHowItWorksTab = ref<'advertiser' | 'publisher'>('advertiser')

const advertiserSteps = [
  {
    num: '01',
    title: 'Deploy Non-Custodial Ad Escrow',
    desc: 'Deposit your campaign budget directly into an open-source smart contract escrow. Funds remain locked on-chain under your wallet control.'
  },
  {
    num: '02',
    title: 'Set Privacy-Preserving Targeting',
    desc: 'Define contextual ad parameters and CPM/CPC bid caps without harvesting invasive personal data or private identity (PII).'
  },
  {
    num: '03',
    title: 'Cryptographic Proof Verification',
    desc: 'Ad impressions and engagements are validated in real time via cryptographic Merkle proofs and decentralized verification nodes.'
  },
  {
    num: '04',
    title: 'Programmatic Micro-Settlement',
    desc: 'Escrow funds are automatically micro-released to verified publishers as impressions occur. Unspent budget can be reclaimed anytime.'
  }
]

const publisherSteps = [
  {
    num: '01',
    title: 'Embed Non-Custodial SDK',
    desc: 'Integrate our lightweight Web3 Ad SDK or widget into your decentralized app, media site, or dApp portal in under 5 minutes.'
  },
  {
    num: '02',
    title: 'Serve Contextual Ad Inventory',
    desc: 'Serve high-quality targeted sponsor campaigns directly to your visitors without tracking cookies or third-party user profiling.'
  },
  {
    num: '03',
    title: 'Automated Real-Time Streams',
    desc: 'Receive programmatic payout streams directly into your connected Web3 wallet immediately as impression proofs complete on-chain.'
  },
  {
    num: '04',
    title: 'Stake for Protocol Fee Discounts',
    desc: 'Optionally stake protocol tokens to reduce network execution fees from 1.5% down to 0.5% and run verification nodes.'
  }
]
</script>

<template>
  <section class="max-w-6xl mx-auto space-y-8">
    <div class="text-center max-w-3xl mx-auto space-y-3">
      <UBadge color="neutral" variant="outline" class="font-mono text-xs uppercase">Step-by-Step Architecture</UBadge>
      <h2 class="text-3xl sm:text-4xl font-extrabold text-gray-900 dark:text-white">
        How the Protocol Executes
      </h2>
      <p class="text-sm text-gray-600 dark:text-gray-400">Select your role to view the on-chain workflow.</p>
    </div>

    <!-- Tab Switcher -->
    <div class="flex justify-center">
      <div class="p-1 bg-gray-200 dark:bg-gray-850 rounded-xl flex gap-1 border border-gray-300 dark:border-gray-800">
        <button
          type="button"
          class="px-6 py-2 rounded-lg text-xs font-bold transition-all"
          :class="activeHowItWorksTab === 'advertiser'
            ? 'bg-white dark:bg-gray-900 text-emerald-500 shadow-sm'
            : 'text-gray-500 dark:text-gray-400 hover:text-gray-900 dark:hover:text-white'"
          @click="activeHowItWorksTab = 'advertiser'"
        >
          For Advertisers & Brands
        </button>
        <button
          type="button"
          class="px-6 py-2 rounded-lg text-xs font-bold transition-all"
          :class="activeHowItWorksTab === 'publisher'
            ? 'bg-white dark:bg-gray-900 text-emerald-500 shadow-sm'
            : 'text-gray-500 dark:text-gray-400 hover:text-gray-900 dark:hover:text-white'"
          @click="activeHowItWorksTab = 'publisher'"
        >
          For Publishers & Validators
        </button>
      </div>
    </div>

    <!-- Workflow Cards Grid -->
    <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
      <div
        v-for="step in (activeHowItWorksTab === 'advertiser' ? advertiserSteps : publisherSteps)"
        :key="step.num"
        class="p-6 rounded-2xl bg-white dark:bg-gray-900 border border-gray-200 dark:border-gray-800 relative space-y-3"
      >
        <div class="text-2xl font-mono font-extrabold text-emerald-500/80">{{ step.num }}</div>
        <h3 class="text-base font-bold text-gray-900 dark:text-white">{{ step.title }}</h3>
        <p class="text-xs text-gray-600 dark:text-gray-400 leading-relaxed">{{ step.desc }}</p>
      </div>
    </div>
  </section>
</template>
