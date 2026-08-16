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
  <div class="inline-flex items-center gap-1.5 px-2.5 py-1.5 rounded-xl bg-gray-950/80 border text-xs font-bold transition-all hover:border-gray-700 shadow-xs font-mono"
    :class="address.startsWith('T') ? 'text-rose-400 border-rose-500/30 bg-rose-950/20' : 'text-emerald-400 border-emerald-500/30 bg-emerald-950/20'">
    <UIcon :name="address.startsWith('T') ? 'i-heroicons-currency-dollar' : 'i-heroicons-wallet'"
      class="w-3.5 h-3.5 shrink-0" />
    <span title="Click to copy" class="cursor-pointer" @click="copyToClipboard(address, 'Wallet Address')">
      {{ formatAddress(address) }}
    </span>
    <button title="Copy Wallet Address" class="text-gray-500 hover:text-white transition-colors ml-0.5"
      @click="copyToClipboard(address, 'Wallet Address')">
      <UIcon name="i-heroicons-clipboard-document" class="w-3.5 h-3.5" />
    </button>
  </div>
</template>
