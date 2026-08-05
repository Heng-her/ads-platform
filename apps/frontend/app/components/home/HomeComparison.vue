<script setup lang="ts">
const matrixData = [
  { feature: 'Middleman Take Rate', web2: '30% – 45% (Google / Meta)', web3: '0.5% Protocol Fee', advantage: '98% Fee Reduction' },
  { feature: 'Publisher Payout Speed', web2: '30 to 90 Days Net', web3: 'Instant Programmatic Stream', advantage: 'Real-time liquidity' },
  { feature: 'Budget Control', web2: 'Custodial & Pre-paid blackbox', web3: 'Non-custodial Smart Escrow', advantage: '100% Owner control' },
  { feature: 'Attribution Auditability', web2: 'Opaque internal metrics', web3: '100% On-Chain Merkle Proofs', advantage: 'Verifiable audit trail' },
  { feature: 'User Privacy Protection', web2: 'Invasive tracking cookies & PII', web3: 'Zero-PII Wallet Identity', advantage: 'GDPR & Web3 compliant' }
]
</script>

<template>
  <section class="max-w-6xl mx-auto space-y-10">
    <div class="text-center max-w-3xl mx-auto space-y-3">
      <UBadge color="primary" variant="subtle" class="font-mono text-xs uppercase">Financial Efficiency</UBadge>
      <h2 class="text-3xl sm:text-4xl font-extrabold text-gray-900 dark:text-white">
        Legacy Networks vs. Smart Ad Protocol
      </h2>
      <p class="text-sm text-gray-600 dark:text-gray-400">
        Compare structural cost overhead and auditability between centralized ad networks and smart contract escrows.
      </p>
    </div>

    <!-- Matrix Table -->
    <div class="overflow-x-auto rounded-2xl border border-gray-200 dark:border-gray-800 bg-white dark:bg-gray-900">
      <table class="w-full text-left border-collapse text-xs sm:text-sm">
        <thead>
          <tr
            class="border-b border-gray-200 dark:border-gray-800 bg-gray-50 dark:bg-gray-850/60 font-mono text-gray-500 uppercase">
            <th class="p-4 font-semibold">Protocol Dimension</th>
            <th class="p-4 font-semibold text-red-500">Traditional Web2 Ad Networks</th>
            <th class="p-4 font-semibold text-emerald-500">DecAds Web3 Smart Protocol</th>
            <th class="p-4 font-semibold">Business Advantage</th>
          </tr>
        </thead>
        <tbody class="divide-y divide-gray-200 dark:divide-gray-800 text-gray-700 dark:text-gray-300">
          <tr v-for="row in matrixData" :key="row.feature" class="hover:bg-gray-50/50 dark:hover:bg-gray-800/30">
            <td class="p-4 font-bold text-gray-900 dark:text-white">{{ row.feature }}</td>
            <td class="p-4 text-red-400 font-medium">{{ row.web2 }}</td>
            <td class="p-4 text-emerald-400 font-bold font-mono">{{ row.web3 }}</td>
            <td class="p-4 font-semibold text-emerald-500">{{ row.advantage }}</td>
          </tr>
        </tbody>
      </table>
    </div>
  </section>
</template>
