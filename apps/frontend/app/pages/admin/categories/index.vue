<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import { useCategories, type CategoryItem, type CustomCategoryItem } from '~/composables/useCategories'
import { useAppToast } from '~/composables/useAppToast'

import CategoriesHeader from '~/components/admin/categories/CategoriesHeader.vue'
import CategoriesStatsCards from '~/components/admin/categories/CategoriesStatsCards.vue'
import CategoriesTable from '~/components/admin/categories/CategoriesTable.vue'
import CategoryAddEditModal from '~/components/admin/categories/CategoryAddEditModal.vue'
import CategoryDeleteModal from '~/components/admin/categories/CategoryDeleteModal.vue'

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
  allCustomCategories,
  isLoadingAllCustomCategories,
  fetchAllCustomCategories,
  deleteCustomCategoryByAdmin
} = useCategories()

const toast = useAppToast()

// State
const activeTab = ref<'system' | 'creator'>('system')
const searchQuery = ref('')

// Modals State
const isAddModalOpen = ref(false)
const isEditModalOpen = ref(false)
const isDeleteModalOpen = ref(false)
const isDeleteCustomModalOpen = ref(false)

const newCategoryName = ref('')
const newAdsterraSmartlinkUrl = ref('')
const newAdsterraBannerKey = ref('')

const editingCategory = ref<CategoryItem | null>(null)
const editingName = ref('')
const editingAdsterraSmartlinkUrl = ref('')
const editingAdsterraBannerKey = ref('')

const deletingCategory = ref<CategoryItem | null>(null)
const deletingCustomCategory = ref<CustomCategoryItem | null>(null)

const isSubmitting = ref(false)

onMounted(() => {
  fetchCategories(true)
  fetchAllCustomCategories(true)
})

// Filtered lists
const filteredSystemCategories = computed(() => {
  const query = searchQuery.value.trim().toLowerCase()
  if (!query) return categories.value
  return categories.value.filter(cat => cat.name.toLowerCase().includes(query))
})

const filteredCreatorCategories = computed(() => {
  const query = searchQuery.value.trim().toLowerCase()
  if (!query) return allCustomCategories.value
  return allCustomCategories.value.filter(cat =>
    cat.name.toLowerCase().includes(query) ||
    (cat.userEmail && cat.userEmail.toLowerCase().includes(query)) ||
    (cat.username && cat.username.toLowerCase().includes(query))
  )
})

// System Category Actions
function openAddModal() {
  newCategoryName.value = ''
  newAdsterraSmartlinkUrl.value = ''
  newAdsterraBannerKey.value = ''
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
    const res = await createCategory(name, newAdsterraSmartlinkUrl.value.trim() || null, newAdsterraBannerKey.value.trim() || null)
    if (res?.code === 1) {
      toast.success('Category Created', `System category "${name}" was created successfully.`)
      isAddModalOpen.value = false
      newCategoryName.value = ''
      newAdsterraSmartlinkUrl.value = ''
      newAdsterraBannerKey.value = ''
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
  editingAdsterraSmartlinkUrl.value = category.adsterraSmartlinkUrl || ''
  editingAdsterraBannerKey.value = category.adsterraBannerKey || ''
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
    const res = await updateCategory(
      editingCategory.value.id,
      name,
      editingAdsterraSmartlinkUrl.value.trim() || null,
      editingAdsterraBannerKey.value.trim() || null
    )
    if (res?.code === 1) {
      toast.success('Category Updated', `Category updated to "${name}".`)
      isEditModalOpen.value = false
      editingCategory.value = null
      editingName.value = ''
      editingAdsterraSmartlinkUrl.value = ''
      editingAdsterraBannerKey.value = ''
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

// Creator Custom Category Admin Actions
function openDeleteCustomModal(category: CustomCategoryItem) {
  deletingCustomCategory.value = category
  isDeleteCustomModalOpen.value = true
}

async function handleDeleteCustomCategory() {
  if (!deletingCustomCategory.value) return

  isSubmitting.value = true
  try {
    const res = await deleteCustomCategoryByAdmin(deletingCustomCategory.value.id)
    if (res?.code === 1) {
      toast.success('Custom Category Deleted', `Creator category "${deletingCustomCategory.value.name}" removed.`)
      isDeleteCustomModalOpen.value = false
      deletingCustomCategory.value = null
    } else {
      toast.error('Delete Failed', res?.msg || 'Could not delete custom category.')
    }
  } catch (err: any) {
    toast.error('Error', err.message || 'An error occurred while deleting custom category.')
  } finally {
    isSubmitting.value = false
  }
}
</script>

<template>
  <div class="space-y-6 max-w-7xl mx-auto pb-12">
    <!-- Header Section -->
    <CategoriesHeader @open-add="openAddModal" />

    <!-- Quick Stats Cards -->
    <CategoriesStatsCards
      :system-count="categories.length"
      :creator-count="allCustomCategories.length"
    />

    <!-- Main Content Area -->
    <CategoriesTable
      v-model:active-tab="activeTab"
      v-model:search-query="searchQuery"
      :categories-count="categories.length"
      :custom-categories-count="allCustomCategories.length"
      :filtered-system-categories="filteredSystemCategories"
      :filtered-creator-categories="filteredCreatorCategories"
      :is-loading-categories="isLoadingCategories"
      :is-loading-all-custom-categories="isLoadingAllCustomCategories"
      @open-edit="openEditModal"
      @open-delete="openDeleteModal"
      @open-delete-custom="openDeleteCustomModal"
    />

    <!-- Add & Edit System Category Modals -->
    <CategoryAddEditModal
      v-model:is-add-open="isAddModalOpen"
      v-model:is-edit-open="isEditModalOpen"
      v-model:new-category-name="newCategoryName"
      v-model:editing-name="editingName"
      v-model:new-adsterra-smartlink-url="newAdsterraSmartlinkUrl"
      v-model:editing-adsterra-smartlink-url="editingAdsterraSmartlinkUrl"
      v-model:new-adsterra-banner-key="newAdsterraBannerKey"
      v-model:editing-adsterra-banner-key="editingAdsterraBannerKey"
      :is-submitting="isSubmitting"
      @submit-add="handleAddCategory"
      @submit-edit="handleUpdateCategory"
    />

    <!-- Delete System & Custom Category Modals -->
    <CategoryDeleteModal
      v-model:is-delete-open="isDeleteModalOpen"
      v-model:is-delete-custom-open="isDeleteCustomModalOpen"
      :deleting-category="deletingCategory"
      :deleting-custom-category="deletingCustomCategory"
      :is-submitting="isSubmitting"
      @confirm-delete-system="handleDeleteCategory"
      @confirm-delete-custom="handleDeleteCustomCategory"
    />
  </div>
</template>
