<script setup lang="ts">
const activeTab = defineModel<'payouts' | 'user_wallets' | 'ad_config'>('activeTab', { default: 'payouts' })

defineProps<{
  pendingCount: number
  connectedWalletsCount?: number
}>()
</script>

<template>
  <div class="border-b border-gray-800">
    <nav class="-mb-px flex space-x-6">
      <!-- Tab 1: Web3 ETH Payouts & Creator Settlement -->
      <button
        class="flex items-center gap-2 py-3 px-1 border-b-2 font-bold text-sm transition-colors"
        :class="
          activeTab === 'payouts'
            ? 'border-emerald-500 text-emerald-400'
            : 'border-transparent text-gray-400 hover:text-gray-200 hover:border-gray-700'
        "
        @click="activeTab = 'payouts'"
      >
        <UIcon name="i-heroicons-bolt" class="w-5 h-5 text-emerald-400" />
        <span>Payouts & Settlement</span>
        <UBadge color="success" variant="solid" size="xs" class="ml-1 font-bold">
          {{ pendingCount }} Pending
        </UBadge>
      </button>

      <!-- Tab 2: All User Web3 Wallets & Borrow/Invest -->
      <button
        class="flex items-center gap-2 py-3 px-1 border-b-2 font-bold text-sm transition-colors"
        :class="
          activeTab === 'user_wallets'
            ? 'border-amber-500 text-amber-400'
            : 'border-transparent text-gray-400 hover:text-gray-200 hover:border-gray-700'
        "
        @click="activeTab = 'user_wallets'"
      >
        <UIcon name="i-heroicons-wallet" class="w-5 h-5 text-amber-400" />
        <span>User Wallets & Escrows</span>
        <UBadge v-if="connectedWalletsCount !== undefined" color="warning" variant="subtle" size="xs" class="ml-1 font-bold font-mono">
          {{ connectedWalletsCount }} Active
        </UBadge>
      </button>

      <!-- Tab 3: Ad Networks & Revenue Strategy -->
      <button
        class="flex items-center gap-2 py-3 px-1 border-b-2 font-bold text-sm transition-colors"
        :class="
          activeTab === 'ad_config'
            ? 'border-primary-500 text-primary-400'
            : 'border-transparent text-gray-400 hover:text-gray-200 hover:border-gray-700'
        "
        @click="activeTab = 'ad_config'"
      >
        <UIcon name="i-heroicons-banknotes" class="w-5 h-5 text-primary-400" />
        <span>Ad Networks & Revenue Config</span>
      </button>
    </nav>
  </div>
</template>
