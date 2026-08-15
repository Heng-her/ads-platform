<script setup lang="ts">
import { useWalletAdapter } from '~/composables/useWalletAdapter'

const props = defineProps<{
  open: boolean
}>()

const emit = defineEmits<{
  (e: 'update:open', value: boolean): void
}>()

const walletAdapter = useWalletAdapter()
const isConnecting = ref(false)
const selectedWallet = ref<string | null>(null)
const connectedAddress = ref<string | null>(null)
const selectedNetwork = ref('Arbitrum One')

const networks = [
  { name: 'Arbitrum One', chainId: '42161', icon: 'i-heroicons-bolt' },
  { name: 'TRON Mainnet', chainId: 'tron', icon: 'i-heroicons-currency-dollar' },
  { name: 'Ethereum Mainnet', chainId: '1', icon: 'i-simple-icons-ethereum' },
  { name: 'Polygon', chainId: '137', icon: 'i-simple-icons-polygon' }
]

const walletProviders = [
  {
    id: 'metamask',
    name: 'MetaMask',
    desc: 'Connect using EVM browser extension or mobile app',
    icon: 'i-simple-icons-metamask',
    badge: 'EVM Popular'
  },
  {
    id: 'tronlink',
    name: 'TronLink',
    desc: 'Connect TRON network (TRX & TRC-20 USDT)',
    icon: 'i-heroicons-currency-dollar',
    badge: 'TRC-20'
  },
  {
    id: 'coinbase',
    name: 'Coinbase Wallet',
    desc: 'Connect using Coinbase Wallet app or extension',
    icon: 'i-simple-icons-coinbase',
    badge: 'Supported'
  },
  {
    id: 'walletconnect',
    name: 'WalletConnect',
    desc: 'Scan QR code with any supported mobile wallet',
    icon: 'i-simple-icons-walletconnect',
    badge: 'Multi-chain'
  }
]

async function connectWallet(providerId: string) {
  selectedWallet.value = providerId
  isConnecting.value = true

  try {
    if (providerId === 'tronlink') {
      walletAdapter.selectedChainFamily.value = 'TRON'
      selectedNetwork.value = 'TRON Mainnet'
      const success = await walletAdapter.tronWallet.connectTronWallet()
      if (success && walletAdapter.tronWallet.tronWallet.value) {
        connectedAddress.value = walletAdapter.tronWallet.tronWallet.value
      }
    } else {
      walletAdapter.selectedChainFamily.value = 'EVM'
      const success = await walletAdapter.evmWallet.connect()
      if (success && walletAdapter.evmWallet.wallet.value) {
        connectedAddress.value = walletAdapter.evmWallet.wallet.value
      }
    }
  } catch (err) {
    console.warn('Wallet connection error:', err)
  } finally {
    isConnecting.value = false
  }
}

function disconnect() {
  connectedAddress.value = null
  selectedWallet.value = null
  isConnecting.value = false
}

function closeModal() {
  emit('update:open', false)
}
</script>

<template>
  <UModal
    :open="open"
    title="Connect Web3 Wallet"
    description="Connect your non-custodial wallet to interact with ad budget escrows and smart contracts."
    @update:open="emit('update:open', $event)"
  >
    <template #body>
      <div class="space-y-5">
        <!-- Connected State -->
        <div v-if="connectedAddress" class="p-4 bg-emerald-500/10 border border-emerald-500/30 rounded-xl space-y-3">
          <div class="flex items-center justify-between">
            <span class="text-xs font-semibold text-emerald-400 uppercase tracking-wider">Wallet Connected</span>
            <UBadge color="success" variant="subtle" size="xs">Non-Custodial Session Active</UBadge>
          </div>

          <div class="flex items-center justify-between bg-black/30 p-3 rounded-lg border border-emerald-500/20">
            <div>
              <div class="text-xs text-gray-400">Account Address</div>
              <div class="text-sm font-mono font-bold text-white">{{ connectedAddress }}</div>
            </div>
            <div class="text-right">
              <div class="text-xs text-gray-400">Network</div>
              <div class="text-xs font-semibold text-emerald-300">{{ selectedNetwork }}</div>
            </div>
          </div>

          <div class="flex items-center gap-2 pt-1">
            <UButton color="neutral" variant="soft" size="xs" block @click="disconnect">
              Disconnect Wallet
            </UButton>
            <UButton color="primary" size="xs" block @click="closeModal">
              Continue to Platform
            </UButton>
          </div>
        </div>

        <!-- Disconnected Connection Flow -->
        <template v-else>
          <!-- Network Switcher Selector -->
          <div>
            <label class="block text-xs font-semibold text-gray-400 uppercase tracking-wider mb-2">
              Select Execution Network
            </label>
            <div class="grid grid-cols-2 gap-2">
              <button
                v-for="net in networks"
                :key="net.chainId"
                type="button"
                class="flex items-center gap-2 p-2.5 rounded-lg text-xs font-medium border transition-all text-left"
                :class="selectedNetwork === net.name
                  ? 'border-emerald-500/50 bg-emerald-500/10 text-emerald-400 font-semibold'
                  : 'border-gray-200 dark:border-gray-800 bg-gray-50 dark:bg-gray-900/60 text-gray-600 dark:text-gray-300 hover:border-gray-300 dark:hover:border-gray-700'"
                @click="selectedNetwork = net.name"
              >
                <UIcon :name="net.icon" class="w-4 h-4 text-emerald-400 shrink-0" />
                <span class="truncate">{{ net.name }}</span>
              </button>
            </div>
          </div>

          <!-- Wallet Provider List -->
          <div class="space-y-2">
            <label class="block text-xs font-semibold text-gray-400 uppercase tracking-wider">
              Choose Wallet Provider
            </label>

            <button
              v-for="provider in walletProviders"
              :key="provider.id"
              type="button"
              :disabled="isConnecting"
              class="w-full flex items-center justify-between p-3.5 rounded-xl border border-gray-200 dark:border-gray-800/80 bg-white dark:bg-gray-900/80 hover:border-emerald-500/40 hover:bg-emerald-500/5 transition-all text-left group disabled:opacity-50"
              @click="connectWallet(provider.id)"
            >
              <div class="flex items-center gap-3">
                <div class="w-9 h-9 rounded-lg bg-gray-100 dark:bg-gray-800 flex items-center justify-center group-hover:bg-emerald-500/20 transition-colors">
                  <UIcon :name="provider.icon" class="w-5 h-5 text-gray-700 dark:text-gray-300 group-hover:text-emerald-400" />
                </div>
                <div>
                  <div class="text-sm font-semibold text-gray-900 dark:text-gray-100 flex items-center gap-2">
                    {{ provider.name }}
                    <span v-if="provider.badge" class="text-[10px] px-1.5 py-0.5 rounded bg-gray-100 dark:bg-gray-800 text-gray-500 dark:text-gray-400 font-mono">
                      {{ provider.badge }}
                    </span>
                  </div>
                  <div class="text-xs text-gray-500 dark:text-gray-400">{{ provider.desc }}</div>
                </div>
              </div>

              <div>
                <UIcon
                  v-if="isConnecting && selectedWallet === provider.id"
                  name="i-heroicons-arrow-path"
                  class="w-5 h-5 text-emerald-400 animate-spin"
                />
                <UIcon
                  v-else
                  name="i-heroicons-chevron-right"
                  class="w-4 h-4 text-gray-400 group-hover:text-emerald-400 group-hover:translate-x-0.5 transition-all"
                />
              </div>
            </button>
          </div>

          <!-- Trust & Security Disclaimer -->
          <div class="p-3 rounded-lg bg-gray-100 dark:bg-gray-850/60 border border-gray-200 dark:border-gray-800/60 text-[11px] text-gray-500 dark:text-gray-400 flex items-start gap-2">
            <UIcon name="i-heroicons-shield-check" class="w-4 h-4 text-emerald-400 shrink-0 mt-0.5" />
            <div>
              <strong class="text-gray-700 dark:text-gray-300 font-semibold">Non-Custodial Architecture:</strong> We never store your private keys or request direct transfers outside smart contract escrows.
            </div>
          </div>
        </template>
      </div>
    </template>
  </UModal>
</template>
