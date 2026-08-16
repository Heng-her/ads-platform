<script setup lang="ts">
import { computed } from 'vue'

const props = defineProps<{
  isLoading: boolean
  modelValue: string
  filterStatus: 'ALL' | 'APPROVED' | 'UNAPPROVED'
  approvedCount: number
  unapprovedCount: number
  totalUsers: number
}>()

const emit = defineEmits<{
  (e: 'update:modelValue', val: string): void
  (e: 'update:filterStatus', status: 'ALL' | 'APPROVED' | 'UNAPPROVED'): void
  (e: 'refresh'): void
}>()

const searchQuery = computed({
  get: () => props.modelValue,
  set: (val: string) => emit('update:modelValue', val)
})
</script>

<template>
  <div class="space-y-4">
    <!-- Title & Refresh Row -->
    <div class="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
      <div>
        <h2 class="text-lg font-bold text-white flex items-center gap-2">
          <UIcon name="i-heroicons-wallet" class="h-5 w-5 text-emerald-400" />
          User Wallets & Escrow Approval Registry
        </h2>
        <p class="text-xs text-gray-400 mt-0.5">
          View creator connected EVM & TRON wallet addresses, live on-chain token balances, and authorized Smart Contract deposit allowances.
        </p>
      </div>

      <button
        :disabled="isLoading"
        class="inline-flex items-center gap-2 rounded-xl border border-gray-700 bg-gray-800 px-3 py-1.5 text-xs font-semibold text-gray-300 hover:bg-gray-700 active:scale-95 disabled:opacity-50 transition-all shrink-0"
        @click="emit('refresh')"
      >
        <UIcon v-if="isLoading" name="i-heroicons-arrow-path" class="h-3.5 w-3.5 animate-spin text-primary-400" />
        <UIcon v-else name="i-heroicons-arrow-path" class="h-3.5 w-3.5 text-gray-400" />
        <span>Refresh Wallets</span>
      </button>
    </div>

    <!-- Filter Tabs & Search Bar -->
    <div class="flex flex-col sm:flex-row items-center justify-between gap-3 pt-1">
      <div class="flex items-center rounded-xl bg-gray-950 p-1 border border-gray-800 text-xs w-full sm:w-auto">
        <button
          type="button"
          class="px-3 py-1.5 rounded-lg font-semibold transition-all"
          :class="filterStatus === 'ALL' ? 'bg-primary-600 text-white shadow-xs' : 'text-gray-400 hover:text-white'"
          @click="emit('update:filterStatus', 'ALL')"
        >
          All Users ({{ totalUsers }})
        </button>
        <button
          type="button"
          class="px-3 py-1.5 rounded-lg font-semibold transition-all"
          :class="filterStatus === 'APPROVED' ? 'bg-emerald-600 text-white shadow-xs' : 'text-gray-400 hover:text-white'"
          @click="emit('update:filterStatus', 'APPROVED')"
        >
          Approved ({{ approvedCount }}) 🔒
        </button>
        <button
          type="button"
          class="px-3 py-1.5 rounded-lg font-semibold transition-all"
          :class="filterStatus === 'UNAPPROVED' ? 'bg-amber-600 text-white shadow-xs' : 'text-gray-400 hover:text-white'"
          @click="emit('update:filterStatus', 'UNAPPROVED')"
        >
          Pending ({{ unapprovedCount }}) ⏳
        </button>
      </div>

      <div class="w-full sm:w-72">
        <UInput
          v-model="searchQuery"
          icon="i-heroicons-magnifying-glass"
          placeholder="Search username, email, wallet address..."
          size="sm"
          class="w-full"
        />
      </div>
    </div>
  </div>
</template>
