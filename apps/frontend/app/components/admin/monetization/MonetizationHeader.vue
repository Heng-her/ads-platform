<script setup lang="ts">
defineProps<{
  isAdminWalletConnected: boolean
  isAdminWalletConnecting: boolean
  adminWallet: string
  adminEthBalance: string
  adminUsdtBalance: string
  adminUsdcBalance: string
  tronWallet?: string
  tronTrxBalance?: string
  tronUsdtBalance?: string
  isSaving: boolean
}>()

const emit = defineEmits<{
  (e: 'connect-wallet'): void
  (e: 'connect-tron'): void
  (e: 'save'): void
}>()

function formatAddress(addr: string) {
  if (!addr) return ''
  if (addr.length <= 12) return addr
  return `${addr.substring(0, 6)}...${addr.substring(addr.length - 4)}`
}
</script>

<template>
  <div class="flex flex-col gap-2 md:flex-row md:items-center md:justify-between">
    <div>
      <div class="flex items-center gap-2">
        <h1 class="text-2xl font-bold tracking-tight text-white">Ads & Monetization Configuration</h1>
        <UBadge color="primary" variant="soft" size="sm" class="font-semibold">Ad Control Center</UBadge>
      </div>
      <p class="text-sm text-gray-400">
        Manage ETH/TRON Creator Payout Requests or configure Google AdSense, Adsterra, and revenue routing.
      </p>
    </div>

    <!-- Admin Wallet Connection & Balance Display Controls -->
    <div class="flex flex-wrap items-center gap-3">
      <!-- EVM Connected State -->
      <div
        v-if="isAdminWalletConnected"
        class="flex items-center gap-3 bg-emerald-500/10 border border-emerald-500/30 px-3.5 py-2 rounded-xl text-xs font-mono"
      >
        <div class="flex items-center gap-2 font-bold text-emerald-400">
          <span class="w-2 h-2 rounded-full bg-emerald-500 animate-pulse"></span>
          <span>EVM: {{ formatAddress(adminWallet) }}</span>
        </div>
        <div class="h-3 w-px bg-emerald-500/30"></div>
        <div class="flex items-center gap-2 font-bold text-white text-[11px]">
          <span class="flex items-center gap-0.5 text-emerald-400">
            <UIcon name="i-heroicons-bolt" class="w-3.5 h-3.5" />
            {{ adminEthBalance }} ETH
          </span>
          <span class="text-gray-600">|</span>
          <span class="text-teal-400 font-semibold">{{ adminUsdtBalance }} USDT</span>
          <span class="text-gray-600">|</span>
          <span class="text-blue-400 font-semibold">{{ adminUsdcBalance }} USDC</span>
        </div>
      </div>

      <!-- TRON Connected State -->
      <div
        v-if="tronWallet"
        class="flex items-center gap-3 bg-rose-500/10 border border-rose-500/30 px-3.5 py-2 rounded-xl text-xs font-mono"
      >
        <div class="flex items-center gap-2 font-bold text-rose-400">
          <span class="w-2 h-2 rounded-full bg-rose-500 animate-pulse"></span>
          <span>TRON: {{ formatAddress(tronWallet) }}</span>
        </div>
        <div class="h-3 w-px bg-rose-500/30"></div>
        <div class="flex items-center gap-2 font-bold text-white text-[11px]">
          <span class="text-rose-400">{{ tronTrxBalance || '0.00' }} TRX</span>
          <span class="text-gray-600">|</span>
          <span class="text-teal-400 font-semibold">{{ tronUsdtBalance || '0.00' }} USDT</span>
        </div>
      </div>

      <!-- Connection Buttons when not connected -->
      <div v-if="!isAdminWalletConnected || !tronWallet" class="flex items-center gap-2">
        <button
          v-if="!isAdminWalletConnected"
          :disabled="isAdminWalletConnecting"
          class="inline-flex items-center gap-1.5 rounded-lg border border-emerald-500/40 bg-emerald-500/10 px-3 py-1.5 text-xs font-bold text-emerald-400 hover:bg-emerald-500/20 disabled:opacity-50"
          @click="emit('connect-wallet')"
        >
          <UIcon v-if="isAdminWalletConnecting" name="i-heroicons-arrow-path" class="h-3.5 w-3.5 animate-spin" />
          <UIcon v-else name="i-heroicons-wallet" class="h-3.5 w-3.5" />
          <span>MetaMask</span>
        </button>

        <button
          v-if="!tronWallet"
          class="inline-flex items-center gap-1.5 rounded-lg border border-rose-500/40 bg-rose-500/10 px-3 py-1.5 text-xs font-bold text-rose-400 hover:bg-rose-500/20 disabled:opacity-50"
          @click="emit('connect-tron')"
        >
          <UIcon name="i-heroicons-currency-dollar" class="h-3.5 w-3.5 text-rose-400" />
          <span>TronLink</span>
        </button>
      </div>

      <button
        :disabled="isSaving"
        class="inline-flex items-center justify-center gap-2 rounded-lg bg-primary-600 px-4 py-2 text-xs font-semibold text-white shadow-sm transition hover:bg-primary-500 disabled:opacity-50"
        @click="emit('save')"
      >
        <UIcon v-if="isSaving" name="i-heroicons-arrow-path" class="h-3.5 w-3.5 animate-spin" />
        <UIcon v-else name="i-heroicons-check" class="h-3.5 w-3.5" />
        <span>{{ isSaving ? 'Saving...' : 'Save Settings' }}</span>
      </button>
    </div>
  </div>
</template>
