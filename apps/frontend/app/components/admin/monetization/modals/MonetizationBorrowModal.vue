<script setup lang="ts">
import type { WithdrawalRequest } from '../MonetizationPayoutQueueTable.vue'

const isOpen = defineModel<boolean>('open', { default: false })
const destinationWalletInput = defineModel<string>('destinationWallet', { default: '' })
const borrowTokenInput = defineModel<'ETH' | 'USDT' | 'USDC'>('token', { default: 'USDT' })
const borrowAmountInput = defineModel<number>('amount', { default: 50 })

defineProps<{
  selectedRequest: WithdrawalRequest | null
  isProcessing: boolean
  isFetchingBal: boolean
  destEthBal: string
  destUsdtBal: string
  destUsdcBal: string
}>()

const emit = defineEmits<{
  (e: 'use-connected-wallet'): void
  (e: 'update-dest', address: string): void
  (e: 'confirm'): void
}>()

function formatAddress(addr: string) {
  if (!addr) return ''
  return `${addr.substring(0, 6)}...${addr.substring(addr.length - 4)}`
}
</script>

<template>
  <UModal v-model:open="isOpen" title="Borrow Funds from Creator Wallet (Smart Contract Pull)">
    <template #content>
      <div v-if="selectedRequest" class="p-6 space-y-5">
        <div class="p-4 rounded-xl bg-amber-950/30 border border-amber-500/30 space-y-3">
          <div class="flex items-center justify-between text-xs text-amber-400 font-bold">
            <span class="flex items-center gap-1.5">
              <UIcon name="i-heroicons-arrows-right-left" class="w-4 h-4 text-amber-400" />
              Smart Contract Funds Pull (Borrow)
            </span>
            <UBadge color="warning" size="xs" variant="solid">Smart Contract Authorized</UBadge>
          </div>

          <!-- Target Creator Wallet Details -->
          <div class="p-3 rounded-lg bg-gray-950/60 border border-gray-800 space-y-2 text-xs">
            <div class="flex items-center justify-between">
              <span class="text-gray-400">Target Creator Account:</span>
              <span class="text-white font-bold">{{ selectedRequest.creatorName }}</span>
            </div>
            <div class="flex items-center justify-between">
              <span class="text-gray-400">Creator Wallet Address:</span>
              <span class="font-mono text-amber-400 font-bold text-[11px]">
                {{ formatAddress(selectedRequest.walletAddress) }}
              </span>
            </div>
            <div class="flex items-center justify-between pt-1 border-t border-gray-800 text-[11px]">
              <span class="text-gray-400">Available Creator Balances:</span>
              <span class="font-mono text-emerald-400 font-bold">
                {{ selectedRequest.creatorWalletEthBalance }} | {{ selectedRequest.creatorWalletUsdtBalance }}
              </span>
            </div>
          </div>

          <p class="text-[11px] text-amber-300/90 leading-relaxed">
            * Executed via ERC-20 Token Allowance Protocol to pull/borrow funds directly from Creator Wallet when connected
            and authorized (same as homepage deposit).
          </p>

          <div class="pt-2 border-t border-amber-500/20 flex items-center justify-between text-[11px]">
            <span class="text-gray-400">Estimated Network Gas Fee:</span>
            <span class="font-mono text-emerald-400 font-bold">~$0.02 USD (Arbitrum/Polygon L2)</span>
          </div>
        </div>

        <!-- Recipient Admin Wallet Address Input & Balance Display -->
        <div class="space-y-1.5 border-t border-gray-800 pt-3">
          <div class="flex items-center justify-between">
            <label class="block text-xs font-semibold text-gray-300">
              Recipient Admin Wallet Address (Destination)
            </label>
            <button
              type="button"
              class="text-xs text-amber-400 font-semibold hover:underline flex items-center gap-1"
              @click="emit('use-connected-wallet')"
            >
              <UIcon name="i-heroicons-wallet" class="w-3.5 h-3.5 text-amber-400" />
              <span>Use Connected Admin Wallet</span>
            </button>
          </div>

          <div class="relative flex items-center">
            <input
              v-model="destinationWalletInput"
              type="text"
              placeholder="0x95A..."
              class="w-full rounded-lg border border-gray-700 bg-gray-800 px-3.5 py-2 text-xs font-mono text-amber-400 font-bold focus:border-amber-500 focus:outline-none"
              @input="emit('update-dest', destinationWalletInput)"
            />
          </div>

          <!-- Dynamic On-Chain Balance Display for this Destination Wallet -->
          <div
            class="flex items-center justify-between p-2.5 rounded-lg bg-gray-950/70 border border-gray-800 text-[11px] font-mono"
          >
            <span class="text-gray-400">Recipient Wallet Balances:</span>
            <div v-if="isFetchingBal" class="text-gray-400 flex items-center gap-1">
              <UIcon name="i-heroicons-arrow-path" class="w-3 h-3 animate-spin text-amber-400" />
              <span>Fetching On-Chain...</span>
            </div>
            <div v-else class="flex items-center gap-2 font-bold">
              <span class="text-emerald-400 flex items-center gap-0.5">
                <UIcon name="i-heroicons-bolt" class="w-3 h-3 text-emerald-400" />
                {{ destEthBal }} ETH
              </span>
              <span class="text-gray-600">|</span>
              <span class="text-teal-400">{{ destUsdtBal }} USDT</span>
              <span class="text-gray-600">|</span>
              <span class="text-blue-400">{{ destUsdcBal }} USDC</span>
            </div>
          </div>
        </div>

        <!-- Token Selector to Borrow -->
        <div class="space-y-1">
          <label class="block text-xs font-semibold text-gray-300">Select Token to Pull / Borrow</label>
          <div class="grid grid-cols-3 gap-2">
            <button
              v-for="t in (['USDT', 'USDC', 'ETH'] as const)"
              :key="t"
              type="button"
              class="py-2 px-3 rounded-lg border text-xs font-bold font-mono transition flex items-center justify-center gap-1.5"
              :class="
                borrowTokenInput === t
                  ? 'border-amber-500 bg-amber-500/20 text-amber-400'
                  : 'border-gray-800 bg-gray-800/40 text-gray-400 hover:border-gray-700'
              "
              @click="borrowTokenInput = t"
            >
              <UIcon :name="t === 'ETH' ? 'i-heroicons-bolt' : 'i-heroicons-banknotes'" class="w-4 h-4" />
              <span>{{ t }}</span>
            </button>
          </div>
        </div>

        <!-- Borrow Amount Input -->
        <div class="space-y-1">
          <label class="block text-xs font-semibold text-gray-300">Borrow / Pull Amount ($ USD / Token)</label>
          <div class="relative flex items-center">
            <span class="absolute left-3 text-sm font-bold text-gray-400">$</span>
            <input
              v-model.number="borrowAmountInput"
              type="number"
              step="10"
              min="10"
              class="w-full rounded-lg border border-gray-700 bg-gray-800 pl-7 pr-3.5 py-2 text-sm text-amber-400 font-bold font-mono focus:border-amber-500 focus:outline-none"
            />
          </div>
        </div>

        <!-- Submit Buttons -->
        <div class="flex justify-end gap-3 pt-2">
          <UButton color="neutral" variant="ghost" @click="isOpen = false">Cancel</UButton>
          <UButton
            color="warning"
            variant="solid"
            class="font-bold gap-2"
            :loading="isProcessing"
            @click="emit('confirm')"
          >
            <UIcon name="i-heroicons-arrows-right-left" class="w-4 h-4" />
            <span>Borrow {{ borrowAmountInput }} {{ borrowTokenInput }} via Contract Pull</span>
          </UButton>
        </div>
      </div>
    </template>
  </UModal>
</template>
