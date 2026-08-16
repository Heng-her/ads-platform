<script setup lang="ts">
defineProps<{
  minPayoutThreshold: number
  payoutProgressPercent: number
}>()

function formatCurrency(val: number) {
  return new Intl.NumberFormat('en-US', { style: 'currency', currency: 'USD' }).format(val)
}
</script>

<template>
  <div
    class="bg-white dark:bg-gray-900 p-6 rounded-2xl border border-gray-200 dark:border-gray-800 shadow-xs space-y-3">
    <div class="flex items-center justify-between">
      <div>
        <h3 class="text-sm font-bold text-gray-900 dark:text-white">ETH Withdrawal Progress</h3>
        <p class="text-xs text-gray-500 dark:text-gray-400">Reach at least {{ formatCurrency(minPayoutThreshold)
        }} to execute Ethereum (ETH) payouts.</p>
      </div>
      <span class="text-sm font-extrabold font-mono text-emerald-500">{{ payoutProgressPercent }}%</span>
    </div>

    <div class="w-full h-3 bg-gray-100 dark:bg-gray-800 rounded-full overflow-hidden">
      <div class="h-full bg-gradient-to-r from-emerald-500 to-teal-400 transition-all duration-500"
        :style="{ width: payoutProgressPercent + '%' }"></div>
    </div>
  </div>
</template>
