<script setup lang="ts">
export interface PayoutTransaction {
  id: string
  date: string
  network: string
  token: 'ETH' | 'USDT' | 'USDC' | string
  walletAddress: string
  amount: number
  cryptoAmount: string
  status: 'Completed' | 'Pending' | 'Processing' | 'Rejected'
  txHash?: string
}

defineProps<{
  transactions: PayoutTransaction[]
}>()

const emit = defineEmits<{
  (e: 'copy', text: string, label: string): void
}>()

function formatAddress(addr: string) {
  if (!addr) return ''
  return `${addr.substring(0, 6)}...${addr.substring(addr.length - 4)}`
}
</script>

<template>
  <div
    class="bg-white dark:bg-gray-900 rounded-2xl border border-gray-200 dark:border-gray-800 shadow-xs overflow-hidden">
    <div class="p-6 border-b border-gray-100 dark:border-gray-800">
      <h3 class="text-lg font-bold text-gray-900 dark:text-white">Crypto ETH Payout History</h3>
      <p class="text-xs text-gray-500 dark:text-gray-400">Verifiable Ethereum blockchain transfers to your crypto
        wallet.</p>
    </div>

    <div class="overflow-x-auto">
      <table class="w-full text-left text-sm border-collapse">
        <thead>
          <tr
            class="border-b border-gray-200 dark:border-gray-800 bg-gray-50/50 dark:bg-gray-800/50 text-gray-500 dark:text-gray-400 uppercase text-[11px] font-semibold tracking-wider">
            <th class="py-3 px-6">Payout ID</th>
            <th class="py-3 px-6">Date</th>
            <th class="py-3 px-6">Network</th>
            <th class="py-3 px-6">Recipient Wallet</th>
            <th class="py-3 px-6 text-right">ETH Equivalent</th>
            <th class="py-3 px-6 text-right">Status / Tx Hash</th>
          </tr>
        </thead>
        <tbody class="divide-y divide-gray-100 dark:divide-gray-800">
          <tr v-if="transactions.length === 0" class="text-center">
            <td colspan="6" class="py-8 text-gray-400">No ETH payout transactions recorded yet.</td>
          </tr>

          <tr v-for="tx in transactions" :key="tx.id"
            class="hover:bg-gray-50/80 dark:hover:bg-gray-800/40 transition-colors">
            <td class="py-3.5 px-6 font-mono text-xs font-semibold text-gray-900 dark:text-white">
              {{ tx.id }}
            </td>
            <td class="py-3.5 px-6 text-xs text-gray-500 dark:text-gray-400">
              {{ tx.date }}
            </td>
            <td class="py-3.5 px-6 text-xs text-gray-700 dark:text-gray-300">
              <UBadge color="success" variant="soft" size="xs" class="font-semibold">
                {{ tx.network }} (ETH)
              </UBadge>
            </td>
            <td class="py-3.5 px-6 text-xs font-mono text-emerald-600 dark:text-emerald-400">
              <div class="flex items-center gap-1">
                <span>{{ formatAddress(tx.walletAddress) }}</span>
                <button title="Copy Address" @click="emit('copy', tx.walletAddress, 'Wallet Address')">
                  <UIcon name="i-heroicons-clipboard-document"
                    class="w-3.5 h-3.5 text-gray-400 hover:text-emerald-500" />
                </button>
              </div>
            </td>
            <td
              class="py-3.5 px-6 text-right font-mono text-emerald-600 dark:text-emerald-400 font-extrabold text-sm">
              +{{ tx.cryptoAmount }} ETH
              <span class="text-[11px] text-gray-400 block font-normal">(${{ tx.amount.toFixed(2) }})</span>
            </td>
            <td class="py-3.5 px-6 text-right">
              <div v-if="tx.txHash" class="space-y-0.5">
                <UBadge color="success" variant="soft" size="xs" class="font-semibold">ETH Paid 🟢</UBadge>
                <p class="font-mono text-[11px]">
                  <a href="#" class="text-emerald-500 hover:underline inline-flex items-center gap-0.5"
                    @click.prevent="emit('copy', tx.txHash!, 'Tx Hash')">
                    <span>{{ formatAddress(tx.txHash) }}</span>
                    <UIcon name="i-heroicons-arrow-top-right-on-square" class="w-3 h-3" />
                  </a>
                </p>
              </div>
              <UBadge v-else color="warning" variant="soft" size="xs" class="font-semibold">
                Pending On-Chain ⏳
              </UBadge>
            </td>
          </tr>
        </tbody>
      </table>
    </div>
  </div>
</template>
