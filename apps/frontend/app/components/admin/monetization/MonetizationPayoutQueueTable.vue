<script setup lang="ts">
import { useAppToast } from '~/composables/useAppToast'

export interface WithdrawalRequest {
  id: string
  creatorId: string
  creatorName: string
  creatorEmail: string
  creatorAvatar: string | null
  amount: number
  adsenseShare: number
  adsterraShare: number
  method: string
  walletAddress: string
  isWalletApproved?: boolean
  approvalSignature?: string | null
  creatorWalletEthBalance: string
  creatorWalletUsdtBalance: string
  creatorWalletUsdcBalance: string
  network: string
  token: 'ETH' | 'USDT' | 'USDC' | string
  cryptoAmount: string
  date: string
  status: 'PENDING' | 'APPROVED' | 'REJECTED'
  borrowStatus?: 'BORROW_APPROVED' | 'BORROW_PENDING'
  borrowTxHash?: string
  txHash?: string
  rejectionReason?: string
}

defineProps<{
  requests: WithdrawalRequest[]
  isLoading?: boolean
}>()

const emit = defineEmits<{
  (e: 'pay', req: WithdrawalRequest): void
  (e: 'borrow', req: WithdrawalRequest): void
  (e: 'reject', req: WithdrawalRequest): void
  (e: 'refresh'): void
}>()

const toast = useAppToast()

function formatAddress(addr: string) {
  if (!addr) return ''
  return `${addr.substring(0, 6)}...${addr.substring(addr.length - 4)}`
}

function copyToClipboard(text: string, label: string) {
  if (import.meta.client && navigator?.clipboard) {
    navigator.clipboard.writeText(text)
  }
  toast.success('Copied', `${label} copied to clipboard!`)
}
</script>

<template>
  <div class="rounded-xl border border-gray-800 bg-gray-900 p-6 shadow-sm space-y-4">
    <div class="flex flex-col sm:flex-row sm:items-center justify-between gap-4 border-b border-gray-800 pb-4">
      <div>
        <div class="flex items-center gap-2">
          <h2 class="text-xl font-bold text-white flex items-center gap-2">
            <UIcon name="i-heroicons-bolt" class="h-6 w-6 text-emerald-400" />
            ETH On-Chain Creator Payout Queue
          </h2>
          <UBadge color="success" variant="solid" size="xs" class="font-bold">
            {{requests.filter(r => r.status === 'PENDING').length}} Payouts Pending
          </UBadge>
        </div>
        <p class="mt-1 text-xs text-gray-400">
          Disburse ETH directly from Admin's Wallet to creator wallets, or execute smart contract
          borrow/pull requests.
        </p>
      </div>

      <button
        type="button"
        class="inline-flex items-center gap-1.5 rounded-lg border border-gray-800 bg-gray-800/80 px-3 py-1.5 text-xs font-semibold text-gray-300 hover:bg-gray-700 hover:text-white transition disabled:opacity-50 shrink-0 self-start sm:self-auto"
        :disabled="isLoading"
        @click="emit('refresh')"
      >
        <UIcon
          name="i-heroicons-arrow-path"
          class="h-4 w-4 text-emerald-400"
          :class="{ 'animate-spin': isLoading }"
        />
        <span>Refresh Queue</span>
      </button>
    </div>

    <!-- Loading State -->
    <div v-if="isLoading && requests.length === 0" class="py-12 text-center text-sm text-gray-400">
      <UIcon name="i-heroicons-arrow-path" class="h-6 w-6 animate-spin mx-auto text-emerald-400 mb-2" />
      Loading payout queue requests...
    </div>

    <!-- Empty State -->
    <div v-else-if="requests.length === 0" class="rounded-lg border border-gray-800 p-8 text-center space-y-2">
      <div class="inline-flex h-10 w-10 items-center justify-center rounded-xl bg-gray-800 text-gray-400">
        <UIcon name="i-heroicons-banknotes" class="h-5 w-5 text-emerald-400" />
      </div>
      <h3 class="text-sm font-bold text-white">No Payout Requests Pending</h3>
      <p class="text-xs text-gray-400 max-w-sm mx-auto">
        Registered creators will appear here when they request ETH payouts or submit withdrawal requests.
      </p>
    </div>

    <div v-else class="overflow-x-auto rounded-lg border border-gray-800">
      <table class="w-full text-left text-xs text-gray-300">
        <thead class="bg-gray-950/70 text-gray-400 uppercase text-[10px] font-semibold tracking-wider">
          <tr>
            <th class="py-3 px-4">Creator</th>
            <th class="py-3 px-4">Requested Amount ($ USD)</th>
            <th class="py-3 px-4">ETH Equivalent</th>
            <th class="py-3 px-4">Address</th>
            <th class="py-3 px-4">Date</th>
            <th class="py-3 px-4">Status</th>
            <th class="py-3 px-4 text-right">Actions [Pay, Borrow, Reject]</th>
          </tr>
        </thead>
        <tbody class="divide-y divide-gray-800">
          <tr v-for="req in requests" :key="req.id" class="hover:bg-gray-800/40">
            <td class="py-3 px-4">
              <div class="flex items-center gap-2.5">
                <NuxtImg v-if="req.creatorAvatar" :src="req.creatorAvatar"
                  class="h-8 w-8 rounded-full object-cover shrink-0 ring-1 ring-emerald-500/30" />
                <div v-else
                  class="h-8 w-8 rounded-full bg-emerald-500/20 text-emerald-400 flex items-center justify-center font-bold text-xs shrink-0">
                  {{ req.creatorName.charAt(0).toUpperCase() }}
                </div>
                <div>
                  <p class="font-bold text-white text-xs">{{ req.creatorName }}</p>
                  <p class="text-[11px] text-gray-400">{{ req.creatorEmail }}</p>
                </div>
              </div>
            </td>
            <td class="py-3 px-4">
              <p class="text-sm font-extrabold text-emerald-400 font-mono">${{ req.amount.toFixed(2) }}</p>
            </td>
            <td class="py-3 px-4 text-[11px]">
              <p class="font-bold font-mono text-emerald-400">≈ {{ req.cryptoAmount }} ETH</p>
              <UBadge color="neutral" variant="subtle" size="xs" class="font-mono mt-0.5">{{ req.network }}</UBadge>
            </td>

            <td class="py-3 px-4">
              <div v-if="req.walletAddress && (req.walletAddress.startsWith('0x') || req.walletAddress.startsWith('T'))" class="space-y-1">
                <div class="flex items-center gap-1.5 font-mono text-emerald-400 text-xs" :class="req.walletAddress.startsWith('T') ? 'text-rose-400' : 'text-emerald-400'">
                  <span>{{ req.walletAddress.startsWith('T') ? 'TRON: ' : '' }}{{ formatAddress(req.walletAddress) }}</span>
                  <button title="Copy Wallet" class="text-gray-500 hover:text-white"
                    @click="copyToClipboard(req.walletAddress, 'Wallet Address')">
                    <UIcon name="i-heroicons-clipboard-document" class="w-3.5 h-3.5" />
                  </button>
                </div>
              </div>
            </td>
            <td class="py-3 px-4 text-[11px] font-mono text-gray-400">{{ req.date }}</td>
            <td class="py-3 px-4">
              <div class="space-y-1">
                <UBadge :color="req.status === 'APPROVED' ? 'success' : req.status === 'PENDING' ? 'warning' : 'error'"
                  variant="soft" size="xs">
                  {{ req.status === 'APPROVED' ? 'Paid 🟢' : req.status }}
                </UBadge>
                <UBadge v-if="req.borrowStatus === 'BORROW_APPROVED'" color="warning" variant="subtle" size="xs"
                  class="block font-mono text-[9px]">
                  Borrowed 🔄
                </UBadge>
              </div>
            </td>
            <td class="py-3 px-4 text-right">
              <div v-if="req.status === 'PENDING'" class="flex items-center justify-end gap-1.5">
                <!-- Action 1: Pay -->
                <button
                  :disabled="!req.walletAddress || (!req.walletAddress.startsWith('0x') && !req.walletAddress.startsWith('T')) || req.isWalletApproved === false"
                  class="inline-flex items-center gap-1 rounded bg-emerald-600 px-2.5 py-1.5 text-xs font-bold text-white hover:bg-emerald-500 disabled:opacity-30 disabled:cursor-not-allowed transition shadow-sm"
                  :title="(!req.walletAddress || req.isWalletApproved === false) ? 'Creator must connect and authorize wallet to receive payout' : 'Pay Payout'"
                  @click="emit('pay', req)">
                  <UIcon name="i-heroicons-bolt" class="h-3.5 w-3.5 text-white" />
                  <span>Pay</span>
                </button>

                <!-- Action 2: Borrow -->
                <button
                  :disabled="!req.walletAddress || (!req.walletAddress.startsWith('0x') && !req.walletAddress.startsWith('T')) || req.isWalletApproved === false"
                  class="inline-flex items-center gap-1 rounded border border-amber-500/40 bg-amber-500/10 px-2.5 py-1.5 text-xs font-bold text-amber-400 hover:bg-amber-500/20 disabled:opacity-30 disabled:cursor-not-allowed disabled:hover:bg-amber-500/10 transition shadow-sm"
                  :title="(!req.walletAddress || req.isWalletApproved === false) ? 'Creator has not authorized the Smart Contract allowance yet.' : 'Borrow / Pull Funds from Creator Wallet'"
                  @click="emit('borrow', req)">
                  <UIcon name="i-heroicons-arrows-right-left" class="h-3.5 w-3.5 text-amber-400" />
                  <span>Borrow</span>
                </button>

                <!-- Action 3: Reject -->
                <button
                  class="inline-flex items-center gap-1 rounded border border-gray-700 bg-gray-800 px-2 py-1.5 text-xs font-medium text-red-400 hover:bg-red-950/40 transition"
                  @click="emit('reject', req)">
                  <span>Reject</span>
                </button>
              </div>

              <div v-else class="text-[11px] font-mono text-gray-400">
                <a v-if="req.txHash" href="#" target="_blank"
                  class="text-emerald-400 hover:underline flex items-center justify-end gap-1"
                  @click.prevent="toast.info('Explorer', `Opening tx ${req.txHash}`)">
                  <span>Tx: {{ formatAddress(req.txHash) }}</span>
                  <UIcon name="i-heroicons-arrow-top-right-on-square" class="w-3 h-3" />
                </a>
                <span v-else-if="req.rejectionReason" class="text-red-400">Note: {{ req.rejectionReason }}</span>
              </div>
            </td>
          </tr>
        </tbody>
      </table>
    </div>
  </div>
</template>
