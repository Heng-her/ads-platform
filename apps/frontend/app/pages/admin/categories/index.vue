<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import { useCategories, type CategoryItem } from '~/composables/useCategories'
import { useAppToast } from '~/composables/useAppToast'

definePageMeta({
  layout: 'admin'
})

const {
  categories,
  isLoadingCategories,
  fetchCategories,
  createCategory,
  updateCategory,
  deleteCategory,
  myCategories,
  isLoadingMyCategories,
  fetchMyCategories
} = useCategories()

const toast = useAppToast()

// State
const activeTab = ref<'system' | 'creator'>('system')
const searchQuery = ref('')

// Modals State
const isAddModalOpen = ref(false)
const isEditModalOpen = ref(false)
const isDeleteModalOpen = ref(false)

const newCategoryName = ref('')
const editingCategory = ref<CategoryItem | null>(null)
const editingName = ref('')
const deletingCategory = ref<CategoryItem | null>(null)

const isSubmitting = ref(false)

onMounted(() => {
  fetchCategories(true)
  fetchMyCategories(true)
})

// Filtered lists
const filteredSystemCategories = computed(() => {
  const query = searchQuery.value.trim().toLowerCase()
  if (!query) return categories.value
  return categories.value.filter(cat => cat.name.toLowerCase().includes(query))
})

const filteredCreatorCategories = computed(() => {
  const query = searchQuery.value.trim().toLowerCase()
  if (!query) return myCategories.value
  return myCategories.value.filter(cat => cat.name.toLowerCase().includes(query))
})

// Date Formatter
function formatDate(dateStr?: string | null) {
  if (!dateStr) return 'N/A'
  try {
    return new Date(dateStr).toLocaleDateString('en-US', {
      year: 'numeric',
      month: 'short',
      day: 'numeric'
    })
  } catch {
    return dateStr
  }
}

// Actions
function openAddModal() {
  newCategoryName.value = ''
  isAddModalOpen.value = true
}

async function handleAddCategory() {
  const name = newCategoryName.value.trim()
  if (!name) {
    toast.error('Validation Error', 'Category name cannot be empty.')
    return
  }

  isSubmitting.value = true
  try {
    const res = await createCategory(name)
    if (res?.code === 1) {
      toast.success('Category Created', `System category "${name}" was created successfully.`)
      isAddModalOpen.value = false
      newCategoryName.value = ''
    } else {
      toast.error('Create Failed', res?.msg || 'Could not create system category.')
    }
  } catch (err: any) {
    toast.error('Error', err.message || 'An error occurred while creating category.')
  } finally {
    isSubmitting.value = false
  }
}

function openEditModal(category: CategoryItem) {
  editingCategory.value = category
  editingName.value = category.name
  isEditModalOpen.value = true
}

async function handleUpdateCategory() {
  if (!editingCategory.value) return
  const name = editingName.value.trim()
  if (!name) {
    toast.error('Validation Error', 'Category name cannot be empty.')
    return
  }

  isSubmitting.value = true
  try {
    const res = await updateCategory(editingCategory.value.id, name)
    if (res?.code === 1) {
      toast.success('Category Updated', `Category updated to "${name}".`)
      isEditModalOpen.value = false
      editingCategory.value = null
      editingName.value = ''
    } else {
      toast.error('Update Failed', res?.msg || 'Could not update category.')
    }
  } catch (err: any) {
    toast.error('Error', err.message || 'An error occurred while updating category.')
  } finally {
    isSubmitting.value = false
  }
}

function openDeleteModal(category: CategoryItem) {
  deletingCategory.value = category
  isDeleteModalOpen.value = true
}

async function handleDeleteCategory() {
  if (!deletingCategory.value) return

  isSubmitting.value = true
  try {
    const res = await deleteCategory(deletingCategory.value.id)
    if (res?.code === 1) {
      toast.success('Category Deleted', `Category "${deletingCategory.value.name}" removed successfully.`)
      isDeleteModalOpen.value = false
      deletingCategory.value = null
    } else {
      toast.error('Delete Failed', res?.msg || 'Could not delete category.')
    }
  } catch (err: any) {
    toast.error('Error', err.message || 'An error occurred while deleting category.')
  } finally {
    isSubmitting.value = false
  }
}
</script>

<template>
  <div class="space-y-6 max-w-7xl mx-auto pb-12">
    <!-- Header Section -->
    <div
      class="flex flex-col sm:flex-row sm:items-center justify-between gap-4 bg-white dark:bg-gray-900 p-6 rounded-2xl border border-gray-200 dark:border-gray-800 shadow-xs">
      <div>
        <div class="flex items-center gap-2">
          <UIcon name="i-heroicons-tag" class="w-7 h-7 text-primary" />
          <h1 class="text-2xl font-bold tracking-tight text-gray-900 dark:text-white">
            Category Management
          </h1>
        </div>
        <p class="mt-1 text-sm text-gray-500 dark:text-gray-400">
          Manage system-wide campaign categories, view creator custom categories, and organize content.
        </p>
      </div>

      <div class="flex items-center gap-3">
        <UButton color="primary" variant="solid" icon="i-heroicons-plus" size="md" class="font-semibold shadow-xs"
          @click="openAddModal">
          Add System Category
        </UButton>
      </div>
    </div>

    <!-- Quick Stats Cards -->
    <div class="grid grid-cols-1 sm:grid-cols-3 gap-4">
      <div
        class="bg-white dark:bg-gray-900 p-5 rounded-xl border border-gray-200 dark:border-gray-800 flex items-center gap-4">
        <div class="p-3 rounded-lg bg-blue-500/10 text-blue-600 dark:text-blue-400">
          <UIcon name="i-heroicons-globe-alt" class="w-6 h-6" />
        </div>
        <div>
          <p class="text-xs font-medium text-gray-500 dark:text-gray-400">System Categories</p>
          <p class="text-2xl font-bold text-gray-900 dark:text-white">{{ categories.length }}</p>
        </div>
      </div>

      <div
        class="bg-white dark:bg-gray-900 p-5 rounded-xl border border-gray-200 dark:border-gray-800 flex items-center gap-4">
        <div class="p-3 rounded-lg bg-purple-500/10 text-purple-600 dark:text-purple-400">
          <UIcon name="i-heroicons-user-group" class="w-6 h-6" />
        </div>
        <div>
          <p class="text-xs font-medium text-gray-500 dark:text-gray-400">Creator Categories</p>
          <p class="text-2xl font-bold text-gray-900 dark:text-white">{{ myCategories.length }}</p>
        </div>
      </div>

      <div
        class="bg-white dark:bg-gray-900 p-5 rounded-xl border border-gray-200 dark:border-gray-800 flex items-center gap-4">
        <div class="p-3 rounded-lg bg-amber-500/10 text-amber-600 dark:text-amber-400">
          <UIcon name="i-heroicons-check-circle" class="w-6 h-6" />
        </div>
        <div>
          <p class="text-xs font-medium text-gray-500 dark:text-gray-400">Status</p>
          <p class="text-base font-bold text-emerald-600 dark:text-emerald-400 flex items-center gap-1">
            <span class="w-2 h-2 rounded-full bg-emerald-500 animate-pulse"></span>
            Active Sync
          </p>
        </div>
      </div>
    </div>

    <!-- Main Content Area -->
    <div
      class="bg-white dark:bg-gray-900 rounded-2xl border border-gray-200 dark:border-gray-800 overflow-hidden shadow-xs">
      <!-- Toolbar: Tabs & Search -->
      <div
        class="p-4 sm:p-5 border-b border-gray-200 dark:border-gray-800 flex flex-col sm:flex-row sm:items-center justify-between gap-4">
        <!-- Tabs -->
        <div class="flex items-center p-1 bg-gray-100 dark:bg-gray-800 rounded-lg w-fit">
          <button class="px-4 py-1.5 text-xs font-semibold rounded-md transition-all"
            :class="activeTab === 'system' ? 'bg-white dark:bg-gray-900 text-gray-900 dark:text-white shadow-xs' : 'text-gray-500 hover:text-gray-900 dark:hover:text-white'"
            @click="activeTab = 'system'">
            System Categories ({{ categories.length }})
          </button>
          <button class="px-4 py-1.5 text-xs font-semibold rounded-md transition-all"
            :class="activeTab === 'creator' ? 'bg-white dark:bg-gray-900 text-gray-900 dark:text-white shadow-xs' : 'text-gray-500 hover:text-gray-900 dark:hover:text-white'"
            @click="activeTab = 'creator'">
            Creator Custom ({{ myCategories.length }})
          </button>
        </div>

        <!-- Search Bar -->
        <div class="w-full sm:w-72">
          <UInput v-model="searchQuery" icon="i-heroicons-magnifying-glass" placeholder="Search categories..." size="sm"
            color="neutral" variant="outline" />
        </div>
      </div>

      <!-- Category Data Table -->
      <div class="overflow-x-auto">
        <table class="w-full text-left text-sm border-collapse">
          <thead>
            <tr
              class="border-b border-gray-200 dark:border-gray-800 bg-gray-50/50 dark:bg-gray-800/50 text-gray-500 dark:text-gray-400 uppercase text-[11px] font-semibold tracking-wider">
              <th class="py-3 px-4 sm:px-6">ID</th>
              <th class="py-3 px-4 sm:px-6">Preview Badge</th>
              <th class="py-3 px-4 sm:px-6">Category Name</th>
              <th class="py-3 px-4 sm:px-6">Created Date</th>
              <th class="py-3 px-4 sm:px-6 text-right">Actions</th>
            </tr>
          </thead>

          <tbody v-if="activeTab === 'system'" class="divide-y divide-gray-100 dark:divide-gray-800">
            <tr v-if="isLoadingCategories" class="text-center">
              <td colspan="5" class="py-8 text-gray-500 dark:text-gray-400">
                <UIcon name="i-heroicons-arrow-path" class="w-6 h-6 animate-spin inline-block mr-2 text-primary" />
                Loading system categories...
              </td>
            </tr>

            <tr v-else-if="filteredSystemCategories.length === 0" class="text-center">
              <td colspan="5" class="py-10 text-gray-400 dark:text-gray-500">
                <UIcon name="i-heroicons-tag" class="w-8 h-8 mx-auto mb-2 opacity-50" />
                No categories found matching your query.
              </td>
            </tr>

            <tr v-for="cat in filteredSystemCategories" :key="cat.id"
              class="hover:bg-gray-50/80 dark:hover:bg-gray-800/40 transition-colors">
              <td class="py-3.5 px-4 sm:px-6 font-mono text-xs text-gray-500 dark:text-gray-400">
                #{{ cat.id }}
              </td>
              <td class="py-3.5 px-4 sm:px-6">
                <CategoryBadge :name="cat.name" size="md" />
              </td>
              <td class="py-3.5 px-4 sm:px-6 font-medium text-gray-900 dark:text-white">
                {{ cat.name }}
                <UBadge v-if="cat.id === 999" color="neutral" variant="soft" size="xs" class="ml-2">
                  System Virtual
                </UBadge>
              </td>
              <td class="py-3.5 px-4 sm:px-6 text-xs text-gray-500 dark:text-gray-400">
                {{ formatDate(cat.createdAt) }}
              </td>
              <td class="py-3.5 px-4 sm:px-6 text-right">
                <div v-if="cat.id !== 999" class="flex items-center justify-end gap-1">
                  <UButton icon="i-heroicons-pencil-square" color="neutral" variant="ghost" size="xs"
                    aria-label="Edit category" @click="openEditModal(cat)" />
                  <UButton icon="i-heroicons-trash" color="error" variant="ghost" size="xs" aria-label="Delete category"
                    @click="openDeleteModal(cat)" />
                </div>
                <span v-else class="text-xs text-gray-400 italic">Protected</span>
              </td>
            </tr>
          </tbody>

          <!-- Creator Categories Tab -->
          <tbody v-else class="divide-y divide-gray-100 dark:divide-gray-800">
            <tr v-if="isLoadingMyCategories" class="text-center">
              <td colspan="5" class="py-8 text-gray-500 dark:text-gray-400">
                <UIcon name="i-heroicons-arrow-path" class="w-6 h-6 animate-spin inline-block mr-2 text-primary" />
                Loading custom categories...
              </td>
            </tr>

            <tr v-else-if="filteredCreatorCategories.length === 0" class="text-center">
              <td colspan="5" class="py-10 text-gray-400 dark:text-gray-500">
                <UIcon name="i-heroicons-user-group" class="w-8 h-8 mx-auto mb-2 opacity-50" />
                No custom creator categories found.
              </td>
            </tr>

            <tr v-for="cat in filteredCreatorCategories" :key="cat.id"
              class="hover:bg-gray-50/80 dark:hover:bg-gray-800/40 transition-colors">
              <td class="py-3.5 px-4 sm:px-6 font-mono text-xs text-gray-500 dark:text-gray-400">
                #{{ cat.id }}
              </td>
              <td class="py-3.5 px-4 sm:px-6">
                <CategoryBadge :name="cat.name" size="md" />
              </td>
              <td class="py-3.5 px-4 sm:px-6 font-medium text-gray-900 dark:text-white">
                {{ cat.name }}
              </td>
              <td class="py-3.5 px-4 sm:px-6 text-xs text-gray-500 dark:text-gray-400">
                {{ formatDate(cat.createdAt) }}
              </td>
              <td class="py-3.5 px-4 sm:px-6 text-right">
                <UBadge color="secondary" variant="soft" size="xs">
                  Creator Custom
                </UBadge>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>

    <!-- Create Modal -->
    <UModal v-model:open="isAddModalOpen">
      <template #content>
        <div class="p-6 space-y-5 bg-white dark:bg-gray-900 rounded-2xl border border-gray-200 dark:border-gray-800">
          <div class="flex items-center justify-between">
            <h3 class="text-lg font-bold text-gray-900 dark:text-white flex items-center gap-2">
              <UIcon name="i-heroicons-plus-circle" class="w-5 h-5 text-primary" />
              Add System Category
            </h3>
            <UButton icon="i-heroicons-x-mark" color="neutral" variant="ghost" size="xs"
              @click="isAddModalOpen = false" />
          </div>

          <p class="text-xs text-gray-500 dark:text-gray-400">
            System categories are visible across the platform for campaign classification and public filters.
          </p>

          <div>
            <label class="block text-xs font-semibold text-gray-700 dark:text-gray-300 mb-1.5">Category Name</label>
            <UInput v-model="newCategoryName" placeholder="e.g. Artificial Intelligence" size="md" color="neutral"
              variant="outline" @keyup.enter="handleAddCategory" />
          </div>

          <div class="flex items-center justify-end gap-2 pt-2">
            <UButton color="neutral" variant="subtle" size="sm" @click="isAddModalOpen = false">
              Cancel
            </UButton>
            <UButton color="primary" variant="solid" size="sm" :loading="isSubmitting" @click="handleAddCategory">
              Create Category
            </UButton>
          </div>
        </div>
      </template>
    </UModal>

    <!-- Edit Modal -->
    <UModal v-model:open="isEditModalOpen">
      <template #content>
        <div class="p-6 space-y-5 bg-white dark:bg-gray-900 rounded-2xl border border-gray-200 dark:border-gray-800">
          <div class="flex items-center justify-between">
            <h3 class="text-lg font-bold text-gray-900 dark:text-white flex items-center gap-2">
              <UIcon name="i-heroicons-pencil-square" class="w-5 h-5 text-primary" />
              Edit System Category
            </h3>
            <UButton icon="i-heroicons-x-mark" color="neutral" variant="ghost" size="xs"
              @click="isEditModalOpen = false" />
          </div>

          <div>
            <label class="block text-xs font-semibold text-gray-700 dark:text-gray-300 mb-1.5">Category Name</label>
            <UInput v-model="editingName" placeholder="Enter category name..." size="md" color="neutral"
              variant="outline" @keyup.enter="handleUpdateCategory" />
          </div>

          <div class="flex items-center justify-end gap-2 pt-2">
            <UButton color="neutral" variant="subtle" size="sm" @click="isEditModalOpen = false">
              Cancel
            </UButton>
            <UButton color="primary" variant="solid" size="sm" :loading="isSubmitting" @click="handleUpdateCategory">
              Save Changes
            </UButton>
          </div>
        </div>
      </template>
    </UModal>

    <!-- Delete Modal -->
    <UModal v-model:open="isDeleteModalOpen">
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
            <UButton color="neutral" variant="subtle" size="sm" @click="isDeleteModalOpen = false">
              Cancel
            </UButton>
            <UButton color="error" variant="solid" size="sm" :loading="isSubmitting" @click="handleDeleteCategory">
              Delete Category
            </UButton>
          </div>
        </div>
      </template>
    </UModal>
  </div>
</template>
