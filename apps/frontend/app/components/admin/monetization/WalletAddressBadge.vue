<script setup lang="ts">
import { useAppToast } from '~/composables/useAppToast'

const props = defineProps<{
  address: string
}>()

const toast = useAppToast()

function formatAddress(addr?: string | null) {
  if (!addr) return ''
  if (addr.length <= 12) return addr
  return `${addr.substring(0, 6)}...${addr.substring(addr.length - 4)}`
}

function copyToClipboard(text: string, label: string) {
  if (import.meta.client && navigator?.clipboard) {
    navigator.clipboard.writeText(text)
  }
  toast.success('Copied', `${label} copied to clipboard!`)
}
</script>

<template>
  <div class="inline-flex items-center gap-1.5 font-mono text-xs font-semibold group cursor-pointer"
    :class="address.startsWith('T') ? 'text-rose-400 hover:text-rose-300' : 'text-emerald-400 hover:text-emerald-300'"
    title="Click to copy wallet address"
    @click="copyToClipboard(address, 'Wallet Address')">
    <UIcon :name="address.startsWith('T') ? 'i-heroicons-currency-dollar' : 'i-heroicons-wallet'"
      class="w-3.5 h-3.5 shrink-0 opacity-75" />
    <span>{{ formatAddress(address) }}</span>
    <UIcon name="i-heroicons-clipboard-document"
      class="w-3 h-3 text-gray-500 group-hover:text-white transition-colors" />
  </div>
</template>
