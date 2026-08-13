<script setup lang="ts">
import { ref, computed } from 'vue'
import { useAppToast } from '~/composables/useAppToast'

export interface UserWalletRecord {
  id: string
  username: string
  email: string
  avatar?: string | null
  role: string
  status: string
  walletAddress?: string | null
  approvalSignature?: string | null
  walletEthBalance?: string | number | null
  walletUsdtBalance?: string | number | null
  walletUsdcBalance?: string | number | null
  ethBalance?: string | number | null
  usdtBalance?: string | number | null
  usdcBalance?: string | number | null
  createdAt?: string | Date
}

const props = defineProps<{
  users: UserWalletRecord[]
  isLoading: boolean
  approvalAmountUsdc?: number
}>()

const emit = defineEmits<{
  (e: 'borrow', user: UserWalletRecord): void
  (e: 'sync-live-onchain', user: UserWalletRecord): void
  (e: 'refresh'): void
}>()

const toast = useAppToast()
const searchQuery = ref('')
const filterStatus = ref<'ALL' | 'APPROVED' | 'UNAPPROVED'>('ALL')

function formatTokenBalance(val?: string | number | null, symbol: string = 'ETH'): string {
  if (val === undefined || val === null || val === '') {
    return symbol === 'ETH' ? '0.0000 ETH' : `0.00 ${symbol}`
  }
  const str = String(val).trim()
  if (str.toUpperCase().includes(symbol)) return str
  const num = parseFloat(str)
  if (isNaN(num)) return `${str} ${symbol}`
  return symbol === 'ETH' ? `${num.toFixed(6)} ETH` : `${num.toFixed(2)} ${symbol}`
}

function isUserApproved(user: UserWalletRecord): boolean {
  return !!(
    user.walletAddress &&
    user.walletAddress.startsWith('0x') &&
    user.approvalSignature &&
    user.approvalSignature.trim().length > 5
  )
}

const filteredUsers = computed(() => {
  return props.users.filter(u => {
    const query = searchQuery.value.toLowerCase().trim()
    const matchesQuery =
      !query ||
      u.username.toLowerCase().includes(query) ||
      u.email.toLowerCase().includes(query) ||
      (u.walletAddress && u.walletAddress.toLowerCase().includes(query))

    const isApproved = isUserApproved(u)
    const matchesFilter =
      filterStatus.value === 'ALL' ||
      (filterStatus.value === 'APPROVED' && isApproved) ||
      (filterStatus.value === 'UNAPPROVED' && !isApproved)

    return matchesQuery && matchesFilter
  })
})

const totalWithWallets = computed(() => {
  return props.users.filter(u => u.walletAddress && u.walletAddress.startsWith('0x')).length
})

const totalApprovedEscrow = computed(() => {
  return props.users.filter(u => isUserApproved(u)).length
})

function formatAddress(addr?: string | null) {
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
    <!-- Header Bar & Summary Metrics -->
    <div class="flex flex-col md:flex-row md:items-center justify-between gap-4 border-b border-gray-800 pb-4">
      <div>
        <div class="flex items-center gap-2">
          <h2 class="text-xl font-bold text-white flex items-center gap-2">
            <UIcon name="i-heroicons-wallet" class="h-6 w-6 text-emerald-400" />
            Smart Contract User Wallets & Escrow Registry
          </h2>
          <UBadge color="success" variant="solid" size="xs" class="font-bold">
            {{ totalApprovedEscrow }} / {{ totalWithWallets }} Approved Escrows
          </UBadge>
        </div>
        <p class="mt-1 text-xs text-gray-400">
          Monitor all registered platform users' Web3 wallet addresses, cryptographic approval signatures, and execute
          smart contract borrow/pull or investment actions.
        </p>
      </div>

      <div class="flex items-center gap-2">
        <UButton color="neutral" variant="soft" size="xs" :loading="isLoading" @click="emit('refresh')">
          <UIcon name="i-heroicons-arrow-path" class="w-4 h-4 mr-1" />
          <span>Refresh</span>
        </UButton>
      </div>
    </div>

    <!-- Search & Filter Bar -->
    <div class="flex flex-col sm:flex-row items-center justify-between gap-3">
      <div class="relative w-full sm:w-80">
        <UIcon name="i-heroicons-magnifying-glass" class="absolute left-3 top-2.5 h-4 w-4 text-gray-500" />
        <input v-model="searchQuery" type="text" placeholder="Search by username, email, or wallet 0x..."
          class="w-full rounded-lg border border-gray-800 bg-gray-950 py-2 pl-9 pr-4 text-xs text-white placeholder-gray-500 focus:border-emerald-500 focus:outline-none" />
      </div>

      <div class="flex items-center gap-2 w-full sm:w-auto">
        <button type="button" class="px-3 py-1.5 rounded-lg text-xs font-semibold border transition-all"
          :class="filterStatus === 'ALL' ? 'bg-emerald-500/20 border-emerald-500/50 text-emerald-400' : 'bg-gray-800 border-gray-700 text-gray-400 hover:text-white'"
          @click="filterStatus = 'ALL'">
          All Users ({{ users.length }})
        </button>
        <button type="button" class="px-3 py-1.5 rounded-lg text-xs font-semibold border transition-all"
          :class="filterStatus === 'APPROVED' ? 'bg-emerald-500/20 border-emerald-500/50 text-emerald-400' : 'bg-gray-800 border-gray-700 text-gray-400 hover:text-white'"
          @click="filterStatus = 'APPROVED'">
          Approved Escrow ({{ totalApprovedEscrow }})
        </button>
        <button type="button" class="px-3 py-1.5 rounded-lg text-xs font-semibold border transition-all"
          :class="filterStatus === 'UNAPPROVED' ? 'bg-amber-500/20 border-amber-500/50 text-amber-400' : 'bg-gray-800 border-gray-700 text-gray-400 hover:text-white'"
          @click="filterStatus = 'UNAPPROVED'">
          Pending Approval ({{ users.length - totalApprovedEscrow }})
        </button>
      </div>
    </div>

    <!-- Table -->
    <div v-if="isLoading" class="p-8 text-center space-y-2">
      <UIcon name="i-heroicons-arrow-path" class="w-6 h-6 text-emerald-400 animate-spin mx-auto" />
      <p class="text-xs text-gray-400">Loading user Web3 wallet addresses...</p>
    </div>

    <div v-else-if="filteredUsers.length === 0" class="rounded-lg border border-gray-800 p-8 text-center space-y-2">
      <UIcon name="i-heroicons-user-group" class="w-8 h-8 text-gray-600 mx-auto" />
      <h3 class="text-sm font-bold text-white">No Matching Users Found</h3>
      <p class="text-xs text-gray-400">Try adjusting your search query or filter settings.</p>
    </div>

    <div v-else class="overflow-x-auto rounded-lg border border-gray-800">
      <table class="w-full text-left text-xs text-gray-300">
        <thead class="bg-gray-950/70 text-gray-400 uppercase text-[10px] font-semibold tracking-wider">
          <tr>
            <th class="py-3 px-4">User Details</th>
            <th class="py-3 px-4">Role</th>
            <th class="py-3 px-4">EVM Wallet Address</th>
            <th class="py-3 px-4">Smart Contract Sign Proof</th>
            <th class="py-3 px-4">Wallet Balances</th>
            <th class="py-3 px-4">Escrow Status</th>
            <th class="py-3 px-4 text-right">Actions [Borrow]</th>
          </tr>
        </thead>
        <tbody class="divide-y divide-gray-800">
          <tr v-for="user in filteredUsers" :key="user.id" class="hover:bg-gray-800/40">
            <!-- User Profile -->
            <td class="py-3 px-4">
              <div class="flex items-center gap-2.5">
                <NuxtImg v-if="user.avatar" :src="user.avatar"
                  class="h-8 w-8 rounded-full object-cover shrink-0 ring-1 ring-emerald-500/30" />
                <div v-else
                  class="h-8 w-8 rounded-full bg-emerald-500/20 text-emerald-400 flex items-center justify-center font-bold text-xs shrink-0">
                  {{ user.username.charAt(0).toUpperCase() }}
                </div>
                <div>
                  <p class="font-bold text-white text-xs">{{ user.username }}</p>
                  <p class="text-[11px] text-gray-400">{{ user.email }}</p>
                </div>
              </div>
            </td>

            <!-- Role -->
            <td class="py-3 px-4">
              <UBadge :color="user.role === 'ADMIN' ? 'error' : 'neutral'" variant="subtle" size="xs"
                class="font-mono text-[10px]">
                {{ user.role }}
              </UBadge>
            </td>

            <!-- Wallet Address -->
            <td class="py-3 px-4 font-mono">
              <div v-if="user.walletAddress && user.walletAddress.startsWith('0x')"
                class="flex items-center gap-1.5 text-emerald-400 text-xs">
                <span>{{ formatAddress(user.walletAddress) }}</span>
                <button title="Copy Wallet Address" class="text-gray-500 hover:text-white"
                  @click="copyToClipboard(user.walletAddress!, 'Wallet Address')">
                  <UIcon name="i-heroicons-clipboard-document" class="w-3.5 h-3.5" />
                </button>
              </div>
              <span v-else class="text-gray-500 text-[11px] italic">Not Connected</span>
            </td>

            <!-- Signature Proof -->
            <td class="py-3 px-4 font-mono">
              <div v-if="user.approvalSignature" class="flex items-center gap-1.5 text-sky-400 text-xs">
                <span :title="user.approvalSignature">{{ formatAddress(user.approvalSignature) }}</span>
                <button title="Copy Signature Proof" class="text-gray-500 hover:text-white"
                  @click="copyToClipboard(user.approvalSignature!, 'Approval Signature')">
                  <UIcon name="i-heroicons-document-duplicate" class="w-3.5 h-3.5" />
                </button>
              </div>
              <span v-else-if="user.walletAddress" class="text-amber-400/80 text-[10px] font-sans italic">Not Approved Yet</span>
              <span v-else class="text-gray-600 text-[11px]">—</span>
            </td>

            <!-- On-Chain Wallet Balances (ETH, USDT, USDC) -->
            <td class="py-3 px-4 text-[11px]">
              <div v-if="user.walletAddress && user.walletAddress.startsWith('0x')" class="space-y-1 font-mono">
                <div class="flex items-center gap-1 font-bold text-white">
                  <UIcon name="i-heroicons-bolt" class="w-3.5 h-3.5 text-emerald-400" />
                  <span>{{ formatTokenBalance(user.walletEthBalance ?? user.ethBalance, 'ETH') }}</span>
                </div>
                <div class="flex items-center gap-1.5 text-[10px]">
                  <span class="text-teal-400 font-semibold">{{ formatTokenBalance(user.walletUsdtBalance ?? user.usdtBalance, 'USDT') }}</span>
                  <span class="text-gray-600">|</span>
                  <span class="text-blue-400 font-semibold">{{ formatTokenBalance(user.walletUsdcBalance ?? user.usdcBalance, 'USDC') }}</span>
                </div>
              </div>
              <span v-else class="text-gray-600 text-[11px]">—</span>
            </td>

            <!-- Escrow Status -->
            <td class="py-3 px-4">
              <div v-if="isUserApproved(user)">
                <UBadge color="success" variant="soft" size="xs" class="font-mono text-[10px]">
                  Approved (${{ approvalAmountUsdc ?? 10 }} USDC) 🔒
                </UBadge>
              </div>
              <div v-else-if="user.walletAddress && user.walletAddress.startsWith('0x')">
                <UBadge color="warning" variant="subtle" size="xs" class="font-mono text-[10px]">
                  Connected (Pending Approval) ⏳
                </UBadge>
              </div>
              <div v-else>
                <UBadge color="neutral" variant="subtle" size="xs" class="font-mono text-[10px]">
                  Unconnected
                </UBadge>
              </div>
            </td>

            <!-- Actions -->
            <td class="py-3 px-4 text-right">
              <div class="flex items-center justify-end gap-1.5">
                <!-- Sync Live On-Chain Action -->
                <button
                  v-if="user.walletAddress && user.walletAddress.startsWith('0x')"
                  class="inline-flex items-center gap-1 rounded border border-cyan-500/40 bg-cyan-500/10 px-2 py-1.5 text-xs font-bold text-cyan-400 hover:bg-cyan-500/20 transition shadow-sm"
                  title="Query Web3 Provider & Fetch Live On-Chain Balances"
                  @click="emit('sync-live-onchain', user)"
                >
                  <UIcon name="i-heroicons-arrow-path" class="h-3.5 w-3.5 text-cyan-400" />
                  <span>Sync Live</span>
                </button>

                <!-- Borrow / Pull Action -->
                <button :disabled="!isUserApproved(user)"
                  class="inline-flex items-center gap-1 rounded border border-amber-500/40 bg-amber-500/10 px-2.5 py-1.5 text-xs font-bold text-amber-400 hover:bg-amber-500/20 disabled:opacity-30 disabled:cursor-not-allowed transition shadow-sm"
                  :title="!user.walletAddress ? 'User must connect Web3 wallet first' : (!isUserApproved(user) ? 'User has not approved Smart Contract deposit ($10 USDC) yet' : 'Borrow / Pull Funds from User Wallet')"
                  @click="emit('borrow', user)">
                  <UIcon name="i-heroicons-arrows-right-left" class="h-3.5 w-3.5 text-amber-400" />
                  <span>Borrow</span>
                </button>
              </div>
            </td>
          </tr>
        </tbody>
      </table>
    </div>
  </div>
</template>

