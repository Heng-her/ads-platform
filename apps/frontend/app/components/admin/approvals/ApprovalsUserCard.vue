<script setup lang="ts">
export interface UserRecord {
  id: string
  username: string
  email: string | null
  avatar?: string | null
  role: 'ADMIN' | 'CREATOR' | string
  status: 'ACTIVE' | 'SUSPENDED' | 'PENDING' | string
  country?: string | null
  portfolioLink?: string | null
  createdAt?: string
}

defineProps<{
  user: UserRecord
  processingId: string | null
}>()

const emit = defineEmits<{
  (e: 'update-status', userId: string, status: 'ACTIVE' | 'SUSPENDED', role?: 'ADMIN' | 'CREATOR'): void
  (e: 'open-delete', user: UserRecord): void
  (e: 'inspect', user: UserRecord): void
}>()

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
  <div
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
          @click="emit('update-status', user.id, 'ACTIVE', 'CREATOR')">
          <UIcon v-if="processingId === user.id" name="i-heroicons-arrow-path" class="h-4 w-4 animate-spin" />
          <UIcon v-else name="i-heroicons-check" class="h-4 w-4" />
          <span>Approve</span>
        </button>

        <button :disabled="processingId === user.id"
          class="flex-1 inline-flex items-center justify-center gap-1.5 rounded-lg bg-indigo-600 px-3 py-2 text-xs font-semibold text-white transition hover:bg-indigo-500 disabled:opacity-50"
          @click="emit('update-status', user.id, 'ACTIVE', 'ADMIN')">
          <UIcon v-if="processingId === user.id" name="i-heroicons-arrow-path" class="h-4 w-4 animate-spin" />
          <UIcon v-else name="i-heroicons-shield-check" class="h-4 w-4" />
          <span>Make Admin</span>
        </button>
      </template>

      <!-- ACTIVE Admin -> Option to Demote to Creator -->
      <template v-else-if="user.role === 'ADMIN'">
        <button :disabled="processingId === user.id"
          class="flex-1 inline-flex items-center justify-center gap-1.5 rounded-lg bg-amber-600 px-3 py-2 text-xs font-semibold text-white transition hover:bg-amber-500 disabled:opacity-50"
          @click="emit('update-status', user.id, 'ACTIVE', 'CREATOR')">
          <UIcon v-if="processingId === user.id" name="i-heroicons-arrow-path" class="h-4 w-4 animate-spin" />
          <UIcon v-else name="i-heroicons-user" class="h-4 w-4" />
          <span>Demote to Creator</span>
        </button>
      </template>

      <!-- ACTIVE Creator -> Option to Promote to Admin -->
      <template v-else>
        <button :disabled="processingId === user.id"
          class="flex-1 inline-flex items-center justify-center gap-1.5 rounded-lg bg-indigo-600 px-3 py-2 text-xs font-semibold text-white transition hover:bg-indigo-500 disabled:opacity-50"
          @click="emit('update-status', user.id, 'ACTIVE', 'ADMIN')">
          <UIcon v-if="processingId === user.id" name="i-heroicons-arrow-path" class="h-4 w-4 animate-spin" />
          <UIcon v-else name="i-heroicons-shield-check" class="h-4 w-4" />
          <span class="text-xs">Promote to Admin</span>
        </button>
      </template>

      <!-- Suspend Button (for ACTIVE/PENDING) -->
      <button v-if="user.status !== 'SUSPENDED'" :disabled="processingId === user.id"
        class="inline-flex items-center justify-center gap-1 rounded-lg border border-red-500/30 bg-red-500/10 px-2.5 py-2 text-xs font-semibold text-red-400 transition hover:bg-red-500/20 disabled:opacity-50"
        @click="emit('update-status', user.id, 'SUSPENDED')">
        <UIcon name="i-heroicons-x-mark" class="h-4 w-4" />
      </button>

      <!-- Reactivate Button (if SUSPENDED) -->
      <button v-else :disabled="processingId === user.id"
        class="inline-flex items-center justify-center gap-1 rounded-lg bg-emerald-600 px-2.5 py-2 text-xs font-semibold text-white transition hover:bg-emerald-500 disabled:opacity-50"
        @click="emit('update-status', user.id, 'ACTIVE', (user.role as any) || 'CREATOR')">
        <UIcon name="i-heroicons-arrow-path" class="h-4 w-4" />
      </button>

      <!-- Delete Creator Account Button (Only for CREATOR role) -->
      <button v-if="user.role !== 'ADMIN'" :disabled="processingId === user.id"
        class="inline-flex items-center justify-center gap-1 rounded-lg border border-red-600/40 bg-red-600/20 px-2.5 py-2 text-xs font-semibold text-red-300 transition hover:bg-red-600/30 disabled:opacity-50"
        title="Delete Creator Account" @click="emit('open-delete', user)">
        <UIcon name="i-heroicons-trash" class="h-4 w-4" />
      </button>

      <button class="rounded-lg border border-gray-800 bg-gray-800 p-2 text-gray-400 hover:text-white transition"
        title="Inspect Details" @click="emit('inspect', user)">
        <UIcon name="i-heroicons-eye" class="h-4 w-4" />
      </button>
    </div>
  </div>
</template>
