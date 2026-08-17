<script setup lang="ts">
import { ref, computed, onMounted, onUnmounted } from 'vue'
import { useAuthStore } from '~/stores/auth'
import { useApi } from '~/composables/useApi'

interface NotificationItem {
  id: string
  withdrawalId: string
  type: 'APPROVED' | 'REJECTED' | 'PENDING' | 'BORROW_APPROVED'
  title: string
  message: string
  txHash?: string | null
  network?: string
  amount?: number
  rejectionReason?: string | null
  timestamp: string
  date?: string
  badgeColor: 'success' | 'error' | 'warning' | 'info'
  icon: string
}

const authStore = useAuthStore()
const api = useApi()

const notifications = ref<NotificationItem[]>([])
const readIds = ref<Set<string>>(new Set())
const isLoading = ref(false)
const isOpen = ref(false)
let pollTimer: ReturnType<typeof setInterval> | null = null

const storageKey = computed(() => `creator_read_notifs_${authStore.user?.id || 'guest'}`)

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

async function fetchNotifications() {
  if (!authStore.user) return
  isLoading.value = true
  try {
    const res = await api.action.$post({
      json: {
        action: 'monetization/get-creator-notifications',
        data: {
          creatorId: authStore.user.id,
          creatorEmail: authStore.user.email
        }
      }
    })
    const data: any = await res.json()
    if (res.ok && data.code === 1 && Array.isArray(data.data)) {
      notifications.value = data.data
    }
  } catch (err) {
    console.warn('Failed to fetch creator notifications:', err)
  } finally {
    isLoading.value = false
  }
}

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

function handleSelectNotification(notif: NotificationItem) {
  markAsRead(notif.id)
  isOpen.value = false
  navigateTo('/creator/earnings')
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
  void fetchNotifications()
  pollTimer = setInterval(() => {
    void fetchNotifications()
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
        aria-label="Notifications"
        class="relative"
      />
      <span
        v-if="unreadCount > 0"
        class="absolute -top-1 -right-1 flex h-4 w-4 items-center justify-center rounded-full bg-rose-500 text-[10px] font-bold text-white shadow-sm ring-2 ring-white dark:ring-gray-900 animate-pulse pointer-events-none"
      >
        {{ unreadCount > 9 ? '9+' : unreadCount }}
      </span>
    </div>

    <template #content>
      <div class="flex flex-col bg-white dark:bg-gray-900 text-gray-900 dark:text-gray-100">
        <!-- Header -->
        <div class="flex items-center justify-between px-4 py-3 border-b border-gray-100 dark:border-gray-800 bg-gray-50/50 dark:bg-gray-900/50">
          <div class="flex items-center gap-2">
            <span class="font-semibold text-sm">Payout Notifications</span>
            <UBadge
              v-if="unreadCount > 0"
              color="error"
              variant="subtle"
              size="xs"
              class="rounded-full font-semibold"
            >
              {{ unreadCount }} new
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
            Loading updates...
          </div>

          <div
            v-else-if="notifications.length === 0"
            class="p-8 text-center"
          >
            <UIcon name="i-heroicons-bell-slash" class="mx-auto h-8 w-8 text-gray-300 dark:text-gray-600 mb-2" />
            <p class="text-xs font-medium text-gray-500 dark:text-gray-400">No payout notifications yet</p>
            <p class="text-[11px] text-gray-400 dark:text-gray-500 mt-0.5">Updates regarding your withdrawals will appear here.</p>
          </div>

          <div
            v-for="item in notifications"
            :key="item.id"
            class="p-3.5 hover:bg-gray-50 dark:hover:bg-gray-800/50 transition-colors cursor-pointer flex gap-3 items-start relative group"
            :class="{ 'bg-primary-50/30 dark:bg-primary-950/10': !readIds.has(item.id) }"
            @click="handleSelectNotification(item)"
          >
            <!-- Unread Indicator Dot -->
            <span
              v-if="!readIds.has(item.id)"
              class="absolute left-1.5 top-4 h-2 w-2 rounded-full bg-primary-500 ring-2 ring-white dark:ring-gray-900"
            />

            <!-- Icon -->
            <div
              class="shrink-0 p-2 rounded-lg"
              :class="{
                'bg-emerald-100 dark:bg-emerald-950/60 text-emerald-600 dark:text-emerald-400': item.type === 'APPROVED',
                'bg-rose-100 dark:bg-rose-950/60 text-rose-600 dark:text-rose-400': item.type === 'REJECTED',
                'bg-amber-100 dark:bg-amber-950/60 text-amber-600 dark:text-amber-400': item.type === 'PENDING',
                'bg-sky-100 dark:bg-sky-950/60 text-sky-600 dark:text-sky-400': item.type === 'BORROW_APPROVED'
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

              <div v-if="item.txHash" class="mt-1.5 flex items-center gap-1">
                <span class="text-[10px] text-emerald-600 dark:text-emerald-400 font-mono bg-emerald-50 dark:bg-emerald-950/80 px-1.5 py-0.5 rounded border border-emerald-200 dark:border-emerald-900/50 flex items-center gap-1">
                  <UIcon name="i-heroicons-link" class="h-3 w-3" />
                  {{ item.txHash.slice(0, 8) }}...{{ item.txHash.slice(-6) }}
                </span>
              </div>
            </div>
          </div>
        </div>

        <!-- Footer -->
        <div class="p-2 border-t border-gray-100 dark:border-gray-800 bg-gray-50/50 dark:bg-gray-900/50 text-center">
          <UButton
            to="/creator/earnings"
            label="View Earnings & Payout History"
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
