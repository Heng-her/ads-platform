<script setup lang="ts">
const securityPillars = [
  {
    title: 'Non-Custodial Escrows',
    icon: 'i-heroicons-lock-closed',
    desc: 'Ad deposits are locked strictly within smart contract escrows. Platform operators have zero custody over advertiser funds.'
  },
  {
    title: 'Multi-Sig & Timelocks',
    icon: 'i-heroicons-shield-check',
    desc: 'Protocol upgrades require multi-signature approval and enforced 48-hour timelocks for full ecosystem transparency.'
  },
  {
    title: 'Circuit Breaker Pause',
    icon: 'i-heroicons-bolt',
    desc: 'Automated anomaly detection circuit breakers temporarily halt payouts if abnormal verification spikes occur.'
  },
  {
    title: 'Open-Source Auditing',
    icon: 'i-heroicons-code-bracket',
    desc: 'All smart contract logic is publicly verifiable on block explorers with immutable execution rules.'
  }
]
</script>

<template>
  <section class="max-w-6xl mx-auto space-y-8">
    <div class="text-center max-w-3xl mx-auto space-y-3">
      <UBadge color="neutral" variant="outline" class="font-mono text-xs uppercase">On-Chain Trust Architecture</UBadge>
      <h2 class="text-3xl sm:text-4xl font-extrabold text-gray-900 dark:text-white">
        Secured by Audited Smart Contracts & Timelocks
      </h2>
      <p class="text-sm text-gray-600 dark:text-gray-400">
        How campaign funds and automated settlement rules are protected on-chain without human intervention.
      </p>
    </div>

    <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
      <div v-for="pillar in securityPillars" :key="pillar.title" class="p-5 rounded-xl bg-gray-900/80 border border-gray-800 space-y-3 text-left">
        <UIcon :name="pillar.icon" class="w-6 h-6 text-emerald-400" />
        <h3 class="text-sm font-bold text-white">{{ pillar.title }}</h3>
        <p class="text-xs text-gray-400 leading-relaxed">{{ pillar.desc }}</p>
      </div>
    </div>
  </section>
</template>
