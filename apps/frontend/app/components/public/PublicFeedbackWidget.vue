<script setup lang="ts">
defineProps<{
  feedbackGiven: boolean | null
}>()

const emit = defineEmits<{
  (e: 'give-feedback', val: boolean): void
}>()
</script>

<template>
  <div class="w-full max-w-sm rounded-xl p-4 border shadow-xs bg-white dark:bg-slate-900 border-slate-200 dark:border-slate-800 transition-colors duration-200">
    <!-- Header -->
    <h4 class="text-[10px] font-mono uppercase tracking-widest font-bold mb-1 text-slate-400 dark:text-slate-500">
      Help Us Improve
    </h4>
    <p class="text-xs font-medium text-slate-700 dark:text-slate-300 mb-3 leading-snug">
      Were these campaign search results helpful?
    </p>

    <!-- Interactive Buttons -->
    <div v-if="feedbackGiven === null" class="flex gap-2">
      <button 
        @click="emit('give-feedback', true)"
        class="flex-1 text-xs font-medium py-2 px-3 rounded-lg text-slate-800 dark:text-slate-200 bg-slate-50 dark:bg-slate-800/50 border border-slate-200 dark:border-slate-800 hover:bg-slate-100 dark:hover:bg-slate-800 hover:border-slate-300 dark:hover:border-slate-700 transition-all duration-200 flex items-center justify-center gap-2 cursor-pointer shadow-xs active:scale-[0.98]"
      >
        <UIcon name="i-heroicons-hand-thumb-up" class="w-4 h-4 text-emerald-500" />
        Yes
      </button>
      
      <button 
        @click="emit('give-feedback', false)"
        class="flex-1 text-xs font-medium py-2 px-3 rounded-lg text-slate-800 dark:text-slate-200 bg-slate-50 dark:bg-slate-800/50 border border-slate-200 dark:border-slate-800 hover:bg-slate-100 dark:hover:bg-slate-800 hover:border-slate-300 dark:hover:border-slate-700 transition-all duration-200 flex items-center justify-center gap-2 cursor-pointer shadow-xs active:scale-[0.98]"
      >
        <UIcon name="i-heroicons-hand-thumb-down" class="w-4 h-4 text-rose-500" />
        No
      </button>
    </div>

    <!-- Success State -->
    <div 
      v-else
      class="p-2.5 rounded-lg bg-emerald-50/60 dark:bg-emerald-500/10 border border-emerald-200/60 dark:border-emerald-500/20 text-emerald-800 dark:text-emerald-400 text-xs font-medium text-center flex items-center justify-center gap-2 animate-fade-in"
    >
      <UIcon name="i-heroicons-check-circle" class="w-4 h-4 text-emerald-600 dark:text-emerald-400" /> 
      Thanks for your feedback!
    </div>
  </div>
</template>

<style scoped>
@keyframes fadeIn {
  from { opacity: 0; transform: translateY(2px); }
  to { opacity: 1; transform: translateY(0); }
}
.animate-fade-in {
  animation: fadeIn 0.2s ease-out forwards;
}
</style>
