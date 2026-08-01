<script setup lang="ts">
import { ref } from 'vue'

const activeSandboxTab = ref<'campaigns' | 'analytics' | 'escrow'>('campaigns')
</script>

<template>
  <section class="max-w-6xl mx-auto space-y-8">
    <div class="text-center max-w-3xl mx-auto space-y-3">
      <UBadge color="primary" variant="subtle" class="font-mono text-xs uppercase">Interactive Sandbox</UBadge>
      <h2 class="text-3xl sm:text-4xl font-extrabold text-gray-900 dark:text-white">
        Real-Time Advertiser & Publisher Portal
      </h2>
      <p class="text-sm text-gray-600 dark:text-gray-400">
        Explore live campaign management, budget escrows, and CPM verification telemetry.
      </p>
    </div>

    <!-- Sandbox Container -->
    <div class="p-6 rounded-2xl bg-gray-950 border border-gray-800 shadow-2xl space-y-6">
      <!-- Sandbox Navigation -->
      <div class="flex flex-wrap items-center justify-between gap-4 border-b border-gray-800 pb-4">
        <div class="flex gap-2">
          <button
            type="button"
            class="px-4 py-1.5 rounded-lg text-xs font-semibold transition-all"
            :class="activeSandboxTab === 'campaigns' ? 'bg-emerald-500 text-gray-950 font-bold' : 'text-gray-400 hover:text-white bg-gray-900'"
            @click="activeSandboxTab = 'campaigns'"
          >
            Active Campaigns
          </button>
          <button
            type="button"
            class="px-4 py-1.5 rounded-lg text-xs font-semibold transition-all"
            :class="activeSandboxTab === 'analytics' ? 'bg-emerald-500 text-gray-950 font-bold' : 'text-gray-400 hover:text-white bg-gray-900'"
            @click="activeSandboxTab = 'analytics'"
          >
            CPM & Reach Telemetry
          </button>
          <button
            type="button"
            class="px-4 py-1.5 rounded-lg text-xs font-semibold transition-all"
            :class="activeSandboxTab === 'escrow' ? 'bg-emerald-500 text-gray-950 font-bold' : 'text-gray-400 hover:text-white bg-gray-900'"
            @click="activeSandboxTab = 'escrow'"
          >
            Escrow Audit Log
          </button>
        </div>

        <div class="text-xs font-mono text-gray-500 hidden sm:block">
          Connected Network: <span class="text-emerald-400">Arbitrum L2 Mainnet</span>
        </div>
      </div>

      <!-- Tab 1: Campaigns -->
      <div v-if="activeSandboxTab === 'campaigns'" class="space-y-4">
        <div class="grid grid-cols-1 md:grid-cols-2 gap-4 text-xs">
          <div class="p-4 rounded-xl bg-gray-900 border border-gray-800 space-y-3">
            <div class="flex items-center justify-between">
              <span class="font-bold text-white">DeFi Protocol Launch Campaign</span>
              <UBadge color="success" size="xs">Escrow Active</UBadge>
            </div>
            <div class="grid grid-cols-3 gap-2 py-2 font-mono text-[11px]">
              <div>
                <div class="text-gray-500">Budget Escrow</div>
                <div class="text-white font-semibold">$10,000 USDC</div>
              </div>
              <div>
                <div class="text-gray-500">Impressions</div>
                <div class="text-white font-semibold">1,240,000</div>
              </div>
              <div>
                <div class="text-gray-500">Avg. CPM</div>
                <div class="text-emerald-400 font-semibold">$4.20</div>
              </div>
            </div>
            <div class="w-full bg-gray-800 h-1.5 rounded-full overflow-hidden">
              <div class="bg-emerald-500 h-full w-[65%]" />
            </div>
          </div>

          <div class="p-4 rounded-xl bg-gray-900 border border-gray-800 space-y-3">
            <div class="flex items-center justify-between">
              <span class="font-bold text-white">Web3 Gaming NFT Sponsor</span>
              <UBadge color="success" size="xs">Escrow Active</UBadge>
            </div>
            <div class="grid grid-cols-3 gap-2 py-2 font-mono text-[11px]">
              <div>
                <div class="text-gray-500">Budget Escrow</div>
                <div class="text-white font-semibold">$15,000 USDC</div>
              </div>
              <div>
                <div class="text-gray-500">Impressions</div>
                <div class="text-white font-semibold">2,890,500</div>
              </div>
              <div>
                <div class="text-gray-500">Avg. CPM</div>
                <div class="text-emerald-400 font-semibold">$3.90</div>
              </div>
            </div>
            <div class="w-full bg-gray-800 h-1.5 rounded-full overflow-hidden">
              <div class="bg-emerald-500 h-full w-[82%]" />
            </div>
          </div>
        </div>
      </div>

      <!-- Tab 2: Analytics -->
      <div v-else-if="activeSandboxTab === 'analytics'" class="p-6 rounded-xl bg-gray-900 border border-gray-800 text-center space-y-4">
        <div class="text-xs font-mono text-gray-400">Simulated 24-Hour Impression & Payout Velocity (Mock Telemetry)</div>
        <div class="h-32 flex items-end justify-between gap-2 px-4 pt-4 border-b border-gray-800">
          <div v-for="h in [40, 65, 80, 55, 90, 75, 95, 110, 85, 120, 100, 130]" :key="h" class="flex-1 bg-emerald-500/30 hover:bg-emerald-500 transition-all rounded-t" :style="{ height: `${h}px` }" />
        </div>
        <div class="flex justify-between text-[10px] font-mono text-gray-500">
          <span>00:00 UTC</span>
          <span>06:00 UTC</span>
          <span>12:00 UTC</span>
          <span>18:00 UTC</span>
          <span>24:00 UTC</span>
        </div>
      </div>

      <!-- Tab 3: Escrow Log -->
      <div v-else class="space-y-2 font-mono text-xs">
        <div class="p-2.5 rounded bg-gray-900 border border-gray-800 flex items-center justify-between text-gray-300">
          <span>Tx: 0x91a...44f2 | Released $12.50 USDC to 0x71C...39A1</span>
          <span class="text-emerald-400">Proof Verified (Block #21940120)</span>
        </div>
        <div class="p-2.5 rounded bg-gray-900 border border-gray-800 flex items-center justify-between text-gray-300">
          <span>Tx: 0x88c...10b9 | Released $45.00 USDC to 0x12D...90FE</span>
          <span class="text-emerald-400">Proof Verified (Block #21940118)</span>
        </div>
        <div class="p-2.5 rounded bg-gray-900 border border-gray-800 flex items-center justify-between text-gray-300">
          <span>Tx: 0x33e...99a0 | Campaign Escrow Deposited $10,000 USDC</span>
          <span class="text-teal-400">Escrow Locked (Block #21940080)</span>
        </div>
      </div>
    </div>
  </section>
</template>
