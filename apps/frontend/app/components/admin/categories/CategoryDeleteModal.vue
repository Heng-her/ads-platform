<script setup lang="ts">
import { computed } from 'vue'
import type { CategoryItem, CustomCategoryItem } from '~/composables/useCategories'

const props = defineProps<{
  isDeleteOpen: boolean
  isDeleteCustomOpen: boolean
  deletingCategory: CategoryItem | null
  deletingCustomCategory: CustomCategoryItem | null
  isSubmitting: boolean
}>()

const emit = defineEmits<{
  (e: 'update:isDeleteOpen', val: boolean): void
  (e: 'update:isDeleteCustomOpen', val: boolean): void
  (e: 'confirm-delete-system'): void
  (e: 'confirm-delete-custom'): void
}>()

const deleteOpenModel = computed({
  get: () => props.isDeleteOpen,
  set: (val: boolean) => emit('update:isDeleteOpen', val)
})

const deleteCustomOpenModel = computed({
  get: () => props.isDeleteCustomOpen,
  set: (val: boolean) => emit('update:isDeleteCustomOpen', val)
})
</script>

<template>
  <div>
    <!-- Delete System Category Modal -->
    <UModal v-model:open="deleteOpenModel">
      <template #content>
        <div class="p-6 space-y-4 bg-white dark:bg-gray-900 rounded-2xl border border-gray-200 dark:border-gray-800">
          <div class="flex items-center gap-3 text-red-600 dark:text-red-400">
            <div class="p-2 rounded-full bg-red-100 dark:bg-red-950/50">
              <UIcon name="i-heroicons-exclamation-triangle" class="w-6 h-6" />
            </div>
            <h3 class="text-lg font-bold text-gray-900 dark:text-white">
              Delete System Category
            </h3>
          </div>

          <p class="text-sm text-gray-600 dark:text-gray-300">
            Are you sure you want to delete <strong class="text-gray-900 dark:text-white">"{{ deletingCategory?.name
              }}"</strong>? Campaigns referencing this category will default to "General".
          </p>

          <div class="flex items-center justify-end gap-2 pt-3">
            <UButton color="neutral" variant="subtle" size="sm" @click="deleteOpenModel = false">
              Cancel
            </UButton>
            <UButton color="error" variant="solid" size="sm" :loading="isSubmitting" @click="emit('confirm-delete-system')">
              Delete Category
            </UButton>
          </div>
        </div>
      </template>
    </UModal>

    <!-- Delete Creator Custom Category Modal (Admin Action) -->
    <UModal v-model:open="deleteCustomOpenModel">
      <template #content>
        <div class="p-6 space-y-4 bg-white dark:bg-gray-900 rounded-2xl border border-gray-200 dark:border-gray-800">
          <div class="flex items-center gap-3 text-red-600 dark:text-red-400">
            <div class="p-2 rounded-full bg-red-100 dark:bg-red-950/50">
              <UIcon name="i-heroicons-exclamation-triangle" class="w-6 h-6" />
            </div>
            <h3 class="text-lg font-bold text-gray-900 dark:text-white">
              Delete Creator Custom Category
            </h3>
          </div>

          <p class="text-sm text-gray-600 dark:text-gray-300">
            Are you sure you want to delete custom category <strong class="text-gray-900 dark:text-white">"{{ deletingCustomCategory?.name }}"</strong> created by <strong class="text-gray-900 dark:text-white">{{ deletingCustomCategory?.userEmail || deletingCustomCategory?.username }}</strong>?
          </p>

          <div class="flex items-center justify-end gap-2 pt-3">
            <UButton color="neutral" variant="subtle" size="sm" @click="deleteCustomOpenModel = false">
              Cancel
            </UButton>
            <UButton color="error" variant="solid" size="sm" :loading="isSubmitting" @click="emit('confirm-delete-custom')">
              Delete Category
            </UButton>
          </div>
        </div>
      </template>
    </UModal>
  </div>
</template>
