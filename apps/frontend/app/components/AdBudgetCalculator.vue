<script setup lang="ts">
import { ref, computed } from 'vue'

const monthlyBudget = ref(10000)

// Financial calculations
const web2TakeRate = 0.30 // 30% Google/Meta middleman take
const web3ProtocolFeeRate = 0.005 // 0.5% smart contract protocol fee

const web2Fees = computed(() => monthlyBudget.value * web2TakeRate)
const web2EffectiveDelivery = computed(() => monthlyBudget.value - web2Fees.value)

const web3Fees = computed(() => monthlyBudget.value * web3ProtocolFeeRate)
const web3EffectiveDelivery = computed(() => monthlyBudget.value - web3Fees.value)

const netBudgetSaved = computed(() => web2Fees.value - web3Fees.value)

const estimatedImpressions = computed(() => {
  const cpm = 4.50 // $4.50 per 1,000 impressions baseline
  return Math.round((web3EffectiveDelivery.value / cpm) * 1000)
})

function formatCurrency(val: number): string {
  return new Intl.NumberFormat('en-US', { style: 'currency', currency: 'USD', maximumFractionDigits: 0 }).format(val)
}
</script>

<template>
  <div class="p-6 md:p-8 rounded-2xl bg-gray-900/90 border border-gray-800 backdrop-blur shadow-2xl space-y-6">
    <div class="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
      <div>
        <div class="inline-flex items-center gap-1.5 px-2.5 py-1 rounded-full bg-emerald-500/10 text-emerald-400 text-xs font-semibold border border-emerald-500/20 mb-2">
          <UIcon name="i-heroicons-calculator" class="w-3.5 h-3.5" />
          <span>Interactive SaaS ROI Calculator</span>
        </div>
        <h3 class="text-xl font-bold text-white">Compare Ad Budget Efficiency</h3>
        <p class="text-xs text-gray-400">See how much ad budget goes directly to verified impressions vs traditional middleman markups.</p>
      </div>

      <div class="bg-gray-800/80 px-4 py-2 rounded-xl border border-gray-700/60 text-right">
        <span class="text-[10px] text-gray-400 uppercase font-semibold block">Monthly Ad Deposit</span>
        <span class="text-2xl font-extrabold text-emerald-400 font-mono">{{ formatCurrency(monthlyBudget) }}</span>
      </div>
    </div>

    <!-- Budget Slider -->
    <div class="space-y-2">
      <div class="flex justify-between text-xs text-gray-400 font-medium">
        <span>$1,000 / mo</span>
        <span>$50,000 / mo</span>
        <span>$100,000 / mo</span>
      </div>
      <input
        v-model.number="monthlyBudget"
        type="range"
        min="1000"
        max="100000"
        step="1000"
        class="w-full h-2 bg-gray-800 rounded-lg appearance-none cursor-pointer accent-emerald-500"
      />
    </div>

    <!-- Efficiency Comparison Grid -->
    <div class="grid grid-cols-1 md:grid-cols-2 gap-4 pt-2">
      <!-- Web2 Legacy Ad Networks -->
      <div class="p-4 rounded-xl bg-red-950/20 border border-red-900/30 space-y-3">
        <div class="flex items-center justify-between">
          <span class="text-xs font-bold text-red-400 uppercase tracking-wider">Traditional Ad Networks</span>
          <UBadge color="error" variant="subtle" size="xs">30% Middleman Take</UBadge>
        </div>

        <div class="space-y-1.5 text-xs">
          <div class="flex justify-between text-gray-400">
            <span>Opaque Network Fees:</span>
            <span class="font-mono text-red-300 font-semibold">{{ formatCurrency(web2Fees) }}</span>
          </div>
          <div class="flex justify-between text-gray-400">
            <span>Effective Ad Delivery:</span>
            <span class="font-mono text-gray-300 font-bold">{{ formatCurrency(web2EffectiveDelivery) }}</span>
          </div>
        </div>

        <div class="pt-2 border-t border-red-900/30 text-[11px] text-red-300/80 flex items-center gap-1.5">
          <UIcon name="i-heroicons-exclamation-triangle" class="w-4 h-4 shrink-0" />
          <span>Over 30% of your budget is lost to network markups and fraud.</span>
        </div>
      </div>

      <!-- DecAds Protocol Escrow -->
      <div class="p-4 rounded-xl bg-emerald-950/30 border border-emerald-500/40 space-y-3 relative overflow-hidden">
        <div class="absolute -right-10 -bottom-10 w-32 h-32 bg-emerald-500/10 rounded-full blur-2xl pointer-events-none" />

        <div class="flex items-center justify-between">
          <span class="text-xs font-bold text-emerald-400 uppercase tracking-wider">DecAds Smart Protocol</span>
          <UBadge color="success" variant="subtle" size="xs">0.5% Protocol Fee</UBadge>
        </div>

        <div class="space-y-1.5 text-xs">
          <div class="flex justify-between text-gray-400">
            <span>Smart Contract Fee:</span>
            <span class="font-mono text-emerald-400 font-semibold">{{ formatCurrency(web3Fees) }}</span>
          </div>
          <div class="flex justify-between text-gray-400">
            <span>Net Ad Inventory Escrow:</span>
            <span class="font-mono text-white font-extrabold text-sm">{{ formatCurrency(web3EffectiveDelivery) }}</span>
          </div>
        </div>

        <div class="pt-2 border-t border-emerald-500/30 text-[11px] text-emerald-300 flex items-center justify-between">
          <span class="font-semibold">Budget Recovered to Ads:</span>
          <span class="font-mono font-bold text-emerald-400 text-xs">+{{ formatCurrency(netBudgetSaved) }} / mo</span>
        </div>
      </div>
    </div>

    <!-- Impression Impact Summary Bar -->
    <div class="p-4 rounded-xl bg-gray-800/60 border border-gray-700/60 flex flex-col sm:flex-row items-center justify-between gap-3 text-xs">
      <div class="flex items-center gap-3">
        <div class="w-8 h-8 rounded-lg bg-emerald-500/20 text-emerald-400 flex items-center justify-center shrink-0">
          <UIcon name="i-heroicons-sparkles" class="w-4 h-4" />
        </div>
        <div>
          <div class="text-white font-semibold">Estimated Monthly Verified Impressions</div>
          <div class="text-gray-400 text-[11px]">Based on ~$4.50 CPM on-chain escrow verification</div>
        </div>
      </div>

      <div class="text-right sm:text-right w-full sm:w-auto">
        <span class="text-lg font-mono font-extrabold text-white block">{{ estimatedImpressions.toLocaleString('en-US') }}</span>
        <span class="text-[10px] text-emerald-400 font-semibold">Verified On-Chain</span>
      </div>
    </div>
  </div>
</template>
