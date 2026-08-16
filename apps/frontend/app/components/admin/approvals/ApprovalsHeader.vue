<script setup lang="ts">
defineProps<{
  pendingUsersCount: number
  isLoading: boolean
}>()

const emit = defineEmits<{
  (e: 'refresh'): void
}>()
</script>

<template>
  <div class="flex flex-col gap-4 sm:flex-row sm:items-center sm:justify-between">
    <div>
      <div class="flex items-center gap-3">
        <h1 class="text-2xl font-bold tracking-tight text-white sm:text-3xl">User Accounts & Verification</h1>
        <UBadge v-if="pendingUsersCount > 0" color="warning" variant="solid" class="font-mono text-xs">
          {{ pendingUsersCount }} PENDING REVIEWS
        </UBadge>
      </div>
      <p class="mt-1 text-sm text-gray-400">
        Manage platform user registrations, verify new creators, assign Admin roles, or suspend accounts.
      </p>
    </div>

    <div class="flex items-center gap-3">
      <button :disabled="isLoading"
        class="inline-flex items-center gap-2 rounded-lg border border-gray-800 bg-gray-900 px-4 py-2.5 text-xs font-semibold text-gray-300 transition hover:bg-gray-800 hover:text-white disabled:opacity-50"
        @click="emit('refresh')">
        <UIcon v-if="isLoading" name="i-heroicons-arrow-path" class="h-4 w-4 animate-spin text-primary-400" />
        <UIcon v-else name="i-heroicons-arrow-path" class="h-4 w-4 text-gray-400" />
        <span>{{ isLoading ? 'Refreshing...' : 'Refresh List' }}</span>
      </button>
    </div>
  </div>
</template>
