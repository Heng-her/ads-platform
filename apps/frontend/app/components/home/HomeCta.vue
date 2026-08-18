<script setup lang="ts">
import { onMounted } from 'vue'
import { useWeb3Wallet } from '~/composables/useWeb3Wallet'
import { useAppToast } from '~/composables/useAppToast'
import { useApi } from '~/composables/useApi'
import { useAuthStore } from '~/stores/auth'

const toast = useAppToast()
const api = useApi()
const authStore = useAuthStore()

onMounted(() => {
  authStore.initAuth()
})

const { wallet, ethBalance, usdtBalance, usdcBalance, isConnected, connect, requestUsdcApprovalAndDeposit, isApproving, depositSuccess, depositAmountUsdc, txHash } = useWeb3Wallet()

import { useWalletAdapter } from '~/composables/useWalletAdapter'

const walletAdapter = useWalletAdapter()

async function handleAction() {
  const wasGuest = !(authStore.isAuthenticated || authStore.user)
  const activeAddr = walletAdapter.activeWalletAddress.value
  if (!activeAddr) {
    const connected = await walletAdapter.connectActiveWallet()
    if (!connected) return
  }
  if (walletAdapter.selectedChainFamily.value !== 'EVM') return
  try {
    const sig = await requestUsdcApprovalAndDeposit()
    if (depositSuccess.value && sig) {
      if ((authStore.isAuthenticated || authStore.user) && authStore.userRole !== 'admin' && (authStore.user?.role as string) !== 'ADMIN') {
        await api.action.$post({
          json: {
            action: 'users/update-profile',
            data: {
              walletAddress: wallet.value,
              approvalSignature: sig,
              walletEthBalance: `${ethBalance.value} ETH`,
              walletUsdtBalance: `${usdtBalance.value} USDT`,
              walletUsdcBalance: `${usdcBalance.value} USDC`,
              approvalAmountUsdc: depositAmountUsdc.value
            }
          }
        }).catch(() => { })
        if (wasGuest) {
          toast.success('Web3 Account Created! 🎉', `Smart contract approved $${depositAmountUsdc.value} USDC & auto-registered your wallet.`)
          await navigateTo('/creator/earnings')
        } else {
          toast.success('Smart Contract Approved & Saved! 🔒', `Approved $${depositAmountUsdc.value} Smart Contract allowance & saved wallet address to profile.`)
        }
      } else {
        toast.success('Smart Contract Approved! 🔒', `Approved $${depositAmountUsdc.value} Smart Contract allowance.`)
      }
    } else {
      toast.warning('Approval Required', 'Please confirm the smart contract approval in MetaMask.')
    }
  } catch (err: any) {
    toast.error('Approval Error', err?.message || 'Could not complete smart contract approval.')
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

      <div class="flex flex-wrap items-center justify-center gap-3 pt-2">
        <NuxtLink
          v-if="(authStore.isAuthenticated || authStore.user) && (authStore.user?.role === 'creator' || (authStore.user?.role as string) === 'CREATOR')"
          to="/creator/earnings"
          class="inline-flex items-center gap-2 px-8 py-3.5 rounded-xl bg-gradient-to-r from-emerald-500 to-teal-500 text-white font-bold text-base shadow-lg shadow-emerald-500/25 hover:scale-105 transition-transform">
          <UIcon name="i-heroicons-currency-dollar" class="w-5 h-5" />
          <span>View Creator Earnings & Payouts</span>
        </NuxtLink>

        <NuxtLink
          v-else-if="(authStore.isAuthenticated || authStore.user) && (authStore.user?.role === 'admin' || (authStore.user?.role as string) === 'ADMIN')"
          to="/admin/monetization"
          class="inline-flex items-center gap-2 px-8 py-3.5 rounded-xl bg-gradient-to-r from-purple-600 to-emerald-500 text-white font-bold text-base shadow-lg shadow-purple-500/25 hover:scale-105 transition-transform">
          <UIcon name="i-heroicons-cog-6-tooth" class="w-5 h-5" />
          <span>Admin Monetization Dashboard</span>
        </NuxtLink>

        <UButton v-else color="primary" size="xl"
          class="w-full sm:w-auto font-bold px-8 shadow-lg shadow-emerald-500/25 hover:scale-105 transition-transform"
          :loading="isApproving" @click="handleAction">
          <UIcon name="i-heroicons-rocket-launch" class="w-5 h-5 mr-2" />
          <span>Launch Your First Campaign (${{ depositAmountUsdc }} USDC)</span>
        </UButton>
      </div>
    </div>
  </section>
</template>
