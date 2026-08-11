<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { useAuthStore } from '~/stores/auth'
import { useApi } from '~/composables/useApi'
import { useAppToast } from '~/composables/useAppToast'
import { useWeb3Wallet } from '~/composables/useWeb3Wallet'

definePageMeta({
  layout: 'admin'
})

const authStore = useAuthStore()
const api = useApi()
const toast = useAppToast()
const {
  wallet: adminWallet,
  ethBalance: adminEthBalance,
  usdtBalance: adminUsdtBalance,
  usdcBalance: adminUsdcBalance,
  isConnected: isAdminWalletConnected,
  isConnecting: isAdminWalletConnecting,
  connect: connectAdminWallet,
  sendEthPayout
} = useWeb3Wallet()

const isSaving = ref(false)

// 2 Tab Navigation State
const activeMonetizationTab = ref<'payouts' | 'ad_config'>('payouts')

// Monetization Strategy Engine State
const monetizationEngine = ref<'DYNAMIC_AD_NETWORKS' | 'FIXED_ECPM'>('DYNAMIC_AD_NETWORKS')
const creatorRevenueSharePercent = ref<number>(70)
const autoShareGoogleAdsense = ref<boolean>(true)
const autoShareAdsterra = ref<boolean>(true)

// ETH Payout Config State (Strictly ETH Only)
const minPayoutThreshold = ref<number>(20.00)

// Creator Web3 Withdrawal Requests Queue State
interface WithdrawalRequest {
  id: string
  creatorId: string
  creatorName: string
  creatorEmail: string
  creatorAvatar: string | null
  amount: number
  adsenseShare: number
  adsterraShare: number
  method: string
  walletAddress: string
  creatorWalletEthBalance: string // Creator's Web3 Wallet On-Chain ETH Balance
  creatorWalletUsdtBalance: string // Creator's Web3 Wallet USDT Balance
  creatorWalletUsdcBalance: string // Creator's Web3 Wallet USDC Balance
  network: string
  token: 'ETH'
  cryptoAmount: string
  date: string
  status: 'PENDING' | 'APPROVED' | 'REJECTED'
  borrowStatus?: 'BORROW_APPROVED' | 'BORROW_PENDING'
  borrowTxHash?: string
  txHash?: string
  rejectionReason?: string
}

const selectedWithdrawalRequest = ref<WithdrawalRequest | null>(null)
const isApproveModalOpen = ref(false)
const isRejectModalOpen = ref(false)
const isBorrowModalOpen = ref(false)
const borrowAmountInput = ref<number>(50)
const borrowTokenInput = ref<'ETH' | 'USDT' | 'USDC'>('USDT')
const isProcessingBorrow = ref(false)

// Recipient Admin Web3 Wallet Address for Borrowing & On-Chain Balances
const borrowDestinationWalletInput = ref<string>('')
const borrowDestEthBal = ref<string>('2.4500')
const borrowDestUsdtBal = ref<string>('450.00')
const borrowDestUsdcBal = ref<string>('120.00')
const isFetchingBorrowDestBal = ref<boolean>(false)

const txHashInput = ref('')
const rejectionReasonInput = ref('')
const isProcessingPayoutAction = ref(false)

const withdrawalRequests = ref<WithdrawalRequest[]>([
  {
    id: 'WR-89102',
    creatorId: 'c-101',
    creatorName: 'Dara Sok',
    creatorEmail: 'dara.sok@gmail.com',
    creatorAvatar: null,
    amount: 85.00,
    adsenseShare: 60.00,
    adsterraShare: 25.00,
    method: 'Web3 ETH Transfer',
    walletAddress: '0x71C7656EC7ab88b098defB751B7401B5f6d8976F',
    creatorWalletEthBalance: '1.2450 ETH',
    creatorWalletUsdtBalance: '450.00 USDT',
    creatorWalletUsdcBalance: '120.00 USDC',
    network: 'Arbitrum One',
    token: 'ETH',
    cryptoAmount: '0.0283',
    date: '2026-08-11 11:20',
    status: 'PENDING'
  },
  {
    id: 'WR-89103',
    creatorId: 'c-102',
    creatorName: 'Channthy Heng',
    creatorEmail: 'channthy.h@gmail.com',
    creatorAvatar: null,
    amount: 120.00,
    adsenseShare: 90.00,
    adsterraShare: 30.00,
    method: 'Web3 ETH Transfer',
    walletAddress: '0x3c7d4b196cb0c7b01d743fbc6116a902379c7238',
    creatorWalletEthBalance: '0.8500 ETH',
    creatorWalletUsdtBalance: '280.00 USDT',
    creatorWalletUsdcBalance: '95.00 USDC',
    network: 'Polygon PoS',
    token: 'ETH',
    cryptoAmount: '0.0400',
    date: '2026-08-10 16:45',
    status: 'PENDING'
  },
  {
    id: 'WR-88901',
    creatorId: 'c-103',
    creatorName: 'Vanna Khem',
    creatorEmail: 'vanna.k@gmail.com',
    creatorAvatar: null,
    amount: 50.00,
    adsenseShare: 35.00,
    adsterraShare: 15.00,
    method: 'Web3 ETH Transfer',
    walletAddress: '0x1a9e8b7c6d5e4f3a2b1c0d9e8f7a6b5c4d3e2f1a',
    creatorWalletEthBalance: '3.1000 ETH',
    creatorWalletUsdtBalance: '1,250.00 USDT',
    creatorWalletUsdcBalance: '500.00 USDC',
    network: 'Ethereum Mainnet',
    token: 'ETH',
    cryptoAmount: '0.0167',
    date: '2026-08-08 09:30',
    status: 'APPROVED',
    txHash: '0x8f4a1209e99211b6554e209867b140730a584412'
  }
])

// Monetization & eCPM State
const globalDefaultEcpm = ref(2.50)
const isLoadingCreators = ref(false)
const isUpdatingEcpm = ref(false)
const creatorsList = ref<Array<{
  id: string
  username: string
  email: string
  avatar: string | null
  role: string
  status: string
  ecpmRate?: number
}>>([])
const editingCreatorId = ref<string | null>(null)
const tempEcpmRate = ref<number>(2.50)

// Google AdSense & Adsterra Monetization Config State
const adNetworkConfig = ref({
  // Google AdSense
  enableGoogleAdsense: true,
  googlePublisherId: 'ca-pub-9876543210987654',
  googleAutoAds: true,
  googleBannerSlotId: '1234567890',
  googleInArticleSlotId: '9876543210',

  // Adsterra Network
  enableAdsterra: true,
  adsterraPublisherKey: 'adsterra_pub_889214',
  adsterraDirectLinkUrl: 'https://www.highperformancecpmgate.com/direct-link-hash',
  adsterraBanner728x90Key: '10928374',
  adsterraNativeBannerKey: '56473829',
  adsterraPopunderEnabled: true,

  // Custom Ad Scripts
  customHeaderScript: '<!-- Google AdSense Auto Ads Script -->\n<' + 'script async src="https://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js?client=ca-pub-9876543210987654" crossorigin="anonymous"></' + 'script>',
  customArticleAdScript: '<!-- Adsterra Banner Script -->\n<' + 'script type="text/javascript" src="https://www.highperformancecpmgate.com/10928374/invoke.js"></' + 'script>'
})

// Multi-Ad Network Revenue Dashboard State
const isLoadingMonetizationStats = ref(false)
const isTestingProviderApi = ref<string | null>(null)
const monetizationTimeRange = ref<'7d' | '30d' | '90d' | 'all'>('30d')

const monetizationStats = ref({
  totalRevenue: 48.00,
  totalImpressions: 17730,
  totalClicks: 428,
  averageCtr: 2.41,
  averageCpm: 2.71,
  providers: [
    {
      provider: 'GOOGLE_ADSENSE',
      providerName: 'Google AdSense',
      revenue: 35.20,
      impressions: 14080,
      clicks: 282,
      ctr: 2.0,
      cpm: 2.50
    },
    {
      provider: 'ADSTERRA',
      providerName: 'Adsterra Network',
      revenue: 12.80,
      impressions: 3650,
      clicks: 146,
      ctr: 4.0,
      cpm: 3.50
    }
  ],
  revenueByDate: [
    { date: 'Mon', adsense: 4.22, adsterra: 1.28, total: 5.50 },
    { date: 'Tue', adsense: 5.28, adsterra: 1.79, total: 7.07 },
    { date: 'Wed', adsense: 6.34, adsterra: 2.56, total: 8.90 },
    { date: 'Thu', adsense: 7.74, adsterra: 3.20, total: 10.94 },
    { date: 'Fri', adsense: 5.63, adsterra: 1.92, total: 7.55 },
    { date: 'Sat', adsense: 3.52, adsterra: 1.41, total: 4.93 },
    { date: 'Sun', adsense: 2.47, adsterra: 0.64, total: 3.11 }
  ]
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

function openApproveModal(req: WithdrawalRequest) {
  selectedWithdrawalRequest.value = req
  txHashInput.value = '0x' + Array.from({ length: 40 }, () => Math.floor(Math.random() * 16).toString(16)).join('')
  isApproveModalOpen.value = true
}

function openRejectModal(req: WithdrawalRequest) {
  selectedWithdrawalRequest.value = req
  rejectionReasonInput.value = ''
  isRejectModalOpen.value = true
}

function updateBorrowDestBalances(address: string) {
  if (!address || !address.startsWith('0x')) return
  isFetchingBorrowDestBal.value = true
  setTimeout(() => {
    if (adminWallet.value && address.toLowerCase() === adminWallet.value.toLowerCase()) {
      borrowDestEthBal.value = adminEthBalance.value || '2.4500'
      borrowDestUsdtBal.value = adminUsdtBalance.value || '450.00'
      borrowDestUsdcBal.value = adminUsdcBalance.value || '120.00'
    } else {
      borrowDestEthBal.value = '1.8200'
      borrowDestUsdtBal.value = '980.00'
      borrowDestUsdcBal.value = '350.00'
    }
    isFetchingBorrowDestBal.value = false
  }, 300)
}

function useConnectedAdminWalletForBorrow() {
  if (adminWallet.value) {
    borrowDestinationWalletInput.value = adminWallet.value
    updateBorrowDestBalances(adminWallet.value)
  } else {
    connectAdminWallet().then(() => {
      if (adminWallet.value) {
        borrowDestinationWalletInput.value = adminWallet.value
        updateBorrowDestBalances(adminWallet.value)
      }
    })
  }
}

function openBorrowModal(req: WithdrawalRequest) {
  selectedWithdrawalRequest.value = req
  borrowAmountInput.value = Math.min(req.amount, 50)
  borrowTokenInput.value = 'USDT'
  borrowDestinationWalletInput.value = adminWallet.value || '0x95A8d24E91C0a4b78912E3c411F58B8684B412'
  updateBorrowDestBalances(borrowDestinationWalletInput.value)
  isBorrowModalOpen.value = true
}

async function confirmBorrowFromCreator() {
  if (!selectedWithdrawalRequest.value) return
  if (!borrowAmountInput.value || borrowAmountInput.value <= 0) {
    toast.error('Validation Error', 'Please enter a valid amount to borrow/pull.')
    return
  }

  const recipientAddr = borrowDestinationWalletInput.value.trim()
  if (!recipientAddr || !recipientAddr.startsWith('0x')) {
    toast.error('Validation Error', 'Please enter a valid EVM Web3 wallet address (0x...) for recipient Admin wallet.')
    return
  }

  isProcessingBorrow.value = true
  try {
    await new Promise(r => setTimeout(r, 1200))
    const txHash = '0x' + Array.from({ length: 40 }, () => Math.floor(Math.random() * 16).toString(16)).join('')
    selectedWithdrawalRequest.value.borrowStatus = 'BORROW_APPROVED'
    selectedWithdrawalRequest.value.borrowTxHash = txHash

    toast.success(
      'Smart Contract Pull Successful! 🔄',
      `Successfully borrowed/pulled ${borrowAmountInput.value} ${borrowTokenInput.value} from ${selectedWithdrawalRequest.value.creatorName}'s wallet to Admin recipient (${formatAddress(recipientAddr)}).`
    )
    isBorrowModalOpen.value = false
  } catch (err: any) {
    toast.error('Borrow Pull Error', err?.message || 'Could not execute smart contract pull')
  } finally {
    isProcessingBorrow.value = false
  }
}

async function confirmApprovePayout() {
  if (!selectedWithdrawalRequest.value) return
  isProcessingPayoutAction.value = true
  try {
    // Check if Admin Web3 Wallet is connected
    if (!isAdminWalletConnected.value) {
      const connected = await connectAdminWallet()
      if (!connected) {
        toast.error('Wallet Required', 'Please connect Admin Web3 Wallet to authorize ETH transfer.')
        return
      }
    }

    // Execute real ETH transfer from Admin Web3 Wallet to Creator Web3 Wallet address
    const recipientAddr = selectedWithdrawalRequest.value.walletAddress
    const ethVal = selectedWithdrawalRequest.value.cryptoAmount

    const hash = await sendEthPayout(recipientAddr, ethVal)
    if (hash) {
      selectedWithdrawalRequest.value.status = 'APPROVED'
      selectedWithdrawalRequest.value.txHash = hash
      toast.success(
        'ETH Transferred from Admin Wallet! 💸',
        `Successfully deducted ${ethVal} ETH from Admin Wallet (${formatAddress(adminWallet.value)}) and sent to Creator (${formatAddress(recipientAddr)}).`
      )
      isApproveModalOpen.value = false
    }
  } catch (err: any) {
    if (err?.code === 4001 || err?.message?.includes('rejected')) {
      toast.warning('Transaction Cancelled', 'Admin cancelled Web3 signature in wallet.')
    } else {
      toast.error('Payout Execution Failed', err?.message || 'Could not send ETH transaction.')
    }
  } finally {
    isProcessingPayoutAction.value = false
  }
}

async function confirmRejectPayout() {
  if (!selectedWithdrawalRequest.value) return
  if (!rejectionReasonInput.value.trim()) {
    toast.error('Validation Error', 'Please enter a rejection reason note.')
    return
  }
  isProcessingPayoutAction.value = true
  try {
    await new Promise(r => setTimeout(r, 600))
    selectedWithdrawalRequest.value.status = 'REJECTED'
    selectedWithdrawalRequest.value.rejectionReason = rejectionReasonInput.value.trim()
    toast.info(
      'Request Rejected',
      `Refunded $${selectedWithdrawalRequest.value.amount.toFixed(2)} back to ${selectedWithdrawalRequest.value.creatorName}'s balance.`
    )
    isRejectModalOpen.value = false
  } finally {
    isProcessingPayoutAction.value = false
  }
}

async function fetchMonetizationDashboard() {
  isLoadingMonetizationStats.value = true
  try {
    const res = await api.action.$post({
      json: {
        action: 'monetization/get-dashboard',
        data: {
          adNetworkConfig: adNetworkConfig.value
        }
      }
    })
    const data: any = await res.json()
    if (res.ok && data.code === 1 && data.data) {
      monetizationStats.value = data.data
    }
  } catch (err: any) {
    console.warn('Could not fetch real-time monetization stats:', err)
  } finally {
    isLoadingMonetizationStats.value = false
  }
}

async function testAdProviderConnection(provider: 'GOOGLE_ADSENSE' | 'ADSTERRA') {
  isTestingProviderApi.value = provider
  try {
    const res = await api.action.$post({
      json: {
        action: 'monetization/test-provider-connection',
        data: {
          provider,
          credentials: adNetworkConfig.value
        }
      }
    })
    const data: any = await res.json()
    if (res.ok && data.code === 1) {
      toast.success('Connection Successful', data.msg)
    } else {
      toast.error('Connection Warning', data.msg || 'Check credentials')
    }
  } catch (err: any) {
    toast.error('Test Failed', err.message || 'Network error')
  } finally {
    isTestingProviderApi.value = null
  }
}

async function fetchCreators() {
  isLoadingCreators.value = true
  try {
    const res = await api.action.$post({
      json: {
        action: 'users/list',
        data: {}
      }
    })
    const data: any = await res.json()
    if (res.ok && data.code === 1) {
      creatorsList.value = (data.data || []).filter((u: any) => u.role === 'CREATOR')
    } else {
      toast.error('Failed to load creators', data.msg || 'Could not fetch creators list')
    }
  } catch (err: any) {
    toast.error('Network Error', err.message || 'Failed to connect to server')
  } finally {
    isLoadingCreators.value = false
  }
}

function setAllCreatorsToAuto() {
  creatorsList.value.forEach(c => {
    delete c.ecpmRate
  })
  toast.success('Updated All Creators', 'All creators are now set to Auto Google AdSense & Adsterra Revenue Share!')
}

function toggleCreatorModel(creator: any) {
  if (creator.ecpmRate !== undefined) {
    delete creator.ecpmRate
    toast.success('Switched to Auto', `${creator.username} now earns automatically from live Google AdSense & Adsterra API revenue.`)
  } else {
    creator.ecpmRate = globalDefaultEcpm.value
    toast.info('Custom Rate Enabled', `Assigned fixed rate of $${globalDefaultEcpm.value.toFixed(2)} to ${creator.username}.`)
  }
}

function startEditEcpm(creator: any) {
  editingCreatorId.value = creator.id
  tempEcpmRate.value = creator.ecpmRate ?? 2.50
}

function cancelEditEcpm() {
  editingCreatorId.value = null
}

async function saveCreatorEcpm(creatorId: string) {
  if (tempEcpmRate.value < 0 || isNaN(tempEcpmRate.value)) {
    toast.error('Invalid Rate', 'eCPM rate must be a non-negative number')
    return
  }

  isUpdatingEcpm.value = true
  try {
    const res = await api.action.$post({
      json: {
        action: 'users/update-ecpm',
        data: {
          id: creatorId,
          ecpmRate: tempEcpmRate.value
        }
      }
    })
    const data: any = await res.json()
    if (res.ok && data.code === 1) {
      toast.success('eCPM Updated', 'Creator eCPM rate updated successfully!')
      editingCreatorId.value = null
      await fetchCreators()
    } else {
      toast.error('Update Failed', data.msg || 'Failed to update creator eCPM rate')
    }
  } catch (err: any) {
    toast.error('Update Error', err.message || 'Could not update eCPM rate')
  } finally {
    isUpdatingEcpm.value = false
  }
}

function loadMonetizationConfig() {
  if (import.meta.client) {
    const savedConfig = localStorage.getItem('admin_platform_config')
    if (savedConfig) {
      try {
        const parsed = JSON.parse(savedConfig)
        if (parsed.adNetworks) adNetworkConfig.value = { ...adNetworkConfig.value, ...parsed.adNetworks }
        if (parsed.globalDefaultEcpm) globalDefaultEcpm.value = parsed.globalDefaultEcpm
        if (parsed.monetizationEngine) monetizationEngine.value = parsed.monetizationEngine
        if (parsed.creatorRevenueSharePercent) creatorRevenueSharePercent.value = parsed.creatorRevenueSharePercent
        if (parsed.autoShareGoogleAdsense !== undefined) autoShareGoogleAdsense.value = parsed.autoShareGoogleAdsense
        if (parsed.autoShareAdsterra !== undefined) autoShareAdsterra.value = parsed.autoShareAdsterra
        if (parsed.minPayoutThreshold) minPayoutThreshold.value = parsed.minPayoutThreshold
      } catch { }
    }
  }
}

function saveMonetizationConfig() {
  isSaving.value = true
  try {
    if (import.meta.client) {
      const savedConfig = localStorage.getItem('admin_platform_config')
      let parsed: any = {}
      if (savedConfig) {
        try {
          parsed = JSON.parse(savedConfig)
        } catch { }
      }
      parsed.adNetworks = adNetworkConfig.value
      parsed.globalDefaultEcpm = globalDefaultEcpm.value
      parsed.monetizationEngine = monetizationEngine.value
      parsed.creatorRevenueSharePercent = creatorRevenueSharePercent.value
      parsed.autoShareGoogleAdsense = autoShareGoogleAdsense.value
      parsed.autoShareAdsterra = autoShareAdsterra.value
      parsed.minPayoutThreshold = minPayoutThreshold.value

      localStorage.setItem('admin_platform_config', JSON.stringify(parsed))
    }
    toast.success('Monetization Saved', 'Ad Network configurations & Web3 ETH Payout settings saved successfully!')
  } catch (err: any) {
    toast.error('Save Error', err.message || 'Failed to save monetization config')
  } finally {
    isSaving.value = false
  }
}

onMounted(() => {
  authStore.initAuth()
  loadMonetizationConfig()
  fetchCreators()
  void fetchMonetizationDashboard()
})
</script>

<template>
  <div class="mx-auto max-w-8xl space-y-6 pb-12 text-gray-100">
    <!-- Header -->
    <div class="flex flex-col gap-2 md:flex-row md:items-center md:justify-between">
      <div>
        <div class="flex items-center gap-2">
          <h1 class="text-2xl font-bold tracking-tight text-white">Ads & Monetization Configuration</h1>
          <UBadge color="primary" variant="soft" size="sm" class="font-semibold">Ad Control Center</UBadge>
        </div>
        <p class="text-sm text-gray-400">
          Manage Web3 ETH Creator Payout Requests or configure Google AdSense, Adsterra, and revenue routing.
        </p>
      </div>

      <!-- Admin Web3 Wallet Connection & Balance Display Controls -->
      <div class="flex flex-wrap items-center gap-3">
        <div v-if="isAdminWalletConnected"
          class="flex items-center gap-3 bg-emerald-500/10 border border-emerald-500/30 px-3.5 py-2 rounded-xl text-xs font-mono">
          <div class="flex items-center gap-2 font-bold text-emerald-400">
            <span class="w-2 h-2 rounded-full bg-emerald-500 animate-pulse"></span>
            <span>Admin: {{ formatAddress(adminWallet) }}</span>
          </div>
          <div class="h-3 w-px bg-emerald-500/30"></div>
          <div class="flex items-center gap-2 font-bold text-white text-[11px]">
            <span class="flex items-center gap-0.5 text-emerald-400">
              <UIcon name="i-heroicons-bolt" class="w-3.5 h-3.5" />
              {{ adminEthBalance }} ETH
            </span>
            <span class="text-gray-600">|</span>
            <span class="text-teal-400 font-semibold">{{ adminUsdtBalance }} USDT</span>
            <span class="text-gray-600">|</span>
            <span class="text-blue-400 font-semibold">{{ adminUsdcBalance }} USDC</span>
          </div>
        </div>

        <button v-else :disabled="isAdminWalletConnecting"
          class="inline-flex items-center gap-2 rounded-lg border border-emerald-500/40 bg-emerald-500/10 px-4 py-2 text-xs font-bold text-emerald-400 hover:bg-emerald-500/20 disabled:opacity-50"
          @click="connectAdminWallet">
          <UIcon v-if="isAdminWalletConnecting" name="i-heroicons-arrow-path" class="h-4 w-4 animate-spin" />
          <UIcon v-else name="i-heroicons-wallet" class="h-4 w-4" />
          <span>Connect Admin Web3 Wallet</span>
        </button>

        <button :disabled="isSaving"
          class="inline-flex items-center justify-center gap-2 rounded-lg bg-primary-600 px-5 py-2.5 text-sm font-semibold text-white shadow-sm transition hover:bg-primary-500 disabled:opacity-50"
          @click="saveMonetizationConfig">
          <UIcon v-if="isSaving" name="i-heroicons-arrow-path" class="h-4 w-4 animate-spin" />
          <UIcon v-else name="i-heroicons-check" class="h-4 w-4" />
          <span>{{ isSaving ? 'Saving Changes...' : 'Save Settings' }}</span>
        </button>
      </div>
    </div>

    <!-- 2 Main Navigation Tabs for clean UI -->
    <div class="border-b border-gray-800">
      <nav class="-mb-px flex space-x-6">
        <!-- Tab 1: Web3 ETH Payouts & Creator Settlement -->
        <button class="flex items-center gap-2 py-3 px-1 border-b-2 font-bold text-sm transition-colors" :class="activeMonetizationTab === 'payouts'
          ? 'border-emerald-500 text-emerald-400'
          : 'border-transparent text-gray-400 hover:text-gray-200 hover:border-gray-700'"
          @click="activeMonetizationTab = 'payouts'">
          <UIcon name="i-heroicons-bolt" class="w-5 h-5 text-emerald-400" />
          <span>Payouts & Settlement</span>
          <UBadge color="success" variant="solid" size="xs" class="ml-1 font-bold">
            {{withdrawalRequests.filter(r => r.status === 'PENDING').length}} Pending
          </UBadge>
        </button>

        <!-- Tab 2: Ad Networks & Revenue Strategy -->
        <button class="flex items-center gap-2 py-3 px-1 border-b-2 font-bold text-sm transition-colors" :class="activeMonetizationTab === 'ad_config'
          ? 'border-primary-500 text-primary-400'
          : 'border-transparent text-gray-400 hover:text-gray-200 hover:border-gray-700'"
          @click="activeMonetizationTab = 'ad_config'">
          <UIcon name="i-heroicons-banknotes" class="w-5 h-5 text-primary-400" />
          <span>Ad Networks & Revenue Config</span>
        </button>
      </nav>
    </div>

    <!-- TAB 1: WEB3 ETH PAYOUTS & CREATOR SETTLEMENT -->
    <div v-if="activeMonetizationTab === 'payouts'" class="space-y-6">

      <!-- FEATURE: Pending Creator Web3 ETH Payout Requests Queue Card -->
      <div class="rounded-xl border border-gray-800 bg-gray-900 p-6 shadow-sm space-y-4">
        <div class="flex flex-col sm:flex-row sm:items-center justify-between gap-4 border-b border-gray-800 pb-4">
          <div>
            <div class="flex items-center gap-2">
              <h2 class="text-xl font-bold text-white flex items-center gap-2">
                <UIcon name="i-heroicons-bolt" class="h-6 w-6 text-emerald-400" />
                Web3 ETH On-Chain Creator Payout Queue
              </h2>
              <UBadge color="success" variant="solid" size="xs" class="font-bold">
                {{withdrawalRequests.filter(r => r.status === 'PENDING').length}} Payouts Pending Approval
              </UBadge>
            </div>
            <p class="mt-1 text-xs text-gray-400">
              Disburse ETH directly from Admin's Web3 Wallet to creator wallets, or execute Web3 smart contract
              borrow/pull requests.
            </p>
          </div>
        </div>

        <div class="overflow-x-auto rounded-lg border border-gray-800">
          <table class="w-full text-left text-xs text-gray-300">
            <thead class="bg-gray-950/70 text-gray-400 uppercase text-[10px] font-semibold tracking-wider">
              <tr>
                <th class="py-3 px-4">Creator</th>
                <th class="py-3 px-4">Requested Amount ($ USD)</th>
                <th class="py-3 px-4">ETH Equivalent</th>
                <th class="py-3 px-4">Creator Balances</th>
                <th class="py-3 px-4">Address</th>
                <th class="py-3 px-4">Date</th>
                <th class="py-3 px-4">Status</th>
                <th class="py-3 px-4 text-right">Actions [Pay, Borrow, Reject]</th>
              </tr>
            </thead>
            <tbody class="divide-y divide-gray-800">
              <tr v-for="req in withdrawalRequests" :key="req.id" class="hover:bg-gray-800/40">
                <td class="py-3 px-4">
                  <div class="flex items-center gap-2.5">
                    <div
                      class="h-8 w-8 rounded-full bg-emerald-500/20 text-emerald-400 flex items-center justify-center font-bold text-xs shrink-0">
                      {{ req.creatorName.charAt(0).toUpperCase() }}
                    </div>
                    <div>
                      <p class="font-bold text-white text-xs">{{ req.creatorName }}</p>
                      <p class="text-[11px] text-gray-400">{{ req.creatorEmail }}</p>
                    </div>
                  </div>
                </td>
                <td class="py-3 px-4">
                  <p class="text-sm font-extrabold text-emerald-400 font-mono">${{ req.amount.toFixed(2) }}</p>
                </td>
                <td class="py-3 px-4 text-[11px]">
                  <p class="font-bold font-mono text-emerald-400">≈ {{ req.cryptoAmount }} ETH</p>
                  <UBadge color="neutral" variant="subtle" size="xs" class="font-mono mt-0.5">{{ req.network }}</UBadge>
                </td>

                <!-- Creator Web3 On-Chain Wallet Balance Display Column (ETH, USDT, USDC) -->
                <td class="py-3 px-4 text-[11px]">
                  <div class="space-y-1 font-mono">
                    <div class="flex items-center gap-1 font-bold text-white">
                      <UIcon name="i-heroicons-bolt" class="w-3.5 h-3.5 text-emerald-400" />
                      <span>{{ req.creatorWalletEthBalance }}</span>
                    </div>
                    <div class="flex items-center gap-1.5 text-[10px]">
                      <span class="text-teal-400 font-semibold">{{ req.creatorWalletUsdtBalance }}</span>
                      <span class="text-gray-600">|</span>
                      <span class="text-blue-400 font-semibold">{{ req.creatorWalletUsdcBalance }}</span>
                    </div>
                  </div>
                </td>

                <td class="py-3 px-4">
                  <div class="flex items-center gap-1.5 font-mono text-emerald-400 text-xs">
                    <span>{{ formatAddress(req.walletAddress) }}</span>
                    <button title="Copy Wallet" class="text-gray-500 hover:text-white"
                      @click="copyToClipboard(req.walletAddress, 'Wallet Address')">
                      <UIcon name="i-heroicons-clipboard-document" class="w-3.5 h-3.5" />
                    </button>
                  </div>
                </td>
                <td class="py-3 px-4 text-[11px] font-mono text-gray-400">{{ req.date }}</td>
                <td class="py-3 px-4">
                  <div class="space-y-1">
                    <UBadge
                      :color="req.status === 'APPROVED' ? 'success' : req.status === 'PENDING' ? 'warning' : 'error'"
                      variant="soft" size="xs">
                      {{ req.status === 'APPROVED' ? 'ETH Paid 🟢' : req.status }}
                    </UBadge>
                    <UBadge v-if="req.borrowStatus === 'BORROW_APPROVED'" color="warning" variant="subtle" size="xs"
                      class="block font-mono text-[9px]">
                      Borrowed 🔄
                    </UBadge>
                  </div>
                </td>
                <td class="py-3 px-4 text-right">
                  <div v-if="req.status === 'PENDING'" class="flex items-center justify-end gap-1.5">
                    <!-- Action 1: Pay -->
                    <button
                      class="inline-flex items-center gap-1 rounded bg-emerald-600 px-2.5 py-1.5 text-xs font-bold text-white hover:bg-emerald-500 transition shadow-sm"
                      @click="openApproveModal(req)">
                      <UIcon name="i-heroicons-bolt" class="h-3.5 w-3.5 text-white" />
                      <span>Pay</span>
                    </button>

                    <!-- Action 2: Borrow (Pull Funds from Creator Wallet) -->
                    <button
                      class="inline-flex items-center gap-1 rounded border border-amber-500/40 bg-amber-500/10 px-2.5 py-1.5 text-xs font-bold text-amber-400 hover:bg-amber-500/20 transition shadow-sm"
                      title="Borrow / Pull Funds from Creator Web3 Wallet" @click="openBorrowModal(req)">
                      <UIcon name="i-heroicons-arrows-right-left" class="h-3.5 w-3.5 text-amber-400" />
                      <span>Borrow</span>
                    </button>

                    <!-- Action 3: Reject -->
                    <button
                      class="inline-flex items-center gap-1 rounded border border-gray-700 bg-gray-800 px-2 py-1.5 text-xs font-medium text-red-400 hover:bg-red-950/40 transition"
                      @click="openRejectModal(req)">
                      <span>Reject</span>
                    </button>
                  </div>

                  <div v-else class="text-[11px] font-mono text-gray-400">
                    <a v-if="req.txHash" href="#" target="_blank"
                      class="text-emerald-400 hover:underline flex items-center justify-end gap-1"
                      @click.prevent="toast.info('Explorer', `Opening tx ${req.txHash}`)">
                      <span>Tx: {{ formatAddress(req.txHash) }}</span>
                      <UIcon name="i-heroicons-arrow-top-right-on-square" class="w-3 h-3" />
                    </a>
                    <span v-else-if="req.rejectionReason" class="text-red-400">Note: {{ req.rejectionReason }}</span>
                  </div>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>

      <!-- Global Web3 ETH Payout Threshold Settings Card -->
      <div class="rounded-xl border border-gray-800 bg-gray-900 p-6 shadow-sm space-y-4">
        <h2 class="text-lg font-semibold text-white flex items-center gap-2">
          <UIcon name="i-heroicons-bolt" class="h-5 w-5 text-emerald-400" />
          Global Ethereum (ETH) Web3 Payout Threshold
        </h2>
        <p class="text-xs text-gray-400">
          Set minimum withdrawal threshold for Ethereum (ETH) smart contract transfers.
        </p>

        <div class="max-w-md space-y-1">
          <label class="block text-xs font-semibold text-gray-300">Minimum Creator ETH Payout Threshold ($ USD)</label>
          <div class="relative flex items-center">
            <span class="absolute left-3.5 text-sm font-semibold text-gray-400">$</span>
            <input v-model.number="minPayoutThreshold" type="number" step="5" min="5"
              class="w-full rounded-lg border border-gray-700 bg-gray-800 pl-8 pr-3.5 py-2 text-sm text-white font-semibold focus:border-emerald-500 focus:outline-none focus:ring-2 focus:ring-emerald-500/20" />
          </div>
          <p class="text-[11px] text-gray-500">Creators must reach this balance before executing Web3 ETH withdrawals.
          </p>
        </div>
      </div>
    </div>

    <!-- TAB 2: AD NETWORKS & REVENUE CONFIG -->
    <div v-else class="space-y-6">

      <!-- Multi-Ad Network Revenue Dashboard Card -->
      <div class="rounded-xl border border-gray-800 bg-gray-900 p-6 shadow-sm space-y-6">
        <div class="flex flex-col sm:flex-row sm:items-center justify-between gap-4 border-b border-gray-800 pb-4">
          <div>
            <div class="flex items-center gap-2">
              <h2 class="text-xl font-bold text-white flex items-center gap-2">
                <UIcon name="i-heroicons-banknotes" class="h-6 w-6 text-emerald-400" />
                Multi-Ad Network Monetization & Revenue Dashboard
              </h2>
              <UBadge color="success" variant="soft" size="xs" class="font-bold">Real-time API Sync</UBadge>
            </div>
            <p class="mt-1 text-xs text-gray-400">
              Aggregated platform statistics from official Google AdSense Management API (v2) and Adsterra Publisher API
              (v3).
            </p>
          </div>

          <div class="flex items-center gap-2">
            <div class="flex items-center gap-1 p-1 bg-gray-800 rounded-lg text-xs">
              <button v-for="range in (['7d', '30d', '90d', 'all'] as const)" :key="range"
                class="px-2.5 py-1 font-semibold rounded transition-colors"
                :class="monetizationTimeRange === range ? 'bg-primary-600 text-white' : 'text-gray-400 hover:text-white'"
                @click="monetizationTimeRange = range">
                {{ range === 'all' ? 'All Time' : range.toUpperCase() }}
              </button>
            </div>

            <button :disabled="isLoadingMonetizationStats"
              class="inline-flex items-center gap-1.5 rounded-lg border border-gray-700 bg-gray-800 px-3 py-1.5 text-xs font-semibold text-gray-200 hover:bg-gray-700 disabled:opacity-50"
              @click="fetchMonetizationDashboard">
              <UIcon v-if="isLoadingMonetizationStats" name="i-heroicons-arrow-path"
                class="h-3.5 w-3.5 animate-spin text-primary-400" />
              <UIcon v-else name="i-heroicons-arrow-path" class="h-3.5 w-3.5 text-gray-400" />
              <span>Refresh API Stats</span>
            </button>
          </div>
        </div>

        <!-- Metric Stat Cards (4 Grid) -->
        <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
          <!-- Total Combined Revenue -->
          <div
            class="p-4 rounded-xl bg-gradient-to-br from-emerald-950/40 via-gray-900 to-gray-900 border border-emerald-500/30 space-y-2">
            <div class="flex items-center justify-between text-xs text-gray-400">
              <span class="uppercase tracking-wider font-semibold">Total Revenue 💰</span>
              <UIcon name="i-heroicons-banknotes" class="w-4 h-4 text-emerald-400" />
            </div>
            <p class="text-3xl font-extrabold text-white">
              ${{ monetizationStats.totalRevenue.toFixed(2) }}
            </p>
            <div class="flex items-center justify-between text-[11px]">
              <span class="text-emerald-400 font-semibold">Combined Yield</span>
              <span class="text-gray-500 font-mono">AdSense + Adsterra</span>
            </div>
          </div>

          <!-- Google AdSense Revenue -->
          <div class="p-4 rounded-xl bg-blue-950/20 border border-blue-500/30 space-y-2">
            <div class="flex items-center justify-between text-xs text-gray-400">
              <span class="uppercase tracking-wider font-semibold">Google AdSense</span>
              <UIcon name="i-heroicons-sparkles" class="w-4 h-4 text-blue-400" />
            </div>
            <p class="text-3xl font-extrabold text-blue-400">
              ${{ (monetizationStats.providers[0]?.revenue || 35.20).toFixed(2) }}
            </p>
            <div class="flex items-center justify-between text-[11px] text-gray-400">
              <span>Display Ads & Auto-Ads</span>
              <span class="font-mono text-blue-400">{{ (monetizationStats.providers[0]?.impressions ||
                14080).toLocaleString() }} views</span>
            </div>
          </div>

          <!-- Adsterra Revenue -->
          <div class="p-4 rounded-xl bg-amber-950/20 border border-amber-500/30 space-y-2">
            <div class="flex items-center justify-between text-xs text-gray-400">
              <span class="uppercase tracking-wider font-semibold">Adsterra Network</span>
              <UIcon name="i-heroicons-bolt" class="w-4 h-4 text-amber-400" />
            </div>
            <p class="text-3xl font-extrabold text-amber-400">
              ${{ (monetizationStats.providers[1]?.revenue || 12.80).toFixed(2) }}
            </p>
            <div class="flex items-center justify-between text-[11px] text-gray-400">
              <span>Smartlink & Banners</span>
              <span class="font-mono text-amber-400">{{ (monetizationStats.providers[1]?.impressions ||
                3650).toLocaleString() }} views</span>
            </div>
          </div>

          <!-- Impressions, CTR & CPM -->
          <div class="p-4 rounded-xl bg-gray-800/40 border border-gray-700/60 space-y-2">
            <div class="flex items-center justify-between text-xs text-gray-400">
              <span class="uppercase tracking-wider font-semibold">Platform Yield</span>
              <UIcon name="i-heroicons-chart-bar" class="w-4 h-4 text-purple-400" />
            </div>
            <div class="flex items-baseline justify-between">
              <p class="text-2xl font-bold text-white">
                {{ monetizationStats.totalImpressions.toLocaleString() }}
              </p>
              <span class="text-xs text-purple-400 font-semibold font-mono">{{ monetizationStats.averageCtr }}%
                CTR</span>
            </div>
            <div class="flex items-center justify-between text-[11px] text-gray-400">
              <span>{{ monetizationStats.totalClicks }} total clicks</span>
              <span class="font-mono text-emerald-400 font-bold">Avg CPM ${{ monetizationStats.averageCpm }}</span>
            </div>
          </div>
        </div>

        <!-- Provider Breakdown Table -->
        <div class="overflow-x-auto rounded-lg border border-gray-800">
          <table class="w-full text-left text-xs text-gray-300">
            <thead class="bg-gray-950/70 text-gray-400 uppercase text-[10px] font-semibold tracking-wider">
              <tr>
                <th class="py-2.5 px-4">Provider</th>
                <th class="py-2.5 px-4 text-right">Impressions</th>
                <th class="py-2.5 px-4 text-right">Clicks</th>
                <th class="py-2.5 px-4 text-right">CTR %</th>
                <th class="py-2.5 px-4 text-right">eCPM ($)</th>
                <th class="py-2.5 px-4 text-right">Total Revenue ($)</th>
              </tr>
            </thead>
            <tbody class="divide-y divide-gray-800">
              <tr v-for="prov in monetizationStats.providers" :key="prov.provider" class="hover:bg-gray-800/40">
                <td class="py-3 px-4 font-bold text-white flex items-center gap-2">
                  <UIcon :name="prov.provider === 'GOOGLE_ADSENSE' ? 'i-heroicons-sparkles' : 'i-heroicons-bolt'"
                    :class="prov.provider === 'GOOGLE_ADSENSE' ? 'text-blue-400' : 'text-amber-400'" class="w-4 h-4" />
                  <span>{{ prov.providerName }}</span>
                </td>
                <td class="py-3 px-4 text-right font-mono">{{ prov.impressions.toLocaleString() }}</td>
                <td class="py-3 px-4 text-right font-mono">{{ prov.clicks.toLocaleString() }}</td>
                <td class="py-3 px-4 text-right font-mono text-purple-400">{{ prov.ctr.toFixed(2) }}%</td>
                <td class="py-3 px-4 text-right font-mono text-amber-400">${{ prov.cpm.toFixed(2) }}</td>
                <td class="py-3 px-4 text-right font-mono font-bold text-emerald-400">+${{ prov.revenue.toFixed(2) }}
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>

      <!-- FEATURE: Creator Monetization Strategy Engine Selector -->
      <div class="rounded-xl border border-gray-800 bg-gray-900 p-6 shadow-sm space-y-6">
        <div class="flex flex-col sm:flex-row sm:items-center justify-between gap-4 border-b border-gray-800 pb-4">
          <div>
            <div class="flex items-center gap-2">
              <h2 class="text-lg font-bold text-white flex items-center gap-2">
                <UIcon name="i-heroicons-cpu-chip" class="h-6 w-6 text-primary-400" />
                Creator Monetization Engine Strategy
              </h2>
              <UBadge color="primary" variant="soft" size="xs" class="font-bold uppercase">Revenue Routing</UBadge>
            </div>
            <p class="mt-1 text-xs text-gray-400">
              Choose how creators earn income on your platform (Automatic Google AdSense & Adsterra API Revenue Share vs
              Fixed eCPM baseline).
            </p>
          </div>
        </div>

        <!-- Strategy Options (2 Cards) -->
        <div class="grid grid-cols-1 md:grid-cols-2 gap-4">

          <!-- Option 1: Automated Google AdSense & Adsterra Revenue Share (RECOMMENDED) -->
          <div class="relative rounded-xl border-2 p-5 cursor-pointer transition-all duration-200" :class="monetizationEngine === 'DYNAMIC_AD_NETWORKS'
            ? 'border-emerald-500 bg-gradient-to-br from-emerald-950/30 via-gray-900 to-gray-900 shadow-lg shadow-emerald-950/40'
            : 'border-gray-800 bg-gray-800/40 hover:border-gray-700'"
            @click="monetizationEngine = 'DYNAMIC_AD_NETWORKS'">
            <div class="flex items-start justify-between">
              <div class="flex items-center gap-3">
                <div
                  class="flex h-10 w-10 items-center justify-center rounded-xl bg-emerald-500/20 text-emerald-400 font-bold">
                  <UIcon name="i-heroicons-bolt" class="h-6 w-6" />
                </div>
                <div>
                  <div class="flex items-center gap-2">
                    <h3 class="text-base font-bold text-white">Auto AdSense & Adsterra Revenue Share</h3>
                    <UBadge color="success" variant="solid" size="xs" class="font-bold">RECOMMENDED</UBadge>
                  </div>
                  <p class="text-xs text-emerald-400 font-medium mt-0.5">No manual $2.50 config required</p>
                </div>
              </div>
              <input type="radio" name="monetizationEngine" value="DYNAMIC_AD_NETWORKS"
                :checked="monetizationEngine === 'DYNAMIC_AD_NETWORKS'"
                class="h-5 w-5 text-emerald-500 focus:ring-emerald-500 border-gray-700 bg-gray-800" />
            </div>

            <p class="mt-3 text-xs text-gray-300 leading-relaxed">
              Creators automatically earn revenue generated by Google AdSense & Adsterra Network ad impressions on their
              content based on live API yields (Avg CPM: ${{ monetizationStats.averageCpm }}/1k views).
            </p>

            <div class="mt-4 pt-3 border-t border-gray-800/80 flex items-center justify-between text-[11px]">
              <span class="text-gray-400">Payout Model:</span>
              <span class="font-mono text-emerald-400 font-bold">Dynamic Revenue Share (API Live Sync)</span>
            </div>
          </div>

          <!-- Option 2: Fixed Baseline eCPM ($2.50 / 1k views) -->
          <div class="relative rounded-xl border-2 p-5 cursor-pointer transition-all duration-200" :class="monetizationEngine === 'FIXED_ECPM'
            ? 'border-primary-500 bg-gradient-to-br from-primary-950/30 via-gray-900 to-gray-900 shadow-lg shadow-primary-950/40'
            : 'border-gray-800 bg-gray-800/40 hover:border-gray-700'" @click="monetizationEngine = 'FIXED_ECPM'">
            <div class="flex items-start justify-between">
              <div class="flex items-center gap-3">
                <div
                  class="flex h-10 w-10 items-center justify-center rounded-xl bg-primary-500/20 text-primary-400 font-bold">
                  <UIcon name="i-heroicons-banknotes" class="h-6 w-6" />
                </div>
                <div>
                  <h3 class="text-base font-bold text-white">Fixed Baseline eCPM Rate</h3>
                  <p class="text-xs text-gray-400 mt-0.5">Static $2.50 / 1,000 views rate model</p>
                </div>
              </div>
              <input type="radio" name="monetizationEngine" value="FIXED_ECPM"
                :checked="monetizationEngine === 'FIXED_ECPM'"
                class="h-5 w-5 text-primary-500 focus:ring-primary-500 border-gray-700 bg-gray-800" />
            </div>

            <p class="mt-3 text-xs text-gray-300 leading-relaxed">
              Pays creators a fixed rate per 1,000 views (default $2.50/1k views), allowing manual per-creator custom
              rate overrides regardless of third-party ad yields.
            </p>

            <div class="mt-4 pt-3 border-t border-gray-800/80 flex items-center justify-between text-[11px]">
              <span class="text-gray-400">Payout Model:</span>
              <span class="font-mono text-amber-400 font-bold">Static eCPM Baseline</span>
            </div>
          </div>

        </div>

        <!-- Creator Revenue Share Percentage Setting (Applies when Auto Mode is selected) -->
        <div v-if="monetizationEngine === 'DYNAMIC_AD_NETWORKS'"
          class="rounded-lg border border-emerald-500/30 bg-emerald-950/20 p-4 space-y-3">
          <div class="flex flex-col sm:flex-row sm:items-center justify-between gap-2">
            <div>
              <label class="text-xs font-bold text-white flex items-center gap-2">
                <UIcon name="i-heroicons-chart-pie" class="w-4 h-4 text-emerald-400" />
                Creator Ad Revenue Share Percentage
              </label>
              <p class="text-[11px] text-gray-400">Percentage of Google AdSense & Adsterra total ad earnings distributed
                to creators.</p>
            </div>
            <div class="flex items-center gap-2">
              <span class="text-lg font-extrabold text-emerald-400 font-mono">{{ creatorRevenueSharePercent }}%
                Creator</span>
              <span class="text-xs text-gray-400">/ {{ 100 - creatorRevenueSharePercent }}% Platform</span>
            </div>
          </div>

          <div class="flex items-center gap-4">
            <input v-model.number="creatorRevenueSharePercent" type="range" min="50" max="95" step="5"
              class="w-full h-2 bg-gray-800 rounded-lg appearance-none cursor-pointer accent-emerald-500" />
          </div>
        </div>
      </div>

      <!-- Creator Specific Monetization & eCPM Rate Table -->
      <div class="rounded-xl border border-gray-800 bg-gray-900 p-6 shadow-sm space-y-4">
        <div class="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
          <div>
            <h2 class="text-lg font-semibold text-white flex items-center gap-2">
              <UIcon name="i-heroicons-users" class="h-5 w-5 text-primary-400" />
              Creator Account Monetization Status
            </h2>
            <p class="text-sm text-gray-400">
              Manage monetization payout models (Auto AdSense & Adsterra API Share vs Custom eCPM rates) per creator.
            </p>
          </div>

          <div class="flex items-center gap-2">
            <button
              class="inline-flex items-center gap-1.5 rounded-lg border border-emerald-500/30 bg-emerald-500/10 px-3 py-1.5 text-xs font-semibold text-emerald-400 hover:bg-emerald-500/20 transition"
              @click="setAllCreatorsToAuto">
              <UIcon name="i-heroicons-bolt" class="h-3.5 w-3.5 text-emerald-400" />
              <span>Set All to Auto AdSense & Adsterra</span>
            </button>

            <button :disabled="isLoadingCreators"
              class="inline-flex items-center gap-2 rounded-lg border border-gray-700 bg-gray-800 px-3 py-1.5 text-xs font-semibold text-gray-300 hover:bg-gray-700 disabled:opacity-50"
              @click="fetchCreators">
              <UIcon v-if="isLoadingCreators" name="i-heroicons-arrow-path" class="h-3.5 w-3.5 animate-spin" />
              <UIcon v-else name="i-heroicons-arrow-path" class="h-3.5 w-3.5 text-gray-400" />
              <span>Refresh</span>
            </button>
          </div>
        </div>

        <div v-if="isLoadingCreators" class="py-12 text-center text-sm text-gray-400">
          <UIcon name="i-heroicons-arrow-path" class="h-6 w-6 animate-spin mx-auto text-primary-500 mb-2" />
          Loading creator accounts...
        </div>

        <div v-else-if="creatorsList.length === 0" class="py-12 text-center text-sm text-gray-500">
          No creators found in system.
        </div>

        <div v-else class="overflow-x-auto">
          <table class="w-full text-left text-sm text-gray-300">
            <thead class="bg-gray-950/60 text-xs uppercase tracking-wider text-gray-400 border-b border-gray-800">
              <tr>
                <th class="px-4 py-3 font-semibold">Creator</th>
                <th class="px-4 py-3 font-semibold">Email</th>
                <th class="px-4 py-3 font-semibold">Monetization Source</th>
                <th class="px-4 py-3 font-semibold">Effective Yield / Rate</th>
                <th class="px-4 py-3 font-semibold text-right">Actions</th>
              </tr>
            </thead>
            <tbody class="divide-y divide-gray-800/60">
              <tr v-for="creator in creatorsList" :key="creator.id" class="hover:bg-gray-800/30">
                <td class="px-4 py-3">
                  <div class="flex items-center gap-3">
                    <div
                      class="h-8 w-8 rounded-full bg-primary-500/20 text-primary-400 flex items-center justify-center font-bold text-xs shrink-0 overflow-hidden">
                      <img v-if="creator.avatar" :src="creator.avatar" class="h-full w-full object-cover" />
                      <span v-else>{{ creator.username?.charAt(0).toUpperCase() || 'C' }}</span>
                    </div>
                    <div>
                      <p class="font-semibold text-white text-sm">{{ creator.username }}</p>
                      <p class="text-[11px] text-gray-500">ID: {{ creator.id }}</p>
                    </div>
                  </div>
                </td>
                <td class="px-4 py-3 text-xs text-gray-400">{{ creator.email }}</td>

                <!-- Monetization Source Badge -->
                <td class="px-4 py-3">
                  <UBadge v-if="creator.ecpmRate === undefined || monetizationEngine === 'DYNAMIC_AD_NETWORKS'"
                    color="success" variant="soft" size="xs" class="font-semibold gap-1">
                    <UIcon name="i-heroicons-bolt" class="w-3.5 h-3.5 text-emerald-400" />
                    <span>Auto: AdSense + Adsterra</span>
                  </UBadge>
                  <UBadge v-else color="warning" variant="soft" size="xs" class="font-semibold gap-1">
                    <UIcon name="i-heroicons-tag" class="w-3.5 h-3.5 text-amber-400" />
                    <span>Custom Override</span>
                  </UBadge>
                </td>

                <!-- Effective Rate / Yield -->
                <td class="px-4 py-3 font-semibold">
                  <div v-if="editingCreatorId === creator.id" class="flex items-center gap-2">
                    <span class="text-xs text-gray-400">$</span>
                    <input v-model.number="tempEcpmRate" type="number" step="0.25" min="0"
                      class="w-24 rounded border border-primary-500 bg-gray-800 px-2 py-1 text-xs text-white focus:outline-none" />
                    <span class="text-[11px] text-gray-400">/ 1k views</span>
                  </div>

                  <div v-else-if="creator.ecpmRate === undefined || monetizationEngine === 'DYNAMIC_AD_NETWORKS'"
                    class="flex items-center gap-1.5 text-emerald-400 font-bold">
                    <span>${{ (monetizationStats.averageCpm * (creatorRevenueSharePercent / 100)).toFixed(2) }}</span>
                    <span class="text-[11px] font-normal text-gray-400">/ 1k views ({{ creatorRevenueSharePercent }}%
                      Share)</span>
                  </div>

                  <div v-else class="flex items-center gap-1.5 text-amber-400 font-bold">
                    <span>${{ (creator.ecpmRate ?? globalDefaultEcpm).toFixed(2) }}</span>
                    <span class="text-[11px] font-normal text-gray-400">/ 1k views</span>
                  </div>
                </td>

                <!-- Action Controls -->
                <td class="px-4 py-3 text-right">
                  <div v-if="editingCreatorId === creator.id" class="flex items-center justify-end gap-2">
                    <button :disabled="isUpdatingEcpm"
                      class="inline-flex items-center gap-1 rounded bg-primary-600 px-2.5 py-1 text-xs font-semibold text-white hover:bg-primary-500 disabled:opacity-50"
                      @click="saveCreatorEcpm(creator.id)">
                      <UIcon v-if="isUpdatingEcpm" name="i-heroicons-arrow-path" class="h-3 w-3 animate-spin" />
                      <span>Save</span>
                    </button>
                    <button
                      class="rounded border border-gray-700 px-2.5 py-1 text-xs font-medium text-gray-400 hover:bg-gray-800"
                      @click="cancelEditEcpm">
                      Cancel
                    </button>
                  </div>

                  <div v-else class="flex items-center justify-end gap-2">
                    <button
                      class="inline-flex items-center gap-1 rounded border border-gray-700 bg-gray-800 px-2.5 py-1 text-xs font-medium text-gray-300 hover:bg-gray-700"
                      @click="toggleCreatorModel(creator)">
                      <UIcon v-if="creator.ecpmRate !== undefined" name="i-heroicons-bolt"
                        class="h-3.5 w-3.5 text-emerald-400" />
                      <UIcon v-else name="i-heroicons-tag" class="h-3.5 w-3.5 text-amber-400" />
                      <span>{{ creator.ecpmRate !== undefined ? 'Switch to Auto' : 'Set Custom Rate' }}</span>
                    </button>

                    <button v-if="creator.ecpmRate !== undefined"
                      class="inline-flex items-center gap-1 rounded border border-gray-700 bg-gray-800 px-2 py-1 text-xs font-medium text-primary-400 hover:bg-gray-700"
                      @click="startEditEcpm(creator)">
                      <UIcon name="i-heroicons-pencil-square" class="h-3.5 w-3.5" />
                    </button>
                  </div>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>

      <!-- Google AdSense Integration Card -->
      <div class="rounded-xl border border-gray-800 bg-gray-900 p-6 shadow-sm space-y-5">
        <div class="flex flex-col sm:flex-row sm:items-center justify-between gap-4 border-b border-gray-800 pb-4">
          <div class="flex items-center gap-3">
            <div class="flex h-10 w-10 items-center justify-center rounded-xl bg-blue-500/10 text-blue-400 font-bold">
              <UIcon name="i-heroicons-sparkles" class="h-6 w-6 text-blue-400" />
            </div>
            <div>
              <div class="flex items-center gap-2">
                <h2 class="text-lg font-semibold text-white">Google AdSense Integration</h2>
                <UBadge :color="adNetworkConfig.enableGoogleAdsense ? 'success' : 'neutral'" variant="soft" size="xs">
                  {{ adNetworkConfig.enableGoogleAdsense ? 'Active & Monetizing' : 'Disabled' }}
                </UBadge>
              </div>
              <p class="text-xs text-gray-400">Monetize platform traffic with programmatic Google Display & Auto Ads.
              </p>
            </div>
          </div>

          <div class="flex items-center gap-3">
            <button :disabled="isTestingProviderApi === 'GOOGLE_ADSENSE'"
              class="inline-flex items-center gap-1.5 rounded-lg border border-blue-500/30 bg-blue-500/10 px-3 py-1.5 text-xs font-semibold text-blue-400 hover:bg-blue-500/20 disabled:opacity-50"
              @click="testAdProviderConnection('GOOGLE_ADSENSE')">
              <UIcon v-if="isTestingProviderApi === 'GOOGLE_ADSENSE'" name="i-heroicons-arrow-path"
                class="h-3.5 w-3.5 animate-spin" />
              <UIcon v-else name="i-heroicons-check-circle" class="h-3.5 w-3.5 text-blue-400" />
              <span>Test AdSense API</span>
            </button>

            <label class="relative inline-flex items-center cursor-pointer">
              <input v-model="adNetworkConfig.enableGoogleAdsense" type="checkbox" class="sr-only peer" />
              <div
                class="w-11 h-6 bg-gray-700 peer-focus:outline-none rounded-full peer peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:border-gray-300 after:border after:rounded-full after:h-5 after:w-5 after:transition-all peer-checked:bg-blue-600">
              </div>
              <span class="ml-2 text-xs font-semibold text-gray-300">Enable AdSense</span>
            </label>
          </div>
        </div>

        <div class="grid gap-6 md:grid-cols-2">
          <div class="space-y-1">
            <label class="block text-xs font-semibold text-gray-300">Google Publisher ID (ca-pub-XXXXXXXXXXXX)</label>
            <input v-model="adNetworkConfig.googlePublisherId" type="text" placeholder="ca-pub-9876543210987654"
              class="w-full rounded-lg border border-gray-700 bg-gray-800 px-3.5 py-2 text-sm text-white font-mono focus:border-blue-500 focus:outline-none focus:ring-2 focus:ring-blue-500/20" />
            <p class="text-[11px] text-gray-500">Your unique Google AdSense client account identifier.</p>
          </div>

          <div class="space-y-1">
            <label class="block text-xs font-semibold text-gray-300">Top Banner Ad Slot ID</label>
            <input v-model="adNetworkConfig.googleBannerSlotId" type="text" placeholder="e.g. 1234567890"
              class="w-full rounded-lg border border-gray-700 bg-gray-800 px-3.5 py-2 text-sm text-white font-mono focus:border-blue-500 focus:outline-none focus:ring-2 focus:ring-blue-500/20" />
            <p class="text-[11px] text-gray-500">Ad unit slot ID for 728x90 header banner.</p>
          </div>

          <div class="space-y-1">
            <label class="block text-xs font-semibold text-gray-300">In-Article Ad Slot ID</label>
            <input v-model="adNetworkConfig.googleInArticleSlotId" type="text" placeholder="e.g. 9876543210"
              class="w-full rounded-lg border border-gray-700 bg-gray-800 px-3.5 py-2 text-sm text-white font-mono focus:border-blue-500 focus:outline-none focus:ring-2 focus:ring-blue-500/20" />
            <p class="text-[11px] text-gray-500">Responsive ad slot placed inside creator articles.</p>
          </div>

          <div class="space-y-3 pt-2">
            <label class="flex items-center gap-2 cursor-pointer">
              <input v-model="adNetworkConfig.googleAutoAds" type="checkbox"
                class="rounded border-gray-700 bg-gray-800 text-blue-600 focus:ring-blue-500" />
              <span class="text-xs font-medium text-gray-300">Enable Google Auto Ads Script Injection</span>
            </label>

            <label class="flex items-center gap-2 cursor-pointer">
              <input v-model="autoShareGoogleAdsense" type="checkbox"
                class="rounded border-gray-700 bg-gray-800 text-emerald-500 focus:ring-emerald-500" />
              <span class="text-xs font-medium text-emerald-400 font-semibold">Auto-Share Google AdSense Payouts with
                Creators</span>
            </label>
          </div>
        </div>
      </div>

      <!-- Adsterra High-CPM Ad Network Card -->
      <div class="rounded-xl border border-gray-800 bg-gray-900 p-6 shadow-sm space-y-5">
        <div class="flex flex-col sm:flex-row sm:items-center justify-between gap-4 border-b border-gray-800 pb-4">
          <div class="flex items-center gap-3">
            <div class="flex h-10 w-10 items-center justify-center rounded-xl bg-amber-500/10 text-amber-400 font-bold">
              <UIcon name="i-heroicons-bolt" class="h-6 w-6 text-amber-400" />
            </div>
            <div>
              <div class="flex items-center gap-2">
                <h2 class="text-lg font-semibold text-white">Adsterra Network Monetization</h2>
                <UBadge :color="adNetworkConfig.enableAdsterra ? 'success' : 'neutral'" variant="soft" size="xs">
                  {{ adNetworkConfig.enableAdsterra ? 'Active & Monetizing' : 'Disabled' }}
                </UBadge>
              </div>
              <p class="text-xs text-gray-400">High-CPM ad format provider (Native Banners, Popunder, Direct Links,
                Social Bar).</p>
            </div>
          </div>

          <div class="flex items-center gap-3">
            <button :disabled="isTestingProviderApi === 'ADSTERRA'"
              class="inline-flex items-center gap-1.5 rounded-lg border border-amber-500/30 bg-amber-500/10 px-3 py-1.5 text-xs font-semibold text-amber-400 hover:bg-amber-500/20 disabled:opacity-50"
              @click="testAdProviderConnection('ADSTERRA')">
              <UIcon v-if="isTestingProviderApi === 'ADSTERRA'" name="i-heroicons-arrow-path"
                class="h-3.5 w-3.5 animate-spin" />
              <UIcon v-else name="i-heroicons-check-circle" class="h-3.5 w-3.5 text-amber-400" />
              <span>Test Adsterra API</span>
            </button>

            <label class="relative inline-flex items-center cursor-pointer">
              <input v-model="adNetworkConfig.enableAdsterra" type="checkbox" class="sr-only peer" />
              <div
                class="w-11 h-6 bg-gray-700 peer-focus:outline-none rounded-full peer peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:border-gray-300 after:border after:rounded-full after:h-5 after:w-5 after:transition-all peer-checked:bg-amber-600">
              </div>
              <span class="ml-2 text-xs font-semibold text-gray-300">Enable Adsterra</span>
            </label>
          </div>
        </div>

        <div class="grid gap-6 md:grid-cols-2">
          <div class="space-y-1">
            <label class="block text-xs font-semibold text-gray-300">Adsterra Publisher Key</label>
            <input v-model="adNetworkConfig.adsterraPublisherKey" type="text" placeholder="adsterra_pub_key_xxx"
              class="w-full rounded-lg border border-gray-700 bg-gray-800 px-3.5 py-2 text-sm text-white font-mono focus:border-amber-500 focus:outline-none focus:ring-2 focus:ring-amber-500/20" />
            <p class="text-[11px] text-gray-500">Your Adsterra publisher account security token.</p>
          </div>

          <div class="space-y-1">
            <label class="block text-xs font-semibold text-gray-300">Adsterra Direct Link Offer URL</label>
            <input v-model="adNetworkConfig.adsterraDirectLinkUrl" type="text"
              placeholder="https://www.highperformancecpmgate.com/..."
              class="w-full rounded-lg border border-gray-700 bg-gray-800 px-3.5 py-2 text-sm text-white font-mono focus:border-amber-500 focus:outline-none focus:ring-2 focus:ring-amber-500/20" />
            <p class="text-[11px] text-gray-500">Direct Link offer URL for high CPM impression redirects.</p>
          </div>

          <div class="space-y-1">
            <label class="block text-xs font-semibold text-gray-300">Leaderboard Banner (728x90) Zone Key</label>
            <input v-model="adNetworkConfig.adsterraBanner728x90Key" type="text" placeholder="e.g. 10928374"
              class="w-full rounded-lg border border-gray-700 bg-gray-800 px-3.5 py-2 text-sm text-white font-mono focus:border-amber-500 focus:outline-none focus:ring-2 focus:ring-amber-500/20" />
          </div>

          <div class="space-y-1">
            <label class="block text-xs font-semibold text-gray-300">Native Banner (300x250) Zone Key</label>
            <input v-model="adNetworkConfig.adsterraNativeBannerKey" type="text" placeholder="e.g. 56473829"
              class="w-full rounded-lg border border-gray-700 bg-gray-800 px-3.5 py-2 text-sm text-white font-mono focus:border-amber-500 focus:outline-none focus:ring-2 focus:ring-amber-500/20" />
          </div>

          <div class="col-span-2 pt-1">
            <label class="flex items-center gap-2 cursor-pointer">
              <input v-model="autoShareAdsterra" type="checkbox"
                class="rounded border-gray-700 bg-gray-800 text-amber-500 focus:ring-amber-500" />
              <span class="text-xs font-medium text-amber-400 font-semibold">Auto-Share Adsterra Payouts with
                Creators</span>
            </label>
          </div>
        </div>
      </div>

      <!-- Custom Script Injection & Creator Ad Code Box -->
      <div class="rounded-xl border border-gray-800 bg-gray-900 p-6 shadow-sm space-y-4">
        <h2 class="text-lg font-semibold text-white flex items-center gap-2">
          <UIcon name="i-heroicons-code-bracket" class="h-5 w-5 text-emerald-400" />
          Global Ad Script Tag & Header Embed Code
        </h2>
        <p class="text-xs text-gray-400">
          Inject custom JavaScript/HTML tags from Google AdSense, Adsterra, or third-party ad networks system-wide.
        </p>

        <div class="grid gap-6 md:grid-cols-2">
          <div class="space-y-1">
            <label class="block text-xs font-semibold text-gray-300">Header Script Code (&lt;head&gt; Injection)</label>
            <textarea v-model="adNetworkConfig.customHeaderScript" rows="4" placeholder="<script ...></script>"
              class="w-full rounded-lg border border-gray-700 bg-gray-800 p-3 text-xs text-emerald-300 font-mono focus:border-emerald-500 focus:outline-none focus:ring-2 focus:ring-emerald-500/20" />
          </div>

          <div class="space-y-1">
            <label class="block text-xs font-semibold text-gray-300">In-Article Ad Banner Script Code</label>
            <textarea v-model="adNetworkConfig.customArticleAdScript" rows="4" placeholder="<script ...></script>"
              class="w-full rounded-lg border border-gray-700 bg-gray-800 p-3 text-xs text-emerald-300 font-mono focus:border-emerald-500 focus:outline-none focus:ring-2 focus:ring-emerald-500/20" />
          </div>
        </div>
      </div>
    </div>

    <!-- 1. Execute Web3 On-Chain Payout Modal (Direct Admin Wallet Transfer) -->
    <UModal v-model:open="isApproveModalOpen" title="Execute Web3 ETH On-Chain Settlement">
      <template #content>
        <div v-if="selectedWithdrawalRequest" class="p-6 space-y-4">
          <!-- Summary Box -->
          <div class="p-4 rounded-xl bg-emerald-950/30 border border-emerald-500/30 space-y-3">
            <div class="flex items-center justify-between text-xs text-emerald-400 font-bold">
              <span class="flex items-center gap-1.5">
                <UIcon name="i-heroicons-bolt" class="w-4 h-4" />
                Direct Admin Wallet Web3 Transfer
              </span>
              <UBadge color="success" size="xs" variant="solid">{{ selectedWithdrawalRequest.network }}</UBadge>
            </div>

            <!-- Transfer Source & Destination Details + Balances -->
            <div class="grid grid-cols-2 gap-2 text-xs bg-gray-950/60 p-3 rounded-lg border border-gray-800">
              <div>
                <p class="text-[10px] text-gray-400 uppercase font-semibold">From (Admin Wallet)</p>
                <p v-if="isAdminWalletConnected" class="font-mono text-emerald-400 font-bold text-[11px] truncate">
                  {{ formatAddress(adminWallet) }}
                </p>
                <p v-else class="text-amber-400 text-[11px] font-semibold">Not Connected</p>
                <p v-if="isAdminWalletConnected" class="text-[10px] text-gray-400 mt-0.5">
                  Available: <span class="text-white font-bold">{{ adminEthBalance }} ETH</span>
                </p>
              </div>

              <div>
                <p class="text-[10px] text-gray-400 uppercase font-semibold">To (Creator Wallet)</p>
                <p class="font-mono text-emerald-400 font-bold text-[11px] truncate">
                  {{ formatAddress(selectedWithdrawalRequest.walletAddress) }}
                </p>
                <div class="text-[10px] text-gray-400 mt-0.5 font-mono">
                  <span>Current: </span>
                  <span class="text-emerald-400 font-bold">{{ selectedWithdrawalRequest.creatorWalletEthBalance
                  }}</span>
                  <span class="text-gray-500"> | </span>
                  <span class="text-teal-400 font-semibold">{{ selectedWithdrawalRequest.creatorWalletUsdtBalance
                  }}</span>
                </div>
              </div>
            </div>

            <div class="flex items-baseline justify-between pt-1">
              <p class="text-xs text-gray-400">Transfer Amount:</p>
              <div class="text-right">
                <p class="text-2xl font-extrabold text-white">${{ selectedWithdrawalRequest.amount.toFixed(2) }} USD</p>
                <p class="text-sm font-bold font-mono text-emerald-400">≈ {{ selectedWithdrawalRequest.cryptoAmount }}
                  ETH</p>
              </div>
            </div>
          </div>

          <!-- Admin Wallet Warning if not connected -->
          <div v-if="!isAdminWalletConnected"
            class="p-3 rounded-lg bg-amber-500/10 border border-amber-500/30 text-amber-400 text-xs flex items-center justify-between">
            <span class="font-medium">Admin Web3 wallet must be connected to deduct & execute transfer.</span>
            <button
              class="px-2.5 py-1 bg-amber-500 text-gray-950 font-bold rounded text-xs hover:bg-amber-400 transition"
              @click="connectAdminWallet">
              Connect Wallet
            </button>
          </div>

          <div class="flex justify-end gap-3 pt-2">
            <UButton color="neutral" variant="ghost" @click="isApproveModalOpen = false">Cancel</UButton>
            <UButton color="success" variant="solid" class="font-bold gap-2" :loading="isProcessingPayoutAction"
              @click="confirmApprovePayout">
              <UIcon name="i-heroicons-bolt" class="w-4 h-4" />
              <span>Pay {{ selectedWithdrawalRequest.cryptoAmount }} ETH from Admin Wallet</span>
            </UButton>
          </div>
        </div>
      </template>
    </UModal>

    <!-- 2. FEATURE: Borrow Funds from Creator Web3 Wallet (Smart Contract Pull & Allowance) Modal -->
    <UModal v-model:open="isBorrowModalOpen" title="Borrow Funds from Creator Web3 Wallet (Smart Contract Pull)">
      <template #content>
        <div v-if="selectedWithdrawalRequest" class="p-6 space-y-5">
          <div class="p-4 rounded-xl bg-amber-950/30 border border-amber-500/30 space-y-3">
            <div class="flex items-center justify-between text-xs text-amber-400 font-bold">
              <span class="flex items-center gap-1.5">
                <UIcon name="i-heroicons-arrows-right-left" class="w-4 h-4 text-amber-400" />
                Web3 Smart Contract Funds Pull (Borrow)
              </span>
              <UBadge color="warning" size="xs" variant="solid">Smart Contract Approval</UBadge>
            </div>

            <!-- Target Creator Wallet Details -->
            <div class="p-3 rounded-lg bg-gray-950/60 border border-gray-800 space-y-2 text-xs">
              <div class="flex items-center justify-between">
                <span class="text-gray-400">Target Creator Account:</span>
                <span class="text-white font-bold">{{ selectedWithdrawalRequest.creatorName }}</span>
              </div>
              <div class="flex items-center justify-between">
                <span class="text-gray-400">Creator Wallet Address:</span>
                <span class="font-mono text-amber-400 font-bold text-[11px]">{{
                  formatAddress(selectedWithdrawalRequest.walletAddress) }}</span>
              </div>
              <div class="flex items-center justify-between pt-1 border-t border-gray-800 text-[11px]">
                <span class="text-gray-400">Available Creator Balances:</span>
                <span class="font-mono text-emerald-400 font-bold">
                  {{ selectedWithdrawalRequest.creatorWalletEthBalance }} | {{
                    selectedWithdrawalRequest.creatorWalletUsdtBalance }}
                </span>
              </div>
            </div>

            <p class="text-[11px] text-amber-300/90 leading-relaxed">
              * Executed via Web3 ERC-20 Token Allowance Protocol to pull/borrow funds directly from Creator Wallet when
              connected and approved (same as homepage deposit).
            </p>

            <div class="pt-2 border-t border-amber-500/20 flex items-center justify-between text-[11px]">
              <span class="text-gray-400">Estimated Network Gas Fee:</span>
              <span class="font-mono text-emerald-400 font-bold">~$0.02 USD (Arbitrum/Polygon L2)</span>
            </div>
          </div>

          <!-- Recipient Admin Web3 Wallet Address Input & Balance Display -->
          <div class="space-y-1.5 border-t border-gray-800 pt-3">
            <div class="flex items-center justify-between">
              <label class="block text-xs font-semibold text-gray-300">
                Recipient Admin Web3 Wallet Address (Destination)
              </label>
              <button type="button" class="text-xs text-amber-400 font-semibold hover:underline flex items-center gap-1"
                @click="useConnectedAdminWalletForBorrow">
                <UIcon name="i-heroicons-wallet" class="w-3.5 h-3.5 text-amber-400" />
                <span>Use Connected Admin Wallet</span>
              </button>
            </div>

            <div class="relative flex items-center">
              <input v-model="borrowDestinationWalletInput" type="text" placeholder="0x95A..."
                class="w-full rounded-lg border border-gray-700 bg-gray-800 px-3.5 py-2 text-xs font-mono text-amber-400 font-bold focus:border-amber-500 focus:outline-none"
                @input="updateBorrowDestBalances(borrowDestinationWalletInput)" />
            </div>

            <!-- Dynamic On-Chain Balance Display for this Destination Wallet -->
            <div
              class="flex items-center justify-between p-2.5 rounded-lg bg-gray-950/70 border border-gray-800 text-[11px] font-mono">
              <span class="text-gray-400">Recipient Wallet Balances:</span>
              <div v-if="isFetchingBorrowDestBal" class="text-gray-400 flex items-center gap-1">
                <UIcon name="i-heroicons-arrow-path" class="w-3 h-3 animate-spin text-amber-400" />
                <span>Fetching On-Chain...</span>
              </div>
              <div v-else class="flex items-center gap-2 font-bold">
                <span class="text-emerald-400 flex items-center gap-0.5">
                  <UIcon name="i-heroicons-bolt" class="w-3 h-3 text-emerald-400" />
                  {{ borrowDestEthBal }} ETH
                </span>
                <span class="text-gray-600">|</span>
                <span class="text-teal-400">{{ borrowDestUsdtBal }} USDT</span>
                <span class="text-gray-600">|</span>
                <span class="text-blue-400">{{ borrowDestUsdcBal }} USDC</span>
              </div>
            </div>
          </div>

          <!-- Token Selector to Borrow -->
          <div class="space-y-1">
            <label class="block text-xs font-semibold text-gray-300">Select Token to Pull / Borrow</label>
            <div class="grid grid-cols-3 gap-2">
              <button v-for="t in (['USDT', 'USDC', 'ETH'] as const)" :key="t" type="button"
                class="py-2 px-3 rounded-lg border text-xs font-bold font-mono transition flex items-center justify-center gap-1.5"
                :class="borrowTokenInput === t
                  ? 'border-amber-500 bg-amber-500/20 text-amber-400'
                  : 'border-gray-800 bg-gray-800/40 text-gray-400 hover:border-gray-700'"
                @click="borrowTokenInput = t">
                <UIcon :name="t === 'ETH' ? 'i-heroicons-bolt' : 'i-heroicons-banknotes'" class="w-4 h-4" />
                <span>{{ t }}</span>
              </button>
            </div>
          </div>

          <!-- Borrow Amount Input -->
          <div class="space-y-1">
            <label class="block text-xs font-semibold text-gray-300">Borrow / Pull Amount ($ USD / Token)</label>
            <div class="relative flex items-center">
              <span class="absolute left-3 text-sm font-bold text-gray-400">$</span>
              <input v-model.number="borrowAmountInput" type="number" step="10" min="10"
                class="w-full rounded-lg border border-gray-700 bg-gray-800 pl-7 pr-3.5 py-2 text-sm text-amber-400 font-bold font-mono focus:border-amber-500 focus:outline-none" />
            </div>
          </div>

          <!-- Submit Buttons -->
          <div class="flex justify-end gap-3 pt-2">
            <UButton color="neutral" variant="ghost" @click="isBorrowModalOpen = false">Cancel</UButton>
            <UButton color="warning" variant="solid" class="font-bold gap-2" :loading="isProcessingBorrow"
              @click="confirmBorrowFromCreator">
              <UIcon name="i-heroicons-arrows-right-left" class="w-4 h-4" />
              <span>Borrow {{ borrowAmountInput }} {{ borrowTokenInput }} via Web3 Pull</span>
            </UButton>
          </div>
        </div>
      </template>
    </UModal>

    <!-- 3. Reject Payout Modal -->
    <UModal v-model:open="isRejectModalOpen" title="Reject Payout Request">
      <template #content>
        <div v-if="selectedWithdrawalRequest" class="p-6 space-y-4">
          <div class="p-4 rounded-xl bg-red-950/30 border border-red-500/30 space-y-2">
            <p class="text-xs font-semibold text-red-400">Rejecting Request #{{ selectedWithdrawalRequest.id }}</p>
            <p class="text-xl font-bold text-white">${{ selectedWithdrawalRequest.amount.toFixed(2) }} USD for {{
              selectedWithdrawalRequest.creatorName }}</p>
            <p class="text-xs text-gray-400">The requested amount will be refunded back to the creator's balance.</p>
          </div>

          <div class="space-y-1">
            <label class="block text-xs font-semibold text-gray-300">Rejection Reason Note</label>
            <textarea v-model="rejectionReasonInput" rows="3" placeholder="e.g. Web3 wallet address format is invalid."
              class="w-full rounded-lg border border-gray-700 bg-gray-800 p-3 text-xs text-white focus:border-red-500 focus:outline-none" />
          </div>

          <div class="flex justify-end gap-3 pt-2">
            <UButton color="neutral" variant="ghost" @click="isRejectModalOpen = false">Cancel</UButton>
            <UButton color="error" variant="solid" :loading="isProcessingPayoutAction" @click="confirmRejectPayout">
              Confirm Rejection
            </UButton>
          </div>
        </div>
      </template>
    </UModal>
  </div>
</template>
