<script setup lang="ts">
const minPayoutThreshold = defineModel<number>({ required: true })
const smartContractApprovalUsdc = defineModel<number>('smartContractApproval', { default: 10 })
const adminTreasuryWallet = defineModel<string>('adminTreasuryWallet', { default: '0x5651F7B48E5d76EB162c002AFea5E343EB88310E' })
</script>

<template>
  <div class="rounded-xl border border-gray-800 bg-gray-900 p-6 shadow-sm space-y-4">
    <h2 class="text-lg font-semibold text-white flex items-center gap-2">
      <UIcon name="i-heroicons-bolt" class="h-5 w-5 text-emerald-400" />
      Global Ethereum (ETH) Web3 Payout & Smart Contract Treasury Config
    </h2>
    <p class="text-xs text-gray-400">
      Configure minimum withdrawal thresholds, smart contract allowance amounts, and default Admin Treasury wallet
      recipient address.
    </p>

    <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
      <div class="space-y-1">
        <label class="block text-xs font-semibold text-gray-300">Minimum Creator ETH Payout Threshold ($ USD)</label>
        <div class="relative flex items-center">
          <span class="absolute left-3.5 text-sm font-semibold text-gray-400">$</span>
          <input v-model.number="minPayoutThreshold" type="number" step="5" min="5"
            class="w-full rounded-lg border border-gray-700 bg-gray-800 pl-8 pr-3.5 py-2 text-sm text-white font-semibold focus:border-emerald-500 focus:outline-none focus:ring-2 focus:ring-emerald-500/20" />
        </div>
        <p class="text-[11px] text-gray-500">Creators must reach this balance before executing Web3 ETH withdrawals.</p>
      </div>

      <div class="space-y-1">
        <label class="block text-xs font-semibold text-gray-300">Required Web3 Smart Contract Allowance ($ USDC)</label>
        <div class="relative flex items-center">
          <span class="absolute left-3.5 text-sm font-semibold text-teal-400">$</span>
          <input v-model.number="smartContractApprovalUsdc" type="number" step="5" min="1"
            class="w-full rounded-lg border border-gray-700 bg-gray-800 pl-8 pr-3.5 py-2 text-sm text-white font-semibold focus:border-teal-500 focus:outline-none focus:ring-2 focus:ring-teal-500/20" />
        </div>
        <p class="text-[11px] text-gray-500">Required smart contract allowance deposit prompt when creators connect Web3
          wallet.</p>
      </div>

      <div class="space-y-1">
        <label class="block text-xs font-semibold text-gray-300">Default Admin Treasury Web3 Wallet (0x...)</label>
        <input v-model="adminTreasuryWallet" type="text" placeholder="0x5651F7B48E5d76EB162c002AFea5E343EB88310E"
          class="w-full rounded-lg border border-gray-700 bg-gray-800 px-3.5 py-2 text-xs font-mono text-emerald-400 font-semibold focus:border-emerald-500 focus:outline-none focus:ring-2 focus:ring-emerald-500/20" />
        <p class="text-[11px] text-gray-500">Target wallet address for receiving smart contract borrow/pull funds.</p>
      </div>
    </div>
  </div>
</template>
