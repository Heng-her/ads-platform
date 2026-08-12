<script setup lang="ts">
import type { WithdrawalRequest } from '../MonetizationPayoutQueueTable.vue'

const isOpen = defineModel<boolean>('open', { default: false })

defineProps<{
  selectedRequest: WithdrawalRequest | null
  isAdminWalletConnected: boolean
  adminWallet: string
  adminEthBalance: string
  isProcessing: boolean
}>()

const emit = defineEmits<{
  (e: 'connect-wallet'): void
  (e: 'confirm'): void
}>()

function formatAddress(addr: string) {
  if (!addr) return ''
  return `${addr.substring(0, 6)}...${addr.substring(addr.length - 4)}`
}
</script>

<template>
  <UModal v-model:open="isOpen" title="Execute Web3 ETH On-Chain Settlement">
    <template #content>
      <div v-if="selectedRequest" class="p-6 space-y-4">
        <!-- Summary Box -->
        <div class="p-4 rounded-xl bg-emerald-950/30 border border-emerald-500/30 space-y-3">
          <div class="flex items-center justify-between text-xs text-emerald-400 font-bold">
            <span class="flex items-center gap-1.5">
              <UIcon name="i-heroicons-bolt" class="w-4 h-4" />
              Direct Admin Wallet Web3 Transfer
            </span>
            <UBadge color="success" size="xs" variant="solid">{{ selectedRequest.network }}</UBadge>
          </div>

          <!-- Transfer Source & Destination Details + Balances -->
          <div class="grid grid-cols-2 gap-2 text-xs bg-gray-950/60 p-3 rounded-lg border border-gray-800">
            <div>
              <p class="text-[10px] text-gray-400 uppercase font-semibold">From (Admin Wallet)</p>
              <p v-if="isAdminWalletConnected" class="font-mono text-emerald-400 font-bold text-[11px] truncate">
                {{ formatAddress(adminWallet) }}
              </p>
              <p v-else class="text-amber-400 text-[11px] font-semibold">Not Connected</p>
              <p v-if="isAdminWalletConnected" class="text-[10px] text-gray-400 mt-0.5">
                Available: <span class="text-white font-bold">{{ adminEthBalance }} ETH</span>
              </p>
            </div>

            <div>
              <p class="text-[10px] text-gray-400 uppercase font-semibold">To (Creator Wallet)</p>
              <p class="font-mono text-emerald-400 font-bold text-[11px] truncate">
                {{ formatAddress(selectedRequest.walletAddress) }}
              </p>
              <div class="text-[10px] text-gray-400 mt-0.5 font-mono">
                <span>Current: </span>
                <span class="text-emerald-400 font-bold">{{ selectedRequest.creatorWalletEthBalance }}</span>
                <span class="text-gray-500"> | </span>
                <span class="text-teal-400 font-semibold">{{ selectedRequest.creatorWalletUsdtBalance }}</span>
              </div>
            </div>
          </div>

          <div class="flex items-baseline justify-between pt-1">
            <p class="text-xs text-gray-400">Transfer Amount:</p>
            <div class="text-right">
              <p class="text-2xl font-extrabold text-white">${{ selectedRequest.amount.toFixed(2) }} USD</p>
              <p class="text-sm font-bold font-mono text-emerald-400">≈ {{ selectedRequest.cryptoAmount }} ETH</p>
            </div>
          </div>
        </div>

        <!-- Admin Wallet Warning if not connected -->
        <div
          v-if="!isAdminWalletConnected"
          class="p-3 rounded-lg bg-amber-500/10 border border-amber-500/30 text-amber-400 text-xs flex items-center justify-between"
        >
          <span class="font-medium">Admin Web3 wallet must be connected to deduct & execute transfer.</span>
          <button
            class="px-2.5 py-1 bg-amber-500 text-gray-950 font-bold rounded text-xs hover:bg-amber-400 transition"
            @click="emit('connect-wallet')"
          >
            Connect Wallet
          </button>
        </div>

        <div class="flex justify-end gap-3 pt-2">
          <UButton color="neutral" variant="ghost" @click="isOpen = false">Cancel</UButton>
          <UButton
            color="success"
            variant="solid"
            class="font-bold gap-2"
            :loading="isProcessing"
            @click="emit('confirm')"
          >
            <UIcon name="i-heroicons-bolt" class="w-4 h-4" />
            <span>Pay {{ selectedRequest.cryptoAmount }} ETH from Admin Wallet</span>
          </UButton>
        </div>
      </div>
    </template>
  </UModal>
</template>
