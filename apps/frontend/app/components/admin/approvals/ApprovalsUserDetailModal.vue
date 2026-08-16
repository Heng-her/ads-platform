<script setup lang="ts">
import type { UserRecord } from './ApprovalsUserCard.vue'

defineProps<{
  user: UserRecord | null
}>()

const emit = defineEmits<{
  (e: 'close'): void
  (e: 'update-status', userId: string, status: 'ACTIVE' | 'SUSPENDED', role?: 'ADMIN' | 'CREATOR'): void
  (e: 'open-delete', user: UserRecord): void
}>()
</script>

<template>
  <div v-if="user"
    class="fixed inset-0 z-50 flex items-center justify-center bg-black/70 p-4 backdrop-blur-xs">
    <div
      class="w-full max-w-lg rounded-2xl border border-gray-800 bg-gray-900 p-6 shadow-2xl space-y-6 text-gray-100">
      <div class="flex items-center justify-between border-b border-gray-800 pb-4">
        <div class="flex items-center gap-3">
          <UIcon name="i-heroicons-user-circle" class="h-6 w-6 text-primary-400" />
          <h2 class="text-lg font-bold text-white">User Verification & Role Details</h2>
        </div>
        <button class="text-gray-400 hover:text-white" @click="emit('close')">
          <UIcon name="i-heroicons-x-mark" class="h-5 w-5" />
        </button>
      </div>

      <div class="space-y-4">
        <div class="flex items-center gap-4">
          <div class="relative h-16 w-16 overflow-hidden rounded-full border border-gray-700 bg-gray-800">
            <img v-if="user.avatar" :src="user.avatar" :alt="user.username"
              class="h-full w-full object-cover" />
            <div v-else class="flex h-full w-full items-center justify-center text-gray-400">
              <UIcon name="i-heroicons-user" class="h-8 w-8" />
            </div>
          </div>
          <div>
            <h3 class="text-lg font-bold text-white">{{ user.username }}</h3>
            <p class="text-sm text-gray-400">{{ user.email }}</p>
            <div class="mt-1 flex items-center gap-2">
              <UBadge :color="user.role === 'ADMIN' ? 'error' : 'primary'" variant="solid" size="xs">
                Role: {{ user.role || 'CREATOR' }}
              </UBadge>
              <UBadge :color="user.status === 'ACTIVE' ? 'success' : 'warning'" variant="soft" size="xs">
                Status: {{ user.status || 'PENDING' }}
              </UBadge>
            </div>
          </div>
        </div>

        <div class="space-y-2 rounded-xl bg-gray-950 p-4 border border-gray-800 text-xs">
          <div class="flex justify-between">
            <span class="text-gray-400">User ID:</span>
            <span class="font-mono text-gray-200">{{ user.id }}</span>
          </div>
          <div class="flex justify-between">
            <span class="text-gray-400">Country:</span>
            <span class="text-gray-200">{{ user.country || 'Cambodia (KH)' }}</span>
          </div>
          <div v-if="user.portfolioLink" class="flex justify-between">
            <span class="text-gray-400">Portfolio Link:</span>
            <a :href="user.portfolioLink" target="_blank" class="text-primary-400 hover:underline">
              {{ user.portfolioLink }}
            </a>
          </div>
        </div>
      </div>

      <div class="flex flex-wrap items-center justify-end gap-2.5 border-t border-gray-800 pt-4">
        <button v-if="user.role !== 'ADMIN'"
          class="rounded-lg border border-red-600/40 bg-red-600/20 px-3.5 py-2 text-xs font-semibold text-red-300 hover:bg-red-600/30 transition flex items-center gap-1.5"
          @click="emit('open-delete', user)">
          <UIcon name="i-heroicons-trash" class="h-4 w-4" />
          <span>Delete Creator</span>
        </button>

        <button v-if="user.status !== 'SUSPENDED'"
          class="rounded-lg border border-red-500/30 bg-red-500/10 px-3.5 py-2 text-xs font-semibold text-red-400 hover:bg-red-500/20 transition"
          @click="emit('update-status', user.id, 'SUSPENDED')">
          Suspend Account
        </button>

        <button v-if="user.role === 'ADMIN'"
          class="rounded-lg bg-amber-600 px-4 py-2 text-xs font-semibold text-white hover:bg-amber-500 transition"
          @click="emit('update-status', user.id, 'ACTIVE', 'CREATOR')">
          Demote to Creator Role
        </button>

        <button v-else
          class="rounded-lg bg-indigo-600 px-4 py-2 text-xs font-semibold text-white hover:bg-indigo-500 transition"
          @click="emit('update-status', user.id, 'ACTIVE', 'ADMIN')">
          Promote to Admin Role
        </button>
      </div>
    </div>
  </div>
</template>
