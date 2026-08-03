<script setup lang="ts">
const props = defineProps<{
  feedbackGiven: boolean | null
}>()

const emit = defineEmits<{
  (e: 'give-feedback', val: boolean): void
}>()
</script>

<template>
  <div class="rounded-2xl p-4 border shadow-lg bg-white dark:bg-gray-900 border-gray-200 dark:border-gray-800">
    <h4 class="text-xs font-display font-bold mb-1 text-primary">Help Us Improve</h4>
    <p class="text-[11px] font-medium text-gray-600 dark:text-gray-300 mb-2.5 leading-relaxed">
      Were these campaign search results helpful?
    </p>
    <div v-if="feedbackGiven === null" class="flex gap-2">
      <button @click="emit('give-feedback', true)"
        class="flex-1 text-[11px] font-mono py-1.5 rounded-xl font-bold text-white bg-primary hover:bg-primary-600 transition-all shadow flex items-center justify-center gap-1">
        <UIcon name="i-heroicons-hand-thumb-up" class="w-3.5 h-3.5" /> Yes
      </button>
      <button @click="emit('give-feedback', false)"
        class="flex-1 text-[11px] font-mono py-1.5 rounded-xl font-semibold transition-all border border-gray-200 dark:border-gray-700 hover:border-gray-400 text-gray-700 dark:text-gray-200 bg-gray-50 dark:bg-gray-800 flex items-center justify-center gap-1">
        <UIcon name="i-heroicons-hand-thumb-down" class="w-3.5 h-3.5" /> No
      </button>
    </div>
    <div v-else
      class="p-2 rounded-xl bg-primary-50 dark:bg-primary-950/40 border border-primary/30 text-primary text-[11px] font-mono font-semibold text-center flex items-center justify-center gap-1">
      <UIcon name="i-heroicons-check" class="w-4 h-4 text-primary" /> Thanks for your feedback!
    </div>
  </div>
</template>
