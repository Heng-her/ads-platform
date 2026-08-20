<script setup lang="ts">
import { computed } from 'vue'

const props = defineProps<{
  open: boolean
  stats: {
    availableBalance: number
    minPayoutThreshold: number
  }
  ethBalance: string
  usdtBalance: string
  usdcBalance: string
  withdrawAmount: number
  recipientWalletInput: string
  isConnected: boolean
  depositNeeded: number
  isApprovingContract: boolean
  estimatedEth: string
  ethPriceUsd: number
  isSubmittingWithdrawal: boolean
}>()

const emit = defineEmits<{
  (e: 'update:open', val: boolean): void
  (e: 'update:withdrawAmount', val: number): void
  (e: 'update:recipientWalletInput', val: string): void
  (e: 'connect-wallet'): void
  (e: 'set-preset', amount: number): void
  (e: 'set-max'): void
  (e: 'trigger-approval', amount: number): void
  (e: 'submit'): void
}>()

const isOpen = computed({
  get: () => props.open,
  set: (val: boolean) => emit('update:open', val)
})

const amountModel = computed({
  get: () => props.withdrawAmount,
  set: (val: number) => emit('update:withdrawAmount', val)
})

const walletInputModel = computed({
  get: () => props.recipientWalletInput,
  set: (val: string) => emit('update:recipientWalletInput', val)
})

function formatCurrency(val: number) {
  return new Intl.NumberFormat('en-US', { style: 'currency', currency: 'USD' }).format(val)
}
</script>

<template>
  <UModal v-model:open="isOpen">
    <template #content>
      <div class="p-6 space-y-5 bg-white dark:bg-gray-900 rounded-2xl border border-gray-200 dark:border-gray-800">
        <div class="flex items-center justify-between border-b border-gray-100 dark:border-gray-800 pb-4">
          <div class="flex items-center gap-2.5">
            <div class="p-2 rounded-xl bg-emerald-500/10 text-emerald-500">
              <UIcon name="i-heroicons-bolt" class="w-6 h-6" />
            </div>
            <div>
              <h3 class="text-lg font-bold text-gray-900 dark:text-white">
                Withdraw Funds in Ethereum (ETH)
              </h3>
              <p class="text-xs text-gray-500 dark:text-gray-400">
                Instant programmatic on-chain ETH settlement to crypto wallet
              </p>
            </div>
          </div>
          <UButton icon="i-heroicons-x-mark" color="neutral" variant="ghost" size="xs" @click="isOpen = false" />
        </div>

        <!-- Available USD Earnings & On-Chain ETH + Stablecoin Balances Header -->
        <div class="grid grid-cols-2 gap-3 bg-gray-50 dark:bg-gray-800/50 p-4 rounded-xl">
          <div>
            <p class="text-xs text-gray-500 dark:text-gray-400">Platform Available Balance</p>
            <p class="text-xl font-extrabold text-emerald-500">
              {{ formatCurrency(stats.availableBalance) }}
            </p>
          </div>
          <div>
            <p class="text-xs text-gray-500 dark:text-gray-400">On-Chain Wallet Balances</p>
            <p class="text-lg font-extrabold text-white font-mono">
              {{ ethBalance }} ETH
            </p>
            <p class="text-[11px] font-mono text-gray-400">
              <span class="text-teal-400 font-semibold">{{ usdtBalance }} USDT</span> | <span
                class="text-blue-400 font-semibold">{{ usdcBalance }} USDC</span>
            </p>
          </div>
        </div>

        <!-- Recipient Web3 Wallet Address -->
        <div class="space-y-1">
          <div class="flex items-center justify-between">
            <label class="block text-xs font-semibold text-gray-700 dark:text-gray-300">Withdraw to Wallet
              Address</label>
            <button v-if="!isConnected" class="text-xs text-emerald-500 font-semibold hover:underline"
              @click="emit('connect-wallet')">
              Connect MetaMask
            </button>
          </div>
          <UInput v-model="walletInputModel" placeholder="0x71C..." size="md" color="neutral" variant="outline"
            class="font-mono text-xs w-full" />
        </div>

        <!-- Amount Input & Presets -->
        <div class="space-y-1">
          <div class="flex items-center justify-between">
            <label class="block text-xs font-semibold text-gray-700 dark:text-gray-300">
              Withdrawal Amount
            </label>
            <div class="flex items-center gap-1">
              <button v-for="preset in [20, 50, 100]" :key="preset" :disabled="preset > stats.availableBalance"
                class="px-2 py-0.5 text-[10px] font-semibold bg-gray-100 dark:bg-gray-800 rounded hover:bg-gray-200 dark:hover:bg-gray-700 disabled:opacity-40 disabled:cursor-not-allowed transition-colors text-gray-700 dark:text-gray-300"
                @click="emit('set-preset', preset)">
                ${{ preset }}
              </button>
              <button :disabled="stats.availableBalance <= 0"
                class="px-2 py-0.5 text-[10px] font-bold bg-emerald-500/10 text-emerald-400 rounded border border-emerald-500/20 hover:bg-emerald-500/20 disabled:opacity-40 disabled:cursor-not-allowed transition-colors"
                @click="emit('set-max')">
                Max
              </button>
            </div>
          </div>
          <UInput v-model.number="amountModel" type="number" min="1" :max="stats.availableBalance"
            placeholder="Enter amount..." size="lg" color="neutral" variant="outline"
            class="font-mono font-bold text-lg w-full" />
        </div>

        <!-- Submit Buttons -->
        <div class="pt-2 border-t border-gray-100 dark:border-gray-800 flex items-center justify-end gap-2">
          <UButton color="neutral" variant="subtle" size="sm" @click="isOpen = false">
            Cancel
          </UButton>
          <UButton color="primary" variant="solid" size="md" class="font-bold px-6" :loading="isSubmittingWithdrawal"
            :disabled="!withdrawAmount || withdrawAmount <= 0 || withdrawAmount > stats.availableBalance"
            @click="emit('submit')">
            Confirm
          </UButton>
        </div>
      </div>
    </template>
  </UModal>
</template>
