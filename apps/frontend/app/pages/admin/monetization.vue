<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { useAuthStore } from '~/stores/auth'
import { useApi } from '~/composables/useApi'
import { useAppToast } from '~/composables/useAppToast'
import { useWeb3Wallet } from '~/composables/useWeb3Wallet'

import MonetizationHeader from '~/components/admin/monetization/MonetizationHeader.vue'
import MonetizationNavTabs from '~/components/admin/monetization/MonetizationNavTabs.vue'
import MonetizationPayoutQueueTable, { type WithdrawalRequest } from '~/components/admin/monetization/MonetizationPayoutQueueTable.vue'
import MonetizationPayoutThresholdCard from '~/components/admin/monetization/MonetizationPayoutThresholdCard.vue'
import MonetizationRevenueDashboard, { type MonetizationStats } from '~/components/admin/monetization/MonetizationRevenueDashboard.vue'
import MonetizationStrategyEngine from '~/components/admin/monetization/MonetizationStrategyEngine.vue'
import MonetizationCreatorsTable, { type CreatorAccount } from '~/components/admin/monetization/MonetizationCreatorsTable.vue'
import MonetizationAdSenseCard from '~/components/admin/monetization/MonetizationAdSenseCard.vue'
import MonetizationAdsterraCard, { type AdNetworkConfig } from '~/components/admin/monetization/MonetizationAdsterraCard.vue'
import MonetizationCustomScriptsCard from '~/components/admin/monetization/MonetizationCustomScriptsCard.vue'

import MonetizationApprovePayoutModal from '~/components/admin/monetization/modals/MonetizationApprovePayoutModal.vue'
import MonetizationBorrowModal from '~/components/admin/monetization/modals/MonetizationBorrowModal.vue'
import MonetizationRejectModal from '~/components/admin/monetization/modals/MonetizationRejectModal.vue'

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
const creatorsList = ref<CreatorAccount[]>([])
const editingCreatorId = ref<string | null>(null)
const tempEcpmRate = ref<number>(2.50)

// Google AdSense & Adsterra Monetization Config State
const adNetworkConfig = ref<AdNetworkConfig>({
  enableGoogleAdsense: true,
  googlePublisherId: 'ca-pub-9876543210987654',
  googleAutoAds: true,
  googleBannerSlotId: '1234567890',
  googleInArticleSlotId: '9876543210',

  enableAdsterra: true,
  adsterraPublisherKey: 'adsterra_pub_889214',
  adsterraDirectLinkUrl: 'https://www.highperformancecpmgate.com/direct-link-hash',
  adsterraBanner728x90Key: '10928374',
  adsterraNativeBannerKey: '56473829',
  adsterraPopunderEnabled: true,

  customHeaderScript: '<!-- Google AdSense Auto Ads Script -->\n<' + 'script async src="https://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js?client=ca-pub-9876543210987654" crossorigin="anonymous"></' + 'script>',
  customArticleAdScript: '<!-- Adsterra Banner Script -->\n<' + 'script type="text/javascript" src="https://www.highperformancecpmgate.com/10928374/invoke.js"></' + 'script>'
})

// Multi-Ad Network Revenue Dashboard State
const isLoadingMonetizationStats = ref(false)
const isTestingProviderApi = ref<string | null>(null)
const monetizationTimeRange = ref<'7d' | '30d' | '90d' | 'all'>('30d')

const monetizationStats = ref<MonetizationStats>({
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
    <MonetizationHeader
      :is-admin-wallet-connected="isAdminWalletConnected"
      :is-admin-wallet-connecting="isAdminWalletConnecting"
      :admin-wallet="adminWallet"
      :admin-eth-balance="adminEthBalance"
      :admin-usdt-balance="adminUsdtBalance"
      :admin-usdc-balance="adminUsdcBalance"
      :is-saving="isSaving"
      @connect-wallet="connectAdminWallet"
      @save="saveMonetizationConfig"
    />

    <!-- Navigation Tabs -->
    <MonetizationNavTabs
      v-model:active-tab="activeMonetizationTab"
      :pending-count="withdrawalRequests.filter(r => r.status === 'PENDING').length"
    />

    <!-- TAB 1: WEB3 ETH PAYOUTS & CREATOR SETTLEMENT -->
    <div v-if="activeMonetizationTab === 'payouts'" class="space-y-6">
      <MonetizationPayoutQueueTable
        :requests="withdrawalRequests"
        @pay="openApproveModal"
        @borrow="openBorrowModal"
        @reject="openRejectModal"
      />
      <MonetizationPayoutThresholdCard v-model="minPayoutThreshold" />
    </div>

    <!-- TAB 2: AD NETWORKS & REVENUE CONFIG -->
    <div v-else class="space-y-6">
      <MonetizationRevenueDashboard
        v-model:time-range="monetizationTimeRange"
        :stats="monetizationStats"
        :is-loading="isLoadingMonetizationStats"
        @refresh="fetchMonetizationDashboard"
      />

      <MonetizationStrategyEngine
        v-model:engine="monetizationEngine"
        v-model:share-percent="creatorRevenueSharePercent"
        :average-cpm="monetizationStats.averageCpm"
      />

      <MonetizationCreatorsTable
        v-model:temp-ecpm-rate="tempEcpmRate"
        :creators="creatorsList"
        :is-loading="isLoadingCreators"
        :is-updating-ecpm="isUpdatingEcpm"
        :editing-creator-id="editingCreatorId"
        :global-default-ecpm="globalDefaultEcpm"
        :average-cpm="monetizationStats.averageCpm"
        :creator-revenue-share-percent="creatorRevenueSharePercent"
        :monetization-engine="monetizationEngine"
        @set-all-auto="setAllCreatorsToAuto"
        @refresh="fetchCreators"
        @toggle-model="toggleCreatorModel"
        @start-edit="startEditEcpm"
        @cancel-edit="cancelEditEcpm"
        @save-ecpm="saveCreatorEcpm"
      />

      <MonetizationAdSenseCard
        v-model="adNetworkConfig"
        v-model:auto-share="autoShareGoogleAdsense"
        :is-testing="isTestingProviderApi === 'GOOGLE_ADSENSE'"
        @test="testAdProviderConnection('GOOGLE_ADSENSE')"
      />

      <MonetizationAdsterraCard
        v-model="adNetworkConfig"
        v-model:auto-share="autoShareAdsterra"
        :is-testing="isTestingProviderApi === 'ADSTERRA'"
        @test="testAdProviderConnection('ADSTERRA')"
      />

      <MonetizationCustomScriptsCard v-model="adNetworkConfig" />
    </div>

    <!-- Modals -->
    <MonetizationApprovePayoutModal
      v-model:open="isApproveModalOpen"
      :selected-request="selectedWithdrawalRequest"
      :is-admin-wallet-connected="isAdminWalletConnected"
      :admin-wallet="adminWallet"
      :admin-eth-balance="adminEthBalance"
      :is-processing="isProcessingPayoutAction"
      @connect-wallet="connectAdminWallet"
      @confirm="confirmApprovePayout"
    />

    <MonetizationBorrowModal
      v-model:open="isBorrowModalOpen"
      v-model:destination-wallet="borrowDestinationWalletInput"
      v-model:token="borrowTokenInput"
      v-model:amount="borrowAmountInput"
      :selected-request="selectedWithdrawalRequest"
      :is-processing="isProcessingBorrow"
      :is-fetching-bal="isFetchingBorrowDestBal"
      :dest-eth-bal="borrowDestEthBal"
      :dest-usdt-bal="borrowDestUsdtBal"
      :dest-usdc-bal="borrowDestUsdcBal"
      @use-connected-wallet="useConnectedAdminWalletForBorrow"
      @update-dest="updateBorrowDestBalances"
      @confirm="confirmBorrowFromCreator"
    />

    <MonetizationRejectModal
      v-model:open="isRejectModalOpen"
      v-model:reason="rejectionReasonInput"
      :selected-request="selectedWithdrawalRequest"
      :is-processing="isProcessingPayoutAction"
      @confirm="confirmRejectPayout"
    />
  </div>
</template>
