<script setup lang="ts">
import { computed } from 'vue'

const props = withDefaults(defineProps<{
  variant?: 'primary' | 'secondary' | 'outline' | 'ghost' | 'danger' | 'success' | 'info'
  size?: 'xs' | 'sm' | 'md' | 'lg'
  icon?: string
  loading?: boolean
  disabled?: boolean
  block?: boolean
  type?: 'button' | 'submit' | 'reset'
}>(), {
  variant: 'primary',
  size: 'sm',
  type: 'button',
  loading: false,
  disabled: false,
  block: false
})

const emit = defineEmits<{
  (e: 'click', event: MouseEvent): void
}>()

const sizeClasses = computed(() => {
  switch (props.size) {
    case 'xs':
      return 'px-2.5 py-1 text-xs gap-1.5'
    case 'sm':
      return 'px-3.5 py-1.5 text-xs gap-2'
    case 'lg':
      return 'px-6 py-3 text-base gap-2.5'
    case 'md':
    default:
      return 'px-4 py-2 text-sm gap-2'
  }
})

const variantClasses = computed(() => {
  switch (props.variant) {
    case 'secondary':
      return 'bg-gray-800 border border-gray-700 text-gray-200 hover:bg-gray-700 hover:text-white'
    case 'outline':
      return 'bg-transparent border border-gray-700 text-gray-300 hover:bg-gray-800 hover:text-white'
    case 'ghost':
      return 'bg-transparent text-gray-400 hover:bg-gray-800 hover:text-white'
    case 'danger':
      return 'bg-red-600/10 border border-red-500/30 text-red-400 hover:bg-red-600/20'
    case 'success':
      return 'bg-emerald-500/10 border border-emerald-500/30 text-emerald-400 hover:bg-emerald-500/20'
    case 'info':
      return 'bg-sky-500/10 border border-sky-500/30 text-sky-400 hover:bg-sky-500/20'
    case 'primary':
    default:
      return 'bg-primary-600 text-white hover:bg-primary-500 shadow-xs'
  }
})

function handleClick(event: MouseEvent) {
  if (!props.disabled && !props.loading) {
    emit('click', event)
  }
}
</script>

<template>
  <button
    :type="type"
    :disabled="disabled || loading"
    class="inline-flex items-center justify-center font-bold rounded-xl transition-all active:scale-95 disabled:opacity-50 disabled:cursor-not-allowed shrink-0"
    :class="[
      sizeClasses,
      variantClasses,
      block ? 'w-full' : ''
    ]"
    @click="handleClick"
  >
    <UIcon v-if="loading" name="i-heroicons-arrow-path" class="animate-spin shrink-0" :class="size === 'xs' ? 'w-3.5 h-3.5' : 'w-4 h-4'" />
    <UIcon v-else-if="icon" :name="icon" class="shrink-0" :class="size === 'xs' ? 'w-3.5 h-3.5' : 'w-4 h-4'" />
    <span><slot /></span>
  </button>
</template>
