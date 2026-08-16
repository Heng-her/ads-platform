<script setup lang="ts">
import { ref, computed } from 'vue'
import type { UserRecord } from './ApprovalsUserCard.vue'

const props = defineProps<{
  open: boolean
  creatorToDelete: UserRecord | null
  adminDeletePassword: string
  isDeleting: boolean
  deleteErrorMessage: string
}>()

const emit = defineEmits<{
  (e: 'update:open', val: boolean): void
  (e: 'update:adminDeletePassword', val: string): void
  (e: 'close'): void
  (e: 'confirm'): void
}>()

const showPassword = ref(false)

const isOpen = computed({
  get: () => props.open,
  set: (val: boolean) => emit('update:open', val)
})

const passwordModel = computed({
  get: () => props.adminDeletePassword,
  set: (val: string) => emit('update:adminDeletePassword', val)
})
</script>

<template>
  <div v-if="isOpen && creatorToDelete"
    class="fixed inset-0 z-50 flex items-center justify-center bg-black/80 p-4 backdrop-blur-xs">
    <div
      class="w-full max-w-md rounded-2xl border border-red-900/50 bg-gray-900 p-6 shadow-2xl space-y-5 text-gray-100">
      <div class="flex items-center justify-between border-b border-gray-800 pb-3">
        <div class="flex items-center gap-2.5 text-red-400">
          <UIcon name="i-heroicons-trash" class="h-6 w-6" />
          <h2 class="text-lg font-bold text-white">Delete Creator Account</h2>
        </div>
        <button class="text-gray-400 hover:text-white" @click="emit('close')">
          <UIcon name="i-heroicons-x-mark" class="h-5 w-5" />
        </button>
      </div>

      <div class="rounded-xl border border-red-900/40 bg-red-950/30 p-4 space-y-2">
        <p class="text-xs text-red-200">
          You are about to permanently delete this creator account. This action <b>cannot be undone</b>.
        </p>
        <div class="space-y-1 text-xs text-gray-300 border-t border-red-900/30 pt-2 font-mono">
          <div><span class="text-gray-400 font-sans">Username:</span> <strong class="text-white">{{
            creatorToDelete.username }}</strong></div>
          <div><span class="text-gray-400 font-sans">Email:</span> <strong class="text-white">{{ creatorToDelete.email
          }}</strong></div>
          <div><span class="text-gray-400 font-sans">User ID:</span> {{ creatorToDelete.id }}</div>
        </div>
      </div>

      <div class="space-y-2">
        <label class="block text-xs font-semibold text-gray-300">
          Enter Admin Creator Deletion Password to Confirm:
        </label>
        <div class="relative">
          <input v-model="passwordModel" :type="showPassword ? 'text' : 'password'"
            placeholder="Enter deletion security password"
            class="w-full rounded-lg border border-gray-700 bg-gray-950 py-2.5 pl-3.5 pr-10 text-sm text-white focus:border-red-500 focus:outline-none focus:ring-2 focus:ring-red-500/20 font-mono"
            @keyup.enter="emit('confirm')" />
          <button type="button" class="absolute right-3 top-1/2 -translate-y-1/2 text-gray-400 hover:text-white"
            @click="showPassword = !showPassword">
            <UIcon :name="showPassword ? 'i-heroicons-eye-slash' : 'i-heroicons-eye'" class="h-4 w-4" />
          </button>
        </div>
        <p v-if="deleteErrorMessage" class="text-xs text-red-400 font-semibold flex items-center gap-1 mt-1">
          <UIcon name="i-heroicons-exclamation-circle" class="h-4 w-4 shrink-0" />
          <span>{{ deleteErrorMessage }}</span>
        </p>
      </div>

      <div class="flex items-center justify-end gap-3 border-t border-gray-800 pt-4">
        <button type="button"
          class="rounded-lg border border-gray-700 bg-gray-800 px-4 py-2 text-xs font-semibold text-gray-300 hover:bg-gray-700 hover:text-white transition"
          @click="emit('close')">
          Cancel
        </button>

        <button type="button" :disabled="isDeleting || !adminDeletePassword.trim()"
          class="inline-flex items-center gap-1.5 rounded-lg bg-red-600 px-4 py-2 text-xs font-semibold text-white transition hover:bg-red-500 disabled:opacity-50"
          @click="emit('confirm')">
          <UIcon v-if="isDeleting" name="i-heroicons-arrow-path" class="h-4 w-4 animate-spin" />
          <UIcon v-else name="i-heroicons-trash" class="h-4 w-4" />
          <span>{{ isDeleting ? 'Deleting...' : 'Confirm & Delete Creator' }}</span>
        </button>
      </div>
    </div>
  </div>
</template>
