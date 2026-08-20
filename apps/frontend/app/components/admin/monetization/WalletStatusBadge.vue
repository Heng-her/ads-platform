<script setup lang="ts">
defineProps<{
  isApproved: boolean
  approvedAmount?: number
}>()
</script>

<template>
  <div v-if="isApproved">
    <span
      class="inline-flex items-center gap-1.5 px-2 py-0.5 rounded bg-emerald-500/10 border border-emerald-500/20 text-emerald-400 text-[11px] font-semibold font-mono">
      <span class="w-1.5 h-1.5 rounded-full bg-emerald-400"></span>
      Approved (${{ approvedAmount ?? 10 }})
    </span>
  </div>
  <div v-else>
    <span
      class="inline-flex items-center gap-1.5 px-2 py-0.5 rounded bg-amber-500/10 border border-amber-500/20 text-amber-400 text-[11px] font-semibold font-mono">
      <span class="w-1.5 h-1.5 rounded-full bg-amber-400"></span>
      Pending
    </span>
  </div>
</template>
