<script setup lang="ts">
import { computed } from 'vue'

const props = defineProps<{
  isAddOpen: boolean
  isEditOpen: boolean
  newCategoryName: string
  editingName: string
  newAdsterraSmartlinkUrl?: string
  editingAdsterraSmartlinkUrl?: string
  newAdsterraBannerKey?: string
  editingAdsterraBannerKey?: string
  isSubmitting: boolean
}>()

const emit = defineEmits<{
  (e: 'update:isAddOpen', val: boolean): void
  (e: 'update:isEditOpen', val: boolean): void
  (e: 'update:newCategoryName', val: string): void
  (e: 'update:editingName', val: string): void
  (e: 'update:newAdsterraSmartlinkUrl', val: string): void
  (e: 'update:editingAdsterraSmartlinkUrl', val: string): void
  (e: 'update:newAdsterraBannerKey', val: string): void
  (e: 'update:editingAdsterraBannerKey', val: string): void
  (e: 'submit-add'): void
  (e: 'submit-edit'): void
}>()

const addOpenModel = computed({
  get: () => props.isAddOpen,
  set: (val: boolean) => emit('update:isAddOpen', val)
})

const editOpenModel = computed({
  get: () => props.isEditOpen,
  set: (val: boolean) => emit('update:isEditOpen', val)
})

const newNameModel = computed({
  get: () => props.newCategoryName,
  set: (val: string) => emit('update:newCategoryName', val)
})

const editNameModel = computed({
  get: () => props.editingName,
  set: (val: string) => emit('update:editingName', val)
})

const newSmartlinkModel = computed({
  get: () => props.newAdsterraSmartlinkUrl || '',
  set: (val: string) => emit('update:newAdsterraSmartlinkUrl', val)
})

const editSmartlinkModel = computed({
  get: () => props.editingAdsterraSmartlinkUrl || '',
  set: (val: string) => emit('update:editingAdsterraSmartlinkUrl', val)
})

const newBannerKeyModel = computed({
  get: () => props.newAdsterraBannerKey || '',
  set: (val: string) => emit('update:newAdsterraBannerKey', val)
})

const editBannerKeyModel = computed({
  get: () => props.editingAdsterraBannerKey || '',
  set: (val: string) => emit('update:editingAdsterraBannerKey', val)
})
</script>

<template>
  <div>
    <!-- Create System Category Modal -->
    <UModal v-model:open="addOpenModel" :ui="{ content: 'sm:max-w-xl w-full' }">
      <template #content>
        <div class="p-6 space-y-5 bg-white dark:bg-gray-900 rounded-2xl border border-gray-200 dark:border-gray-800 w-full sm:max-w-xl">
          <div class="flex items-center justify-between">
            <h3 class="text-lg font-bold text-gray-900 dark:text-white flex items-center gap-2">
              <UIcon name="i-heroicons-plus-circle" class="w-5 h-5 text-primary" />
              Add System Category
            </h3>
            <UButton icon="i-heroicons-x-mark" color="neutral" variant="ghost" size="xs"
              @click="addOpenModel = false" />
          </div>

          <p class="text-xs text-gray-500 dark:text-gray-400">
            System categories are visible across the platform for campaign classification and public filters.
          </p>

          <div class="space-y-4">
            <div>
              <label class="block text-xs font-semibold text-gray-700 dark:text-gray-300 mb-1.5">Category Name *</label>
              <UInput v-model="newNameModel" placeholder="e.g. NEWS" size="md" color="neutral" class="w-full"
                variant="outline" @keyup.enter="emit('submit-add')" />
            </div>

            <div>
              <label class="block text-xs font-semibold text-gray-700 dark:text-gray-300 mb-1.5">
                Adsterra Smartlink URL (Optional)
              </label>
              <UInput v-model="newSmartlinkModel" placeholder="e.g. https://ironcomparable.com/gh6u2ftq6?key=..." size="md" color="neutral" class="w-full"
                variant="outline" />
              <p class="text-[11px] text-gray-400 mt-1">Direct link for category-specific Adsterra sponsor offer.</p>
            </div>

            <div>
              <label class="block text-xs font-semibold text-gray-700 dark:text-gray-300 mb-1.5">
                Adsterra Banner Key (Optional)
              </label>
              <UInput v-model="newBannerKeyModel" placeholder="e.g. a3904ecfe67c81deb37177a2588649a9" size="md" color="neutral" class="w-full"
                variant="outline" />
              <p class="text-[11px] text-gray-400 mt-1">Key for 300x250 or 728x90 Adsterra banner unit.</p>
            </div>
          </div>

          <div class="flex items-center justify-end gap-2 pt-2">
            <UButton color="neutral" variant="subtle" size="sm" @click="addOpenModel = false">
              Cancel
            </UButton>
            <UButton color="primary" variant="solid" size="sm" :loading="isSubmitting" @click="emit('submit-add')">
              Create Category
            </UButton>
          </div>
        </div>
      </template>
    </UModal>

    <!-- Edit System Category Modal -->
    <UModal v-model:open="editOpenModel" :ui="{ content: 'sm:max-w-xl w-full' }">
      <template #content>
        <div class="p-6 space-y-5 bg-white dark:bg-gray-900 rounded-2xl border border-gray-200 dark:border-gray-800 w-full sm:max-w-xl">
          <div class="flex items-center justify-between">
            <h3 class="text-lg font-bold text-gray-900 dark:text-white flex items-center gap-2">
              <UIcon name="i-heroicons-pencil-square" class="w-5 h-5 text-primary" />
              Edit System Category
            </h3>
            <UButton icon="i-heroicons-x-mark" color="neutral" variant="ghost" size="xs"
              @click="editOpenModel = false" />
          </div>

          <div class="space-y-4">
            <div>
              <label class="block text-xs font-semibold text-gray-700 dark:text-gray-300 mb-1.5">Category Name *</label>
              <UInput v-model="editNameModel" placeholder="Enter category name..." size="md" color="neutral" class="w-full"
                variant="outline" @keyup.enter="emit('submit-edit')" />
            </div>

            <div>
              <label class="block text-xs font-semibold text-gray-700 dark:text-gray-300 mb-1.5">
                Adsterra Smartlink URL (Optional)
              </label>
              <UInput v-model="editSmartlinkModel" placeholder="e.g. https://ironcomparable.com/gh6u2ftq6?key=..." size="md" color="neutral" class="w-full"
                variant="outline" />
            </div>

            <div>
              <label class="block text-xs font-semibold text-gray-700 dark:text-gray-300 mb-1.5">
                Adsterra Banner Key (Optional)
              </label>
              <UInput v-model="editBannerKeyModel" placeholder="e.g. a3904ecfe67c81deb37177a2588649a9" size="md" color="neutral" class="w-full"
                variant="outline" />
            </div>
          </div>

          <div class="flex items-center justify-end gap-2 pt-2">
            <UButton color="neutral" variant="subtle" size="sm" @click="editOpenModel = false">
              Cancel
            </UButton>
            <UButton color="primary" variant="solid" size="sm" :loading="isSubmitting" @click="emit('submit-edit')">
              Save Changes
            </UButton>
          </div>
        </div>
      </template>
    </UModal>
  </div>
</template>
