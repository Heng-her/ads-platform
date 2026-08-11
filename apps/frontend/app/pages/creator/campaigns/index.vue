<script setup lang="ts">
import { ref, onMounted, watch } from 'vue'
import { useCampaigns, type CampaignData } from '~/composables/useCampaigns'
import { useCategories } from '~/composables/useCategories'
import { getArticleUrl } from '~/lib/utils'

definePageMeta({
  layout: 'creator'
})

const { campaignsList, totalPages, isLoading, fetchMyCampaigns, updateCampaignStatus, deleteCampaign } = useCampaigns()
const { categories, myCategories } = useCategories()

const searchQuery = ref('')
const selectedCategory = ref('')
const selectedStatus = ref<'ALL' | 'DRAFT' | 'PUBLIC'>('ALL')
const currentPage = ref(1)

const deleteModalOpen = ref(false)
const selectedCampaignToDelete = ref<CampaignData | null>(null)
const isDeleting = ref(false)
const updatingStatusIds = ref<Set<string>>(new Set())
const imagePreviewOpen = ref(false)
const imagePreviewUrl = ref('')
const imagePreviewTitle = ref('Campaign image')

function getPreviewImage(item: CampaignData) {
  return item.imageUrl || item.images?.[0]?.url || ''
}

function openImagePreview(item: CampaignData) {
  const imageUrl = getPreviewImage(item)
  if (!imageUrl) return
  imagePreviewUrl.value = imageUrl
  imagePreviewTitle.value = item.imageTitle || item.images?.[0]?.title || item.title || 'Campaign image'
  imagePreviewOpen.value = true
}

async function loadData() {
  await fetchMyCampaigns({
    page: currentPage.value,
    limit: 5,
    search: searchQuery.value || undefined,
    category: selectedCategory.value || undefined,
    status: selectedStatus.value === 'ALL' ? undefined : selectedStatus.value,
  })
}

watch([searchQuery, selectedCategory, selectedStatus], () => {
  currentPage.value = 1
  loadData()
})

async function handleStatusToggle(campaign: CampaignData, newStatus: 'DRAFT' | 'PUBLIC') {
  if (updatingStatusIds.value.has(campaign.id)) return

  updatingStatusIds.value = new Set(updatingStatusIds.value).add(campaign.id)
  try {
    await updateCampaignStatus(campaign.id, newStatus)
    campaign.status = newStatus
  } catch (err: any) {
    alert(err.message || 'Failed to update status')
  } finally {
    const nextUpdatingIds = new Set(updatingStatusIds.value)
    nextUpdatingIds.delete(campaign.id)
    updatingStatusIds.value = nextUpdatingIds
  }
}

function confirmDelete(campaign: CampaignData) {
  selectedCampaignToDelete.value = campaign
  deleteModalOpen.value = true
}

async function executeDelete() {
  if (!selectedCampaignToDelete.value) return
  isDeleting.value = true
  try {
    await deleteCampaign(selectedCampaignToDelete.value.id)
    deleteModalOpen.value = false
    selectedCampaignToDelete.value = null
  } catch (err: any) {
    alert(err.message || 'Failed to delete campaign')
  } finally {
    isDeleting.value = false
  }
}

onMounted(() => {
  loadData()
})
</script>

<template>
  <div class="space-y-6">
    <!-- Header Section -->
    <div
      class="flex flex-col sm:flex-row sm:items-center justify-between gap-4 border-b border-gray-200 dark:border-gray-800 pb-4">
      <div>
        <h1 class="text-xl font-bold text-gray-900 dark:text-gray-100">
          Campaign Management
        </h1>
        <p class="text-xs text-gray-500 dark:text-gray-400 mt-1">
          Create, edit, and monitor your promotional campaigns and articles.
        </p>
      </div>

      <UButton to="/creator/campaigns/create" color="primary" icon="i-heroicons-plus" size="sm">
        Create Campaign
      </UButton>
    </div>

    <!-- Filters Bar -->
    <div
      class="flex flex-col sm:flex-row gap-3 items-stretch sm:items-center justify-between bg-white dark:bg-gray-900 p-3 rounded-lg border border-gray-200 dark:border-gray-800">
      <div class="flex-1 max-w-sm">
        <UInput v-model="searchQuery" icon="i-heroicons-magnifying-glass" placeholder="Search campaigns..." size="sm"
          class="w-full" />
      </div>

      <div class="flex flex-wrap items-center gap-2">
        <!-- Status Filter Tabs -->
        <div class="inline-flex p-1 bg-gray-100 dark:bg-gray-800 rounded-md text-xs">
          <button class="px-3 py-1 rounded transition-colors"
            :class="selectedStatus === 'ALL' ? 'bg-white dark:bg-gray-700 text-gray-900 dark:text-gray-100 font-semibold shadow-xs' : 'text-gray-500 hover:text-gray-900 dark:hover:text-gray-200'"
            @click="selectedStatus = 'ALL'">
            All
          </button>
          <button class="px-3 py-1 rounded transition-colors"
            :class="selectedStatus === 'PUBLIC' ? 'bg-white dark:bg-gray-700 text-gray-900 dark:text-gray-100 font-semibold shadow-xs' : 'text-gray-500 hover:text-gray-900 dark:hover:text-gray-200'"
            @click="selectedStatus = 'PUBLIC'">
            Public
          </button>
          <button class="px-3 py-1 rounded transition-colors"
            :class="selectedStatus === 'DRAFT' ? 'bg-white dark:bg-gray-700 text-gray-900 dark:text-gray-100 font-semibold shadow-xs' : 'text-gray-500 hover:text-gray-900 dark:hover:text-gray-200'"
            @click="selectedStatus = 'DRAFT'">
            Drafts
          </button>
        </div>

        <!-- Category Dropdown Filter -->
        <select v-model="selectedCategory"
          class="text-xs bg-white dark:bg-gray-800 border border-gray-200 dark:border-gray-700 rounded-md px-2.5 py-1.5 text-gray-700 dark:text-gray-200 focus:outline-none">
          <option value="">All Categories</option>
          <optgroup v-if="myCategories.length > 0" label="My Custom Categories">
            <option v-for="cat in myCategories" :key="'my-' + cat.id" :value="cat.name">
              {{ cat.name }}
            </option>
          </optgroup>
          <optgroup label="Default">
            <option v-for="cat in categories.filter(c => c.name !== 'OTHER')" :key="'sys-' + cat.id" :value="cat.name">
              {{ cat.name }}
            </option>
          </optgroup>
        </select>
      </div>
    </div>

    <!-- Loading state -->
    <div v-if="isLoading && campaignsList.length === 0" class="py-12 text-center text-gray-500 text-sm">
      <UIcon name="i-heroicons-arrow-path" class="w-6 h-6 animate-spin mx-auto mb-2 text-gray-400" />
      Loading campaigns...
    </div>

    <!-- Empty State -->
    <div v-else-if="campaignsList.length === 0"
      class="py-12 text-center bg-white dark:bg-gray-900 rounded-lg border border-gray-200 dark:border-gray-800 p-6">
      <UIcon name="i-heroicons-megaphone" class="w-10 h-10 text-gray-400 mx-auto mb-3" />
      <h3 class="text-sm font-semibold text-gray-900 dark:text-gray-100">No campaigns found</h3>
      <p class="text-xs text-gray-500 dark:text-gray-400 mt-1 max-w-sm mx-auto">
        Start promoting by creating your first campaign article or content item.
      </p>
      <UButton to="/creator/campaigns/create" color="primary" size="xs" class="mt-4">
        Create Campaign
      </UButton>
    </div>

    <!-- Campaigns List Table -->
    <div v-else
      class="bg-white dark:bg-gray-900 rounded-lg border border-gray-200 dark:border-gray-800 overflow-hidden">
      <div v-if="totalPages > 1"
        class="flex items-center justify-between border-b border-gray-200 px-4 py-3 dark:border-gray-800">
        <span class="text-xs text-gray-500 dark:text-gray-400">Page {{ currentPage }} of {{ totalPages }}</span>
        <div class="flex gap-2">
          <UButton color="neutral" variant="outline" size="xs" :disabled="currentPage === 1"
            @click="currentPage--; loadData()">Previous</UButton>
          <UButton color="neutral" variant="outline" size="xs" :disabled="currentPage === totalPages"
            @click="currentPage++; loadData()">Next</UButton>
        </div>
      </div>
      <div class="no-scrollbar overflow-x-auto">
        <table class="w-full text-left text-xs text-gray-600 dark:text-gray-300">
          <thead
            class="bg-gray-50 dark:bg-gray-950 text-gray-500 dark:text-gray-400 uppercase font-semibold border-b border-gray-200 dark:border-gray-800">
            <tr>
              <th class="py-3 px-4">Campaign Title</th>
              <th class="py-3 px-4">Category</th>
              <th class="py-3 px-4">Type</th>
              <th class="py-3 px-4">Status</th>
              <th class="py-3 px-4">Impressions</th>
              <th class="py-3 px-4">Created</th>
              <th class="py-3 px-4 text-right">Actions</th>
            </tr>
          </thead>
          <tbody class="divide-y divide-gray-200 dark:divide-gray-800">
            <tr v-for="item in campaignsList" :key="item.id"
              class="hover:bg-gray-50/50 dark:hover:bg-gray-800/50 transition-colors">
              <td class="py-3 px-4">
                <div class="flex items-center gap-3">
                  <button v-if="getPreviewImage(item)" type="button" @click="openImagePreview(item)"
                    class="group relative h-10 w-10 shrink-0 overflow-hidden rounded border border-gray-200 dark:border-gray-700 focus:outline-none focus:ring-2 focus:ring-primary/50"
                    :aria-label="`Open ${item.title} image preview`">
                    <img :src="getPreviewImage(item)" :alt="item.imageTitle || item.title"
                      class="h-full w-full object-cover transition-transform duration-200 group-hover:scale-110" />
                    <span
                      class="absolute inset-0 flex items-center justify-center bg-black/35 opacity-0 transition-opacity group-hover:opacity-100">
                      <UIcon name="i-heroicons-magnifying-glass-plus" class="h-4 w-4 text-white" />
                    </span>
                  </button>
                  <div v-else
                    class="w-10 h-10 rounded bg-gray-100 dark:bg-gray-800 flex items-center justify-center text-gray-400 shrink-0">
                    <UIcon name="i-heroicons-photo" class="w-5 h-5" />
                  </div>
                  <div class="min-w-0">
                    <NuxtLink :to="`/creator/campaigns/${item.id}/edit`"
                      class="font-semibold text-gray-900 dark:text-gray-100 hover:text-primary-600 dark:hover:text-primary-400 line-clamp-1">
                      {{ item.title }}
                    </NuxtLink>
                    <p class="text-[11px] text-gray-500 dark:text-gray-400 line-clamp-1 mt-0.5">
                      {{ item.description || 'No description provided' }}
                    </p>
                  </div>
                </div>
              </td>

              <td class="py-3 px-4 font-medium">
                <span
                  class="inline-block px-2 py-0.5 rounded bg-gray-100 dark:bg-gray-800 text-gray-700 dark:text-gray-300">
                  {{ item.category || 'General' }}
                </span>
              </td>

              <td class="py-3 px-4">
                {{ item.contentType || 'ARTICLE' }}
              </td>

              <td class="py-3 px-4">
                <CampaignStatusToggle :title="item.title" :status="item.status"
                  :disabled="updatingStatusIds.has(item.id)" @change="handleStatusToggle(item, $event)" />
              </td>

              <td class="py-3 px-4 font-mono font-medium">
                {{ item.totalImpressions || 0 }}
              </td>

              <td class="py-3 px-4 text-gray-400">
                {{ new Date(item.createdAt).toLocaleDateString() }}
              </td>

              <td class="py-3 px-4 text-right">
                <CampaignRowActions :article-url="getArticleUrl(item)" :edit-url="`/creator/campaigns/${item.id}/edit`"
                  @delete="confirmDelete(item)" />
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>

    <!-- Delete Confirmation Modal -->
    <UModal v-model:open="deleteModalOpen" title="Confirm Deletion">
      <template #body>
        <div class="space-y-3 p-4">
          <p class="text-xs text-gray-600 dark:text-gray-300">
            Are you sure you want to delete <strong class="text-gray-900 dark:text-gray-100">{{
              selectedCampaignToDelete?.title }}</strong>?
          </p>
          <div class="flex justify-end gap-2 pt-2">
            <UButton color="neutral" variant="outline" size="xs" @click="deleteModalOpen = false">
              Cancel
            </UButton>
            <UButton color="error" size="xs" :loading="isDeleting" @click="executeDelete">
              Confirm Delete
            </UButton>
          </div>
        </div>
      </template>
    </UModal>

    <UModal v-model:open="imagePreviewOpen" :title="imagePreviewTitle"
      :ui="{ content: 'w-[calc(100vw-2rem)] max-w-[90vw] sm:max-w-3xl' }">
      <template #body>
        <div class="flex h-[68vh] min-h-[16rem] items-center justify-center overflow-auto bg-gray-950 p-2 sm:p-4">
          <img :src="imagePreviewUrl" :alt="imagePreviewTitle" class="max-h-full max-w-full object-contain" />
        </div>
      </template>
    </UModal>
  </div>
</template>
