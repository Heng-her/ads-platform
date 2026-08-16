<script setup lang="ts">
import { ref, computed, onMounted, watch } from 'vue'
import { useRoute } from 'vue-router'
import { useCampaigns, type CampaignData, type AdminCampaignUser } from '~/composables/useCampaigns'
import { useAppToast } from '~/composables/useAppToast'
import { getArticleUrl } from '~/lib/utils'
import CampaignStatusToggle from '~/components/CampaignStatusToggle.vue'

definePageMeta({ layout: 'admin' })

const route = useRoute()
const toast = useAppToast()

const userId = computed(() => String(route.params.id || ''))

const {
  isLoading,
  fetchAdminCampaignUsers,
  fetchAdminUserCampaigns,
  updateCampaignStatus,
  deleteCampaign
} = useCampaigns()

const creator = ref<AdminCampaignUser | null>(null)
const campaigns = ref<CampaignData[]>([])
const filterStatus = ref<'ALL' | 'PUBLIC' | 'DRAFT'>('ALL')
const searchQuery = ref('')
const currentPage = ref(1)
const totalCampaigns = ref(0)
const totalPages = ref(1)

const updatingStatusIds = ref<Set<string>>(new Set())
const deletingCampaignIds = ref<Set<string>>(new Set())

// Modal for Delete Confirmation
const showDeleteModal = ref(false)
const campaignToDelete = ref<CampaignData | null>(null)
const isDeleting = ref(false)

async function loadCreatorInfo() {
  try {
    const data = await fetchAdminCampaignUsers({ search: undefined, page: 1 })
    const found = data.items.find(u => u.id === userId.value)
    if (found) {
      creator.value = found
    }
  } catch (err: any) {
    console.warn('Could not fetch creator profile:', err)
  }
}

async function loadCampaigns() {
  if (!userId.value) return
  try {
    const data = await fetchAdminUserCampaigns(userId.value, currentPage.value)
    campaigns.value = data.items
    totalCampaigns.value = data.total
    totalPages.value = data.totalPages
  } catch (err: any) {
    toast.error('Failed to load creator campaigns', err.message || 'Could not fetch data')
  }
}

onMounted(async () => {
  await loadCreatorInfo()
  await loadCampaigns()
})

const filteredCampaigns = computed(() => {
  return campaigns.value.filter(c => {
    const q = searchQuery.value.trim().toLowerCase()
    const matchesSearch = !q || c.title.toLowerCase().includes(q) || (c.category && c.category.toLowerCase().includes(q))
    const matchesStatus = filterStatus.value === 'ALL' || c.status === filterStatus.value
    return matchesSearch && matchesStatus
  })
})

const publicCount = computed(() => campaigns.value.filter(c => c.status === 'PUBLIC').length)
const draftCount = computed(() => campaigns.value.filter(c => c.status === 'DRAFT').length)

async function handleStatusToggle(campaign: CampaignData, status: 'DRAFT' | 'PUBLIC') {
  if (updatingStatusIds.value.has(campaign.id)) return

  updatingStatusIds.value.add(campaign.id)
  try {
    await updateCampaignStatus(campaign.id, status)
    campaign.status = status
    toast.success('Status Updated', `Campaign "${campaign.title}" is now ${status}.`)
  } catch (err: any) {
    toast.error('Status Update Failed', err.message || 'Failed to update campaign status')
  } finally {
    updatingStatusIds.value.delete(campaign.id)
  }
}

function promptDelete(campaign: CampaignData) {
  campaignToDelete.value = campaign
  showDeleteModal.value = true
}

async function confirmDelete() {
  if (!campaignToDelete.value) return
  isDeleting.value = true
  const targetId = campaignToDelete.value.id
  deletingCampaignIds.value.add(targetId)

  try {
    await deleteCampaign(targetId)
    campaigns.value = campaigns.value.filter(c => c.id !== targetId)
    totalCampaigns.value = Math.max(0, totalCampaigns.value - 1)
    toast.success('Campaign Deleted', `Campaign "${campaignToDelete.value.title}" removed.`)
    showDeleteModal.value = false
    campaignToDelete.value = null
  } catch (err: any) {
    toast.error('Delete Failed', err.message || 'Could not delete campaign')
  } finally {
    isDeleting.value = false
    deletingCampaignIds.value.delete(targetId)
  }
}
</script>

<template>
  <div class="mx-auto max-w-7xl space-y-6 pb-12 text-gray-100">
    <!-- Back Button & Breadcrumbs -->
    <div class="flex items-center gap-2 text-xs font-semibold text-gray-400">
      <NuxtLink to="/admin/campaigns" class="flex items-center gap-1 hover:text-white transition-colors">
        <UIcon name="i-heroicons-arrow-left" class="w-4 h-4" />
        <span>Back to All Users</span>
      </NuxtLink>
      <span>/</span>
      <span class="text-gray-200">Creator Campaign Management</span>
    </div>

    <!-- Header & Creator Profile Summary Card -->
    <div
      class="flex flex-col sm:flex-row sm:items-center justify-between gap-5 bg-gray-900 p-6 rounded-2xl border border-gray-800 shadow-md">
      <div class="flex items-center gap-4">
        <div class="relative h-14 w-14 shrink-0 overflow-hidden rounded-full border border-gray-700 bg-gray-800">
          <img v-if="creator?.avatar" :src="creator.avatar" :alt="creator.username"
            class="h-full w-full object-cover" />
          <div v-else class="flex h-full w-full items-center justify-center font-bold text-gray-400 text-lg">
            {{ (creator?.username || 'U').charAt(0).toUpperCase() }}
          </div>
        </div>
        <div>
          <div class="flex items-center gap-2 flex-wrap">
            <h1 class="text-xl font-bold text-white tracking-tight">
              {{ creator?.username || 'Creator' }}'s Campaigns
            </h1>
            <UBadge :color="creator?.status === 'ACTIVE' ? 'success' : 'warning'" variant="solid" size="xs"
              class="font-bold uppercase">
              {{ creator?.status || 'ACTIVE' }}
            </UBadge>
          </div>
          <p class="mt-0.5 text-xs text-gray-400 font-mono">
            {{ creator?.email }}
          </p>
        </div>
      </div>

      <!-- Quick Summary Pills -->
      <div class="flex items-center gap-3 flex-wrap">
        <div class="px-3 py-1.5 rounded-xl bg-gray-950 border border-gray-800 text-xs font-mono">
          <span class="text-gray-400">Total: </span>
          <span class="text-white font-bold">{{ totalCampaigns }}</span>
        </div>
        <div class="px-3 py-1.5 rounded-xl bg-gray-950 border border-gray-800 text-xs font-mono">
          <span class="text-gray-400">Public: </span>
          <span class="text-emerald-400 font-bold">{{ publicCount }}</span>
        </div>
        <div class="px-3 py-1.5 rounded-xl bg-gray-950 border border-gray-800 text-xs font-mono">
          <span class="text-gray-400">Drafts: </span>
          <span class="text-amber-400 font-bold">{{ draftCount }}</span>
        </div>
      </div>
    </div>

    <!-- Filter Bar & Search -->
    <div class="flex flex-col sm:flex-row items-center justify-between gap-3">
      <!-- Tabs -->
      <div class="flex items-center rounded-xl bg-gray-900 p-1 border border-gray-800 text-xs w-full sm:w-auto">
        <button type="button" class="px-3.5 py-1.5 rounded-lg font-semibold transition-all"
          :class="filterStatus === 'ALL' ? 'bg-primary-600 text-white shadow-xs' : 'text-gray-400 hover:text-white'"
          @click="filterStatus = 'ALL'">
          All ({{ totalCampaigns }})
        </button>
        <button type="button" class="px-3.5 py-1.5 rounded-lg font-semibold transition-all"
          :class="filterStatus === 'PUBLIC' ? 'bg-emerald-600 text-white shadow-xs' : 'text-gray-400 hover:text-white'"
          @click="filterStatus = 'PUBLIC'">
          Public ({{ publicCount }})
        </button>
        <button type="button" class="px-3.5 py-1.5 rounded-lg font-semibold transition-all"
          :class="filterStatus === 'DRAFT' ? 'bg-amber-600 text-white shadow-xs' : 'text-gray-400 hover:text-white'"
          @click="filterStatus = 'DRAFT'">
          Drafts ({{ draftCount }})
        </button>
      </div>

      <!-- Search Input -->
      <div class="w-full sm:w-80">
        <UInput v-model="searchQuery" icon="i-heroicons-magnifying-glass" placeholder="Filter campaigns..." size="sm"
          class="w-full" />
      </div>
    </div>

    <!-- Full Campaign Table -->
    <div class="overflow-hidden rounded-2xl border border-gray-800 bg-gray-900 shadow-xl">
      <div class="overflow-x-auto">
        <table class="w-full text-left text-xs border-collapse">
          <thead>
            <tr
              class="border-b border-gray-800 bg-gray-950 text-gray-400 uppercase tracking-wider font-semibold text-[11px]">
              <th class="py-3.5 px-4 min-w-[220px]">Campaign Title</th>
              <th class="py-3.5 px-4">Category</th>
              <th class="py-3.5 px-4">Created Date</th>
              <th class="py-3.5 px-4">Visibility / Status</th>
              <th class="py-3.5 px-4 text-right">Actions</th>
            </tr>
          </thead>
          <tbody class="divide-y divide-gray-800/60">
            <tr v-if="isLoading && !campaigns.length">
              <td colspan="5" class="py-12 text-center text-gray-400">
                <UIcon name="i-heroicons-arrow-path" class="w-6 h-6 animate-spin mx-auto mb-2 text-primary-400" />
                Loading campaigns...
              </td>
            </tr>

            <tr v-else-if="filteredCampaigns.length === 0">
              <td colspan="5" class="py-12 text-center text-gray-500 italic">
                No campaigns found matching criteria.
              </td>
            </tr>

            <tr v-for="campaign in filteredCampaigns" :key="campaign.id"
              class="hover:bg-gray-800/40 transition-colors">
              <!-- Title & Thumbnail -->
              <td class="py-3.5 px-4">
                <div class="flex items-center gap-3">
                  <img v-if="campaign.imageUrl" :src="campaign.imageUrl" alt=""
                    class="h-10 w-10 rounded-lg object-cover border border-gray-800 shrink-0" />
                  <div v-else
                    class="h-10 w-10 rounded-lg bg-gray-800 flex items-center justify-center text-gray-500 shrink-0">
                    <UIcon name="i-heroicons-photo" class="w-5 h-5" />
                  </div>
                  <div class="min-w-0">
                    <p class="font-bold text-white text-sm truncate max-w-[280px]">{{ campaign.title }}</p>
                    <p class="text-[11px] text-gray-400 font-mono mt-0.5 truncate max-w-[280px]">ID: {{ campaign.id }}</p>
                  </div>
                </div>
              </td>

              <!-- Category -->
              <td class="py-3.5 px-4">
                <UBadge color="neutral" variant="soft" size="xs" class="font-semibold">
                  {{ campaign.category || 'General' }}
                </UBadge>
              </td>

              <!-- Created Date -->
              <td class="py-3.5 px-4 text-gray-400 font-mono">
                {{ new Date(campaign.createdAt).toLocaleDateString() }}
              </td>

              <!-- Visibility / Status Toggle -->
              <td class="py-3.5 px-4">
                <CampaignStatusToggle :title="campaign.title" :status="campaign.status"
                  :disabled="updatingStatusIds.has(campaign.id)" size="xs"
                  @change="handleStatusToggle(campaign, $event)" />
              </td>

              <!-- Actions -->
              <td class="py-3.5 px-4 text-right">
                <div class="flex items-center justify-end gap-1.5">
                  <!-- View Article -->
                  <a :href="getArticleUrl(campaign)" target="_blank"
                    class="p-1.5 rounded-lg bg-gray-800 text-gray-300 hover:text-white hover:bg-gray-700 transition-colors"
                    title="View Published Article">
                    <UIcon name="i-heroicons-arrow-top-right-on-square" class="w-4 h-4" />
                  </a>

                  <!-- Edit Campaign -->
                  <NuxtLink :to="`/creator/campaigns/${campaign.id}/edit`"
                    class="p-1.5 rounded-lg bg-gray-800 text-gray-300 hover:text-primary-400 hover:bg-gray-700 transition-colors"
                    title="Edit Campaign">
                    <UIcon name="i-heroicons-pencil-square" class="w-4 h-4" />
                  </NuxtLink>

                  <!-- Delete Campaign -->
                  <button type="button"
                    class="p-1.5 rounded-lg bg-red-500/10 border border-red-500/20 text-red-400 hover:bg-red-500/20 transition-colors"
                    title="Delete Campaign" @click="promptDelete(campaign)">
                    <UIcon name="i-heroicons-trash" class="w-4 h-4" />
                  </button>
                </div>
              </td>
            </tr>
          </tbody>
        </table>
      </div>

      <!-- Pagination Footer -->
      <div v-if="totalPages > 1" class="flex items-center justify-between border-t border-gray-800 px-4 py-3 text-xs">
        <span class="text-gray-400">Page {{ currentPage }} of {{ totalPages }}</span>
        <div class="flex gap-2">
          <UButton color="neutral" variant="outline" size="xs" :disabled="currentPage === 1"
            @click="currentPage--; loadCampaigns()">Previous</UButton>
          <UButton color="neutral" variant="outline" size="xs" :disabled="currentPage === totalPages"
            @click="currentPage++; loadCampaigns()">Next</UButton>
        </div>
      </div>
    </div>

    <!-- Modal: Delete Confirmation -->
    <div v-if="showDeleteModal && campaignToDelete"
      class="fixed inset-0 z-50 flex items-center justify-center bg-black/80 p-4 backdrop-blur-xs">
      <div class="w-full max-w-md rounded-2xl border border-red-900/50 bg-gray-900 p-6 shadow-2xl space-y-4">
        <div class="flex items-center gap-3 text-red-400">
          <UIcon name="i-heroicons-exclamation-triangle" class="w-6 h-6 shrink-0" />
          <h3 class="text-lg font-bold text-white">Delete Campaign</h3>
        </div>

        <p class="text-xs text-gray-300">
          Are you sure you want to delete campaign <strong class="text-white">"{{ campaignToDelete.title }}"</strong>? This action can only be restored manually in the database.
        </p>

        <div class="flex items-center justify-end gap-2 pt-3 border-t border-gray-800">
          <button type="button" class="px-4 py-2 rounded-lg bg-gray-800 text-xs font-bold text-gray-300 hover:bg-gray-700"
            @click="showDeleteModal = false">
            Cancel
          </button>
          <button type="button" :disabled="isDeleting"
            class="px-4 py-2 rounded-lg bg-red-600 text-xs font-bold text-white hover:bg-red-500 disabled:opacity-50 inline-flex items-center gap-1.5"
            @click="confirmDelete">
            <UIcon v-if="isDeleting" name="i-heroicons-arrow-path" class="w-4 h-4 animate-spin" />
            <span>{{ isDeleting ? 'Deleting...' : 'Delete Campaign' }}</span>
          </button>
        </div>
      </div>
    </div>
  </div>
</template>
