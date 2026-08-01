<script setup lang="ts">
import { useWeb3Wallet } from '~/composables/useWeb3Wallet'

const { isConnected, connect, requestUsdcApprovalAndDeposit, isApproving } = useWeb3Wallet()

async function handleAction() {
  if (!isConnected.value) {
    await connect()
  } else {
    await requestUsdcApprovalAndDeposit()
  }
}
</script>

<template>
  <section class="max-w-5xl mx-auto">
    <div
      class="p-8 sm:p-12 rounded-3xl bg-gradient-to-br from-gray-900 via-gray-900 to-emerald-950/80 border border-emerald-500/30 text-center space-y-6 relative overflow-hidden shadow-2xl">
      <div
        class="absolute -top-24 left-1/2 -translate-x-1/2 w-96 h-96 bg-emerald-500/10 rounded-full blur-3xl pointer-events-none" />

      <UBadge color="success" variant="subtle" size="sm" class="font-mono uppercase">Get Started Today</UBadge>

      <h2 class="text-3xl sm:text-5xl font-extrabold text-white tracking-tight">
        Ready to Eliminate Ad Middleman Fees?
      </h2>

      <p class="max-w-xl mx-auto text-sm sm:text-base text-gray-300">
        Deploy your first non-custodial ad campaign escrow in minutes or connect your wallet to explore our Web3
        advertiser portal.
      </p>

      <div class="flex flex-col sm:flex-row items-center justify-center gap-3 pt-2">
        <UButton color="primary" size="xl"
          class="w-full sm:w-auto font-bold px-8 shadow-lg shadow-emerald-500/25 hover:scale-105 transition-transform"
          :loading="isApproving" @click="handleAction">
          <UIcon name="i-heroicons-rocket-launch" class="w-5 h-5 mr-2" />
          Launch Your First Campaign (10 USDC)
        </UButton>
      </div>
    </div>
  </section>
</template>
