<script setup lang="ts">
interface Stats {
  availableBalance: number
  minPayoutThreshold: number
  escrowPoolBalance: number
  adsenseShare: number
  adsterraShare: number
}

defineProps<{
  stats: Stats
  selectedChainFamily: string
  ethBalance: string
  usdtBalance: string
  usdcBalance: string
  tronTrxBalance: string
  tronUsdtBalance: string
  creatorRevenueSharePercent: number
}>()

const emit = defineEmits<{
  (e: 'open-withdraw'): void
}>()

function formatCurrency(val: number) {
  return new Intl.NumberFormat('en-US', { style: 'currency', currency: 'USD' }).format(val)
}
</script>

<template>
  <div class="grid grid-cols-1 md:grid-cols-3 lg:grid-cols-5 gap-5">
    <!-- Card 1: Available Balance -->
    <div
      class="bg-white dark:bg-gray-900 p-5 rounded-2xl border border-gray-100 dark:border-gray-800 shadow-xs space-y-3">
      <div class="flex items-center justify-between">
        <span class="text-xs font-medium text-gray-500 dark:text-gray-400 uppercase tracking-wider">Available
          Balance</span>
        <div class="p-2 rounded-lg bg-emerald-500/10 text-emerald-500">
          <UIcon name="i-heroicons-banknotes" class="w-5 h-5" />
        </div>
      </div>
      <div>
        <p class="text-2xl font-extrabold text-gray-900 dark:text-white">
          {{ formatCurrency(stats.availableBalance) }}
        </p>
        <div class="mt-2 flex items-center justify-between text-xs text-gray-500 dark:text-gray-400">
          <span>Min Payout: ${{ stats.minPayoutThreshold }}</span>
          <UButton v-if="stats.availableBalance >= stats.minPayoutThreshold" color="primary" size="xs"
            class="font-bold" @click="emit('open-withdraw')">
            Withdraw
          </UButton>
          <span v-else class="text-[11px] text-amber-500 font-medium">Reach threshold to withdraw</span>
        </div>
      </div>
    </div>

    <!-- Card 2: Connected Wallet Balances -->
    <div
      class="bg-white dark:bg-gray-900 p-5 rounded-2xl border border-gray-100 dark:border-gray-800 shadow-xs space-y-3">
      <div class="flex items-center justify-between">
        <span class="text-xs font-medium text-gray-500 dark:text-gray-400 uppercase tracking-wider">
          {{ selectedChainFamily }} On-Chain Assets
        </span>
        <div class="p-2 rounded-lg bg-emerald-500/10 text-emerald-500">
          <UIcon name="i-heroicons-wallet" class="w-5 h-5" />
        </div>
      </div>
      <div v-if="selectedChainFamily === 'TRON'">
        <p class="text-xl font-extrabold text-rose-500 font-mono">
          {{ tronTrxBalance }} TRX
        </p>
        <div class="mt-1 text-xs text-teal-400 font-mono font-semibold">
          {{ tronUsdtBalance }} USDT (TRC-20)
        </div>
      </div>
      <div v-else>
        <p class="text-xl font-extrabold text-emerald-500 font-mono">
          {{ ethBalance }} ETH
        </p>
        <div class="mt-1 text-xs text-gray-400 font-mono flex items-center gap-2">
          <span class="text-teal-500 font-semibold">{{ usdtBalance }} USDT</span>
          <span>|</span>
          <span class="text-blue-500 font-semibold">{{ usdcBalance }} USDC</span>
        </div>
      </div>
    </div>

    <!-- Card 3: DApp Escrow Pool Balance -->
    <div
      class="bg-white dark:bg-gray-900 p-5 rounded-2xl border border-purple-500/20 dark:border-purple-500/30 shadow-xs space-y-3">
      <div class="flex items-center justify-between">
        <span class="text-xs font-medium text-purple-500 uppercase tracking-wider">Smart Contract Escrow</span>
        <div class="p-2 rounded-lg bg-purple-500/10 text-purple-500">
          <UIcon name="i-heroicons-cube-transparent" class="w-5 h-5" />
        </div>
      </div>
      <div>
        <p class="text-2xl font-extrabold text-purple-400 font-mono">
          {{ stats.escrowPoolBalance }} ETH
        </p>
        <div class="mt-2 text-xs text-gray-400">DApp Contract Vault</div>
      </div>
    </div>

    <!-- Card 4: Google AdSense Share -->
    <div
      class="bg-white dark:bg-gray-900 p-5 rounded-2xl border border-blue-500/20 dark:border-blue-500/30 shadow-xs space-y-3">
      <div class="flex items-center justify-between">
        <span class="text-xs font-medium text-blue-500 uppercase tracking-wider">AdSense Yield</span>
        <div class="p-2 rounded-lg bg-blue-500/10 text-blue-500">
          <UIcon name="i-heroicons-sparkles" class="w-5 h-5" />
        </div>
      </div>
      <div>
        <p class="text-2xl font-extrabold text-blue-500">
          {{ formatCurrency(stats.adsenseShare) }}
        </p>
        <div class="mt-2 text-xs text-gray-400">{{ creatorRevenueSharePercent }}% Auto Share</div>
      </div>
    </div>

    <!-- Card 5: Adsterra Share -->
    <div
      class="bg-white dark:bg-gray-900 p-5 rounded-2xl border border-amber-500/20 dark:border-amber-500/30 shadow-xs space-y-3">
      <div class="flex items-center justify-between">
        <span class="text-xs font-medium text-amber-500 uppercase tracking-wider">Adsterra Yield</span>
        <div class="p-2 rounded-lg bg-amber-500/10 text-amber-500">
          <UIcon name="i-heroicons-bolt" class="w-5 h-5" />
        </div>
      </div>
      <div>
        <p class="text-2xl font-extrabold text-amber-500">
          {{ formatCurrency(stats.adsterraShare) }}
        </p>
        <div class="mt-2 text-xs text-gray-400">{{ creatorRevenueSharePercent }}% Auto Share</div>
      </div>
    </div>
  </div>
</template>
