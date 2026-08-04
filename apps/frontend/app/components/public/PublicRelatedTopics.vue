<script setup lang="ts">
const props = defineProps<{
  topics: string[]
}>()

const emit = defineEmits<{
  (e: 'select-topic', topic: string): void
}>()
</script>

<template>
  <div v-if="topics.length" class="rounded-2xl p-4 border shadow-sm bg-white dark:bg-gray-900 border-gray-200 dark:border-gray-800">
    <h4 class="text-xs font-mono uppercase tracking-wider mb-3 font-extrabold text-gray-900 dark:text-white flex items-center justify-between">
      <span>Related Topics</span>
      <UIcon name="i-heroicons-arrow-trending-up" class="w-4 h-4 text-gray-900 dark:text-white" />
    </h4>
    <div class="flex flex-wrap gap-2">
      <button v-for="topic in topics" :key="topic" @click="emit('select-topic', topic)"
        class="text-xs font-mono font-semibold px-3 py-1.5 rounded-xl transition-all border border-gray-200 dark:border-gray-700 bg-gray-100 dark:bg-gray-800 text-gray-700 dark:text-gray-300 hover:bg-gray-900 hover:text-white dark:hover:bg-white dark:hover:text-gray-950">
        {{ topic }}
      </button>
    </div>
  </div>
</template>
