<script setup lang="ts">
import { computed } from 'vue'

const props = withDefaults(defineProps<{
  title: string
  value: string | number
  subtext?: string
  icon?: string
  color?: 'emerald' | 'purple' | 'blue' | 'amber' | 'rose' | 'neutral'
}>(), {
  color: 'emerald'
})

const colorConfig = computed(() => {
  switch (props.color) {
    case 'purple':
      return {
        border: 'border-purple-500/20 dark:border-purple-500/30',
        bgIcon: 'bg-purple-500/10 text-purple-500',
        textTitle: 'text-purple-400',
        textValue: 'text-purple-400'
      }
    case 'blue':
      return {
        border: 'border-blue-500/20 dark:border-blue-500/30',
        bgIcon: 'bg-blue-500/10 text-blue-500',
        textTitle: 'text-blue-400',
        textValue: 'text-blue-500'
      }
    case 'amber':
      return {
        border: 'border-amber-500/20 dark:border-amber-500/30',
        bgIcon: 'bg-amber-500/10 text-amber-500',
        textTitle: 'text-amber-400',
        textValue: 'text-amber-500'
      }
    case 'rose':
      return {
        border: 'border-rose-500/20 dark:border-rose-500/30',
        bgIcon: 'bg-rose-500/10 text-rose-500',
        textTitle: 'text-rose-400',
        textValue: 'text-rose-500'
      }
    case 'neutral':
      return {
        border: 'border-gray-200 dark:border-gray-800',
        bgIcon: 'bg-gray-100 dark:bg-gray-800 text-gray-400',
        textTitle: 'text-gray-500 dark:text-gray-400',
        textValue: 'text-gray-900 dark:text-white'
      }
    case 'emerald':
    default:
      return {
        border: 'border-emerald-500/20 dark:border-emerald-500/30',
        bgIcon: 'bg-emerald-500/10 text-emerald-500',
        textTitle: 'text-emerald-500',
        textValue: 'text-emerald-500'
      }
  }
})
</script>

<template>
  <div
    class="bg-white dark:bg-gray-900 p-5 rounded-2xl border shadow-xs space-y-3 transition-all hover:border-gray-700"
    :class="colorConfig.border"
  >
    <div class="flex items-center justify-between">
      <span class="text-xs font-semibold uppercase tracking-wider" :class="colorConfig.textTitle">
        {{ title }}
      </span>
      <div v-if="icon" class="p-2 rounded-xl shrink-0" :class="colorConfig.bgIcon">
        <UIcon :name="icon" class="w-5 h-5" />
      </div>
    </div>

    <div>
      <p class="text-2xl font-extrabold font-mono" :class="colorConfig.textValue">
        {{ value }}
      </p>

      <div v-if="subtext || $slots.footer" class="mt-2 text-xs text-gray-500 dark:text-gray-400 flex items-center justify-between">
        <slot name="footer">
          <span>{{ subtext }}</span>
        </slot>
      </div>
    </div>
  </div>
</template>
