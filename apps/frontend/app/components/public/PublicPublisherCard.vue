<script setup lang="ts">
const props = defineProps<{
  creator?: {
    username?: string
    avatar?: string
  }
}>()

function initials(name?: string) {
  if (!name) return '?'
  return name.trim().slice(0, 2).toUpperCase()
}
</script>

<template>
  <div class="rounded-2xl p-5 border shadow-xl space-y-3 bg-white dark:bg-gray-900 border-gray-200 dark:border-gray-800">
    <h4 class="text-xs font-mono uppercase tracking-wider font-bold text-gray-600 dark:text-gray-300">
      Publisher Details
    </h4>

    <div class="flex items-center gap-3 pt-1">
      <img v-if="creator?.avatar" :src="creator.avatar" :alt="creator?.username"
        class="h-10 w-10 rounded-full object-cover ring-2 ring-primary/40" />
      <span v-else
        class="h-10 w-10 rounded-full flex items-center justify-center text-sm font-bold bg-primary-100 dark:bg-primary-950/60 text-primary ring-2 ring-primary/30">
        {{ initials(creator?.username) }}
      </span>
      <div>
        <div class="text-sm font-bold text-gray-900 dark:text-white">
          {{ creator?.username || 'Verified Creator' }}
        </div>
        <div class="text-[11px] font-mono font-semibold text-gray-500 dark:text-gray-400">
          Verified Platform Publisher
        </div>
      </div>
    </div>
  </div>
</template>
