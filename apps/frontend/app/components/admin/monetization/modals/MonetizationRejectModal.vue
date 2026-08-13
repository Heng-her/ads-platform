<script setup lang="ts">
import type { WithdrawalRequest } from '../MonetizationPayoutQueueTable.vue'

const isOpen = defineModel<boolean>('open', { default: false })
const reasonInput = defineModel<string>('reason', { default: '' })

defineProps<{
  selectedRequest: WithdrawalRequest | null
  isProcessing: boolean
}>()

const emit = defineEmits<{
  (e: 'confirm'): void
}>()
</script>

<template>
  <UModal v-model:open="isOpen" title="Reject Payout Request">
    <template #content>
      <div v-if="selectedRequest" class="p-6 space-y-4">
        <div class="p-4 rounded-xl bg-red-950/30 border border-red-500/30 space-y-2">
          <p class="text-xs font-semibold text-red-400">Rejecting Request #{{ selectedRequest.id }}</p>
          <p class="text-xl font-bold text-white">${{ selectedRequest.amount.toFixed(2) }} USD for {{ selectedRequest.creatorName }}</p>
          <p class="text-xs text-gray-400">The requested amount will be refunded back to the creator's balance.</p>
        </div>

        <div class="space-y-1">
          <label class="block text-xs font-semibold text-gray-300">Rejection Reason Note</label>
          <textarea
            v-model="reasonInput"
            rows="3"
            placeholder="e.g. Wallet address format is invalid."
            class="w-full rounded-lg border border-gray-700 bg-gray-800 p-3 text-xs text-white focus:border-red-500 focus:outline-none"
          />
        </div>

        <div class="flex justify-end gap-3 pt-2">
          <UButton color="neutral" variant="ghost" @click="isOpen = false">Cancel</UButton>
          <UButton color="error" variant="solid" :loading="isProcessing" @click="emit('confirm')">
            Confirm Rejection
          </UButton>
        </div>
      </div>
    </template>
  </UModal>
</template>
