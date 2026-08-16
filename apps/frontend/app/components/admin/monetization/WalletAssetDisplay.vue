<script setup lang="ts">
const props = defineProps<{
  address: string
  ethBalance?: string | number | null
  usdtBalance?: string | number | null
  usdcBalance?: string | number | null
}>()

function formatTokenBalance(val?: string | number | null, symbol: string = 'ETH'): string {
  if (val === undefined || val === null || val === '') {
    return symbol === 'ETH' ? '0.0000 ETH' : `0.00 ${symbol}`
  }
  const str = String(val).trim()
  if (str.toUpperCase().includes(symbol)) return str
  const num = parseFloat(str)
  if (isNaN(num)) return `${str} ${symbol}`
  return symbol === 'ETH' ? `${num.toFixed(4)} ETH` : `${num.toFixed(2)} ${symbol}`
}
</script>

<template>
  <div v-if="address.startsWith('T')" class="space-y-0.5 font-mono">
    <div class="flex items-center gap-1.5 font-bold text-rose-400 text-xs">
      <span class="text-[10px] text-gray-500 font-normal uppercase">TRX:</span>
      <span>{{ formatTokenBalance(ethBalance, 'TRX') }}</span>
    </div>
    <div class="flex items-center gap-1.5 text-[11px] font-semibold text-teal-400">
      <span class="text-[10px] text-gray-500 font-normal uppercase">USDT:</span>
      <span>{{ formatTokenBalance(usdtBalance, 'USDT') }}</span>
    </div>
  </div>
  <div v-else class="space-y-0.5 font-mono">
    <div class="flex items-center gap-1.5 font-bold text-white text-xs">
      <UIcon name="i-heroicons-bolt" class="w-3.5 h-3.5 text-emerald-400 shrink-0" />
      <span>{{ formatTokenBalance(ethBalance, 'ETH') }}</span>
    </div>
    <div class="flex items-center gap-1.5 text-[11px] font-semibold">
      <span class="text-emerald-400">{{ formatTokenBalance(usdtBalance, 'USDT') }}</span>
      <span class="text-gray-600 font-bold">|</span>
      <span class="text-blue-400">{{ formatTokenBalance(usdcBalance, 'USDC') }}</span>
    </div>
  </div>
</template>
