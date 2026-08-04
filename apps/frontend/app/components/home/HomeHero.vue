<script setup lang="ts">
import { ref } from 'vue'
import { useWeb3Wallet } from '~/composables/useWeb3Wallet'

const {
  wallet,
  isConnected,
  isConnecting,
  isApproving,
  txHash,
  errorMessage,
  depositSuccess,
  depositAmountUsdc,
  connect,
  requestUsdcApprovalAndDeposit,
  disconnect
} = useWeb3Wallet()

const showDepositModal = ref(false)

async function handleLaunchCampaign() {
  if (!isConnected.value) {
    const success = await connect()
    if (success) {
      showDepositModal.value = true
    }
  } else {
    showDepositModal.value = true
  }
}

async function handleApproveAndDeploy() {
  await requestUsdcApprovalAndDeposit()
  showDepositModal.value = false
  if (depositSuccess.value) {
    console.log("🚀 [Get Started Campaign] Approved & Deployed Escrow Successfully!", {
      wallet: wallet.value,
      txHash: txHash.value,
      amount: "10.00 USDC",
      status: "APPROVED",
      timestamp: new Date().toISOString()
    })
  }
}
</script>

<template>
  <section class="relative pt-6 md:pt-12 pb-8 overflow-hidden">
    <!-- Ambient Radial Glow -->
    <div
      class="absolute top-0 left-1/2 -translate-x-1/2 w-full max-w-7xl h-96 bg-emerald-500/10 dark:bg-emerald-500/15 rounded-full blur-3xl pointer-events-none -z-10" />

    <div class="max-w-5xl mx-auto text-center space-y-6">
      <!-- Hero Title -->
      <h1
        class="text-4xl sm:text-6xl lg:text-7xl font-extrabold text-gray-900 dark:text-white tracking-tight leading-[1.1]">
        Transparent, Escrow-Backed <br class="hidden sm:inline" />
        <span class="bg-clip-text text-transparent bg-gradient-to-r from-emerald-500 via-teal-400 to-cyan-500">
          Decentralized Advertising
        </span>
      </h1>

      <!-- Subtitle -->
      <p class="max-w-3xl mx-auto text-base sm:text-xl text-gray-600 dark:text-gray-300 leading-relaxed font-normal">
        Lock campaign ad budgets into non-custodial smart contracts. Stream programmatic micro-payouts directly to
        publishers on cryptographically verified impression proofs.
      </p>

      <!-- CTA Buttons & Connected Wallet State -->
      <UButton color="primary" size="xl"
        class="w-full sm:w-auto inline-flex items-center justify-center gap-2 font-bold px-8 shadow-lg shadow-emerald-500/20 hover:scale-105 transition-transform"
        :loading="isConnecting" @click="handleLaunchCampaign">
        <UIcon name="i-heroicons-rocket-launch" class="w-5 h-5" />
        <span>{{ isConnected ? 'Get Started' : 'Connect Wallet' }}</span>
      </UButton>

      <!-- Connected Wallet Badge Bar -->
      <div v-if="isConnected" class="pt-2 flex items-center justify-center gap-3">
        <div
          class="inline-flex items-center gap-2 px-3 py-1.5 rounded-full bg-emerald-950/40 border border-emerald-500/30 text-emerald-400 text-xs font-mono">
          <UIcon name="i-heroicons-check-circle" class="w-4 h-4 text-emerald-400" />
          <span>Connected: {{ wallet.slice(0, 6) }}...{{ wallet.slice(-4) }}</span>
          <button class="text-xs text-red-400 hover:underline ml-2" @click="disconnect">Disconnect</button>
        </div>
      </div>

      <div v-if="depositSuccess"
        class="max-w-lg mx-auto p-4 bg-emerald-500/10 border border-emerald-500/40 text-emerald-300 rounded-xl text-xs text-left space-y-1">
        <div class="font-bold text-sm flex items-center gap-1.5 text-emerald-400">
          <UIcon name="i-heroicons-check-badge" class="w-5 h-5" />
          <span>10 USDC Ad Escrow Deposit Approved!</span>
        </div>
        <div>Transaction submitted on-chain. Ad budget is locked in smart contract.</div>
        <div v-if="txHash" class="font-mono text-[10px] text-gray-400 break-all pt-1">
          Tx Hash: <span class="text-emerald-400">{{ txHash }}</span>
        </div>
      </div>

      <!-- Hero Smart Escrow Live State Mockup Card -->
      <div class="pt-8 max-w-4xl mx-auto">
        <div
          class="p-4 sm:p-6 rounded-2xl bg-gray-900/95 border border-gray-800 shadow-2xl text-left font-sans relative overflow-hidden backdrop-blur">
          <div class="grid grid-cols-2 md:grid-cols-4 gap-4 py-5 text-xs">
            <div class="bg-gray-800/60 p-3 rounded-xl border border-gray-700/50">
              <div class="text-gray-400 mb-1">Locked Ad Budget</div>
              <div class="text-lg font-mono font-bold text-white">$25,000.00 USDC</div>
              <div class="text-[10px] text-emerald-400 font-mono mt-0.5">Escrow Locked On-Chain</div>
            </div>

            <div class="bg-gray-800/60 p-3 rounded-xl border border-gray-700/50">
              <div class="text-gray-400 mb-1">Verified Impressions</div>
              <div class="text-lg font-mono font-bold text-white">4,821,900</div>
              <div class="text-[10px] text-teal-400 font-mono mt-0.5">Merkle Proof Verified</div>
            </div>

            <div class="bg-gray-800/60 p-3 rounded-xl border border-gray-700/50">
              <div class="text-gray-400 mb-1">Streamed Payouts</div>
              <div class="text-lg font-mono font-bold text-emerald-400">$21,698.55 USDC</div>
              <div class="text-[10px] text-gray-400 font-mono mt-0.5">Direct to 142 Wallets</div>
            </div>

            <div class="bg-gray-800/60 p-3 rounded-xl border border-gray-700/50">
              <div class="text-gray-400 mb-1">Protocol Take Rate</div>
              <div class="text-lg font-mono font-bold text-white">0.50%</div>
              <div class="text-[10px] text-gray-400 font-mono mt-0.5">Staked Fee Tier</div>
            </div>
          </div>

          <div
            class="p-2.5 bg-black/40 rounded-lg border border-gray-800 text-[11px] font-mono text-gray-400 flex items-center justify-between">
            <div class="flex items-center gap-2 truncate">
              <span class="text-emerald-400">⚡ LIVE EVENT:</span>
              <span class="truncate">Impressions verified block #21940129 • $14.20 USDC stream released to
                0x3F2...88bC</span>
            </div>
            <span class="shrink-0 text-gray-500 hidden sm:inline">0.2s ago</span>
          </div>
        </div>
      </div>
    </div>

    <!-- Interactive Deposit Approval Modal -->
    <UModal :open="showDepositModal" title="Launch Campaign: 10 USDC Ad Budget Escrow"
      description="Approve 10 USDC ad deposit via smart contract escrow to launch your campaign."
      @update:open="showDepositModal = $event">
      <template #body>
        <div class="space-y-4">
          <div class="p-4 bg-gray-900 border border-gray-800 rounded-xl space-y-2 text-xs">
            <div class="flex justify-between text-gray-400">
              <span>Connected Wallet:</span>
              <span class="font-mono text-white font-bold">{{ wallet ? `${wallet.slice(0, 8)}...${wallet.slice(-6)}` :
                'Not Connected' }}</span>
            </div>
            <div class="flex justify-between text-gray-400">
              <span>Initial Campaign Escrow Deposit:</span>
              <span class="font-mono text-emerald-400 font-bold">10.00 USDC</span>
            </div>
            <div class="flex justify-between text-gray-400">
              <span>Smart Contract Destination:</span>
              <span class="font-mono text-gray-300">0x8F4A...4412</span>
            </div>
          </div>

          <p class="text-xs text-gray-400">
            Clicking approve will trigger your MetaMask browser wallet to sign an ERC-20 approval for 10 USDC to start
            campaign impression delivery.
          </p>

          <div class="flex gap-2">
            <UButton color="neutral" variant="soft" block @click="showDepositModal = false">
              Cancel
            </UButton>
            <UButton color="primary" block :loading="isApproving" @click="handleApproveAndDeploy">
              Confirm
            </UButton>
          </div>
        </div>
      </template>
    </UModal>
  </section>
</template>
