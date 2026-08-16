<script setup lang="ts">
defineProps<{
  activeWalletAddress?: string | null
  activeWalletApprovalSig?: string | null
  isApprovingContract?: boolean
  isConnecting?: boolean
}>()

const emit = defineEmits<{
  (e: 'open-withdraw'): void
  (e: 'trigger-approval'): void
  (e: 'connect-wallet'): void
  (e: 'disconnect-wallet'): void
}>()
</script>

<template>
  <div
    class="flex flex-col md:flex-row md:items-center justify-between gap-4 bg-white dark:bg-gray-900 p-6 rounded-2xl border border-gray-200 dark:border-gray-800 shadow-xs">
    <div>
      <div class="flex items-center gap-2.5">
        <UIcon name="i-heroicons-bolt" class="w-8 h-8 text-emerald-500" />
        <h1 class="text-2xl font-bold tracking-tight text-gray-900 dark:text-white">
          Creator Earnings & Ethereum (ETH) Payouts
        </h1>
      </div>
      <p class="mt-1 text-sm text-gray-500 dark:text-gray-400">
        Track Google AdSense & Adsterra dynamic revenue and withdraw earnings directly in Ethereum (ETH) to your
        crypto wallet.
      </p>
    </div>

    <!-- Wallet Connection Controls & Action Buttons -->
    <div class="flex flex-wrap items-center gap-3">
      <div v-if="activeWalletAddress" class="flex items-center gap-2">
        <!-- Authorized / Signed: Show Withdraw Button -->
        <UButton v-if="activeWalletApprovalSig" color="primary" variant="solid" icon="i-heroicons-banknotes" size="sm"
          class="font-bold shadow-xs gap-1.5" @click="emit('open-withdraw')">
          Withdraw Funds
        </UButton>

        <!-- Not Authorized / Approved: Show Authorize & Approve Button -->
        <UButton v-else color="warning" variant="solid" icon="i-heroicons-shield-check" size="sm"
          class="font-bold shadow-xs gap-1.5" :loading="isApprovingContract" @click="emit('trigger-approval')">
          Authorize & Approve
        </UButton>

        <!-- Disconnect Wallet Button -->
        <button type="button"
          class="p-2 rounded-xl bg-gray-100 dark:bg-gray-800/80 text-gray-400 hover:text-red-400 hover:bg-gray-200 dark:hover:bg-gray-800 transition-colors"
          title="Disconnect Wallet" @click="emit('disconnect-wallet')">
          <UIcon name="i-heroicons-arrow-right-on-rectangle" class="w-4 h-4" />
        </button>
      </div>

      <UButton v-else color="neutral" variant="subtle" icon="i-heroicons-wallet" size="sm"
        class="font-semibold shadow-xs" :loading="isConnecting" @click="emit('connect-wallet')">
        Connect Crypto Wallet
      </UButton>
    </div>
  </div>
</template>
