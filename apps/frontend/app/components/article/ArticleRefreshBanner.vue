<script setup lang="ts">
defineProps<{
  count: number
}>()

const emit = defineEmits<{
  (e: 'refresh'): void
}>()
</script>

<template>
  <UButton
    v-if="count > 0"
    @click="emit('refresh')"
    color="primary"
    variant="subtle"
    block
    icon="i-heroicons-arrow-path"
    class="py-3 font-semibold text-sm cursor-pointer shadow-sm"
  >
    {{ count }} new campaign{{ count === 1 ? '' : 's' }} available. Refresh feed
  </UButton>
</template>
