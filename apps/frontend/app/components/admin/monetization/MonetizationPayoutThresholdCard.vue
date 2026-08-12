<script setup lang="ts">
const minPayoutThreshold = defineModel<number>({ required: true })
</script>

<template>
  <div class="rounded-xl border border-gray-800 bg-gray-900 p-6 shadow-sm space-y-4">
    <h2 class="text-lg font-semibold text-white flex items-center gap-2">
      <UIcon name="i-heroicons-bolt" class="h-5 w-5 text-emerald-400" />
      Global Ethereum (ETH) Web3 Payout Threshold
    </h2>
    <p class="text-xs text-gray-400">
      Set minimum withdrawal threshold for Ethereum (ETH) smart contract transfers.
    </p>

    <div class="max-w-md space-y-1">
      <label class="block text-xs font-semibold text-gray-300">Minimum Creator ETH Payout Threshold ($ USD)</label>
      <div class="relative flex items-center">
        <span class="absolute left-3.5 text-sm font-semibold text-gray-400">$</span>
        <input
          v-model.number="minPayoutThreshold"
          type="number"
          step="5"
          min="5"
          class="w-full rounded-lg border border-gray-700 bg-gray-800 pl-8 pr-3.5 py-2 text-sm text-white font-semibold focus:border-emerald-500 focus:outline-none focus:ring-2 focus:ring-emerald-500/20"
        />
      </div>
      <p class="text-[11px] text-gray-500">Creators must reach this balance before executing Web3 ETH withdrawals.</p>
    </div>
  </div>
</template>
