<script setup lang="ts">
defineProps<{
  articleUrl: string
  editUrl: string
  deleting?: boolean
}>()

defineEmits<{
  delete: []
}>()
</script>

<template>
  <div class="flex items-center justify-end gap-1">
    <UButton :to="articleUrl" target="_blank" rel="noopener noreferrer" icon="i-heroicons-arrow-top-right-on-square" color="neutral" variant="ghost" size="xs" title="Open public post" />
    <UButton :to="editUrl" icon="i-heroicons-pencil-square" color="neutral" variant="ghost" size="xs" title="Edit campaign" />
    <UButton icon="i-heroicons-trash" color="error" variant="ghost" size="xs" :loading="deleting" title="Delete campaign" @click="$emit('delete')" />
  </div>
</template>
