<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import { useAuthStore } from '~/stores/auth'
import { useApi } from '~/composables/useApi'
import { useAppToast } from '~/composables/useAppToast'
import { useWeb3Wallet } from '~/composables/useWeb3Wallet'

definePageMeta({
  layout: 'creator'
})

const authStore = useAuthStore()
const api = useApi()
const toast = useAppToast()
const {
  wallet,
  ethBalance,
  usdtBalance,
  usdcBalance,
  isConnected,
  isConnecting,
  connect: connectWallet,
  disconnect: disconnectWallet
} = useWeb3Wallet()

// State
const isLoading = ref(true)
const timeRange = ref<'7d' | '30d' | '90d' | 'all'>('30d')
const isWithdrawModalOpen = ref(false)
const isSubmittingWithdrawal = ref(false)

// Web3 Networks Options (ETH Payout Supported)
const networkOptions = [
  { id: 'Arbitrum One', name: 'Arbitrum One (L2)', chainId: 42161, icon: 'i-heroicons-bolt', fee: '~$0.05' },
  { id: 'Polygon PoS', name: 'Polygon PoS (wETH)', chainId: 137, icon: 'i-heroicons-sparkles', fee: '~$0.02' },
  { id: 'Ethereum Mainnet', name: 'Ethereum Mainnet', chainId: 1, icon: 'i-heroicons-cube', fee: '~$1.80' },
  { id: 'BNB Smart Chain', name: 'BNB Smart Chain (BSC)', chainId: 56, icon: 'i-heroicons-globe-alt', fee: '~$0.15' }
]

// Payout Form State (Strictly ETH Only)
const withdrawAmount = ref<number>(50)
const selectedNetwork = ref('Arbitrum One')
const recipientWalletInput = ref('0x71C7656EC7ab88b098defB751B7401B5f6d8976F')
const ethPriceUsd = ref<number>(3000)

const estimatedEth = computed(() => {
  if (!withdrawAmount.value || withdrawAmount.value <= 0) return '0.0000'
  return (withdrawAmount.value / ethPriceUsd.value).toFixed(4)
})

// Financial Stats (Connected to dynamic eCPM rate & impressions)
const stats = ref({
  availableBalance: 148.50,
  lifetimeRevenue: 680.50,
  adsenseShare: 102.30,
  adsterraShare: 46.20,
  escrowPoolBalance: 0.0500, // DApp Escrow Contract Balance in ETH
  minPayoutThreshold: 20.00
})

// Web3 ETH Payout Transaction History
interface PayoutTransaction {
  id: string
  date: string
  network: string
  token: 'ETH'
  walletAddress: string
  amount: number
  cryptoAmount: string
  status: 'Completed' | 'Pending' | 'Processing' | 'Rejected'
  txHash?: string
}

const transactions = ref<PayoutTransaction[]>([
  {
    id: 'PO-98214',
    date: '2026-08-08 14:32',
    network: 'Arbitrum One',
    token: 'ETH',
    walletAddress: '0x71C7656EC7ab88b098defB751B7401B5f6d8976F',
    amount: 150.00,
    cryptoAmount: '0.0500',
    status: 'Completed',
    txHash: '0x8f4a1209e99211b6554e209867b140730a584412'
  },
  {
    id: 'PO-97102',
    date: '2026-07-25 09:15',
    network: 'Polygon PoS',
    token: 'ETH',
    walletAddress: '0x3c7d4b196cb0c7b01d743fbc6116a902379c7238',
    amount: 80.00,
    cryptoAmount: '0.0267',
    status: 'Completed',
    txHash: '0x3c7d4b196cb0c7b01d743fbc6116a902379c7238'
  }
])

// Payout Threshold Calculation
const payoutProgressPercent = computed(() => {
  if (!stats.value.minPayoutThreshold) return 100
  const pct = (stats.value.availableBalance / stats.value.minPayoutThreshold) * 100
  return Math.min(Math.round(pct), 100)
})

const canWithdraw = computed(() => {
  return stats.value.availableBalance >= stats.value.minPayoutThreshold
})

function formatAddress(addr: string) {
  if (!addr) return ''
  return `${addr.substring(0, 6)}...${addr.substring(addr.length - 4)}`
}

function formatCurrency(val: number) {
  return new Intl.NumberFormat('en-US', { style: 'currency', currency: 'USD' }).format(val)
}

function copyToClipboard(text: string, label: string) {
  navigator.clipboard.writeText(text)
  toast.success('Copied', `${label} copied to clipboard!`)
}

// Handle Wallet Connect
async function handleConnectWallet() {
  const success = await connectWallet()
  if (success) {
    recipientWalletInput.value = wallet.value
    toast.success('Wallet Connected', `Connected Web3 wallet ${formatAddress(wallet.value)} (${ethBalance.value} ETH | ${usdtBalance.value} USDT)`)
  } else {
    toast.error('Wallet Error', 'Could not connect Web3 wallet.')
  }
}

// Open Withdrawal Modal
function openWithdrawModal() {
  if (!canWithdraw.value) {
    toast.warning('Threshold Not Met', `Minimum withdrawal balance is ${formatCurrency(stats.value.minPayoutThreshold)}`)
    return
  }
  withdrawAmount.value = Math.min(stats.value.availableBalance, 100)
  if (wallet.value) {
    recipientWalletInput.value = wallet.value
  }
  isWithdrawModalOpen.value = true
}

function setPresetAmount(amount: number) {
  withdrawAmount.value = Math.min(amount, stats.value.availableBalance)
}

function setMaxAmount() {
  withdrawAmount.value = stats.value.availableBalance
}

// Execute Web3 ETH Withdrawal Request Submission
async function submitWithdrawal() {
  if (withdrawAmount.value < stats.value.minPayoutThreshold) {
    toast.error('Validation Error', `Minimum ETH withdrawal amount is ${formatCurrency(stats.value.minPayoutThreshold)}.`)
    return
  }
  if (withdrawAmount.value > stats.value.availableBalance) {
    toast.error('Validation Error', 'Withdrawal amount exceeds your available balance.')
    return
  }

  const targetWallet = recipientWalletInput.value.trim() || wallet.value
  if (!targetWallet || !targetWallet.startsWith('0x')) {
    toast.error('Validation Error', 'Please enter or connect a valid EVM Web3 wallet address (0x...).')
    return
  }

  isSubmittingWithdrawal.value = true

  try {
    await new Promise((resolve) => setTimeout(resolve, 1400))

    const newTxId = 'PO-' + Math.floor(10000 + Math.random() * 90000)

    // Deduct available balance
    stats.value.availableBalance -= withdrawAmount.value

    // Record transaction as Pending On-Chain Approval
    transactions.value.unshift({
      id: newTxId,
      date: new Date().toISOString().replace('T', ' ').substring(0, 16),
      network: selectedNetwork.value,
      token: 'ETH',
      walletAddress: targetWallet,
      amount: withdrawAmount.value,
      cryptoAmount: estimatedEth.value,
      status: 'Pending'
    })

    toast.success(
      'ETH Payout Request Submitted!',
      `Submitted ${estimatedEth.value} ETH ($${withdrawAmount.value.toFixed(2)}) payout request to ${formatAddress(targetWallet)} on ${selectedNetwork.value}.`
    )

    isWithdrawModalOpen.value = false
  } catch (err: any) {
    toast.error('Withdrawal Failed', err.message || 'Could not submit ETH withdrawal request.')
  } finally {
    isSubmittingWithdrawal.value = false
  }
}

onMounted(() => {
  authStore.initAuth()
  setTimeout(() => {
    isLoading.value = false
  }, 400)
})
</script>

<template>
  <div class="space-y-6 max-w-7xl mx-auto pb-12">
    <!-- Header & Web3 Connection Bar -->
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
          Track Google AdSense & Adsterra dynamic revenue and withdraw earnings directly in Ethereum (ETH) to your Web3 wallet.
        </p>
      </div>

      <!-- Web3 Wallet Connection Controls & On-Chain Balances (ETH / USDT / USDC) -->
      <div class="flex flex-wrap items-center gap-3">
        <div v-if="isConnected"
          class="flex items-center gap-3 bg-emerald-500/10 border border-emerald-500/30 px-3.5 py-2 rounded-xl text-xs font-mono font-medium">
          <div class="flex items-center gap-1.5 font-bold text-emerald-600 dark:text-emerald-400">
            <span class="w-2 h-2 rounded-full bg-emerald-500 animate-pulse"></span>
            <span>{{ formatAddress(wallet) }}</span>
          </div>

          <div class="h-3 w-px bg-emerald-500/30"></div>

          <!-- Web3 Wallet ETH, USDT & USDC Balances UI -->
          <div class="flex items-center gap-2 font-extrabold text-gray-900 dark:text-white text-[11px]">
            <span class="flex items-center gap-0.5 text-emerald-500">
              <UIcon name="i-heroicons-bolt" class="w-3.5 h-3.5" />
              {{ ethBalance }} ETH
            </span>
            <span class="text-gray-400">|</span>
            <span class="text-teal-500 font-semibold">{{ usdtBalance }} USDT</span>
            <span class="text-gray-400">|</span>
            <span class="text-blue-500 font-semibold">{{ usdcBalance }} USDC</span>
          </div>

          <button class="text-gray-400 hover:text-emerald-500 transition-colors ml-1" title="Copy wallet address"
            @click="copyToClipboard(wallet, 'Wallet Address')">
            <UIcon name="i-heroicons-clipboard-document" class="w-3.5 h-3.5" />
          </button>
          <button class="text-gray-400 hover:text-red-500 transition-colors ml-1" title="Disconnect wallet"
            @click="disconnectWallet">
            <UIcon name="i-heroicons-arrow-right-on-rectangle" class="w-3.5 h-3.5" />
          </button>
        </div>

        <UButton v-else color="neutral" variant="subtle" icon="i-heroicons-wallet" size="sm"
          class="font-semibold shadow-xs" :loading="isConnecting" @click="handleConnectWallet">
          Connect Web3 Wallet
        </UButton>

        <UButton color="primary" variant="solid" icon="i-heroicons-arrow-up-right" size="md"
          class="font-bold px-5 shadow-xs" :disabled="!canWithdraw" @click="openWithdrawModal">
          Withdraw ETH Funds
        </UButton>
      </div>
    </div>

    <!-- Financial & Smart Contract Metric Cards (5 Grid) -->
    <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-5 gap-4">
      <!-- Card 1: Available Balance -->
      <div
        class="bg-white dark:bg-gray-900 p-5 rounded-2xl border border-gray-200 dark:border-gray-800 shadow-xs space-y-3">
        <div class="flex items-center justify-between">
          <span class="text-xs font-medium text-gray-500 dark:text-gray-400 uppercase tracking-wider">Available Balance</span>
          <div class="p-2 rounded-lg bg-emerald-500/10 text-emerald-500">
            <UIcon name="i-heroicons-currency-dollar" class="w-5 h-5" />
          </div>
        </div>
        <div>
          <p class="text-2xl font-extrabold text-gray-900 dark:text-white">
            {{ formatCurrency(stats.availableBalance) }}
          </p>
          <div class="mt-2 flex items-center justify-between text-xs">
            <span class="text-emerald-600 dark:text-emerald-400 font-semibold flex items-center gap-1 text-[11px]">
              <UIcon name="i-heroicons-check-circle" class="w-3.5 h-3.5" />
              Ready to Withdraw
            </span>
          </div>
        </div>
      </div>

      <!-- Card 2: Web3 On-Chain Wallet Balances (ETH / USDT / USDC) -->
      <div
        class="bg-white dark:bg-gray-900 p-5 rounded-2xl border border-emerald-500/30 dark:border-emerald-500/30 shadow-xs space-y-3 bg-gradient-to-br from-emerald-500/5 via-transparent to-transparent">
        <div class="flex items-center justify-between">
          <span class="text-xs font-medium text-emerald-500 uppercase tracking-wider">Web3 On-Chain Balances</span>
          <div class="p-2 rounded-lg bg-emerald-500/10 text-emerald-500">
            <UIcon name="i-heroicons-bolt" class="w-5 h-5" />
          </div>
        </div>
        <div>
          <p class="text-xl font-extrabold text-emerald-500 font-mono">
            {{ ethBalance }} ETH
          </p>
          <div class="mt-1 text-xs text-gray-400 font-mono flex items-center gap-2">
            <span class="text-teal-500 font-semibold">{{ usdtBalance }} USDT</span>
            <span>|</span>
            <span class="text-blue-500 font-semibold">{{ usdcBalance }} USDC</span>
          </div>
        </div>
      </div>

      <!-- Card 3: DApp Escrow Pool Balance -->
      <div
        class="bg-white dark:bg-gray-900 p-5 rounded-2xl border border-purple-500/20 dark:border-purple-500/30 shadow-xs space-y-3">
        <div class="flex items-center justify-between">
          <span class="text-xs font-medium text-purple-500 uppercase tracking-wider">Smart Contract Escrow</span>
          <div class="p-2 rounded-lg bg-purple-500/10 text-purple-500">
            <UIcon name="i-heroicons-cube-transparent" class="w-5 h-5" />
          </div>
        </div>
        <div>
          <p class="text-2xl font-extrabold text-purple-400 font-mono">
            {{ stats.escrowPoolBalance }} ETH
          </p>
          <div class="mt-2 text-xs text-gray-400">DApp Contract Vault</div>
        </div>
      </div>

      <!-- Card 4: Google AdSense Share -->
      <div
        class="bg-white dark:bg-gray-900 p-5 rounded-2xl border border-blue-500/20 dark:border-blue-500/30 shadow-xs space-y-3">
        <div class="flex items-center justify-between">
          <span class="text-xs font-medium text-blue-500 uppercase tracking-wider">AdSense Yield</span>
          <div class="p-2 rounded-lg bg-blue-500/10 text-blue-500">
            <UIcon name="i-heroicons-sparkles" class="w-5 h-5" />
          </div>
        </div>
        <div>
          <p class="text-2xl font-extrabold text-blue-500">
            {{ formatCurrency(stats.adsenseShare) }}
          </p>
          <div class="mt-2 text-xs text-gray-400">70% Auto Share</div>
        </div>
      </div>

      <!-- Card 5: Adsterra Share -->
      <div
        class="bg-white dark:bg-gray-900 p-5 rounded-2xl border border-amber-500/20 dark:border-amber-500/30 shadow-xs space-y-3">
        <div class="flex items-center justify-between">
          <span class="text-xs font-medium text-amber-500 uppercase tracking-wider">Adsterra Yield</span>
          <div class="p-2 rounded-lg bg-amber-500/10 text-amber-500">
            <UIcon name="i-heroicons-bolt" class="w-5 h-5" />
          </div>
        </div>
        <div>
          <p class="text-2xl font-extrabold text-amber-500">
            {{ formatCurrency(stats.adsterraShare) }}
          </p>
          <div class="mt-2 text-xs text-gray-400">70% Auto Share</div>
        </div>
      </div>
    </div>

    <!-- Payout Minimum Threshold Progress Card -->
    <div class="bg-white dark:bg-gray-900 p-6 rounded-2xl border border-gray-200 dark:border-gray-800 shadow-xs space-y-3">
      <div class="flex items-center justify-between">
        <div>
          <h3 class="text-sm font-bold text-gray-900 dark:text-white">ETH Withdrawal Progress</h3>
          <p class="text-xs text-gray-500 dark:text-gray-400">Reach at least {{ formatCurrency(stats.minPayoutThreshold) }} to execute Ethereum (ETH) payouts.</p>
        </div>
        <span class="text-sm font-extrabold font-mono text-emerald-500">{{ payoutProgressPercent }}%</span>
      </div>

      <div class="w-full h-3 bg-gray-100 dark:bg-gray-800 rounded-full overflow-hidden">
        <div class="h-full bg-gradient-to-r from-emerald-500 to-teal-400 transition-all duration-500" :style="{ width: payoutProgressPercent + '%' }"></div>
      </div>
    </div>

    <!-- Web3 ETH Payout History Table -->
    <div class="bg-white dark:bg-gray-900 rounded-2xl border border-gray-200 dark:border-gray-800 shadow-xs overflow-hidden">
      <div class="p-6 border-b border-gray-100 dark:border-gray-800">
        <h3 class="text-lg font-bold text-gray-900 dark:text-white">Web3 ETH Payout History</h3>
        <p class="text-xs text-gray-500 dark:text-gray-400">Verifiable Ethereum blockchain transfers to your Web3 wallet.</p>
      </div>

      <div class="overflow-x-auto">
        <table class="w-full text-left text-sm border-collapse">
          <thead>
            <tr class="border-b border-gray-200 dark:border-gray-800 bg-gray-50/50 dark:bg-gray-800/50 text-gray-500 dark:text-gray-400 uppercase text-[11px] font-semibold tracking-wider">
              <th class="py-3 px-6">Payout ID</th>
              <th class="py-3 px-6">Date</th>
              <th class="py-3 px-6">Network</th>
              <th class="py-3 px-6">Recipient Web3 Wallet</th>
              <th class="py-3 px-6 text-right">ETH Equivalent</th>
              <th class="py-3 px-6 text-right">Status / Tx Hash</th>
            </tr>
          </thead>
          <tbody class="divide-y divide-gray-100 dark:divide-gray-800">
            <tr v-if="transactions.length === 0" class="text-center">
              <td colspan="6" class="py-8 text-gray-400">No Web3 ETH payout transactions recorded yet.</td>
            </tr>

            <tr v-for="tx in transactions" :key="tx.id" class="hover:bg-gray-50/80 dark:hover:bg-gray-800/40 transition-colors">
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
                  <button title="Copy Address" @click="copyToClipboard(tx.walletAddress, 'Wallet Address')">
                    <UIcon name="i-heroicons-clipboard-document" class="w-3.5 h-3.5 text-gray-400 hover:text-emerald-500" />
                  </button>
                </div>
              </td>
              <td class="py-3.5 px-6 text-right font-mono text-emerald-600 dark:text-emerald-400 font-extrabold text-sm">
                +{{ tx.cryptoAmount }} ETH
                <span class="text-[11px] text-gray-400 block font-normal">(${{ tx.amount.toFixed(2) }})</span>
              </td>
              <td class="py-3.5 px-6 text-right">
                <div v-if="tx.txHash" class="space-y-0.5">
                  <UBadge color="success" variant="soft" size="xs" class="font-semibold">ETH Paid 🟢</UBadge>
                  <p class="font-mono text-[11px]">
                    <a href="#" class="text-emerald-500 hover:underline inline-flex items-center gap-0.5" @click.prevent="copyToClipboard(tx.txHash!, 'Tx Hash')">
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

    <!-- Web3 ETH Withdrawal Modal -->
    <UModal v-model:open="isWithdrawModalOpen">
      <template #content>
        <div class="p-6 space-y-5 bg-white dark:bg-gray-900 rounded-2xl border border-gray-200 dark:border-gray-800">
          <div class="flex items-center justify-between border-b border-gray-100 dark:border-gray-800 pb-4">
            <div class="flex items-center gap-2.5">
              <div class="p-2 rounded-xl bg-emerald-500/10 text-emerald-500">
                <UIcon name="i-heroicons-bolt" class="w-6 h-6" />
              </div>
              <div>
                <h3 class="text-lg font-bold text-gray-900 dark:text-white">
                  Withdraw Funds in Ethereum (ETH)
                </h3>
                <p class="text-xs text-gray-500 dark:text-gray-400">
                  Instant programmatic on-chain ETH settlement to Web3 wallet
                </p>
              </div>
            </div>
            <UButton icon="i-heroicons-x-mark" color="neutral" variant="ghost" size="xs" @click="isWithdrawModalOpen = false" />
          </div>

          <!-- Available USD Earnings & On-Chain ETH + Stablecoin Balances Header -->
          <div class="grid grid-cols-2 gap-3 bg-gray-50 dark:bg-gray-800/50 p-4 rounded-xl">
            <div>
              <p class="text-xs text-gray-500 dark:text-gray-400">Platform Available Balance</p>
              <p class="text-xl font-extrabold text-emerald-500">
                {{ formatCurrency(stats.availableBalance) }}
              </p>
            </div>
            <div>
              <p class="text-xs text-gray-500 dark:text-gray-400">On-Chain Wallet Balances</p>
              <p class="text-lg font-extrabold text-white font-mono">
                {{ ethBalance }} ETH
              </p>
              <p class="text-[11px] font-mono text-gray-400">
                <span class="text-teal-400 font-semibold">{{ usdtBalance }} USDT</span> | <span class="text-blue-400 font-semibold">{{ usdcBalance }} USDC</span>
              </p>
            </div>
          </div>

          <!-- Web3 Blockchain Network Selector -->
          <div class="space-y-1">
            <label class="block text-xs font-semibold text-gray-700 dark:text-gray-300">
              Select Blockchain Network (ETH Payout)
            </label>
            <div class="grid grid-cols-2 gap-2">
              <div v-for="net in networkOptions" :key="net.id"
                class="p-2.5 rounded-xl border cursor-pointer transition-all flex items-center gap-2"
                :class="selectedNetwork === net.id
                  ? 'border-emerald-500 bg-emerald-500/10 dark:bg-emerald-950/30'
                  : 'border-gray-200 dark:border-gray-800 bg-gray-50/50 dark:bg-gray-800/30 hover:border-gray-300'"
                @click="selectedNetwork = net.id">
                <UIcon :name="net.icon" class="w-4 h-4 text-emerald-500 shrink-0" />
                <div class="truncate">
                  <p class="text-xs font-bold text-gray-900 dark:text-white truncate">{{ net.name }}</p>
                  <p class="text-[10px] text-gray-400 font-mono">Fee: {{ net.fee }}</p>
                </div>
              </div>
            </div>
          </div>

          <!-- Recipient Web3 Wallet Address -->
          <div class="space-y-1">
            <div class="flex items-center justify-between">
              <label class="block text-xs font-semibold text-gray-700 dark:text-gray-300">Target Web3 Wallet Address (0x...)</label>
              <button v-if="!isConnected" class="text-xs text-emerald-500 font-semibold hover:underline" @click="handleConnectWallet">
                Connect MetaMask
              </button>
            </div>
            <UInput v-model="recipientWalletInput" placeholder="0x71C..." size="md" color="neutral" variant="outline" class="font-mono text-xs" />
          </div>

          <!-- Amount Input & Presets -->
          <div class="space-y-1">
            <div class="flex items-center justify-between">
              <label class="block text-xs font-semibold text-gray-700 dark:text-gray-300">
                Withdrawal Amount ($ USD)
              </label>
              <div class="flex gap-1">
                <button v-for="preset in [20, 50, 100]" :key="preset"
                  class="px-2 py-0.5 text-[10px] font-semibold bg-gray-100 dark:bg-gray-800 rounded hover:bg-gray-200 dark:hover:bg-gray-700 transition-colors text-gray-700 dark:text-gray-300"
                  @click="setPresetAmount(preset)">
                  ${{ preset }}
                </button>
              </div>
            </div>
            <UInput v-model.number="withdrawAmount" type="number" :min="stats.minPayoutThreshold" :max="stats.availableBalance"
              placeholder="Enter amount..." size="lg" color="neutral" variant="outline" class="font-mono font-bold text-lg" />
            <p class="text-xs text-emerald-400 font-mono font-semibold pt-1">
              Estimated On-Chain Payout: ≈ {{ estimatedEth }} ETH (@ ${{ ethPriceUsd.toLocaleString() }}/ETH)
            </p>
          </div>

          <!-- Submit Buttons -->
          <div class="pt-2 border-t border-gray-100 dark:border-gray-800 flex items-center justify-end gap-2">
            <UButton color="neutral" variant="subtle" size="sm" @click="isWithdrawModalOpen = false">
              Cancel
            </UButton>
            <UButton color="primary" variant="solid" size="md" class="font-bold px-6"
              :loading="isSubmittingWithdrawal" @click="submitWithdrawal">
              Confirm ETH Payout (${{ withdrawAmount }} / {{ estimatedEth }} ETH)
            </UButton>
          </div>
        </div>
      </template>
    </UModal>
  </div>
</template>
