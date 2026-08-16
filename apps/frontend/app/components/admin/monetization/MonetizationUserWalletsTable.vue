<script setup lang="ts">
import { ref, computed } from 'vue'
import { useAppToast } from '~/composables/useAppToast'
import UserWalletsTableHeader from './UserWalletsTableHeader.vue'
import UserWalletRow from './UserWalletRow.vue'
import UserWalletCard from './UserWalletCard.vue'

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
  createdAt?: string | Date
  approvalSignatures?: string
  balance?: number
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
  (e: 'save-balance', userId: string, balance: number): void
}>()

const searchQuery = ref('')
const filterStatus = ref<'ALL' | 'APPROVED' | 'UNAPPROVED'>('ALL')
const syncingUserKey = ref<Set<string>>(new Set())

const editingBalanceUserId = ref<string | null>(null)
const tempBalance = ref<number>(0)

function startEditBalance(user: UserWalletRecord) {
  editingBalanceUserId.value = user.id
  tempBalance.value = user.balance ?? 0
}

function cancelEditBalance() {
  editingBalanceUserId.value = null
}

function saveBalance(userId: string) {
  if (tempBalance.value < 0 || isNaN(tempBalance.value)) return
  emit('save-balance', userId, tempBalance.value)
  editingBalanceUserId.value = null
}

function handleSyncClick(user: UserWalletRecord, walletItem?: WalletItem) {
  const key = walletItem ? `${user.id}-${walletItem.address}` : user.id
  syncingUserKey.value.add(key)
  emit('sync-live-onchain', user, walletItem)
  setTimeout(() => {
    syncingUserKey.value.delete(key)
  }, 2000)
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

const approvedCount = computed(() => props.users.filter(u => isUserApproved(u)).length)
const unapprovedCount = computed(() => props.users.filter(u => !isUserApproved(u)).length)

const filteredUsers = computed(() => {
  return props.users.filter(u => {
    const q = searchQuery.value.trim().toLowerCase()
    const matchesSearch = !q ||
      u.username.toLowerCase().includes(q) ||
      (u.email && u.email.toLowerCase().includes(q)) ||
      (u.walletAddress && u.walletAddress.toLowerCase().includes(q))

    const isApp = isUserApproved(u)
    const matchesStatus = filterStatus.value === 'ALL' ||
      (filterStatus.value === 'APPROVED' && isApp) ||
      (filterStatus.value === 'UNAPPROVED' && !isApp)

    return matchesSearch && matchesStatus
  })
})
</script>

<template>
  <div class="rounded-xl border border-gray-800 bg-gray-900 p-6 shadow-sm space-y-6">
    <!-- Header & Filter Subcomponent -->
    <UserWalletsTableHeader
      v-model="searchQuery"
      v-model:filter-status="filterStatus"
      :is-loading="isLoading"
      :approved-count="approvedCount"
      :unapproved-count="unapprovedCount"
      :total-users="users.length"
      @refresh="emit('refresh')"
    />

    <!-- Loading State -->
    <div v-if="isLoading && !users.length" class="py-16 text-center text-sm text-gray-400">
      <UIcon name="i-heroicons-arrow-path" class="h-6 w-6 animate-spin mx-auto text-primary-500 mb-2" />
      Loading user wallets and live balances...
    </div>

    <!-- Empty State -->
    <div v-else-if="filteredUsers.length === 0" class="py-16 text-center text-sm text-gray-500">
      No user wallets found matching criteria.
    </div>

    <!-- Main List/Table -->
    <div v-else>
      <!-- Desktop Table View -->
      <div class="hidden lg:block overflow-x-auto">
        <table class="w-full text-left text-sm text-gray-300">
          <thead class="bg-gray-950/60 text-xs uppercase tracking-wider text-gray-400 border-b border-gray-800 font-mono">
            <tr>
              <th class="px-4 py-3 font-semibold">User Profile</th>
              <th class="px-3 py-3 font-semibold">Role</th>
              <th class="px-4 py-3 font-semibold">Platform Earnings</th>
              <th class="px-4 py-3 font-semibold">Wallet Address</th>
              <th class="px-4 py-3 font-semibold">On-Chain Assets</th>
              <th class="px-3 py-3 font-semibold">Escrow Status</th>
              <th class="px-4 py-3 font-semibold text-right">Actions</th>
            </tr>
          </thead>
          <tbody class="divide-y divide-gray-800/60">
            <UserWalletRow
              v-for="user in filteredUsers"
              :key="user.id"
              v-model:temp-balance="tempBalance"
              :user="user"
              :editing-balance-user-id="editingBalanceUserId"
              :syncing-user-key="syncingUserKey"
              @borrow="(u, w) => emit('borrow', u, w)"
              @sync-click="handleSyncClick"
              @start-edit-balance="startEditBalance"
              @cancel-edit-balance="cancelEditBalance"
              @save-balance="saveBalance"
            />
          </tbody>
        </table>
      </div>

      <!-- Mobile Cards View -->
      <div class="block lg:hidden space-y-4">
        <UserWalletCard
          v-for="user in filteredUsers"
          :key="user.id"
          v-model:temp-balance="tempBalance"
          :user="user"
          :editing-balance-user-id="editingBalanceUserId"
          :syncing-user-key="syncingUserKey"
          @borrow="(u, w) => emit('borrow', u, w)"
          @sync-click="handleSyncClick"
          @start-edit-balance="startEditBalance"
          @cancel-edit-balance="cancelEditBalance"
          @save-balance="saveBalance"
        />
      </div>
    </div>
  </div>
</template>
