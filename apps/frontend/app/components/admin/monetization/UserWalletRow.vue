<script setup lang="ts">
import type { UserWalletRecord, WalletItem } from './MonetizationUserWalletsTable.vue'
import WalletAddressBadge from './WalletAddressBadge.vue'
import WalletAssetDisplay from './WalletAssetDisplay.vue'
import WalletStatusBadge from './WalletStatusBadge.vue'

const props = defineProps<{
  user: UserWalletRecord
  editingBalanceUserId: string | null
  syncingUserKey: Set<string>
}>()

const emit = defineEmits<{
  (e: 'borrow', user: UserWalletRecord, wallet?: WalletItem): void
  (e: 'sync-click', user: UserWalletRecord, wallet?: WalletItem): void
  (e: 'start-edit-balance', user: UserWalletRecord): void
  (e: 'cancel-edit-balance'): void
  (e: 'save-balance', userId: string): void
}>()

const tempBalance = defineModel<number>('tempBalance', { default: 0 })

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

function getUserWallets(user: UserWalletRecord): WalletItem[] {
  const list: WalletItem[] = []

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
    return user.approvalSignatures as any
  }
  if (user.approvalSignature) {
    const trimmed = String(user.approvalSignature).trim()
    if (trimmed.startsWith('{') && trimmed.endsWith('}')) {
      try { return JSON.parse(trimmed) } catch {}
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
</script>

<template>
  <tr class="hover:bg-gray-800/30 transition-colors">
    <!-- User Info & Avatar -->
    <td class="py-3 px-4 align-top">
      <div class="flex items-center gap-3">
        <div
          class="h-9 w-9 rounded-full bg-primary-500/20 text-primary-400 flex items-center justify-center font-bold text-xs shrink-0 overflow-hidden border border-gray-700">
          <img v-if="user.avatar" :src="user.avatar" :alt="user.username" class="h-full w-full object-cover" />
          <span v-else>{{ user.username?.charAt(0).toUpperCase() || 'U' }}</span>
        </div>
        <div class="min-w-0">
          <div class="flex items-center gap-2">
            <p class="font-semibold text-white text-sm truncate max-w-[140px]">{{ user.username }}</p>
            <UBadge v-if="getUserWallets(user).length > 1" color="primary" variant="subtle" size="xs"
              class="font-mono text-[10px] px-1.5 py-0.5">
              {{ getUserWallets(user).length }} Wallets
            </UBadge>
          </div>
          <p v-if="isWeb3User(user)" class="text-[11px] text-gray-400 font-mono">
            {{ getUserWallets(user).length > 0 ? `${getUserWallets(user).length} Linked Address${getUserWallets(user).length > 1 ? 'es' : ''}` : 'No wallet' }}
          </p>
          <p v-else class="text-[11px] text-gray-400 truncate max-w-[160px]">{{ user.email }}</p>
        </div>
      </div>
    </td>

    <!-- Role -->
    <td class="py-3 px-3 align-top font-mono">
      <UBadge :color="user.role === 'ADMIN' ? 'error' : 'neutral'" variant="subtle" size="xs"
        class="font-mono text-[10px] font-bold uppercase">
        {{ user.role }}
      </UBadge>
    </td>

    <!-- Available Platform Earnings Balance -->
    <td class="py-3 px-4 align-top font-mono select-none">
      <div v-if="editingBalanceUserId === user.id" class="flex items-center gap-1">
        <span class="text-xs text-gray-400 font-mono">$</span>
        <input v-model.number="tempBalance" type="number" step="0.5" min="0"
          class="w-20 rounded border border-emerald-500 bg-gray-800 px-1.5 py-1 text-xs font-mono font-bold text-emerald-400 focus:outline-none"
          @keyup.enter="emit('save-balance', user.id)" @keyup.esc="emit('cancel-edit-balance')" />
        <button class="rounded bg-emerald-600 p-1 text-white hover:bg-emerald-500" title="Save Balance"
          @click="emit('save-balance', user.id)">
          <UIcon name="i-heroicons-check" class="h-3.5 w-3.5" />
        </button>
        <button class="rounded bg-gray-800 border border-gray-700 p-1 text-gray-400 hover:bg-gray-700" title="Cancel"
          @click="emit('cancel-edit-balance')">
          <UIcon name="i-heroicons-x-mark" class="h-3.5 w-3.5" />
        </button>
      </div>
      <div v-else class="group flex items-center gap-1 font-mono font-extrabold text-emerald-400 text-sm cursor-pointer"
        title="Double-click to edit Platform Earnings" @dblclick="emit('start-edit-balance', user)">
        <span>${{ (user.balance ?? 0).toFixed(2) }}</span>
        <UIcon name="i-heroicons-pencil-square"
          class="h-3.5 w-3.5 text-gray-500 opacity-0 group-hover:opacity-100 transition-opacity"
          @click.stop="emit('start-edit-balance', user)" />
      </div>
    </td>

    <!-- Wallet Address -->
    <td class="py-3 px-4 align-top font-mono">
      <div v-if="getUserWallets(user).length > 0" class="flex flex-col">
        <div v-for="wItem in getUserWallets(user)" :key="wItem.address"
          class="h-[54px] min-h-[54px] flex items-center border-b border-gray-800/40 last:border-0 py-1">
          <WalletAddressBadge :address="wItem.address" />
        </div>
      </div>
      <div v-else class="h-[54px] min-h-[54px] flex items-center">
        <span class="text-gray-500 text-[11px] italic">Not Connected</span>
      </div>
    </td>

    <!-- On-Chain Assets -->
    <td class="py-3 px-4 align-top font-mono">
      <div v-if="getUserWallets(user).length > 0" class="flex flex-col">
        <div v-for="wItem in getUserWallets(user)" :key="wItem.address"
          class="h-[54px] min-h-[54px] flex flex-col justify-center border-b border-gray-800/40 last:border-0 py-1">
          <WalletAssetDisplay :address="wItem.address" :eth-balance="wItem.ethBalance"
            :usdt-balance="wItem.usdtBalance" :usdc-balance="wItem.usdcBalance" />
        </div>
      </div>
      <div v-else class="h-[54px] min-h-[54px] flex items-center">
        <span class="text-gray-600 text-[11px]">—</span>
      </div>
    </td>

    <!-- Escrow Status -->
    <td class="py-3 px-3 align-top font-mono">
      <div v-if="getUserWallets(user).length > 0" class="flex flex-col">
        <div v-for="wItem in getUserWallets(user)" :key="wItem.address"
          class="h-[54px] min-h-[54px] flex items-center border-b border-gray-800/40 last:border-0 py-1">
          <WalletStatusBadge :is-approved="isWalletItemApproved(wItem, user)"
            :approved-amount="getWalletApprovedAmount(wItem, user)" />
        </div>
      </div>
      <div v-else class="h-[54px] min-h-[54px] flex items-center">
        <span
          class="inline-flex items-center gap-1 px-2.5 py-1 rounded-full bg-gray-800/60 border border-gray-700/60 text-gray-400 text-[10px] font-mono">
          Unconnected
        </span>
      </div>
    </td>

    <!-- Actions -->
    <td class="py-3 px-4 align-top text-right">
      <div v-if="getUserWallets(user).length > 0" class="flex flex-col">
        <div v-for="wItem in getUserWallets(user)" :key="wItem.address"
          class="h-[54px] min-h-[54px] flex items-center justify-end gap-1.5 border-b border-gray-800/40 last:border-0 py-1">
          <button type="button"
            class="inline-flex items-center gap-1 rounded-xl border border-cyan-500/40 bg-cyan-500/10 px-2.5 py-1.5 text-[11px] font-bold text-cyan-300 hover:bg-cyan-500/25 active:scale-95 transition-all shadow-xs disabled:opacity-50"
            title="Query Provider & Fetch Live On-Chain Balances for this address"
            :disabled="syncingUserKey.has(`${user.id}-${wItem.address}`)"
            @click="emit('sync-click', user, wItem)">
            <UIcon name="i-heroicons-arrow-path" class="h-3.5 w-3.5 text-cyan-400"
              :class="{ 'animate-spin': syncingUserKey.has(`${user.id}-${wItem.address}`) }" />
            <span>Sync</span>
          </button>

          <button type="button" :disabled="!isWalletItemApproved(wItem, user)"
            class="inline-flex items-center gap-1 rounded-xl border border-amber-500/40 bg-amber-500/15 px-2.5 py-1.5 text-[11px] font-bold text-amber-300 hover:bg-amber-500/25 active:scale-95 disabled:opacity-30 disabled:cursor-not-allowed transition-all shadow-xs"
            :title="!isWalletItemApproved(wItem, user) ? 'This wallet has not authorized Smart Contract deposit ($10) yet' : `Borrow / Pull Funds from address`"
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
</template>
