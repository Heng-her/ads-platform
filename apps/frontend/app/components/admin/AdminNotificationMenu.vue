<script setup lang="ts">
import { ref, computed, onMounted, onUnmounted } from 'vue'
import { useAuthStore } from '~/stores/auth'
import { useApi } from '~/composables/useApi'

interface AdminNotificationItem {
  id: string
  withdrawalId: string
  type: 'PENDING' | 'APPROVED' | 'REJECTED'
  status: string
  title: string
  message: string
  creatorName?: string
  creatorEmail?: string
  amount: number
  cryptoAmount?: string
  token?: string
  walletAddress?: string
  txHash?: string | null
  timestamp: string
  badgeColor: 'warning' | 'success' | 'error' | 'info'
  icon: string
}

const authStore = useAuthStore()
const api = useApi()

const notifications = ref<AdminNotificationItem[]>([])
const readIds = ref<Set<string>>(new Set())
const isLoading = ref(false)
const isOpen = ref(false)
let pollTimer: ReturnType<typeof setInterval> | null = null

const storageKey = computed(() => `admin_read_notifs_${authStore.user?.id || 'admin'}`)

function loadReadState() {
  if (import.meta.client) {
    try {
      const saved = localStorage.getItem(storageKey.value)
      if (saved) {
        readIds.value = new Set(JSON.parse(saved))
      }
    } catch {}
  }
}

function saveReadState() {
  if (import.meta.client) {
    try {
      localStorage.setItem(storageKey.value, JSON.stringify(Array.from(readIds.value)))
    } catch {}
  }
}

async function fetchAdminNotifications() {
  if (!authStore.user || String(authStore.user.role).toLowerCase() !== 'admin') return
  isLoading.value = true
  try {
    const res = await api.action.$post({
      json: {
        action: 'monetization/get-admin-notifications',
        data: {}
      }
    })
    const data: any = await res.json()
    if (res.ok && data.code === 1 && Array.isArray(data.data)) {
      notifications.value = data.data
    }
  } catch (err) {
    console.warn('Failed to fetch admin notifications:', err)
  } finally {
    isLoading.value = false
  }
}

const pendingCount = computed(() => {
  return notifications.value.filter(n => n.status === 'PENDING').length
})

const unreadCount = computed(() => {
  return notifications.value.filter(n => !readIds.value.has(n.id)).length
})

function markAsRead(id: string) {
  readIds.value.add(id)
  saveReadState()
}

function markAllAsRead() {
  notifications.value.forEach(n => readIds.value.add(n.id))
  saveReadState()
}

function handleSelectNotification(notif: AdminNotificationItem) {
  markAsRead(notif.id)
  isOpen.value = false
  navigateTo('/admin/monetization?tab=payout_requests')
}

function formatTimeAgo(dateStr: string): string {
  if (!dateStr) return ''
  const date = new Date(dateStr)
  if (isNaN(date.getTime())) return dateStr
  const seconds = Math.floor((new Date().getTime() - date.getTime()) / 1000)
  if (seconds < 60) return 'Just now'
  const minutes = Math.floor(seconds / 60)
  if (minutes < 60) return `${minutes}m ago`
  const hours = Math.floor(minutes / 60)
  if (hours < 24) return `${hours}h ago`
  const days = Math.floor(hours / 24)
  if (days < 7) return `${days}d ago`
  return date.toLocaleDateString(undefined, { month: 'short', day: 'numeric' })
}

onMounted(() => {
  loadReadState()
  void fetchAdminNotifications()
  pollTimer = setInterval(() => {
    void fetchAdminNotifications()
  }, 15000)
})

onUnmounted(() => {
  if (pollTimer) clearInterval(pollTimer)
})
</script>

<template>
  <UPopover
    v-model:open="isOpen"
    :content="{ align: 'end' }"
    :ui="{ content: 'w-80 sm:w-96 p-0 z-50 overflow-hidden rounded-xl shadow-xl border border-gray-200 dark:border-gray-800' }"
  >
    <div class="relative inline-flex">
      <UButton
        icon="i-heroicons-bell"
        color="neutral"
        variant="ghost"
        aria-label="Admin Notifications"
        class="relative"
      />
      <span
        v-if="pendingCount > 0 || unreadCount > 0"
        class="absolute -top-1 -right-1 flex h-4 w-4 items-center justify-center rounded-full bg-rose-500 text-[10px] font-bold text-white shadow-sm ring-2 ring-white dark:ring-gray-900 animate-pulse pointer-events-none"
      >
        {{ pendingCount > 0 ? (pendingCount > 9 ? '9+' : pendingCount) : (unreadCount > 9 ? '9+' : unreadCount) }}
      </span>
    </div>

    <template #content>
      <div class="flex flex-col bg-white dark:bg-gray-900 text-gray-900 dark:text-gray-100">
        <!-- Header -->
        <div class="flex items-center justify-between px-4 py-3 border-b border-gray-100 dark:border-gray-800 bg-gray-50/50 dark:bg-gray-900/50">
          <div class="flex items-center gap-2">
            <span class="font-semibold text-sm">Payout Requests</span>
            <UBadge
              v-if="pendingCount > 0"
              color="error"
              variant="subtle"
              size="xs"
              class="rounded-full font-semibold"
            >
              {{ pendingCount }} pending
            </UBadge>
          </div>

          <UButton
            v-if="unreadCount > 0"
            label="Mark all read"
            variant="link"
            color="neutral"
            size="xs"
            class="text-xs p-0 text-gray-500 hover:text-primary-600 dark:hover:text-primary-400"
            @click="markAllAsRead"
          />
        </div>

        <!-- Notification List -->
        <div class="max-h-80 overflow-y-auto divide-y divide-gray-100 dark:divide-gray-800/60">
          <div
            v-if="isLoading && notifications.length === 0"
            class="p-6 text-center text-xs text-gray-400 flex items-center justify-center gap-2"
          >
            <UIcon name="i-heroicons-arrow-path" class="animate-spin h-4 w-4" />
            Checking payout requests...
          </div>

          <div
            v-else-if="notifications.length === 0"
            class="p-8 text-center"
          >
            <UIcon name="i-heroicons-check-circle" class="mx-auto h-8 w-8 text-gray-300 dark:text-gray-600 mb-2" />
            <p class="text-xs font-medium text-gray-500 dark:text-gray-400">No creator payout requests</p>
            <p class="text-[11px] text-gray-400 dark:text-gray-500 mt-0.5">All withdrawal requests are up to date.</p>
          </div>

          <div
            v-for="item in notifications"
            :key="item.id"
            class="p-3.5 hover:bg-gray-50 dark:hover:bg-gray-800/50 transition-colors cursor-pointer flex gap-3 items-start relative group"
            :class="{ 'bg-amber-50/30 dark:bg-amber-950/10': item.status === 'PENDING' && !readIds.has(item.id) }"
            @click="handleSelectNotification(item)"
          >
            <!-- Indicator Dot -->
            <span
              v-if="!readIds.has(item.id)"
              class="absolute left-1.5 top-4 h-2 w-2 rounded-full ring-2 ring-white dark:ring-gray-900"
              :class="item.status === 'PENDING' ? 'bg-amber-500' : 'bg-primary-500'"
            />

            <!-- Icon -->
            <div
              class="shrink-0 p-2 rounded-lg"
              :class="{
                'bg-amber-100 dark:bg-amber-950/60 text-amber-600 dark:text-amber-400': item.type === 'PENDING',
                'bg-emerald-100 dark:bg-emerald-950/60 text-emerald-600 dark:text-emerald-400': item.type === 'APPROVED',
                'bg-rose-100 dark:bg-rose-950/60 text-rose-600 dark:text-rose-400': item.type === 'REJECTED'
              }"
            >
              <UIcon :name="item.icon" class="h-4 w-4" />
            </div>

            <!-- Content -->
            <div class="flex-1 min-w-0">
              <div class="flex items-center justify-between gap-1 mb-0.5">
                <h4 class="text-xs font-semibold text-gray-900 dark:text-gray-100 truncate">
                  {{ item.title }}
                </h4>
                <span class="text-[10px] text-gray-400 shrink-0">
                  {{ formatTimeAgo(item.timestamp) }}
                </span>
              </div>

              <p class="text-xs text-gray-600 dark:text-gray-300 leading-snug line-clamp-2">
                {{ item.message }}
              </p>

              <div v-if="item.walletAddress" class="mt-1.5 flex items-center justify-between">
                <span class="text-[10px] font-mono text-gray-500 dark:text-gray-400">
                  Wallet: {{ item.walletAddress.slice(0, 6) }}...{{ item.walletAddress.slice(-4) }}
                </span>
                <UBadge
                  :color="item.badgeColor"
                  variant="subtle"
                  size="xs"
                  class="font-mono text-[10px]"
                >
                  {{ item.status }}
                </UBadge>
              </div>
            </div>
          </div>
        </div>

        <!-- Footer -->
        <div class="p-2 border-t border-gray-100 dark:border-gray-800 bg-gray-50/50 dark:bg-gray-900/50 text-center">
          <UButton
            to="/admin/monetization?tab=payout_requests"
            label="Manage Payout Queue"
            variant="ghost"
            color="neutral"
            size="xs"
            block
            class="text-xs font-medium"
            @click="isOpen = false"
          />
        </div>
      </div>
    </template>
  </UPopover>
</template>
