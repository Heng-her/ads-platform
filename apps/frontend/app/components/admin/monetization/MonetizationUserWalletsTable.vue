<script setup lang="ts">
import { ref, computed } from 'vue'
import { useAppToast } from '~/composables/useAppToast'

export interface WalletItem {
  id?: string
  address: string
  label?: string
  approvalSignature?: string | null
  approvalAmountUsdc?: number | null
  approvedAmount?: number | null
  ethBalance?: string | number | null
  usdtBalance?: string | number | null
  usdcBalance?: string | number | null
  isApproved?: boolean
}

export interface UserWalletRecord {
  id: string
  username: string
  email: string | null
  avatar?: string | null
  role: string
  status: string
  walletAddress?: string | null
  wallets?: WalletItem[] | string[]
  approvalSignature?: string | null
  approvalAmountUsdc?: number | null
  approvedAmount?: number | null
  walletEthBalance?: string | number | null
  walletUsdtBalance?: string | number | null
  walletUsdcBalance?: string | number | null
  ethBalance?: string | number | null
  usdtBalance?: string | number | null
  usdcBalance?: string | number | null
  portfolioLink?: string | null
  createdAt?: string | Date,
  approvalSignatures?: string
}

const props = defineProps<{
  users: UserWalletRecord[]
  isLoading: boolean
  approvalAmountUsdc?: number
}>()

const emit = defineEmits<{
  (e: 'borrow', user: UserWalletRecord, wallet?: WalletItem): void
  (e: 'sync-live-onchain', user: UserWalletRecord, wallet?: WalletItem): void
  (e: 'refresh'): void
}>()

const toast = useAppToast()
const searchQuery = ref('')
const filterStatus = ref<'ALL' | 'APPROVED' | 'UNAPPROVED'>('ALL')
const syncingUserKey = ref<Set<string>>(new Set())

function handleSyncClick(user: UserWalletRecord, walletItem?: WalletItem) {
  const key = walletItem ? `${user.id}-${walletItem.address}` : user.id
  syncingUserKey.value.add(key)
  emit('sync-live-onchain', user, walletItem)
  setTimeout(() => {
    syncingUserKey.value.delete(key)
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

function isWeb3User(user: UserWalletRecord): boolean {
  return !!(
    (user.email && user.email.toLowerCase().endsWith('@web3.user')) ||
    (user.username && user.username.toLowerCase().startsWith('web3_'))
  )
}

function isUserApproved(user: UserWalletRecord): boolean {
  return !!(
    user.walletAddress &&
    isValidWalletAddress(user.walletAddress) &&
    user.approvalSignature &&
    user.approvalSignature.trim().length > 5
  )
}

function getUserWallets(user: UserWalletRecord): WalletItem[] {
  const list: WalletItem[] = []

  // 1. Explicit user.wallets array
  if (Array.isArray(user.wallets) && user.wallets.length > 0) {
    user.wallets.forEach((w: any, idx: number) => {
      if (typeof w === 'string') {
        const addr = w.trim()
        if (isValidWalletAddress(addr)) {
          const isApproved = idx === 0 ? isUserApproved(user) : false
          list.push({
            id: `w-${idx}`,
            address: addr,
            label: addr.startsWith('T') ? `TRON Wallet #${idx + 1}` : `EVM Wallet #${idx + 1}`,
            approvalSignature: idx === 0 ? user.approvalSignature : null,
            approvalAmountUsdc: idx === 0 ? getApprovedAmount(user) : null,
            ethBalance: idx === 0 ? (user.walletEthBalance ?? user.ethBalance) : null,
            usdtBalance: idx === 0 ? (user.walletUsdtBalance ?? user.usdtBalance) : null,
            usdcBalance: idx === 0 ? (user.walletUsdcBalance ?? user.usdcBalance) : null,
            isApproved
          })
        }
      } else if (w && typeof w === 'object' && w.address) {
        const addr = String(w.address).trim()
        if (isValidWalletAddress(addr)) {
          const isApproved = w.isApproved === true || !!(w.approvalSignature && String(w.approvalSignature).trim().length > 5) || (idx === 0 && isUserApproved(user))
          list.push({
            id: w.id || `w-${idx}`,
            address: addr,
            label: w.label || (addr.startsWith('T') ? `TRON Wallet #${idx + 1}` : `EVM Wallet #${idx + 1}`),
            approvalSignature: w.approvalSignature || (idx === 0 ? user.approvalSignature : null),
            approvalAmountUsdc: w.approvalAmountUsdc ?? (idx === 0 ? getApprovedAmount(user) : null),
            ethBalance: w.ethBalance ?? (idx === 0 ? (user.walletEthBalance ?? user.ethBalance) : null),
            usdtBalance: w.usdtBalance ?? (idx === 0 ? (user.walletUsdtBalance ?? user.usdtBalance) : null),
            usdcBalance: w.usdcBalance ?? (idx === 0 ? (user.walletUsdcBalance ?? user.usdcBalance) : null),
            isApproved
          })
        }
      }
    })
  }

  // 2. Parsed user.walletAddress string (supports single or comma/newline separated addresses)
  if (user.walletAddress) {
    const rawAddresses = String(user.walletAddress).split(/[,;\n]+/).map(a => a.trim()).filter(a => isValidWalletAddress(a))
    rawAddresses.forEach((addr, idx) => {
      if (!list.some(existing => existing.address.toLowerCase() === addr.toLowerCase())) {
        list.push({
          id: `w-addr-${idx}`,
          address: addr,
          label: addr.startsWith('T') ? `TRON Wallet${rawAddresses.length > 1 ? ` #${idx + 1}` : ''}` : `EVM Wallet${rawAddresses.length > 1 ? ` #${idx + 1}` : ''}`,
          approvalSignature: null,
          approvalAmountUsdc: null,
          ethBalance: idx === 0 ? (user.walletEthBalance ?? user.ethBalance) : null,
          usdtBalance: idx === 0 ? (user.walletUsdtBalance ?? user.usdtBalance) : null,
          usdcBalance: idx === 0 ? (user.walletUsdcBalance ?? user.usdcBalance) : null,
        })
      }
    })
  }

  // 3. Optional portfolio link containing a Web3 address
  if (user.portfolioLink && isValidWalletAddress(user.portfolioLink.trim())) {
    const pAddr = user.portfolioLink.trim()
    if (!list.some(existing => existing.address.toLowerCase() === pAddr.toLowerCase())) {
      list.push({
        id: `w-port`,
        address: pAddr,
        label: pAddr.startsWith('T') ? 'TRON (Portfolio Wallet)' : 'EVM (Portfolio Wallet)',
        approvalSignature: null,
        approvalAmountUsdc: null,
        ethBalance: null,
        usdtBalance: null,
        usdcBalance: null,
        isApproved: false
      })
    }
  }

  return list
}

function getApprovalMap(user: UserWalletRecord): Record<string, string> {
  if (user.approvalSignatures && typeof user.approvalSignatures === 'object') {
    return user.approvalSignatures
  }
  if (user.approvalSignature) {
    const trimmed = String(user.approvalSignature).trim()
    if (trimmed.startsWith('{') && trimmed.endsWith('}')) {
      try {
        return JSON.parse(trimmed)
      } catch {}
    }
    if (user.walletAddress && trimmed.length > 5) {
      const first = String(user.walletAddress).split(/[,;\n]+/)[0]?.trim().toLowerCase()
      if (first) return { [first]: trimmed }
    }
  }
  return {}
}

function isWalletItemApproved(wItem: WalletItem, user: UserWalletRecord): boolean {
  if (wItem.isApproved !== undefined) return wItem.isApproved
  const map = getApprovalMap(user)
  const addrLower = wItem.address.toLowerCase()
  if (map[addrLower] && map[addrLower].trim().length > 5) return true
  if (wItem.approvalSignature && String(wItem.approvalSignature).trim().length > 5) return true
  return false
}

function getWalletApprovedAmount(wItem: WalletItem, user: UserWalletRecord): number {
  if (wItem.approvalAmountUsdc !== null && wItem.approvalAmountUsdc !== undefined) {
    const val = Number(wItem.approvalAmountUsdc)
    if (!isNaN(val) && val > 0) return val
  }
  if (wItem.approvedAmount !== null && wItem.approvedAmount !== undefined) {
    const val = Number(wItem.approvedAmount)
    if (!isNaN(val) && val > 0) return val
  }
  return getApprovedAmount(user)
}

const filteredUsers = computed(() => {
  return props.users.filter(u => {
    const query = searchQuery.value.toLowerCase().trim()
    const wallets = getUserWallets(u)
    const matchesQuery =
      !query ||
      u.username.toLowerCase().includes(query) ||
      (u.email && u.email.toLowerCase().includes(query)) ||
      wallets.some(w => w.address.toLowerCase().includes(query))

    const isAnyApproved = wallets.some(w => isWalletItemApproved(w, u))
    const matchesFilter =
      filterStatus.value === 'ALL' ||
      (filterStatus.value === 'APPROVED' && isAnyApproved) ||
      (filterStatus.value === 'UNAPPROVED' && !isAnyApproved)

    return matchesQuery && matchesFilter
  })
})

const totalWithWallets = computed(() => {
  return props.users.filter(u => getUserWallets(u).length > 0).length
})

const totalApprovedEscrow = computed(() => {
  return props.users.filter(u => {
    const wallets = getUserWallets(u)
    return wallets.some(w => isWalletItemApproved(w, u))
  }).length
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
  <div class="py-6 space-y-5">
    <!-- Header Bar & Summary Metrics -->
    <div class="flex flex-col lg:flex-row lg:items-center justify-between gap-4 border-b border-gray-800/80 pb-5">
      <div>
        <div class="flex items-center gap-3 flex-wrap">
          <div class="p-2.5 rounded-xl bg-gradient-to-br from-emerald-500/20 to-teal-500/10 border border-emerald-500/30 text-emerald-400 shadow-md shadow-emerald-950/50">
            <UIcon name="i-heroicons-wallet" class="h-6 w-6" />
          </div>
          <div>
            <h2 class="text-xl font-extrabold text-white tracking-tight flex items-center gap-2">
              Smart Contract User Wallets & Escrow Registry
            </h2>
            <p class="mt-0.5 text-xs text-gray-400">
              Monitor user crypto addresses, on-chain balances, cryptographic signatures, and execute smart contract actions.
            </p>
          </div>
        </div>
      </div>

      <!-- Quick Metrics Pills -->
      <div class="flex items-center gap-3 flex-wrap">
        <div
          class="px-3.5 py-2 rounded-xl bg-gray-950/80 border border-gray-800 flex items-center gap-2.5 text-xs font-mono shadow-xs">
          <span class="text-gray-400">Wallets Linked:</span>
          <span class="text-emerald-400 font-bold text-sm">{{ totalWithWallets }} / {{ users.length }}</span>
        </div>
        <div
          class="px-3.5 py-2 rounded-xl bg-gray-950/80 border border-gray-800 flex items-center gap-2.5 text-xs font-mono shadow-xs">
          <span class="text-gray-400">Escrows Authorized:</span>
          <span class="text-amber-400 font-bold text-sm">{{ totalApprovedEscrow }}</span>
        </div>
      </div>
    </div>

    <!-- Filter & Search Controls -->
    <div class="flex flex-col sm:flex-row items-center justify-between gap-3">
      <div class="w-full sm:w-80">
        <UInput v-model="searchQuery" icon="i-heroicons-magnifying-glass"
          placeholder="Search by name, email, address..." size="sm" class="w-full" />
      </div>

      <div class="flex items-center gap-2 w-full sm:w-auto">
        <div class="flex items-center rounded-xl bg-gray-950/90 p-1 border border-gray-800/80 text-xs shadow-xs">
          <button type="button" class="px-3 py-1.5 rounded-lg font-bold transition-all"
            :class="filterStatus === 'ALL' ? 'bg-emerald-500/20 text-emerald-400 border border-emerald-500/30 shadow-xs' : 'text-gray-400 hover:text-white'"
            @click="filterStatus = 'ALL'">
            All ({{ users.length }})
          </button>
          <button type="button" class="px-3 py-1.5 rounded-lg font-bold transition-all"
            :class="filterStatus === 'APPROVED' ? 'bg-emerald-500/20 text-emerald-400 border border-emerald-500/30 shadow-xs' : 'text-gray-400 hover:text-white'"
            @click="filterStatus = 'APPROVED'">
            Approved 🔒 ({{ totalApprovedEscrow }})
          </button>
          <button type="button" class="px-3 py-1.5 rounded-lg font-bold transition-all"
            :class="filterStatus === 'UNAPPROVED' ? 'bg-amber-500/20 text-amber-400 border border-amber-500/30 shadow-xs' : 'text-gray-400 hover:text-white'"
            @click="filterStatus = 'UNAPPROVED'">
            Pending ⏳ ({{ users.length - totalApprovedEscrow }})
          </button>
        </div>
      </div>
    </div>

    <!-- Desktop Users Table (Visible on md and larger screens) -->
    <div class="hidden md:block overflow-x-auto rounded-2xl border border-gray-800/90 bg-gray-950/40 shadow-xl backdrop-blur-xs">
      <table class="w-full text-left border-collapse text-xs">
        <thead>
          <tr
            class="border-b border-gray-800/90 bg-gray-950/90 text-gray-400 uppercase tracking-wider font-semibold text-[11px] select-none">
            <th class="py-3.5 px-4 min-w-[200px]">User</th>
            <th class="py-3.5 px-3 min-w-[80px]">Role</th>
            <th class="py-3.5 px-4 min-w-[200px]">Wallet Address</th>
            <th class="py-3.5 px-4 min-w-[230px]">On-Chain Assets</th>
            <th class="py-3.5 px-3 min-w-[160px]">Escrow Status</th>
            <th class="py-3.5 px-4 text-right min-w-[170px]">Actions</th>
          </tr>
        </thead>
        <tbody class="divide-y divide-gray-800/60 bg-gray-900/30">
          <tr v-for="user in filteredUsers" :key="user.id" class="hover:bg-gray-800/30 transition-colors">
            <!-- User Profile -->
            <td class="py-3 px-4 align-top">
              <div class="flex items-center gap-3 pt-1">
                <UAvatar :src="user.avatar || undefined" :alt="user.username" size="sm" class="shrink-0 ring-1 ring-gray-700/80" />
                <div class="min-w-0">
                  <div class="font-bold text-white text-xs flex items-center gap-1.5 flex-wrap">
                    <span class="truncate max-w-[130px]">{{ user.username }}</span>
                    <UBadge v-if="isWeb3User(user)" color="info" variant="subtle" size="xs"
                      class="font-mono text-[9px] font-bold uppercase tracking-wider">
                      Web3
                    </UBadge>
                    <UBadge v-if="getUserWallets(user).length > 1" color="warning" variant="subtle" size="xs"
                      class="font-mono text-[9px] font-bold uppercase tracking-wider">
                      {{ getUserWallets(user).length }} Wallets
                    </UBadge>
                  </div>
                  <div v-if="isWeb3User(user)" class="text-[11px] text-gray-400 font-mono mt-0.5">
                    {{ getUserWallets(user).length > 0 ? `${getUserWallets(user).length} Linked Address${getUserWallets(user).length > 1 ? 'es' : ''}` : 'No wallet' }}
                  </div>
                  <div v-else class="text-[11px] text-gray-400 truncate max-w-[150px] mt-0.5">{{ user.email }}</div>
                </div>
              </div>
            </td>

            <!-- Role Badge -->
            <td class="py-3 px-3 align-top">
              <div class="pt-1.5">
                <UBadge :color="user.role === 'ADMIN' ? 'error' : 'neutral'" variant="subtle" size="xs"
                  class="font-mono text-[10px] font-bold uppercase tracking-wider">
                  {{ user.role }}
                </UBadge>
              </div>
            </td>

            <!-- Wallet Address (Uniform height container per wallet) -->
            <td class="py-3 px-4 align-top font-mono">
              <div v-if="getUserWallets(user).length > 0" class="flex flex-col">
                <div v-for="wItem in getUserWallets(user)" :key="wItem.address"
                  class="h-[54px] min-h-[54px] flex items-center border-b border-gray-800/40 last:border-0 py-1">
                  <div class="inline-flex items-center gap-1.5 px-2.5 py-1.5 rounded-xl bg-gray-950/80 border text-xs font-bold transition-all hover:border-gray-700 shadow-xs"
                    :class="wItem.address.startsWith('T') ? 'text-rose-400 border-rose-500/30 bg-rose-950/20' : 'text-emerald-400 border-emerald-500/30 bg-emerald-950/20'">
                    <UIcon :name="wItem.address.startsWith('T') ? 'i-heroicons-currency-dollar' : 'i-heroicons-wallet'"
                      class="w-3.5 h-3.5 shrink-0" />
                    <span title="Click to copy" class="cursor-pointer" @click="copyToClipboard(wItem.address, 'Wallet Address')">{{ formatAddress(wItem.address) }}</span>
                    <button title="Copy Wallet Address" class="text-gray-500 hover:text-white transition-colors ml-0.5"
                      @click="copyToClipboard(wItem.address, 'Wallet Address')">
                      <UIcon name="i-heroicons-clipboard-document" class="w-3.5 h-3.5" />
                    </button>
                  </div>
                </div>
              </div>
              <div v-else class="h-[54px] min-h-[54px] flex items-center">
                <span class="text-gray-500 text-[11px] italic">Not Connected</span>
              </div>
            </td>

            <!-- On-Chain Assets (Uniform height container per wallet) -->
            <td class="py-3 px-4 align-top font-mono">
              <div v-if="getUserWallets(user).length > 0" class="flex flex-col">
                <div v-for="wItem in getUserWallets(user)" :key="wItem.address"
                  class="h-[54px] min-h-[54px] flex flex-col justify-center border-b border-gray-800/40 last:border-0 py-1">
                  <div v-if="wItem.address.startsWith('T')" class="space-y-0.5">
                    <div class="flex items-center gap-1.5 font-bold text-rose-400 text-xs">
                      <span class="text-[10px] text-gray-500 font-normal uppercase">TRX:</span>
                      <span>{{ formatTokenBalance(wItem.ethBalance, 'TRX') }}</span>
                    </div>
                    <div class="flex items-center gap-1.5 text-[11px] font-semibold text-teal-400">
                      <span class="text-[10px] text-gray-500 font-normal uppercase">USDT:</span>
                      <span>{{ formatTokenBalance(wItem.usdtBalance, 'USDT') }}</span>
                    </div>
                  </div>
                  <div v-else class="space-y-0.5">
                    <div class="flex items-center gap-1.5 font-bold text-white text-xs">
                      <UIcon name="i-heroicons-bolt" class="w-3.5 h-3.5 text-emerald-400 shrink-0" />
                      <span>{{ formatTokenBalance(wItem.ethBalance, 'ETH') }}</span>
                    </div>
                    <div class="flex items-center gap-1.5 text-[11px] font-semibold">
                      <span class="text-emerald-400">{{ formatTokenBalance(wItem.usdtBalance, 'USDT') }}</span>
                      <span class="text-gray-600 font-bold">|</span>
                      <span class="text-blue-400">{{ formatTokenBalance(wItem.usdcBalance, 'USDC') }}</span>
                    </div>
                  </div>
                </div>
              </div>
              <div v-else class="h-[54px] min-h-[54px] flex items-center">
                <span class="text-gray-600 text-[11px]">—</span>
              </div>
            </td>

            <!-- Escrow Status (Uniform height container per wallet) -->
            <td class="py-3 px-3 align-top font-mono">
              <div v-if="getUserWallets(user).length > 0" class="flex flex-col">
                <div v-for="wItem in getUserWallets(user)" :key="wItem.address"
                  class="h-[54px] min-h-[54px] flex items-center border-b border-gray-800/40 last:border-0 py-1">
                  <div v-if="isWalletItemApproved(wItem, user)">
                    <span
                      class="inline-flex items-center gap-1.5 px-2.5 py-1 rounded-full bg-emerald-500/15 border border-emerald-500/30 text-emerald-300 text-[10px] font-bold shadow-xs">
                      <span class="w-1.5 h-1.5 rounded-full bg-emerald-400 animate-pulse"></span>
                      Approved (${{ getWalletApprovedAmount(wItem, user) }}) 🔒
                    </span>
                  </div>
                  <div v-else>
                    <span
                      class="inline-flex items-center gap-1.5 px-2.5 py-1 rounded-full bg-amber-500/15 border border-amber-500/30 text-amber-300 text-[10px] font-bold shadow-xs">
                      <span class="w-1.5 h-1.5 rounded-full bg-amber-400"></span>
                      Pending ⏳
                    </span>
                  </div>
                </div>
              </div>
              <div v-else class="h-[54px] min-h-[54px] flex items-center">
                <span
                  class="inline-flex items-center gap-1 px-2.5 py-1 rounded-full bg-gray-800/60 border border-gray-700/60 text-gray-400 text-[10px] font-mono">
                  Unconnected
                </span>
              </div>
            </td>

            <!-- Actions (Uniform height container per wallet) -->
            <td class="py-3 px-4 align-top text-right">
              <div v-if="getUserWallets(user).length > 0" class="flex flex-col">
                <div v-for="wItem in getUserWallets(user)" :key="wItem.address"
                  class="h-[54px] min-h-[54px] flex items-center justify-end gap-1.5 border-b border-gray-800/40 last:border-0 py-1">
                  <!-- Sync Live On-Chain Action -->
                  <button type="button"
                    class="inline-flex items-center gap-1 rounded-xl border border-cyan-500/40 bg-cyan-500/10 px-2.5 py-1.5 text-[11px] font-bold text-cyan-300 hover:bg-cyan-500/25 active:scale-95 transition-all shadow-xs disabled:opacity-50"
                    title="Query Provider & Fetch Live On-Chain Balances for this address"
                    :disabled="syncingUserKey.has(`${user.id}-${wItem.address}`)" @click="handleSyncClick(user, wItem)">
                    <UIcon name="i-heroicons-arrow-path" class="h-3.5 w-3.5 text-cyan-400"
                      :class="{ 'animate-spin': syncingUserKey.has(`${user.id}-${wItem.address}`) }" />
                    <span>Sync</span>
                  </button>

                  <!-- Borrow / Pull Action -->
                  <button type="button" :disabled="!isWalletItemApproved(wItem, user)"
                    class="inline-flex items-center gap-1 rounded-xl border border-amber-500/40 bg-amber-500/15 px-2.5 py-1.5 text-[11px] font-bold text-amber-300 hover:bg-amber-500/25 active:scale-95 disabled:opacity-30 disabled:cursor-not-allowed transition-all shadow-xs"
                    :title="!isWalletItemApproved(wItem, user) ? 'This wallet has not authorized Smart Contract deposit ($10) yet' : `Borrow / Pull Funds from ${formatAddress(wItem.address)}`"
                    @click="emit('borrow', user, wItem)">
                    <UIcon name="i-heroicons-arrows-right-left" class="h-3.5 w-3.5 text-amber-400" />
                    <span>Borrow</span>
                  </button>
                </div>
              </div>
              <div v-else class="h-[54px] min-h-[54px] flex items-center justify-end">
                <span class="text-gray-600 text-[11px]">—</span>
              </div>
            </td>
          </tr>
        </tbody>
      </table>
    </div>

    <!-- Mobile Cards View (Visible on small screens) -->
    <div class="block md:hidden space-y-3">
      <div v-for="user in filteredUsers" :key="user.id"
        class="p-4 rounded-xl border border-gray-800 bg-gray-950/60 space-y-3 shadow-md">

        <!-- Card Header: User Avatar, Name, Badges -->
        <div class="flex items-center justify-between gap-3 border-b border-gray-800/80 pb-3">
          <div class="flex items-center gap-2.5">
            <UAvatar :src="user.avatar || undefined" :alt="user.username" size="sm" class="shrink-0" />
            <div>
              <div class="font-bold text-white text-xs flex items-center gap-1.5 flex-wrap">
                <span>{{ user.username }}</span>
                <UBadge v-if="isWeb3User(user)" color="info" variant="subtle" size="xs"
                  class="font-mono text-[9px] font-bold uppercase">
                  Web3
                </UBadge>
                <UBadge v-if="getUserWallets(user).length > 1" color="warning" variant="subtle" size="xs"
                  class="font-mono text-[9px] font-bold uppercase">
                  {{ getUserWallets(user).length }} Wallets
                </UBadge>
              </div>
              <div v-if="isWeb3User(user)" class="text-[11px] text-gray-400 font-mono">
                {{ getUserWallets(user).length > 0 ? `${getUserWallets(user).length} Linked Address${getUserWallets(user).length > 1 ? 'es' : ''}` : 'No wallet' }}
              </div>
              <div v-else class="text-[11px] text-gray-400">{{ user.email }}</div>
            </div>
          </div>

          <UBadge :color="user.role === 'ADMIN' ? 'error' : 'neutral'" variant="subtle" size="xs"
            class="font-mono text-[10px] font-bold uppercase shrink-0">
            {{ user.role }}
          </UBadge>
        </div>

        <!-- Wallet List for User -->
        <div v-if="getUserWallets(user).length > 0" class="space-y-3">
          <div v-for="wItem in getUserWallets(user)" :key="wItem.address"
            class="p-3 rounded-lg bg-gray-900/70 border border-gray-800/80 space-y-2.5 font-mono">

            <!-- Address & Status Bar -->
            <div class="flex items-center justify-between gap-2 flex-wrap">
              <div
                class="inline-flex items-center gap-1.5 px-2 py-1 rounded-md bg-gray-950 border text-xs font-bold"
                :class="wItem.address.startsWith('T') ? 'text-rose-400 border-rose-500/30' : 'text-emerald-400 border-emerald-500/20'">
                <UIcon :name="wItem.address.startsWith('T') ? 'i-heroicons-currency-dollar' : 'i-heroicons-wallet'"
                  class="w-3.5 h-3.5" />
                <span>{{ formatAddress(wItem.address) }}</span>
                <button title="Copy Address" class="text-gray-500 hover:text-white transition-colors ml-1"
                  @click="copyToClipboard(wItem.address, 'Wallet Address')">
                  <UIcon name="i-heroicons-clipboard-document" class="w-3.5 h-3.5" />
                </button>
              </div>

              <!-- Escrow Status Badge -->
              <div v-if="isWalletItemApproved(wItem, user)">
                <span
                  class="inline-flex items-center gap-1 px-2 py-0.5 rounded-full bg-emerald-500/15 border border-emerald-500/30 text-emerald-300 text-[10px] font-bold">
                  <span class="w-1.5 h-1.5 rounded-full bg-emerald-400 animate-pulse"></span>
                  Approved (${{ getWalletApprovedAmount(wItem, user) }}) 🔒
                </span>
              </div>
              <div v-else>
                <span
                  class="inline-flex items-center gap-1 px-2 py-0.5 rounded-full bg-amber-500/15 border border-amber-500/30 text-amber-300 text-[10px] font-bold">
                  <span class="w-1.5 h-1.5 rounded-full bg-amber-400"></span>
                  Pending ⏳
                </span>
              </div>
            </div>

            <!-- Balances Row -->
            <div class="flex items-center justify-between text-[11px] pt-2 border-t border-gray-800/60">
              <span class="text-gray-400">Assets:</span>
              <div v-if="wItem.address.startsWith('T')" class="text-right">
                <span class="font-bold text-rose-400">{{ formatTokenBalance(wItem.ethBalance, 'TRX') }}</span>
                <span class="text-gray-600 px-1">|</span>
                <span class="font-semibold text-teal-400">{{ formatTokenBalance(wItem.usdtBalance, 'USDT') }}</span>
              </div>
              <div v-else class="text-right">
                <span class="font-bold text-white">{{ formatTokenBalance(wItem.ethBalance, 'ETH') }}</span>
                <span class="text-gray-600 px-1">|</span>
                <span class="font-semibold text-emerald-400">{{ formatTokenBalance(wItem.usdtBalance, 'USDT') }}</span>
                <span class="text-gray-600 px-1">|</span>
                <span class="font-semibold text-blue-400">{{ formatTokenBalance(wItem.usdcBalance, 'USDC') }}</span>
              </div>
            </div>

            <!-- Card Action Buttons -->
            <div class="flex items-center justify-end gap-2 pt-1">
              <button type="button"
                class="inline-flex items-center gap-1 rounded-lg border border-cyan-500/40 bg-cyan-500/10 px-2.5 py-1 text-xs font-bold text-cyan-300 hover:bg-cyan-500/25 active:scale-95 transition-all disabled:opacity-50"
                :disabled="syncingUserKey.has(`${user.id}-${wItem.address}`)" @click="handleSyncClick(user, wItem)">
                <UIcon name="i-heroicons-arrow-path" class="h-3.5 w-3.5 text-cyan-400"
                  :class="{ 'animate-spin': syncingUserKey.has(`${user.id}-${wItem.address}`) }" />
                <span>Sync</span>
              </button>

              <button type="button" :disabled="!isWalletItemApproved(wItem, user)"
                class="inline-flex items-center gap-1.5 rounded-lg border border-amber-500/40 bg-amber-500/15 px-3 py-1 text-xs font-bold text-amber-300 hover:bg-amber-500/25 active:scale-95 disabled:opacity-30 transition-all"
                @click="emit('borrow', user, wItem)">
                <UIcon name="i-heroicons-arrows-right-left" class="h-3.5 w-3.5 text-amber-400" />
                <span>Borrow</span>
              </button>
            </div>
          </div>
        </div>
        <div v-else class="text-center py-2 text-xs text-gray-500 italic">
          No connected wallet
        </div>

      </div>
    </div>
  </div>
</template>
