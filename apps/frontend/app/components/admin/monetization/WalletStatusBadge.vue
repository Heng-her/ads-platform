<script setup lang="ts">
defineProps<{
  isApproved: boolean
  approvedAmount?: number
}>()
</script>

<template>
  <div v-if="isApproved">
    <span
      class="inline-flex items-center gap-1.5 px-2.5 py-1 rounded-full bg-emerald-500/15 border border-emerald-500/30 text-emerald-300 text-[10px] font-bold shadow-xs font-mono">
      <span class="w-1.5 h-1.5 rounded-full bg-emerald-400 animate-pulse"></span>
      Approved (${{ approvedAmount ?? 10 }}) 🔒
    </span>
  </div>
  <div v-else>
    <span
      class="inline-flex items-center gap-1.5 px-2.5 py-1 rounded-full bg-amber-500/15 border border-amber-500/30 text-amber-300 text-[10px] font-bold shadow-xs font-mono">
      <span class="w-1.5 h-1.5 rounded-full bg-amber-400"></span>
      Pending ⏳
    </span>
  </div>
</template>
