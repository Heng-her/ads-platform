<script setup lang="ts">
const props = defineProps<{
  feedbackGiven: boolean | null
}>()

const emit = defineEmits<{
  (e: 'give-feedback', val: boolean): void
}>()
</script>

<template>
  <div class="rounded-2xl p-4 border shadow-sm bg-white dark:bg-[#122131] border-gray-200 dark:border-[#273647]">
    <h4 class="text-xs font-mono uppercase tracking-wider font-extrabold mb-1 text-gray-900 dark:text-white">Help Us Improve</h4>
    <p class="text-[11px] font-medium text-gray-600 dark:text-gray-400 mb-3 leading-relaxed">
      Were these campaign search results helpful?
    </p>
    <div v-if="feedbackGiven === null" class="flex gap-2">
      <button @click="emit('give-feedback', true)"
        class="flex-1 text-xs font-mono py-1.5 rounded-xl font-bold text-gray-900 dark:text-white bg-gray-100 dark:bg-[#18293c] border border-gray-200/60 dark:border-[#273647] hover:bg-gray-200 dark:hover:bg-[#20344b] transition-all shadow-sm flex items-center justify-center gap-1.5 cursor-pointer">
        <UIcon name="i-heroicons-hand-thumb-up" class="w-3.5 h-3.5" /> Yes
      </button>
      <button @click="emit('give-feedback', false)"
        class="flex-1 text-xs font-mono py-1.5 rounded-xl font-semibold transition-all border border-gray-200/60 dark:border-[#273647] hover:bg-gray-200 dark:hover:bg-[#20344b] text-gray-700 dark:text-gray-300 bg-gray-50 dark:bg-[#0d1c2d] flex items-center justify-center gap-1.5 cursor-pointer">
        <UIcon name="i-heroicons-hand-thumb-down" class="w-3.5 h-3.5" /> No
      </button>
    </div>
    <div v-else
      class="p-2.5 rounded-xl bg-gray-100 dark:bg-[#18293c] border border-gray-200/60 dark:border-[#273647] text-gray-900 dark:text-white text-xs font-mono font-bold text-center flex items-center justify-center gap-1.5">
      <UIcon name="i-heroicons-check-circle" class="w-4 h-4 text-gray-900 dark:text-white" /> Thanks for your feedback!
    </div>
  </div>
</template>
