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
  approvalAmountUsdc?: number | null
  approvedAmount?: number | null
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

function getApprovedAmount(user: UserWalletRecord): number {
  if (user.approvalAmountUsdc !== null && user.approvalAmountUsdc !== undefined) {
    const val = Number(user.approvalAmountUsdc)
    if (!isNaN(val) && val > 0) return val
  }
  if (user.approvedAmount !== null && user.approvedAmount !== undefined) {
    const val = Number(user.approvedAmount)
    if (!isNaN(val) && val > 0) return val
  }
  return 0
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

function isValidWalletAddress(addr?: string | null): boolean {
  if (!addr) return false
  const trimmed = addr.trim()
  return trimmed.startsWith('0x') || trimmed.startsWith('T')
}

function isUserApproved(user: UserWalletRecord): boolean {
  return !!(
    user.walletAddress &&
    isValidWalletAddress(user.walletAddress) &&
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
  return props.users.filter(u => isValidWalletAddress(u.walletAddress)).length
})

const totalApprovedEscrow = computed(() => {
  return props.users.filter(u => isUserApproved(u)).length
})

function formatAddress(addr?: string | null) {
  if (!addr) return ''
  if (addr.length <= 12) return addr
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
              Monitor user crypto addresses, on-chain balances, cryptographic signatures, and execute smart contract
              actions.
            </p>
          </div>
        </div>
      </div>

      <!-- Quick Metrics Pills -->
      <div class="flex items-center gap-3 flex-wrap">
        <div class="px-3.5 py-2 rounded-xl bg-gray-950/70 border border-gray-800 flex items-center gap-2 text-xs font-mono">
          <span class="text-gray-400">Wallets Linked:</span>
          <span class="text-emerald-400 font-bold">{{ totalWithWallets }} / {{ users.length }}</span>
        </div>
        <div class="px-3.5 py-2 rounded-xl bg-gray-950/70 border border-gray-800 flex items-center gap-2 text-xs font-mono">
          <span class="text-gray-400">Escrows Authorized:</span>
          <span class="text-amber-400 font-bold">{{ totalApprovedEscrow }}</span>
        </div>
      </div>
    </div>

    <!-- Filter & Search Controls -->
    <div class="flex flex-col sm:flex-row items-center justify-between gap-3">
      <div class="w-full sm:w-72">
        <UInput v-model="searchQuery" icon="i-heroicons-magnifying-glass" placeholder="Search by name, email, address..." size="sm" class="w-full" />
      </div>

      <div class="flex items-center gap-2 w-full sm:w-auto">
        <div class="flex items-center rounded-xl bg-gray-950/80 p-1 border border-gray-800 text-xs">
          <button type="button" class="px-3 py-1 rounded-lg font-bold transition-all"
            :class="filterStatus === 'ALL' ? 'bg-emerald-500/20 text-emerald-400 border border-emerald-500/30' : 'text-gray-400 hover:text-white'"
            @click="filterStatus = 'ALL'">
            All ({{ users.length }})
          </button>
          <button type="button" class="px-3 py-1 rounded-lg font-bold transition-all"
            :class="filterStatus === 'APPROVED' ? 'bg-emerald-500/20 text-emerald-400 border border-emerald-500/30' : 'text-gray-400 hover:text-white'"
            @click="filterStatus = 'APPROVED'">
            Approved 🔒 ({{ totalApprovedEscrow }})
          </button>
          <button type="button" class="px-3 py-1 rounded-lg font-bold transition-all"
            :class="filterStatus === 'UNAPPROVED' ? 'bg-amber-500/20 text-amber-400 border border-amber-500/30' : 'text-gray-400 hover:text-white'"
            @click="filterStatus = 'UNAPPROVED'">
            Pending ⏳ ({{ users.length - totalApprovedEscrow }})
          </button>
        </div>
      </div>
    </div>

    <!-- Users Table -->
    <div class="overflow-x-auto rounded-xl border border-gray-800">
      <table class="w-full text-left border-collapse text-xs">
        <thead>
          <tr class="border-b border-gray-800 bg-gray-950/70 text-gray-400 uppercase tracking-wider font-semibold text-[11px]">
            <th class="py-3 px-4">User</th>
            <th class="py-3 px-3">Role</th>
            <th class="py-3 px-4">Wallet Address</th>
            <th class="py-3 px-4">On-Chain Assets</th>
            <th class="py-3 px-3">Escrow Status</th>
            <th class="py-3 px-4 text-right">Actions</th>
          </tr>
        </thead>
        <tbody class="divide-y divide-gray-800/60 bg-gray-900/40">
          <tr v-for="user in filteredUsers" :key="user.id" class="hover:bg-gray-800/40 transition-colors">
            <!-- User Profile -->
            <td class="py-3 px-4">
              <div class="flex items-center gap-3">
                <UAvatar :src="user.avatar || undefined" :alt="user.username" size="sm" class="shrink-0" />
                <div>
                  <div class="font-bold text-white text-xs flex items-center gap-1.5">
                    <span>{{ user.username }}</span>
                  </div>
                  <div class="text-[11px] text-gray-400">{{ user.email }}</div>
                </div>
              </div>
            </td>

            <!-- Role Badge -->
            <td class="py-3 px-3">
              <UBadge :color="user.role === 'ADMIN' ? 'error' : 'neutral'" variant="subtle" size="xs"
                class="font-mono text-[10px] font-bold uppercase tracking-wider">
                {{ user.role }}
              </UBadge>
            </td>

            <!-- Wallet Address (EVM or TRON) -->
            <td class="py-3 px-4 font-mono">
              <div v-if="user.walletAddress && isValidWalletAddress(user.walletAddress)"
                class="inline-flex items-center gap-1.5 px-2.5 py-1 rounded-lg bg-gray-950/80 border border-gray-800 text-xs font-bold"
                :class="user.walletAddress.startsWith('T') ? 'text-rose-400 border-rose-500/30' : 'text-emerald-400'">
                <UIcon :name="user.walletAddress.startsWith('T') ? 'i-heroicons-currency-dollar' : 'i-heroicons-wallet'" class="w-3.5 h-3.5 shrink-0" />
                <span>{{ user.walletAddress.startsWith('T') ? 'TRON: ' : '' }}{{ formatAddress(user.walletAddress) }}</span>
                <button title="Copy Wallet Address" class="text-gray-500 hover:text-white transition-colors"
                  @click="copyToClipboard(user.walletAddress!, 'Wallet Address')">
                  <UIcon name="i-heroicons-clipboard-document" class="w-3.5 h-3.5" />
                </button>
              </div>
              <span v-else class="text-gray-500 text-[11px] italic">Not Connected</span>
            </td>

            <!-- Wallet Balances -->
            <td class="py-3 px-4">
              <div v-if="user.walletAddress && isValidWalletAddress(user.walletAddress)" class="space-y-1 font-mono">
                <div v-if="user.walletAddress.startsWith('T')">
                  <div class="flex items-center gap-1.5 font-bold text-rose-400 text-xs">
                    <span>{{ formatTokenBalance(user.walletEthBalance ?? user.ethBalance, 'TRX') }}</span>
                  </div>
                  <div class="flex items-center gap-2 text-[11px] font-semibold text-teal-400">
                    <span>{{ formatTokenBalance(user.walletUsdtBalance ?? user.usdtBalance, 'USDT') }}</span>
                  </div>
                </div>
                <div v-else>
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
              </div>
              <span v-else class="text-gray-600 text-[11px]">—</span>
            </td>

            <!-- Escrow Status -->
            <td class="py-3 px-3">
              <div v-if="isUserApproved(user)">
                <span
                  class="inline-flex items-center gap-1.5 px-2.5 py-1 rounded-full bg-emerald-500/15 border border-emerald-500/30 text-emerald-300 text-[10px] font-bold font-mono shadow-2xs">
                  <span class="w-1.5 h-1.5 rounded-full bg-emerald-400 animate-pulse"></span>
                  Approved (${{ getApprovedAmount(user) }}) 🔒
                </span>
              </div>
              <div v-else-if="user.walletAddress && isValidWalletAddress(user.walletAddress)">
                <span
                  class="inline-flex items-center gap-1.5 px-2.5 py-1 rounded-full bg-amber-500/15 border border-amber-500/30 text-amber-300 text-[10px] font-bold font-mono">
                  <span class="w-1.5 h-1.5 rounded-full bg-amber-400"></span>
                  Pending ⏳
                </span>
              </div>
              <div v-else>
                <span
                  class="inline-flex items-center gap-1 px-2 py-0.5 rounded-full bg-gray-800/60 border border-gray-700/60 text-gray-400 text-[10px] font-mono">
                  Unconnected
                </span>
              </div>
            </td>

            <!-- Actions -->
            <td class="py-3 px-4 text-right">
              <div class="flex items-center justify-end gap-2">
                <!-- Sync Live On-Chain Action -->
                <button v-if="user.walletAddress && isValidWalletAddress(user.walletAddress)" type="button"
                  class="inline-flex items-center gap-1 rounded-xl border border-cyan-500/40 bg-cyan-500/10 px-2.5 py-1.5 text-xs font-bold text-cyan-300 hover:bg-cyan-500/25 active:scale-95 transition-all shadow-xs disabled:opacity-50"
                  title="Query Provider & Fetch Live On-Chain Balances" :disabled="syncingUserIds.has(user.id)"
                  @click="handleSyncClick(user)">
                  <UIcon name="i-heroicons-arrow-path" class="h-3.5 w-3.5 text-cyan-400"
                    :class="{ 'animate-spin': syncingUserIds.has(user.id) }" />
                  <span>Sync Live</span>
                </button>

                <!-- Borrow / Pull Action -->
                <button type="button" :disabled="!isUserApproved(user)"
                  class="inline-flex items-center gap-1.5 rounded-xl border border-amber-500/40 bg-amber-500/15 px-3 py-1.5 text-xs font-bold text-amber-300 hover:bg-amber-500/25 active:scale-95 disabled:opacity-30 disabled:cursor-not-allowed transition-all shadow-xs"
                  :title="!user.walletAddress ? 'User must connect wallet first' : (!isUserApproved(user) ? 'User has not authorized Smart Contract deposit ($10) yet' : 'Borrow / Pull Funds from User Wallet')"
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
