<script setup lang="ts">
import type { WithdrawalRequest } from '../MonetizationPayoutQueueTable.vue'

const isOpen = defineModel<boolean>('open', { default: false })
const destinationWalletInput = defineModel<string>('destinationWallet', { default: '' })
const borrowTokenInput = defineModel<string>('token', { default: 'USDC' })
const borrowAmountInput = defineModel<string | number>('amount', { default: '50' })
const selectedChainFamily = defineModel<'EVM' | 'TRON'>('chainFamily', { default: 'EVM' })

defineProps<{
  selectedRequest: WithdrawalRequest | null
  isProcessing: boolean
  isFetchingBal: boolean
  destEthBal: string
  destUsdtBal: string
  destUsdcBal: string
  destTronTrxBal?: string
  destTronUsdtBal?: string
  pullState?: string
  pullStatusMessage?: string
  errorMessage?: string
}>()

const emit = defineEmits<{
  (e: 'use-connected-wallet'): void
  (e: 'update-dest', address: string): void
  (e: 'confirm'): void
}>()

function formatAddress(addr: string) {
  if (!addr) return ''
  if (addr.length <= 12) return addr
  return `${addr.substring(0, 6)}...${addr.substring(addr.length - 4)}`
}
</script>

<template>
  <UModal v-model:open="isOpen" title="Borrow Funds from Creator Wallet">
    <template #content>
      <div v-if="selectedRequest" class="p-5 space-y-4">

        <!-- Blockchain Network Selector -->
        <div class="flex items-center justify-between gap-2 p-1 bg-gray-950/80 rounded-xl border border-gray-800">
          <button type="button"
            class="flex-1 py-1.5 px-3 rounded-lg text-xs font-bold transition flex items-center justify-center gap-2"
            :class="selectedChainFamily === 'EVM'
              ? 'bg-amber-500/20 text-amber-300 border border-amber-500/30 shadow-xs'
              : 'text-gray-400 hover:text-white'"
            @click="selectedChainFamily = 'EVM'; borrowTokenInput = 'USDC'">
            <UIcon name="i-heroicons-bolt" class="w-4 h-4 text-amber-400" />
            <span>EVM Network</span>
          </button>

          <button type="button"
            class="flex-1 py-1.5 px-3 rounded-lg text-xs font-bold transition flex items-center justify-center gap-2"
            :class="selectedChainFamily === 'TRON'
              ? 'bg-rose-500/20 text-rose-300 border border-rose-500/30 shadow-xs'
              : 'text-gray-400 hover:text-white'"
            @click="selectedChainFamily = 'TRON'; borrowTokenInput = 'USDT'">
            <UIcon name="i-heroicons-currency-dollar" class="w-4 h-4 text-rose-400" />
            <span>TRON Network</span>
          </button>
        </div>

        <!-- Transaction Status Alert (Only shown when active) -->
        <div v-if="pullState && pullState !== 'idle'" class="p-3 rounded-xl text-xs space-y-1" :class="{
          'bg-blue-950/60 border border-blue-500/40 text-blue-300': pullState === 'checking',
          'bg-amber-950/60 border border-amber-500/40 text-amber-300': pullState === 'approval_required' || pullState === 'approving',
          'bg-purple-950/60 border border-purple-500/40 text-purple-300': pullState === 'pulling' || pullState === 'confirming',
          'bg-emerald-950/60 border border-emerald-500/40 text-emerald-300': pullState === 'success',
          'bg-rose-950/60 border border-rose-500/40 text-rose-300': pullState === 'failed' || pullState === 'user_rejected'
        }">
          <div class="flex items-center gap-2 font-bold text-[11px]">
            <UIcon v-if="pullState === 'checking' || pullState === 'pulling' || pullState === 'confirming'"
              name="i-heroicons-arrow-path" class="w-4 h-4 animate-spin text-amber-400" />
            <UIcon v-else-if="pullState === 'success'" name="i-heroicons-check-circle"
              class="w-4 h-4 text-emerald-400" />
            <UIcon v-else name="i-heroicons-exclamation-triangle" class="w-4 h-4 text-rose-400" />
            <span>Status: {{ pullState }}</span>
          </div>
          <p v-if="pullStatusMessage" class="text-[11px]">{{ pullStatusMessage }}</p>
          <p v-if="errorMessage && (pullState === 'failed' || pullState === 'user_rejected')" class="text-[11px] font-mono text-rose-400 font-semibold">
            Error: {{ errorMessage }}
          </p>
        </div>

        <!-- Target Creator Info (Clean & Compact) -->
        <div class="p-3.5 rounded-xl bg-gray-950/70 border border-gray-800 space-y-2 text-xs">
          <div class="flex items-center justify-between">
            <span class="text-gray-400">Target Creator:</span>
            <span class="text-white font-bold flex items-center gap-1.5">
              <span>{{ selectedRequest.creatorName }}</span>
              <span class="font-mono text-[11px] text-gray-400">({{ formatAddress(selectedRequest.walletAddress) }})</span>
            </span>
          </div>
          <div class="flex items-center justify-between">
            <span class="text-gray-400">Creator Balances:</span>
            <span class="font-mono text-emerald-400 font-bold text-[11px]">
              {{ selectedRequest.creatorWalletEthBalance }} | {{ selectedRequest.creatorWalletUsdtBalance }} | {{ selectedRequest.creatorWalletUsdcBalance }}
            </span>
          </div>
        </div>

        <!-- Recipient Address Input -->
        <div class="space-y-1.5">
          <div class="flex items-center justify-between text-xs">
            <label class="font-semibold text-gray-300">Recipient Wallet (Destination)</label>
            <button type="button" class="font-semibold text-amber-400 hover:underline text-[11px] flex items-center gap-1"
              @click="emit('use-connected-wallet')">
              <UIcon name="i-heroicons-wallet" class="w-3.5 h-3.5" />
              <span>Use Connected Wallet</span>
            </button>
          </div>
          <input v-model="destinationWalletInput" type="text"
            :placeholder="selectedChainFamily === 'TRON' ? 'T... (TRON Address)' : '0x... (EVM Address)'"
            class="w-full rounded-lg border border-gray-700 bg-gray-800 px-3.5 py-2 text-xs font-mono font-bold focus:outline-none"
            :class="selectedChainFamily === 'TRON' ? 'text-rose-400 focus:border-rose-500' : 'text-amber-400 focus:border-amber-500'"
            @input="emit('update-dest', destinationWalletInput)" />
        </div>

        <!-- Token & Amount Selection (Clean 2-Column Grid) -->
        <div class="grid grid-cols-1 sm:grid-cols-2 gap-3">
          <!-- Token -->
          <div class="space-y-1.5">
            <label class="block text-xs font-semibold text-gray-300">Token</label>
            <div v-if="selectedChainFamily === 'EVM'" class="grid grid-cols-3 gap-1.5">
              <button v-for="t in (['USDC', 'USDT', 'WETH'] as const)" :key="t" type="button"
                class="py-1.5 px-2 rounded-lg border text-xs font-bold font-mono transition flex items-center justify-center gap-1"
                :class="borrowTokenInput === t
                  ? 'border-amber-500 bg-amber-500/20 text-amber-400'
                  : 'border-gray-800 bg-gray-900 text-gray-400 hover:border-gray-700'"
                @click="borrowTokenInput = t">
                <span>{{ t }}</span>
              </button>
            </div>
            <div v-else>
              <button type="button"
                class="w-full py-1.5 px-3 rounded-lg border border-rose-500/50 bg-rose-500/20 text-rose-300 text-xs font-bold font-mono text-center">
                USDT (TRC-20)
              </button>
            </div>
          </div>

          <!-- Amount -->
          <div class="space-y-1.5">
            <label class="block text-xs font-semibold text-gray-300">Amount ($)</label>
            <div class="relative flex items-center">
              <span class="absolute left-3 text-xs font-bold text-gray-400">$</span>
              <input v-model="borrowAmountInput" type="text" placeholder="50"
                class="w-full rounded-lg border border-gray-700 bg-gray-800 pl-7 pr-3 py-1.5 text-xs font-bold font-mono focus:outline-none"
                :class="selectedChainFamily === 'TRON' ? 'text-rose-400 focus:border-rose-500' : 'text-amber-400 focus:border-amber-500'" />
            </div>
          </div>
        </div>

        <!-- Quick Amount Chips -->
        <div class="flex items-center gap-1.5 flex-wrap">
          <span class="text-[11px] text-gray-400 font-semibold">Quick:</span>
          <button v-for="amt in ['10', '25', '50', '100', '250']" :key="amt" type="button"
            class="px-2.5 py-1 rounded-lg text-xs font-mono font-semibold transition"
            :class="String(borrowAmountInput) === amt
              ? (selectedChainFamily === 'TRON' ? 'bg-rose-500 text-white font-bold' : 'bg-amber-500 text-black font-bold')
              : 'bg-gray-800/80 border border-gray-700 text-gray-300 hover:bg-gray-700'"
            @click="borrowAmountInput = amt">
            ${{ amt }}
          </button>
        </div>

        <!-- Action Buttons -->
        <div class="flex items-center justify-end gap-2.5 pt-3 border-t border-gray-800">
          <UButton color="neutral" variant="ghost" size="sm" @click="isOpen = false">Cancel</UButton>
          <UButton :color="selectedChainFamily === 'TRON' ? 'error' : 'warning'" variant="solid" size="sm" class="font-bold gap-2" :loading="isProcessing"
            @click="emit('confirm')">
            <UIcon name="i-heroicons-arrows-right-left" class="w-4 h-4" />
            <span>Execute Pull: {{ borrowAmountInput }} {{ borrowTokenInput }}</span>
          </UButton>
        </div>

      </div>
    </template>
  </UModal>
</template>

