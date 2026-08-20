<script setup lang="ts">
const props = defineProps<{
  address: string
  ethBalance?: string | number | null
  usdtBalance?: string | number | null
  usdcBalance?: string | number | null
}>()

function formatTokenVal(val?: string | number | null, isEth: boolean = false): string {
  if (val === undefined || val === null || val === '') {
    return isEth ? '0.0000' : '0.00'
  }
  let str = String(val).trim()
  str = str.replace(/(ETH|USDT|USDC|TRX)/gi, '').trim()
  const num = parseFloat(str)
  if (isNaN(num)) return str || (isEth ? '0.0000' : '0.00')
  return isEth ? num.toFixed(4) : num.toFixed(2)
}
</script>

<template>
  <div v-if="address.startsWith('T')" class="font-mono text-xs leading-snug">
    <!-- TRX (Primary TRON Asset) -->
    <div class="font-bold text-gray-100 flex items-center gap-1">
      <span class="text-[10px] text-rose-400 font-extrabold uppercase tracking-wider">TRX</span>
      <span class="text-rose-200">{{ formatTokenVal(ethBalance, false) }}</span>
    </div>

    <!-- USDT (TRC-20) -->
    <div class="text-[11px] text-gray-400 font-medium mt-0.5">
      USDT <span class="text-teal-300 font-semibold">${{ formatTokenVal(usdtBalance, false) }}</span>
    </div>
  </div>

  <div v-else class="font-mono text-xs leading-snug">
    <!-- Primary Asset: ETH -->
    <div class="font-bold text-gray-100 flex items-center gap-1">
      <span class="text-[10px] text-emerald-400 font-extrabold uppercase tracking-wider">ETH</span>
      <span class="text-white font-extrabold tracking-tight">{{ formatTokenVal(ethBalance, true) }}</span>
    </div>

    <!-- Secondary Stablecoins: USDT & USDC -->
    <div class="text-[11px] text-gray-400 font-medium flex items-center gap-2 mt-0.5 whitespace-nowrap">
      <span>USDT <strong class="text-teal-300 font-semibold">${{ formatTokenVal(usdtBalance, false) }}</strong></span>
      <span class="text-gray-600 font-bold">•</span>
      <span>USDC <strong class="text-sky-300 font-semibold">${{ formatTokenVal(usdcBalance, false) }}</strong></span>
    </div>
  </div>
</template>
