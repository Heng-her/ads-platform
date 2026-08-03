<script setup lang="ts">
import { computed } from 'vue'
import { channelStyle } from '~/composables/channelColor'

const props = withDefaults(
  defineProps<{
    name?: string | null
    contentType?: string | null
    size?: 'sm' | 'md' | 'lg'
    showIcon?: boolean
  }>(),
  {
    name: '',
    contentType: '',
    size: 'sm',
    showIcon: true
  }
)

const label = computed(() => props.name || props.contentType || 'General')

const styleToken = computed(() => channelStyle(label.value))

const sizeClasses = computed(() => {
  if (props.size === 'lg') return 'px-3.5 py-1 text-xs gap-2'
  if (props.size === 'md') return 'px-2.5 py-1 text-[11px] gap-1.5'
  return 'px-2 py-0.5 text-[10px] gap-1'
})

const iconSizeClasses = computed(() => {
  if (props.size === 'lg') return 'w-4 h-4'
  if (props.size === 'md') return 'w-3.5 h-3.5'
  return 'w-3 h-3'
})
</script>

<template>
  <span
    class="inline-flex items-center rounded-full font-mono font-bold border tracking-wide transition-all shadow-sm shrink-0"
    :class="sizeClasses"
    :style="{
      color: styleToken.color,
      backgroundColor: styleToken.background,
      borderColor: styleToken.borderColor
    }"
  >
    <UIcon v-if="showIcon" :name="styleToken.icon" :class="iconSizeClasses" class="shrink-0" />
    <span>{{ label }}</span>
  </span>
</template>
