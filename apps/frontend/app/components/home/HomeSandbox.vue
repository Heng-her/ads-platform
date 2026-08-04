<script setup lang="ts">
import {
  activeSandboxTab,
  tabs,
  campaigns,
  telemetry,
  escrowLogs,
} from "../../data/homesandbox";
</script>

<template>
  <section class="max-w-6xl mx-auto space-y-8">
    <!-- Header -->
    <div class="text-center max-w-3xl mx-auto space-y-3">
      <UBadge color="primary" variant="subtle" class="font-mono text-xs uppercase">
        Interactive Sandbox
      </UBadge>
      <h2 class="text-3xl sm:text-4xl font-extrabold text-gray-900 dark:text-white">
        Real-Time Advertiser & Publisher Portal
      </h2>

      <p class="text-sm text-gray-600 dark:text-gray-400">
        Explore live campaign management, budget escrows, and CPM verification telemetry.
      </p>
    </div>
    <!-- Sandbox Container -->
    <div class="p-6 rounded-2xl bg-gray-950 border border-gray-800 shadow-2xl space-y-6">
      <!-- Navigation -->
      <div class="flex flex-wrap items-center justify-between gap-4 border-b border-gray-800 pb-4">
        <div class="flex gap-2">
          <button v-for="tab in tabs" :key="tab.id" type="button"
            class="px-4 py-1.5 rounded-lg text-xs font-semibold transition-all" :class="activeSandboxTab === tab.id
              ? 'bg-emerald-500 text-gray-950 font-bold'
              : 'text-gray-400 hover:text-white bg-gray-900'
              " @click="activeSandboxTab = tab.id">
            {{ tab.label }}
          </button>
        </div>

        <div class="text-xs font-mono text-gray-500 hidden sm:block">
          Connected Network:
          <span class="text-emerald-400">Arbitrum L2 Mainnet</span>
        </div>
      </div>

      <!-- Active Campaigns -->
      <div v-if="activeSandboxTab === 'campaigns'" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4 text-xs">
        <div v-for="campaign in campaigns" :key="campaign.id"
          class="p-4 rounded-xl bg-gray-900 border border-gray-800 space-y-3">
          <div class="flex items-center justify-between">
            <span class="font-bold text-white truncate max-w-[200px]">
              {{ campaign.name }}
            </span>
            <UBadge color="success" size="xs">{{ campaign.status }}</UBadge>
          </div>

          <div class="grid grid-cols-3 gap-2 py-2 font-mono text-[11px]">
            <div>
              <div class="text-gray-500">Budget Escrow</div>
              <div class="text-white font-semibold">{{ campaign.budget }}</div>
            </div>
            <div>
              <div class="text-gray-500">Impressions</div>
              <div class="text-white font-semibold">{{ campaign.impressions }}</div>
            </div>
            <div>
              <div class="text-gray-500">Avg. CPM</div>
              <div class="text-emerald-400 font-semibold">{{ campaign.cpm }}</div>
            </div>
          </div>

          <div class="w-full bg-gray-800 h-1.5 rounded-full overflow-hidden">
            <div class="bg-emerald-500 h-full transition-all duration-500"
              :style="{ width: `${campaign.progress}%` }" />
          </div>
        </div>
      </div>

      <!-- CPM & Reach Telemetry -->
      <div v-else-if="activeSandboxTab === 'analytics'"
        class="p-6 rounded-xl bg-gray-900 border border-gray-800 text-center space-y-4">
        <div class="text-xs font-mono text-gray-400">
          Simulated 24-Hour Impression & Payout Velocity (Mock Telemetry)
        </div>
        <div class="h-32 flex items-end justify-between gap-2 px-4 pt-4 border-b border-gray-800">
          <div v-for="(height, index) in telemetry" :key="index"
            class="flex-1 bg-emerald-500/30 hover:bg-emerald-500 transition-all rounded-t"
            :style="{ height: `${height}px` }" />
        </div>
        <div class="flex justify-between text-[10px] font-mono text-gray-500">
          <span>00:00 UTC</span>
          <span>06:00 UTC</span>
          <span>12:00 UTC</span>
          <span>18:00 UTC</span>
          <span>24:00 UTC</span>
        </div>
      </div>

      <!-- Escrow Audit Log -->
      <div v-else class="space-y-2 font-mono text-xs">
        <div v-for="log in escrowLogs" :key="log.tx"
          class="p-2.5 rounded bg-gray-900 border border-gray-800 flex items-center justify-between text-gray-300">
          <span>Tx: {{ log.tx }} | {{ log.action }}</span>
          <span :class="log.color">{{ log.status }} (Block {{ log.block }})</span>
        </div>
      </div>
    </div>
  </section>
</template>