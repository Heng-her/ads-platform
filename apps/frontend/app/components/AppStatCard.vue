<script setup lang="ts">
interface Props {
  title: string
  value: string | number
  change?: string
  changeLabel?: string
  icon?: string
  positive?: boolean
}

withDefaults(defineProps<Props>(), {
  change: undefined,
  changeLabel: 'from last month',
  icon: undefined,
  positive: true
})
</script>

<template>
  <UCard class="relative overflow-hidden transition-all duration-300 hover:border-gray-700">
    <div class="flex items-center justify-between">
      <div class="space-y-1">
        <span class="text-xs font-medium text-gray-500 dark:text-gray-400">
          {{ title }}
        </span>
        <p class="text-2xl font-bold text-gray-900 dark:text-gray-100">
          {{ value }}
        </p>
      </div>
      <div v-if="icon" class="p-3 rounded-xl bg-primary/10 text-primary">
        <UIcon :name="icon" class="w-6 h-6" />
      </div>
    </div>

    <div v-if="change" class="mt-4 flex items-center gap-1.5 text-xs font-medium"
      :class="positive ? 'text-emerald-500 dark:text-emerald-400' : 'text-rose-500 dark:text-rose-400'">
      <UIcon :name="positive ? 'i-heroicons-arrow-trending-up' : 'i-heroicons-arrow-trending-down'" class="w-4 h-4" />
      <span>{{ change }} {{ changeLabel }}</span>
    </div>
  </UCard>
</template>
