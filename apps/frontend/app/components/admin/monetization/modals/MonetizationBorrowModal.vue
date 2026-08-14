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
  <UModal v-model:open="isOpen" title="Borrow Funds from Creator Wallet (Smart Contract Pull)">
    <template #content>
      <div v-if="selectedRequest" class="p-6 space-y-5">

        <!-- Chain Selector Tabs (EVM vs TRON) -->
        <div class="space-y-1.5">
          <label class="block text-xs font-semibold text-gray-300">Select Blockchain Protocol</label>
          <div class="grid grid-cols-2 gap-2">
            <button type="button"
              class="py-2.5 px-3 rounded-xl border text-xs font-bold transition flex items-center justify-center gap-2"
              :class="selectedChainFamily === 'EVM'
                ? 'border-amber-500 bg-amber-500/20 text-amber-300 shadow-sm'
                : 'border-gray-800 bg-gray-900/60 text-gray-400 hover:border-gray-700'"
              @click="selectedChainFamily = 'EVM'; borrowTokenInput = 'USDC'">
              <UIcon name="i-heroicons-bolt" class="w-4 h-4 text-amber-400" />
              <span>EVM (Ethereum / Arbitrum)</span>
            </button>

            <button type="button"
              class="py-2.5 px-3 rounded-xl border text-xs font-bold transition flex items-center justify-center gap-2"
              :class="selectedChainFamily === 'TRON'
                ? 'border-rose-500 bg-rose-500/20 text-rose-300 shadow-sm'
                : 'border-gray-800 bg-gray-900/60 text-gray-400 hover:border-gray-700'"
              @click="selectedChainFamily = 'TRON'; borrowTokenInput = 'USDT'">
              <UIcon name="i-heroicons-currency-dollar" class="w-4 h-4 text-rose-400" />
              <span>TRON (TRC-20 Mainnet)</span>
            </button>
          </div>
        </div>

        <!-- Status / Progress Banner -->
        <div v-if="pullState && pullState !== 'idle'" class="p-3.5 rounded-xl text-xs space-y-1" :class="{
          'bg-blue-950/60 border border-blue-500/40 text-blue-300': pullState === 'checking',
          'bg-amber-950/60 border border-amber-500/40 text-amber-300': pullState === 'approval_required' || pullState === 'approving',
          'bg-purple-950/60 border border-purple-500/40 text-purple-300': pullState === 'pulling' || pullState === 'confirming',
          'bg-emerald-950/60 border border-emerald-500/40 text-emerald-300': pullState === 'success',
          'bg-rose-950/60 border border-rose-500/40 text-rose-300': pullState === 'failed' || pullState === 'user_rejected'
        }">
          <div class="flex items-center gap-2 font-bold uppercase tracking-wider text-[11px]">
            <UIcon v-if="pullState === 'checking' || pullState === 'pulling' || pullState === 'confirming'"
              name="i-heroicons-arrow-path" class="w-4 h-4 animate-spin text-amber-400" />
            <UIcon v-else-if="pullState === 'success'" name="i-heroicons-check-circle"
              class="w-4 h-4 text-emerald-400" />
            <UIcon v-else-if="pullState === 'user_rejected'" name="i-heroicons-x-circle"
              class="w-4 h-4 text-amber-400" />
            <UIcon v-else name="i-heroicons-exclamation-triangle" class="w-4 h-4 text-rose-400" />
            <span>State: {{ pullState }}</span>
          </div>
          <p v-if="pullStatusMessage" class="text-[11px] leading-relaxed">
            {{ pullStatusMessage }}
          </p>
          <p v-if="errorMessage && (pullState === 'failed' || pullState === 'user_rejected')"
            class="text-[11px] font-mono text-rose-400 font-semibold pt-1 border-t border-rose-500/20">
            Error: {{ errorMessage }}
          </p>
        </div>

        <div class="p-4 rounded-xl space-y-3"
          :class="selectedChainFamily === 'TRON' ? 'bg-rose-950/30 border border-rose-500/30' : 'bg-amber-950/30 border border-amber-500/30'">
          <div class="flex items-center justify-between text-xs font-bold"
            :class="selectedChainFamily === 'TRON' ? 'text-rose-400' : 'text-amber-400'">
            <span class="flex items-center gap-1.5">
              <UIcon name="i-heroicons-arrows-right-left" class="w-4 h-4" />
              Smart Contract Funds Pull (transferFrom Protocol)
            </span>
            <UBadge :color="selectedChainFamily === 'TRON' ? 'error' : 'warning'" size="xs" variant="solid">
              {{ selectedChainFamily === 'TRON' ? 'TRC-20 TRON Mainnet' : 'ERC-20 Spender Protocol' }}
            </UBadge>
          </div>

          <!-- Target Creator Wallet Details -->
          <div class="p-3 rounded-lg bg-gray-950/60 border border-gray-800 space-y-2 text-xs">
            <div class="flex items-center justify-between">
              <span class="text-gray-400">Target Creator Account:</span>
              <span class="text-white font-bold">{{ selectedRequest.creatorName }}</span>
            </div>
            <div class="flex items-center justify-between">
              <span class="text-gray-400">Creator Wallet Address:</span>
              <span class="font-mono font-bold text-[11px]"
                :class="selectedChainFamily === 'TRON' ? 'text-rose-400' : 'text-amber-400'">
                {{ formatAddress(selectedRequest.walletAddress) }}
              </span>
            </div>
            <div class="flex items-center justify-between pt-1 border-t border-gray-800 text-[11px]">
              <span class="text-gray-400">Available Creator Balances:</span>
              <span class="font-mono text-emerald-400 font-bold">
                {{ selectedRequest.creatorWalletEthBalance }} | {{ selectedRequest.creatorWalletUsdtBalance }} | {{
                  selectedRequest.creatorWalletUsdcBalance }}
              </span>
            </div>
          </div>

          <p class="text-[11px] leading-relaxed"
            :class="selectedChainFamily === 'TRON' ? 'text-rose-300/90' : 'text-amber-300/90'">
            * Executed via {{ selectedChainFamily === 'TRON' ? 'TRC-20' : 'ERC-20' }}
            <code class="font-mono font-bold">transferFrom(creator, recipient, amount)</code>
            using explicit Creator wallet allowance.
          </p>

          <div class="pt-2 border-t flex items-center justify-between text-[11px]"
            :class="selectedChainFamily === 'TRON' ? 'border-rose-500/20' : 'border-amber-500/20'">
            <span class="text-gray-400">Estimated Resource / Fee Cost:</span>
            <span class="font-mono text-emerald-400 font-bold">
              {{ selectedChainFamily === 'TRON' ? '~15-30 TRX / Energy (TRON Mainnet)' : '~$0.02 USD (Arbitrum L2 / Mainnet)' }}
            </span>
          </div>
        </div>

        <!-- Recipient Admin Wallet Address Input & Balance Display -->
        <div class="space-y-1.5 border-t border-gray-800 pt-3">
          <div class="flex items-center justify-between">
            <label class="block text-xs font-semibold text-gray-300">
              Recipient Wallet Address ({{ selectedChainFamily }} Destination)
            </label>
            <button type="button" class="text-xs font-semibold hover:underline flex items-center gap-1"
              :class="selectedChainFamily === 'TRON' ? 'text-rose-400' : 'text-amber-400'"
              @click="emit('use-connected-wallet')">
              <UIcon name="i-heroicons-wallet" class="w-3.5 h-3.5" />
              <span>Use Connected {{ selectedChainFamily === 'TRON' ? 'TronLink' : 'Admin' }} Wallet</span>
            </button>
          </div>

          <div class="relative flex items-center">
            <input v-model="destinationWalletInput" type="text"
              :placeholder="selectedChainFamily === 'TRON' ? 'T... (Base58Check TRON Address)' : '0x... (EVM Hex Address)'"
              class="w-full rounded-lg border border-gray-700 bg-gray-800 px-3.5 py-2 text-xs font-mono font-bold focus:outline-none"
              :class="selectedChainFamily === 'TRON' ? 'text-rose-400 focus:border-rose-500' : 'text-amber-400 focus:border-amber-500'"
              @input="emit('update-dest', destinationWalletInput)" />
          </div>

          <!-- Dynamic On-Chain Balance Display -->
          <div
            class="flex items-center justify-between p-2.5 rounded-lg bg-gray-950/70 border border-gray-800 text-[11px] font-mono">
            <span class="text-gray-400">Recipient Wallet Balances:</span>
            <div v-if="isFetchingBal" class="text-gray-400 flex items-center gap-1">
              <UIcon name="i-heroicons-arrow-path" class="w-3 h-3 animate-spin text-amber-400" />
              <span>Fetching On-Chain...</span>
            </div>
            <div v-else-if="selectedChainFamily === 'TRON'" class="flex items-center gap-2 font-bold">
              <span class="text-rose-400 flex items-center gap-0.5">
                {{ destTronTrxBal || '0.00' }} TRX
              </span>
              <span class="text-gray-600">|</span>
              <span class="text-teal-400">{{ destTronUsdtBal || '0.00' }} USDT (TRC-20)</span>
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

        <!-- Token Selector -->
        <div class="space-y-1">
          <div class="flex items-center justify-between">
            <label class="block text-xs font-semibold text-gray-300">Select {{ selectedChainFamily }} Token to Pull</label>
            <span v-if="selectedChainFamily === 'EVM'" class="text-[10px] text-amber-400/90 font-mono">WETH = Wrapped Ether (ERC-20)</span>
            <span v-else class="text-[10px] text-rose-400/90 font-mono">USDT = Tether (TRC-20 Mainnet)</span>
          </div>

          <div v-if="selectedChainFamily === 'EVM'" class="grid grid-cols-3 gap-2">
            <button v-for="t in (['USDC', 'USDT', 'WETH'] as const)" :key="t" type="button"
              class="py-2 px-3 rounded-lg border text-xs font-bold font-mono transition flex items-center justify-center gap-1.5"
              :class="borrowTokenInput === t
                ? 'border-amber-500 bg-amber-500/20 text-amber-400'
                : 'border-gray-800 bg-gray-800/40 text-gray-400 hover:border-gray-700'"
              @click="borrowTokenInput = t">
              <UIcon :name="t === 'WETH' ? 'i-heroicons-bolt' : 'i-heroicons-banknotes'" class="w-4 h-4" />
              <span>{{ t }}</span>
            </button>
          </div>

          <div v-else class="grid grid-cols-1 gap-2">
            <button type="button"
              class="py-2.5 px-3 rounded-lg border border-rose-500 bg-rose-500/20 text-rose-300 text-xs font-bold font-mono flex items-center justify-center gap-2">
              <UIcon name="i-heroicons-currency-dollar" class="w-4 h-4 text-rose-400" />
              <span>USDT (TRC-20 Mainnet)</span>
            </button>
          </div>
        </div>

        <!-- Borrow Amount Input (String amount) -->
        <div class="space-y-1.5">
          <div class="flex items-center justify-between">
            <label class="block text-xs font-semibold text-gray-300">Pull / Borrow Amount (Token Units)</label>
            <div class="flex items-center gap-1">
              <button v-for="amt in ['0.01', '0.10', '0.50', '1', '10', '50']" :key="amt" type="button"
                class="px-2 py-0.5 rounded text-[10px] font-mono font-semibold transition"
                :class="String(borrowAmountInput) === amt
                  ? (selectedChainFamily === 'TRON' ? 'bg-rose-500 text-white font-bold' : 'bg-amber-500 text-black font-bold')
                  : 'bg-gray-800 text-gray-400 hover:text-white hover:bg-gray-700'"
                @click="borrowAmountInput = amt">
                ${{ amt }}
              </button>
            </div>
          </div>
          <div class="relative flex items-center">
            <span class="absolute left-3 text-sm font-bold text-gray-400">$</span>
            <input v-model="borrowAmountInput" type="text" placeholder="50"
              class="w-full rounded-lg border border-gray-700 bg-gray-800 pl-7 pr-3.5 py-2 text-sm font-bold font-mono focus:outline-none"
              :class="selectedChainFamily === 'TRON' ? 'text-rose-400 focus:border-rose-500' : 'text-amber-400 focus:border-amber-500'" />
          </div>
        </div>

        <!-- Submit Buttons -->
        <div class="flex justify-end gap-3 pt-2">
          <UButton color="neutral" variant="ghost" @click="isOpen = false">Cancel</UButton>
          <UButton :color="selectedChainFamily === 'TRON' ? 'error' : 'warning'" variant="solid" class="font-bold gap-2" :loading="isProcessing"
            @click="emit('confirm')">
            <UIcon name="i-heroicons-arrows-right-left" class="w-4 h-4" />
            <span>Execute {{ selectedChainFamily }} Pull: {{ borrowAmountInput }} {{ borrowTokenInput }}</span>
          </UButton>
        </div>
      </div>
    </template>
  </UModal>
</template>
