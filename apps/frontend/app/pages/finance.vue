<script setup lang="ts">
import { useCustomSeoMeta } from '~/lib/seo/metadata'

useCustomSeoMeta({
  title: 'Finance Dashboard',
  description: 'Manage payments, invoices, and analytics on AdsPlatform.',
  path: '/finance'
})

const stats = [
  { label: 'Total Earnings', value: '$12,482.90', change: '+14.2%', icon: 'i-heroicons-banknotes', color: 'primary' },
  { label: 'Average CPC', value: '$0.42', change: '+2.8%', icon: 'i-heroicons-cursor-arrow-rays', color: 'info' },
  { label: 'Active Campaigns', value: '8', change: '0.0%', icon: 'i-heroicons-megaphone', color: 'neutral' }
]

const recentTransactions = [
  { id: 'TX-1092', date: 'July 22, 2026', type: 'Payout', amount: '$340.50', status: 'Completed' },
  { id: 'TX-1091', date: 'July 15, 2026', type: 'Ad Budget Deposit', amount: '+$500.00', status: 'Completed' },
  { id: 'TX-1090', date: 'July 01, 2026', type: 'Payout', amount: '$290.15', status: 'Completed' }
]
</script>

<template>
  <UContainer class="py-10 max-w-4xl space-y-8">
    <div class="space-y-2">
      <h1 class="text-3xl font-extrabold tracking-tight text-gray-900 dark:text-gray-100 flex items-center gap-2">
        <UIcon name="i-heroicons-banknotes" class="w-8 h-8 text-primary" />
        Finance & Payments
      </h1>
      <p class="text-gray-500 dark:text-gray-400 text-lg">
        Monitor your ad spending, payouts, and billing history.
      </p>
    </div>

    <!-- Stats Grid -->
    <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
      <UCard v-for="(stat, idx) in stats" :key="idx" class="relative overflow-hidden">
        <div class="flex items-center justify-between">
          <div class="space-y-1">
            <span class="text-sm font-medium text-gray-500 dark:text-gray-400">{{ stat.label }}</span>
            <div class="text-2xl font-bold text-gray-900 dark:text-gray-100">
              {{ stat.value }}
            </div>
          </div>
          <div class="p-3 rounded-lg bg-gray-100 dark:bg-gray-800 text-primary">
            <UIcon :name="stat.icon" class="w-6 h-6" />
          </div>
        </div>
        <div class="mt-4 flex items-center gap-1.5 text-xs text-green-500 font-medium">
          <UIcon name="i-heroicons-arrow-trending-up" class="w-4 h-4" />
          <span>{{ stat.change }} from last month</span>
        </div>
      </UCard>
    </div>

    <!-- Transactions Table -->
    <UCard>
      <template #header>
        <div class="flex items-center justify-between">
          <h2 class="text-lg font-bold text-gray-900 dark:text-gray-100">
            Recent Billing Transactions
          </h2>
          <UButton size="sm" color="neutral" variant="outline" icon="i-heroicons-arrow-down-tray">
            Download PDF
          </UButton>
        </div>
      </template>

      <div class="overflow-x-auto">
        <table class="w-full text-left border-collapse text-sm">
          <thead>
            <tr class="border-b border-gray-200 dark:border-gray-800 text-gray-400">
              <th class="py-3 px-4 font-semibold">Transaction ID</th>
              <th class="py-3 px-4 font-semibold">Date</th>
              <th class="py-3 px-4 font-semibold">Type</th>
              <th class="py-3 px-4 font-semibold">Amount</th>
              <th class="py-3 px-4 font-semibold">Status</th>
            </tr>
          </thead>
          <tbody class="divide-y divide-gray-100 dark:divide-gray-800">
            <tr v-for="tx in recentTransactions" :key="tx.id" class="text-gray-700 dark:text-gray-300">
              <td class="py-3.5 px-4 font-mono text-xs">{{ tx.id }}</td>
              <td class="py-3.5 px-4">{{ tx.date }}</td>
              <td class="py-3.5 px-4">{{ tx.type }}</td>
              <td class="py-3.5 px-4 font-semibold" :class="tx.amount.startsWith('+') ? 'text-green-500' : 'text-gray-900 dark:text-gray-100'">
                {{ tx.amount }}
              </td>
              <td class="py-3.5 px-4">
                <UBadge color="success" variant="subtle" size="sm">
                  {{ tx.status }}
                </UBadge>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </UCard>
  </UContainer>
</template>
