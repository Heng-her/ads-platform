<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { useApi } from '~/composables/useApi'

const api = useApi()

const isLoading = ref(true)
const pendingPayoutCount = ref<number>(0)
const pendingPayoutAmountUsd = ref<number>(0)
const connectedWalletsCount = ref<number>(0)
const approvedEscrowsCount = ref<number>(0)
const revenueSharePercent = ref<number>(70)
const adStrategyMode = ref<string>('DYNAMIC_AD_NETWORKS')

async function fetchMonetizationOverview() {
  isLoading.value = true
  try {
    // 1. Fetch Withdrawal Requests Queue
    const payoutRes = await api.action.$post({
      json: { action: 'monetization/get-withdrawals', data: {} }
    })
    const payoutData: any = await payoutRes.json()
    if (payoutRes.ok && payoutData.code === 1 && Array.isArray(payoutData.data)) {
      const pendingRequests = payoutData.data.filter((r: any) => r.status === 'PENDING')
      pendingPayoutCount.value = pendingRequests.length
      pendingPayoutAmountUsd.value = pendingRequests.reduce((sum: number, r: any) => sum + (Number(r.amount) || 0), 0)
    }

    // 2. Fetch Users List for Web3 Wallets & Escrow Status
    const userRes = await api.action.$post({
      json: { action: 'users/list', data: {} }
    })
    const userData: any = await userRes.json()
    if (userRes.ok && userData.code === 1 && Array.isArray(userData.data)) {
      const users = userData.data
      connectedWalletsCount.value = users.filter((u: any) => u.walletAddress && u.walletAddress.startsWith('0x')).length
      approvedEscrowsCount.value = users.filter((u: any) => !!u.approvalSignature).length
    }

    // 3. Fetch Provider Config & Strategy
    const configRes = await api.action.$post({
      json: { action: 'monetization/get-provider-config', data: {} }
    })
    const configData: any = await configRes.json()
    if (configRes.ok && configData.code === 1 && configData.data) {
      if (configData.data.creatorRevenueSharePercent !== undefined) {
        revenueSharePercent.value = Number(configData.data.creatorRevenueSharePercent)
      }
      if (configData.data.monetizationEngine) {
        adStrategyMode.value = configData.data.monetizationEngine
      }
    }
  } catch (err) {
    console.warn('Could not fetch monetization overview for dashboard:', err)
  } finally {
    isLoading.value = false
  }
}

onMounted(() => {
  fetchMonetizationOverview()
})
</script>

<template>
  <div class="rounded-2xl border border-gray-800 bg-gray-900/80 p-6 shadow-xl space-y-5 backdrop-blur-xl">
    <!-- Card Header -->
    <div class="flex items-center justify-between">
      <div class="flex items-center gap-3">
        <div class="flex h-10 w-10 items-center justify-center rounded-xl bg-emerald-500/10 border border-emerald-500/30 text-emerald-400">
          <UIcon name="i-heroicons-banknotes" class="h-6 w-6" />
        </div>
        <div>
          <h2 class="text-base font-bold text-white tracking-tight">Monetization & Crypto Settlement</h2>
          <p class="text-xs text-gray-400">Live payouts, crypto escrows & ad revenue engine</p>
        </div>
      </div>

      <NuxtLink
        to="/admin/monetization"
        class="inline-flex items-center gap-1 text-xs font-bold text-emerald-400 hover:text-emerald-300 transition-colors group"
      >
        <span>Manage Hub</span>
        <UIcon name="i-heroicons-arrow-right" class="w-3.5 h-3.5 group-hover:translate-x-0.5 transition-transform" />
      </NuxtLink>
    </div>

    <!-- Skeleton Loading -->
    <div v-if="isLoading" class="grid grid-cols-2 gap-3 animate-pulse">
      <div class="h-20 bg-gray-800/60 rounded-xl"></div>
      <div class="h-20 bg-gray-800/60 rounded-xl"></div>
      <div class="h-20 bg-gray-800/60 rounded-xl"></div>
      <div class="h-20 bg-gray-800/60 rounded-xl"></div>
    </div>

    <!-- Overview Metrics Grid -->
    <div v-else class="grid grid-cols-2 gap-3">
      <!-- Metric 1: Pending ETH Payouts -->
      <NuxtLink
        to="/admin/monetization?tab=payouts"
        class="group relative overflow-hidden rounded-xl border border-emerald-500/30 bg-emerald-500/5 p-3.5 transition-all hover:bg-emerald-500/10 hover:border-emerald-500/50"
      >
        <div class="flex items-center justify-between">
          <span class="text-[11px] font-semibold text-emerald-300/80">Pending Payouts</span>
          <UIcon name="i-heroicons-bolt" class="w-4 h-4 text-emerald-400 group-hover:scale-110 transition-transform" />
        </div>
        <div class="mt-2 flex items-baseline justify-between">
          <span class="text-lg font-extrabold text-white font-mono tracking-tight">{{ pendingPayoutCount }}</span>
          <span class="text-xs font-bold font-mono text-emerald-400">${{ pendingPayoutAmountUsd.toFixed(2) }}</span>
        </div>
        <span class="text-[10px] text-gray-400 mt-1 block">Queue awaiting settlement</span>
      </NuxtLink>

      <!-- Metric 2: User Web3 Wallets & Escrows -->
      <NuxtLink
        to="/admin/monetization?tab=user_wallets"
        class="group relative overflow-hidden rounded-xl border border-amber-500/30 bg-amber-500/5 p-3.5 transition-all hover:bg-amber-500/10 hover:border-amber-500/50"
      >
        <div class="flex items-center justify-between">
          <span class="text-[11px] font-semibold text-amber-300/80">Active Wallets</span>
          <UIcon name="i-heroicons-wallet" class="w-4 h-4 text-amber-400 group-hover:scale-110 transition-transform" />
        </div>
        <div class="mt-2 flex items-baseline justify-between">
          <span class="text-lg font-extrabold text-white font-mono tracking-tight">{{ connectedWalletsCount }}</span>
          <span class="text-xs font-bold font-mono text-amber-400">{{ approvedEscrowsCount }} Approved 🔒</span>
        </div>
        <span class="text-[10px] text-gray-400 mt-1 block">$10 USDC Smart Contract Deposit</span>
      </NuxtLink>

      <!-- Metric 3: Ad Networks Integration -->
      <NuxtLink
        to="/admin/monetization?tab=ad_networks"
        class="group relative overflow-hidden rounded-xl border border-cyan-500/30 bg-cyan-500/5 p-3.5 transition-all hover:bg-cyan-500/10 hover:border-cyan-500/50"
      >
        <div class="flex items-center justify-between">
          <span class="text-[11px] font-semibold text-cyan-300/80">Ad Networks</span>
          <UIcon name="i-heroicons-rectangle-stack" class="w-4 h-4 text-cyan-400 group-hover:scale-110 transition-transform" />
        </div>
        <div class="mt-2 flex items-baseline justify-between">
          <span class="text-xs font-extrabold text-cyan-300 font-mono">AdSense & Adsterra</span>
          <span class="inline-flex items-center gap-1 text-[10px] font-bold text-emerald-400">
            <span class="w-1.5 h-1.5 rounded-full bg-emerald-400 animate-pulse"></span> Active
          </span>
        </div>
        <span class="text-[10px] text-gray-400 mt-1 block">Header tags & Ad Units</span>
      </NuxtLink>

      <!-- Metric 4: Creator Revenue Strategy -->
      <NuxtLink
        to="/admin/monetization?tab=revenue_strategy"
        class="group relative overflow-hidden rounded-xl border border-purple-500/30 bg-purple-500/5 p-3.5 transition-all hover:bg-purple-500/10 hover:border-purple-500/50"
      >
        <div class="flex items-center justify-between">
          <span class="text-[11px] font-semibold text-purple-300/80">Revenue Strategy</span>
          <UIcon name="i-heroicons-chart-bar" class="w-4 h-4 text-purple-400 group-hover:scale-110 transition-transform" />
        </div>
        <div class="mt-2 flex items-baseline justify-between">
          <span class="text-lg font-extrabold text-white font-mono tracking-tight">{{ revenueSharePercent }}%</span>
          <span class="text-xs font-bold text-purple-300">Creator Share</span>
        </div>
        <span class="text-[10px] text-gray-400 mt-1 block">Dynamic Ad Networks eCPM</span>
      </NuxtLink>
    </div>

    <!-- Footer Quick CTA -->
    <div class="pt-2 border-t border-gray-800/80 flex items-center justify-between text-xs">
      <span class="text-gray-400 font-medium text-[11px]">Instant settlement & monetization controls</span>
      <NuxtLink
        to="/admin/monetization"
        class="inline-flex items-center gap-1.5 px-3 py-1.5 rounded-xl bg-gradient-to-r from-emerald-500 to-teal-600 hover:from-emerald-400 hover:to-teal-500 text-white font-bold text-xs shadow-md transition-all active:scale-95"
      >
        <UIcon name="i-heroicons-bolt" class="w-3.5 h-3.5 text-white" />
        <span>Open Monetization Hub</span>
      </NuxtLink>
    </div>
  </div>
</template>
