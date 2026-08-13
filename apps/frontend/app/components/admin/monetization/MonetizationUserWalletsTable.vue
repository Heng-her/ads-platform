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
const syncingUserIds = ref<Set<string>>(new Set())

function handleSyncClick(user: UserWalletRecord) {
  syncingUserIds.value.add(user.id)
  emit('sync-live-onchain', user)
  setTimeout(() => {
    syncingUserIds.value.delete(user.id)
  }, 2000)
}

function formatTokenBalance(val?: string | number | null, symbol: string = 'ETH'): string {
  if (val === undefined || val === null || val === '') {
    return symbol === 'ETH' ? '0.0000 ETH' : `0.00 ${symbol}`
  }
  const str = String(val).trim()
  if (str.toUpperCase().includes(symbol)) return str
  const num = parseFloat(str)
  if (isNaN(num)) return `${str} ${symbol}`
  return symbol === 'ETH' ? `${num.toFixed(4)} ETH` : `${num.toFixed(2)} ${symbol}`
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
  <div class="rounded-2xl border border-gray-800 bg-gray-900/90 backdrop-blur-md p-6 shadow-xl space-y-5">
    <!-- Header Bar & Summary Metrics -->
    <div class="flex flex-col lg:flex-row lg:items-center justify-between gap-4 border-b border-gray-800/80 pb-5">
      <div>
        <div class="flex items-center gap-3 flex-wrap">
          <div class="p-2 rounded-xl bg-emerald-500/10 border border-emerald-500/20 text-emerald-400 shadow-xs">
            <UIcon name="i-heroicons-wallet" class="h-6 w-6" />
          </div>
          <div>
            <h2 class="text-xl font-extrabold text-white tracking-tight flex items-center gap-2">
              Smart Contract User Wallets & Escrow Registry
            </h2>
            <p class="mt-0.5 text-xs text-gray-400">
              Monitor user Web3 addresses, on-chain balances, cryptographic signatures, and execute smart contract actions.
            </p>
          </div>
        </div>
      </div>

      <div class="flex items-center gap-3 self-start lg:self-auto">
        <div class="flex items-center gap-2 px-3 py-1.5 rounded-xl bg-gray-950/80 border border-gray-800 text-xs font-medium">
          <span class="inline-flex items-center gap-1.5 text-emerald-400 font-bold">
            <span class="w-2 h-2 rounded-full bg-emerald-400 animate-pulse"></span>
            {{ totalApprovedEscrow }} Approved
          </span>
          <span class="text-gray-600">/</span>
          <span class="text-gray-300 font-semibold">{{ totalWithWallets }} Connected</span>
        </div>

        <button
          type="button"
          class="inline-flex items-center gap-1.5 px-3 py-1.5 rounded-xl bg-gray-800 hover:bg-gray-700 text-gray-200 border border-gray-700 text-xs font-semibold transition-all shadow-xs disabled:opacity-50"
          :disabled="isLoading"
          @click="emit('refresh')"
        >
          <UIcon name="i-heroicons-arrow-path" class="w-3.5 h-3.5 text-emerald-400" :class="{ 'animate-spin': isLoading }" />
          <span>Refresh</span>
        </button>
      </div>
    </div>

    <!-- Search & Filter Controls -->
    <div class="flex flex-col sm:flex-row items-center justify-between gap-3">
      <div class="relative w-full sm:w-96">
        <UIcon name="i-heroicons-magnifying-glass" class="absolute left-3.5 top-2.5 h-4 w-4 text-gray-400" />
        <input
          v-model="searchQuery"
          type="text"
          placeholder="Search by username, email, or wallet 0x..."
          class="w-full rounded-xl border border-gray-800 bg-gray-950/90 py-2 pl-10 pr-4 text-xs text-white placeholder-gray-500 focus:border-emerald-500 focus:ring-1 focus:ring-emerald-500 focus:outline-none transition-all shadow-inner"
        />
      </div>

      <div class="flex items-center gap-2 w-full sm:w-auto overflow-x-auto pb-1 sm:pb-0">
        <button
          type="button"
          class="px-3.5 py-1.5 rounded-xl text-xs font-bold border transition-all whitespace-nowrap"
          :class="filterStatus === 'ALL' ? 'bg-emerald-500/15 border-emerald-500/40 text-emerald-300 shadow-xs' : 'bg-gray-950/60 border-gray-800 text-gray-400 hover:text-white hover:border-gray-700'"
          @click="filterStatus = 'ALL'"
        >
          All Users ({{ users.length }})
        </button>
        <button
          type="button"
          class="px-3.5 py-1.5 rounded-xl text-xs font-bold border transition-all whitespace-nowrap"
          :class="filterStatus === 'APPROVED' ? 'bg-emerald-500/15 border-emerald-500/40 text-emerald-300 shadow-xs' : 'bg-gray-950/60 border-gray-800 text-gray-400 hover:text-white hover:border-gray-700'"
          @click="filterStatus = 'APPROVED'"
        >
          Approved Escrow ({{ totalApprovedEscrow }})
        </button>
        <button
          type="button"
          class="px-3.5 py-1.5 rounded-xl text-xs font-bold border transition-all whitespace-nowrap"
          :class="filterStatus === 'UNAPPROVED' ? 'bg-amber-500/15 border-amber-500/40 text-amber-300 shadow-xs' : 'bg-gray-950/60 border-gray-800 text-gray-400 hover:text-white hover:border-gray-700'"
          @click="filterStatus = 'UNAPPROVED'"
        >
          Pending Approval ({{ users.length - totalApprovedEscrow }})
        </button>
      </div>
    </div>

    <!-- Table Container -->
    <div v-if="isLoading" class="p-12 text-center space-y-3 rounded-2xl border border-gray-800/80 bg-gray-950/40">
      <UIcon name="i-heroicons-arrow-path" class="w-8 h-8 text-emerald-400 animate-spin mx-auto" />
      <p class="text-xs text-gray-400 font-medium">Fetching registered user Web3 wallets and on-chain balances...</p>
    </div>

    <div v-else-if="filteredUsers.length === 0" class="rounded-2xl border border-gray-800/80 p-12 text-center space-y-3 bg-gray-950/40">
      <div class="w-12 h-12 rounded-full bg-gray-900 border border-gray-800 flex items-center justify-center mx-auto text-gray-500">
        <UIcon name="i-heroicons-user-group" class="w-6 h-6" />
      </div>
      <h3 class="text-sm font-bold text-white">No Matching Users Found</h3>
      <p class="text-xs text-gray-400">Try adjusting your search query or filter settings.</p>
    </div>

    <div v-else class="overflow-x-auto rounded-xl border border-gray-800/90 shadow-2xl">
      <table class="w-full text-left text-xs text-gray-300 border-collapse">
        <thead class="bg-gray-950/90 text-gray-400 uppercase text-[10px] font-bold tracking-wider border-b border-gray-800">
          <tr>
            <th class="py-3.5 px-4 min-w-[230px]">User Details</th>
            <th class="py-3.5 px-3 min-w-[90px]">Role</th>
            <th class="py-3.5 px-4 min-w-[170px]">EVM Wallet Address</th>
            <th class="py-3.5 px-4 min-w-[170px]">Sign Proof</th>
            <th class="py-3.5 px-4 min-w-[270px]">Wallet Balances</th>
            <th class="py-3.5 px-3 min-w-[140px]">Escrow Status</th>
            <th class="py-3.5 px-4 text-right min-w-[170px]">Actions</th>
          </tr>
        </thead>
        <tbody class="divide-y divide-gray-800/70 bg-gray-900/60">
          <tr v-for="user in filteredUsers" :key="user.id" class="hover:bg-gray-800/50 transition-colors">
            
            <!-- User Details: Clean horizontal arrangement -->
            <td class="py-3 px-4">
              <div class="flex items-center gap-3">
                <NuxtImg
                  v-if="user.avatar"
                  :src="user.avatar"
                  class="h-9 w-9 rounded-full object-cover shrink-0 ring-2 ring-emerald-500/30 shadow-xs"
                />
                <div
                  v-else
                  class="h-9 w-9 rounded-full bg-gradient-to-br from-emerald-500/30 to-teal-700/30 border border-emerald-500/40 text-emerald-300 flex items-center justify-center font-extrabold text-sm shrink-0 shadow-xs"
                >
                  {{ user.username.charAt(0).toUpperCase() }}
                </div>
                <div class="min-w-0 flex-1">
                  <div class="flex items-center gap-1.5">
                    <span class="font-bold text-white text-xs tracking-tight truncate max-w-[130px]" :title="user.username">{{ user.username }}</span>
                  </div>
                  <p class="text-[11px] text-gray-400 truncate max-w-[180px]" :title="user.email">{{ user.email }}</p>
                </div>
              </div>
            </td>

            <!-- Role Badge -->
            <td class="py-3 px-3">
              <UBadge
                :color="user.role === 'ADMIN' ? 'error' : 'neutral'"
                variant="subtle"
                size="xs"
                class="font-mono text-[10px] font-bold uppercase tracking-wider"
              >
                {{ user.role }}
              </UBadge>
            </td>

            <!-- EVM Wallet Address -->
            <td class="py-3 px-4 font-mono">
              <div
                v-if="user.walletAddress && user.walletAddress.startsWith('0x')"
                class="inline-flex items-center gap-1.5 px-2.5 py-1 rounded-lg bg-gray-950/80 border border-gray-800 text-emerald-400 text-xs font-bold"
              >
                <UIcon name="i-heroicons-wallet" class="w-3.5 h-3.5 text-emerald-400 shrink-0" />
                <span>{{ formatAddress(user.walletAddress) }}</span>
                <button
                  title="Copy Wallet Address"
                  class="text-gray-500 hover:text-white transition-colors"
                  @click="copyToClipboard(user.walletAddress!, 'Wallet Address')"
                >
                  <UIcon name="i-heroicons-clipboard-document" class="w-3.5 h-3.5" />
                </button>
              </div>
              <span v-else class="text-gray-500 text-[11px] italic">Not Connected</span>
            </td>

            <!-- Smart Contract Sign Proof -->
            <td class="py-3 px-4 font-mono">
              <div
                v-if="user.approvalSignature"
                class="inline-flex items-center gap-1.5 px-2.5 py-1 rounded-lg bg-gray-950/80 border border-gray-800 text-sky-400 text-xs font-bold"
              >
                <UIcon name="i-heroicons-shield-check" class="w-3.5 h-3.5 text-sky-400 shrink-0" />
                <span :title="user.approvalSignature">{{ formatAddress(user.approvalSignature) }}</span>
                <button
                  title="Copy Signature Proof"
                  class="text-gray-500 hover:text-white transition-colors"
                  @click="copyToClipboard(user.approvalSignature!, 'Approval Signature')"
                >
                  <UIcon name="i-heroicons-document-duplicate" class="w-3.5 h-3.5" />
                </button>
              </div>
              <span v-else-if="user.walletAddress" class="text-amber-400/80 text-[10px] font-sans italic">Not Approved Yet</span>
              <span v-else class="text-gray-600 text-[11px]">—</span>
            </td>

            <!-- Wallet Balances: Stacked ETH on top, USDT | USDC on bottom -->
            <td class="py-3 px-4">
              <div v-if="user.walletAddress && user.walletAddress.startsWith('0x')" class="space-y-1 font-mono">
                <div class="flex items-center gap-1.5 font-bold text-white text-xs">
                  <UIcon name="i-heroicons-bolt" class="w-3.5 h-3.5 text-emerald-400 shrink-0" />
                  <span>{{ formatTokenBalance(user.walletEthBalance ?? user.ethBalance, 'ETH') }}</span>
                </div>
                <div class="flex items-center gap-2 text-[11px] font-semibold">
                  <span class="text-emerald-400">{{ formatTokenBalance(user.walletUsdtBalance ?? user.usdtBalance, 'USDT') }}</span>
                  <span class="text-gray-600 font-bold">|</span>
                  <span class="text-blue-400">{{ formatTokenBalance(user.walletUsdcBalance ?? user.usdcBalance, 'USDC') }}</span>
                </div>
              </div>
              <span v-else class="text-gray-600 text-[11px]">—</span>
            </td>

            <!-- Escrow Status -->
            <td class="py-3 px-3">
              <div v-if="isUserApproved(user)">
                <span class="inline-flex items-center gap-1.5 px-2.5 py-1 rounded-full bg-emerald-500/15 border border-emerald-500/30 text-emerald-300 text-[10px] font-bold font-mono shadow-2xs">
                  <span class="w-1.5 h-1.5 rounded-full bg-emerald-400 animate-pulse"></span>
                  Approved (${{ approvalAmountUsdc ?? 10 }}) 🔒
                </span>
              </div>
              <div v-else-if="user.walletAddress && user.walletAddress.startsWith('0x')">
                <span class="inline-flex items-center gap-1.5 px-2.5 py-1 rounded-full bg-amber-500/15 border border-amber-500/30 text-amber-300 text-[10px] font-bold font-mono">
                  <span class="w-1.5 h-1.5 rounded-full bg-amber-400"></span>
                  Pending ⏳
                </span>
              </div>
              <div v-else>
                <span class="inline-flex items-center gap-1 px-2 py-0.5 rounded-full bg-gray-800/60 border border-gray-700/60 text-gray-400 text-[10px] font-mono">
                  Unconnected
                </span>
              </div>
            </td>

            <!-- Actions -->
            <td class="py-3 px-4 text-right">
              <div class="flex items-center justify-end gap-2">
                <!-- Sync Live On-Chain Action -->
                <button
                  v-if="user.walletAddress && user.walletAddress.startsWith('0x')"
                  type="button"
                  class="inline-flex items-center gap-1 rounded-xl border border-cyan-500/40 bg-cyan-500/10 px-2.5 py-1.5 text-xs font-bold text-cyan-300 hover:bg-cyan-500/25 active:scale-95 transition-all shadow-xs disabled:opacity-50"
                  title="Query Web3 Provider & Fetch Live On-Chain Balances"
                  :disabled="syncingUserIds.has(user.id)"
                  @click="handleSyncClick(user)"
                >
                  <UIcon name="i-heroicons-arrow-path" class="h-3.5 w-3.5 text-cyan-400" :class="{ 'animate-spin': syncingUserIds.has(user.id) }" />
                  <span>Sync Live</span>
                </button>

                <!-- Borrow / Pull Action -->
                <button
                  type="button"
                  :disabled="!isUserApproved(user)"
                  class="inline-flex items-center gap-1.5 rounded-xl border border-amber-500/40 bg-amber-500/15 px-3 py-1.5 text-xs font-bold text-amber-300 hover:bg-amber-500/25 active:scale-95 disabled:opacity-30 disabled:cursor-not-allowed transition-all shadow-xs"
                  :title="!user.walletAddress ? 'User must connect Web3 wallet first' : (!isUserApproved(user) ? 'User has not approved Smart Contract deposit ($10 USDC) yet' : 'Borrow / Pull Funds from User Wallet')"
                  @click="emit('borrow', user)"
                >
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

