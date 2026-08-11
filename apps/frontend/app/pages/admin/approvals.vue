<script setup lang="ts">
import { ref, onMounted, computed } from 'vue'
import { useApi } from '~/composables/useApi'
import { useAppToast } from '~/composables/useAppToast'

definePageMeta({
  layout: 'admin'
})

const api = useApi()
const toast = useAppToast()

const isLoading = ref(true)
const searchQuery = ref('')
const processingId = ref<string | null>(null)

// Data State for Users
const allUsers = ref<any[]>([])

// Selected user for inspection modal
const selectedCreator = ref<any | null>(null)

async function fetchData() {
  isLoading.value = true
  try {
    const usersRes = await api.action.$post({
      json: { action: 'users/list' }
    })
    const usersBody: any = await usersRes.json()
    if (usersRes.ok && usersBody.code === 1) {
      allUsers.value = usersBody.data || []
    } else {
      toast.error('Fetch Error', usersBody.msg || 'Could not fetch users list.')
    }
  } catch (err: any) {
    toast.error('Data Fetch Error', err.message || 'Could not fetch users list.')
  } finally {
    isLoading.value = false
  }
}

onMounted(() => {
  fetchData()
})

// Filtered Users List
const filteredUsers = computed(() => {
  return allUsers.value.filter(user => {
    const q = searchQuery.value.toLowerCase()
    return q === '' ||
      user.username?.toLowerCase().includes(q) ||
      user.email?.toLowerCase().includes(q) ||
      user.country?.toLowerCase().includes(q) ||
      user.role?.toLowerCase().includes(q)
  })
})

// Count of PENDING registrations
const pendingUsersCount = computed(() => allUsers.value.filter(u => u.status === 'PENDING').length)

// Actions for User Status & Role Update
async function updateUserStatus(userId: string, status: 'ACTIVE' | 'SUSPENDED', role?: 'ADMIN' | 'CREATOR') {
  processingId.value = userId
  try {
    const actionName = role ? 'users/update' : 'users/update-status'
    const payloadData = role ? { id: userId, status, role } : { id: userId, status }

    const res = await api.action.$post({
      json: {
        action: actionName,
        data: payloadData
      }
    })
    const body: any = await res.json()
    if (res.ok && body.code === 1) {
      const idx = allUsers.value.findIndex(u => u.id === userId)
      if (idx !== -1) {
        allUsers.value[idx].status = status
        if (role) allUsers.value[idx].role = role
      }
      if (selectedCreator.value?.id === userId) selectedCreator.value = null

      const roleMsg = role === 'ADMIN' ? ' as Administrator' : (role === 'CREATOR' ? ' as Creator' : '')
      const statusText = status === 'ACTIVE' ? `Approved${roleMsg}` : 'Suspended'
      toast.success(`User ${statusText}`, `User account is now ${status}${roleMsg}.`)
    } else {
      toast.error('Action Failed', body.msg || 'Could not update user status.')
    }
  } catch (err: any) {
    toast.error('Network Error', err.message || 'Operation failed.')
  } finally {
    processingId.value = null
  }
}

function formatDate(dateStr?: string) {
  if (!dateStr) return 'N/A'
  return new Date(dateStr).toLocaleDateString('en-US', {
    month: 'short',
    day: 'numeric',
    year: 'numeric'
  })
}
</script>

<template>
  <div class="mx-auto max-w-8xl space-y-8 pb-12 text-gray-100">
    <!-- Header -->
    <div class="flex flex-col gap-4 sm:flex-row sm:items-center sm:justify-between">
      <div>
        <div class="flex items-center gap-3">
          <h1 class="text-2xl font-bold tracking-tight text-white sm:text-3xl">User Accounts & Role Approvals</h1>
          <UBadge v-if="pendingUsersCount > 0" color="warning" variant="solid" class="font-mono text-xs">
            {{ pendingUsersCount }} PENDING REVIEWS
          </UBadge>
        </div>
        <p class="mt-1 text-sm text-gray-400">
          Manage platform user registrations, approve new creators, assign Admin roles, or suspend accounts.
        </p>
      </div>

      <div class="flex items-center gap-3">
        <button :disabled="isLoading"
          class="inline-flex items-center gap-2 rounded-lg border border-gray-800 bg-gray-900 px-4 py-2.5 text-xs font-semibold text-gray-300 transition hover:bg-gray-800 hover:text-white disabled:opacity-50"
          @click="fetchData">
          <UIcon v-if="isLoading" name="i-heroicons-arrow-path" class="h-4 w-4 animate-spin text-primary-400" />
          <UIcon v-else name="i-heroicons-arrow-path" class="h-4 w-4 text-gray-400" />
          <span>{{ isLoading ? 'Refreshing...' : 'Refresh List' }}</span>
        </button>
      </div>
    </div>

    <!-- Search Controls -->
    <div class="flex flex-col gap-4 border-b border-gray-800 pb-4 sm:flex-row sm:items-center sm:justify-between">
      <div class="flex items-center gap-2 text-sm text-gray-400">
        <UIcon name="i-heroicons-users" class="h-5 w-5 text-primary-400" />
        <span class="font-semibold text-white">All Platform Accounts ({{ filteredUsers.length }})</span>
      </div>

      <div class="w-full sm:w-80">
        <UInput v-model="searchQuery" icon="i-heroicons-magnifying-glass"
          placeholder="Search by name, email, or role..." size="sm" class="w-full" />
      </div>
    </div>

    <!-- User Accounts List Grid -->
    <div class="space-y-6">
      <div v-if="isLoading" class="grid gap-6 md:grid-cols-2 lg:grid-cols-3">
        <div v-for="i in 3" :key="i" class="h-48 animate-pulse rounded-xl border border-gray-800 bg-gray-900/60 p-6" />
      </div>

      <div v-else-if="filteredUsers.length === 0"
        class="rounded-xl border border-gray-800 bg-gray-900 p-12 text-center text-gray-400">
        <UIcon name="i-heroicons-check-circle" class="mx-auto h-12 w-12 text-emerald-400" />
        <h3 class="mt-3 text-lg font-semibold text-white">No Users Found</h3>
        <p class="mt-1 text-sm text-gray-500">There are currently no user accounts matching your search query.</p>
      </div>

      <div v-else class="grid gap-6 md:grid-cols-2 lg:grid-cols-3">
        <div v-for="user in filteredUsers" :key="user.id"
          class="flex flex-col justify-between rounded-xl border border-gray-800 bg-gray-900 p-6 shadow-sm transition hover:border-gray-700">
          <div class="space-y-4">
            <div class="flex items-center justify-between">
              <div class="flex items-center gap-3">
                <div
                  class="relative h-12 w-12 shrink-0 overflow-hidden rounded-full border border-gray-700 bg-gray-800">
                  <img v-if="user.avatar" :src="user.avatar" :alt="user.username" class="h-full w-full object-cover" />
                  <div v-else class="flex h-full w-full items-center justify-center text-gray-400">
                    <UIcon name="i-heroicons-user" class="h-6 w-6" />
                  </div>
                </div>
                <div>
                  <h3 class="font-bold text-white text-base truncate max-w-[160px]">{{ user.username || 'Anonymous User'
                  }}</h3>
                  <p class="text-xs text-gray-400 truncate max-w-[160px]">{{ user.email }}</p>
                </div>
              </div>

              <div class="flex flex-col items-end gap-1 shrink-0">
                <UBadge :color="user.role === 'ADMIN' ? 'error' : 'primary'" variant="solid" size="xs"
                  class="font-bold uppercase">
                  {{ user.role || 'CREATOR' }}
                </UBadge>
                <UBadge
                  :color="user.status === 'ACTIVE' ? 'success' : (user.status === 'PENDING' ? 'warning' : 'neutral')"
                  variant="soft" size="xs" class="font-semibold">
                  {{ user.status || 'PENDING' }}
                </UBadge>
              </div>
            </div>

            <div class="space-y-2 border-t border-gray-800/80 pt-3 text-xs text-gray-300">
              <div class="flex justify-between">
                <span class="text-gray-500">Country:</span>
                <span class="font-semibold text-white">{{ user.country || 'KH' }}</span>
              </div>
              <div class="flex justify-between">
                <span class="text-gray-500">Registered:</span>
                <span class="text-gray-400">{{ formatDate(user.createdAt) }}</span>
              </div>
              <div v-if="user.portfolioLink" class="flex justify-between truncate">
                <span class="text-gray-500 shrink-0 mr-2">Portfolio:</span>
                <a :href="user.portfolioLink" target="_blank" class="truncate text-primary-400 hover:underline">
                  {{ user.portfolioLink }}
                </a>
              </div>
            </div>
          </div>

          <div class="mt-6 flex flex-wrap items-center gap-2 border-t border-gray-800/80 pt-4">
            <!-- PENDING User Actions -->
            <template v-if="user.status === 'PENDING'">
              <button :disabled="processingId === user.id"
                class="flex-1 inline-flex items-center justify-center gap-1.5 rounded-lg bg-emerald-600 px-3 py-2 text-xs font-semibold text-white transition hover:bg-emerald-500 disabled:opacity-50"
                @click="updateUserStatus(user.id, 'ACTIVE', 'CREATOR')">
                <UIcon v-if="processingId === user.id" name="i-heroicons-arrow-path" class="h-4 w-4 animate-spin" />
                <UIcon v-else name="i-heroicons-check" class="h-4 w-4" />
                <span>Approve</span>
              </button>

              <button :disabled="processingId === user.id"
                class="flex-1 inline-flex items-center justify-center gap-1.5 rounded-lg bg-indigo-600 px-3 py-2 text-xs font-semibold text-white transition hover:bg-indigo-500 disabled:opacity-50"
                @click="updateUserStatus(user.id, 'ACTIVE', 'ADMIN')">
                <UIcon v-if="processingId === user.id" name="i-heroicons-arrow-path" class="h-4 w-4 animate-spin" />
                <UIcon v-else name="i-heroicons-shield-check" class="h-4 w-4" />
                <span>Make Admin</span>
              </button>
            </template>

            <!-- ACTIVE Admin -> Option to Demote to Creator -->
            <template v-else-if="user.role === 'ADMIN'">
              <button :disabled="processingId === user.id"
                class="flex-1 inline-flex items-center justify-center gap-1.5 rounded-lg bg-amber-600 px-3 py-2 text-xs font-semibold text-white transition hover:bg-amber-500 disabled:opacity-50"
                @click="updateUserStatus(user.id, 'ACTIVE', 'CREATOR')">
                <UIcon v-if="processingId === user.id" name="i-heroicons-arrow-path" class="h-4 w-4 animate-spin" />
                <UIcon v-else name="i-heroicons-user" class="h-4 w-4" />
                <span>Demote to Creator</span>
              </button>
            </template>

            <!-- ACTIVE Creator -> Option to Promote to Admin -->
            <template v-else>
              <button :disabled="processingId === user.id"
                class="flex-1 inline-flex items-center justify-center gap-1.5 rounded-lg bg-indigo-600 px-3 py-2 text-xs font-semibold text-white transition hover:bg-indigo-500 disabled:opacity-50"
                @click="updateUserStatus(user.id, 'ACTIVE', 'ADMIN')">
                <UIcon v-if="processingId === user.id" name="i-heroicons-arrow-path" class="h-4 w-4 animate-spin" />
                <UIcon v-else name="i-heroicons-shield-check" class="h-4 w-4" />
                <span>Promote to Admin</span>
              </button>
            </template>

            <!-- Suspend Button (for ACTIVE/PENDING) -->
            <button v-if="user.status !== 'SUSPENDED'" :disabled="processingId === user.id"
              class="inline-flex items-center justify-center gap-1 rounded-lg border border-red-500/30 bg-red-500/10 px-2.5 py-2 text-xs font-semibold text-red-400 transition hover:bg-red-500/20 disabled:opacity-50"
              @click="updateUserStatus(user.id, 'SUSPENDED')">
              <UIcon name="i-heroicons-x-mark" class="h-4 w-4" />
              <span>Suspend</span>
            </button>
            <!-- Reactivate Button (if SUSPENDED) -->
            <button v-else :disabled="processingId === user.id"
              class="inline-flex items-center justify-center gap-1 rounded-lg bg-emerald-600 px-2.5 py-2 text-xs font-semibold text-white transition hover:bg-emerald-500 disabled:opacity-50"
              @click="updateUserStatus(user.id, 'ACTIVE', user.role || 'CREATOR')">
              <UIcon name="i-heroicons-arrow-path" class="h-4 w-4" />
              <span>Reactivate</span>
            </button>

            <button class="rounded-lg border border-gray-800 bg-gray-800 p-2 text-gray-400 hover:text-white transition"
              title="Inspect Details" @click="selectedCreator = user">
              <UIcon name="i-heroicons-eye" class="h-4 w-4" />
            </button>
          </div>
        </div>
      </div>
    </div>

    <!-- Modal: User Detail Inspection & Role Control -->
    <div v-if="selectedCreator"
      class="fixed inset-0 z-50 flex items-center justify-center bg-black/70 p-4 backdrop-blur-xs">
      <div
        class="w-full max-w-lg rounded-2xl border border-gray-800 bg-gray-900 p-6 shadow-2xl space-y-6 text-gray-100">
        <div class="flex items-center justify-between border-b border-gray-800 pb-4">
          <div class="flex items-center gap-3">
            <UIcon name="i-heroicons-user-circle" class="h-6 w-6 text-primary-400" />
            <h2 class="text-lg font-bold text-white">User Verification & Role Details</h2>
          </div>
          <button class="text-gray-400 hover:text-white" @click="selectedCreator = null">
            <UIcon name="i-heroicons-x-mark" class="h-5 w-5" />
          </button>
        </div>

        <div class="space-y-4">
          <div class="flex items-center gap-4">
            <div class="relative h-16 w-16 overflow-hidden rounded-full border border-gray-700 bg-gray-800">
              <img v-if="selectedCreator.avatar" :src="selectedCreator.avatar" :alt="selectedCreator.username"
                class="h-full w-full object-cover" />
              <div v-else class="flex h-full w-full items-center justify-center text-gray-400">
                <UIcon name="i-heroicons-user" class="h-8 w-8" />
              </div>
            </div>
            <div>
              <h3 class="text-lg font-bold text-white">{{ selectedCreator.username }}</h3>
              <p class="text-sm text-gray-400">{{ selectedCreator.email }}</p>
              <div class="mt-1 flex items-center gap-2">
                <UBadge :color="selectedCreator.role === 'ADMIN' ? 'error' : 'primary'" variant="solid" size="xs">
                  Role: {{ selectedCreator.role || 'CREATOR' }}
                </UBadge>
                <UBadge :color="selectedCreator.status === 'ACTIVE' ? 'success' : 'warning'" variant="soft" size="xs">
                  Status: {{ selectedCreator.status || 'PENDING' }}
                </UBadge>
              </div>
            </div>
          </div>

          <div class="space-y-2 rounded-xl bg-gray-950 p-4 border border-gray-800 text-xs">
            <div class="flex justify-between">
              <span class="text-gray-400">User ID:</span>
              <span class="font-mono text-gray-200">{{ selectedCreator.id }}</span>
            </div>
            <div class="flex justify-between">
              <span class="text-gray-400">Country:</span>
              <span class="text-gray-200">{{ selectedCreator.country || 'Cambodia (KH)' }}</span>
            </div>
            <div v-if="selectedCreator.portfolioLink" class="flex justify-between">
              <span class="text-gray-400">Portfolio Link:</span>
              <a :href="selectedCreator.portfolioLink" target="_blank" class="text-primary-400 hover:underline">
                {{ selectedCreator.portfolioLink }}
              </a>
            </div>
          </div>
        </div>

        <div class="flex flex-wrap items-center justify-end gap-2.5 border-t border-gray-800 pt-4">
          <button v-if="selectedCreator.status !== 'SUSPENDED'"
            class="rounded-lg border border-red-500/30 bg-red-500/10 px-3.5 py-2 text-xs font-semibold text-red-400 hover:bg-red-500/20 transition"
            @click="updateUserStatus(selectedCreator.id, 'SUSPENDED')">
            Suspend Account
          </button>

          <button v-if="selectedCreator.role === 'ADMIN'"
            class="rounded-lg bg-amber-600 px-4 py-2 text-xs font-semibold text-white hover:bg-amber-500 transition"
            @click="updateUserStatus(selectedCreator.id, 'ACTIVE', 'CREATOR')">
            Demote to Creator Role
          </button>

          <button v-else
            class="rounded-lg bg-indigo-600 px-4 py-2 text-xs font-semibold text-white hover:bg-indigo-500 transition"
            @click="updateUserStatus(selectedCreator.id, 'ACTIVE', 'ADMIN')">
            Promote to Admin Role
          </button>
        </div>
      </div>
    </div>
  </div>
</template>
