<script setup lang="ts">
const props = defineProps<{
  title: string
  status: 'DRAFT' | 'PUBLIC'
  disabled?: boolean
  size?: 'xs' | 'sm'
}>()

const emit = defineEmits<{
  change: [status: 'DRAFT' | 'PUBLIC']
}>()

function handleChange(event: Event) {
  emit('change', (event.target as HTMLInputElement).checked ? 'PUBLIC' : 'DRAFT')
}
</script>

<template>
  <div class="flex items-center gap-2">
    <label class="relative inline-flex cursor-pointer items-center">
      <input
        type="checkbox"
        role="switch"
        class="peer sr-only"
        :checked="props.status === 'PUBLIC'"
        :disabled="props.disabled"
        :aria-label="`Make ${props.title} ${props.status === 'PUBLIC' ? 'draft' : 'public'}`"
        @change="handleChange"
      >
      <span class="h-5 w-9 rounded-full bg-gray-300 transition-colors peer-checked:bg-emerald-500 peer-checked:[&>span]:translate-x-4 peer-focus-visible:outline-2 peer-focus-visible:outline-offset-2 peer-focus-visible:outline-primary-500 peer-disabled:cursor-not-allowed peer-disabled:opacity-60 dark:bg-gray-700">
        <span class="block h-4 w-4 translate-x-0.5 translate-y-0.5 rounded-full bg-white shadow-sm transition-transform" />
      </span>
    </label>
    <UBadge :color="props.status === 'PUBLIC' ? 'success' : 'neutral'" variant="soft" :size="props.size || 'sm'">
      {{ props.status }}
    </UBadge>
  </div>
</template>
