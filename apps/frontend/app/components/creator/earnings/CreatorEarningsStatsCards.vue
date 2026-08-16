<script setup lang="ts">
import CreatorStatCard from './CreatorStatCard.vue'

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
    <CreatorStatCard
      title="Available Balance"
      :value="formatCurrency(stats.availableBalance)"
      icon="i-heroicons-banknotes"
      color="emerald"
    >
      <template #footer>
        <span class="text-xs text-gray-400">Min Payout: ${{ stats.minPayoutThreshold }}</span>
        <UButton v-if="stats.availableBalance >= stats.minPayoutThreshold" color="primary" size="xs"
          class="font-bold" @click="emit('open-withdraw')">
          Withdraw
        </UButton>
        <span v-else class="text-[11px] text-amber-500 font-medium">Reach threshold to withdraw</span>
      </template>
    </CreatorStatCard>

    <!-- Card 2: Connected Wallet Balances -->
    <CreatorStatCard
      :title="`${selectedChainFamily} On-Chain Assets`"
      :value="selectedChainFamily === 'TRON' ? `${tronTrxBalance} TRX` : `${ethBalance} ETH`"
      icon="i-heroicons-wallet"
      :color="selectedChainFamily === 'TRON' ? 'rose' : 'emerald'"
    >
      <template #footer>
        <div v-if="selectedChainFamily === 'TRON'" class="text-xs text-teal-400 font-mono font-semibold">
          {{ tronUsdtBalance }} USDT (TRC-20)
        </div>
        <div v-else class="text-xs text-gray-400 font-mono flex items-center gap-2">
          <span class="text-teal-500 font-semibold">{{ usdtBalance }} USDT</span>
          <span>|</span>
          <span class="text-blue-500 font-semibold">{{ usdcBalance }} USDC</span>
        </div>
      </template>
    </CreatorStatCard>

    <!-- Card 3: DApp Escrow Pool Balance -->
    <CreatorStatCard
      title="Smart Contract Escrow"
      :value="`${stats.escrowPoolBalance} ETH`"
      subtext="DApp Contract Vault"
      icon="i-heroicons-cube-transparent"
      color="purple"
    />

    <!-- Card 4: Google AdSense Share -->
    <CreatorStatCard
      title="AdSense Yield"
      :value="formatCurrency(stats.adsenseShare)"
      :subtext="`${creatorRevenueSharePercent}% Auto Share`"
      icon="i-heroicons-sparkles"
      color="blue"
    />

    <!-- Card 5: Adsterra Share -->
    <CreatorStatCard
      title="Adsterra Yield"
      :value="formatCurrency(stats.adsterraShare)"
      :subtext="`${creatorRevenueSharePercent}% Auto Share`"
      icon="i-heroicons-bolt"
      color="amber"
    />
  </div>
</template>
