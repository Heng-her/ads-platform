<script setup lang="ts">
import { computed } from 'vue'

const props = defineProps<{
  modelValue: string
  userLabel: string
}>()

const emit = defineEmits<{
  (e: 'update:modelValue', val: string): void
}>()

const searchQuery = computed({
  get: () => props.modelValue,
  set: (val: string) => emit('update:modelValue', val)
})
</script>

<template>
  <div
    class="flex flex-col gap-3 rounded-xl border border-gray-200 bg-white p-3 sm:flex-row sm:items-center sm:justify-between dark:border-gray-800 dark:bg-gray-900">
    <UInput v-model="searchQuery" icon="i-heroicons-magnifying-glass" placeholder="Search users by name or email..."
      size="sm" class="w-full sm:max-w-md" />
    <span class="text-xs font-medium text-gray-500 dark:text-gray-400">{{ userLabel }}</span>
  </div>
</template>
