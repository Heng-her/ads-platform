<script setup lang="ts">
import { computed } from 'vue'

const props = defineProps<{
  modelValue: string
  totalCount: number
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
  <div class="flex flex-col gap-4 border-b border-gray-800 pb-4 sm:flex-row sm:items-center sm:justify-between">
    <div class="flex items-center gap-2 text-sm text-gray-400">
      <UIcon name="i-heroicons-users" class="h-5 w-5 text-primary-400" />
      <span class="font-semibold text-white">All Platform Accounts ({{ totalCount }})</span>
    </div>

    <div class="w-full sm:w-80">
      <UInput v-model="searchQuery" icon="i-heroicons-magnifying-glass"
        placeholder="Search by name, email, or role..." size="sm" class="w-full" />
    </div>
  </div>
</template>
