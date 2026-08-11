<script setup lang="ts">
import { ref, onMounted, computed } from 'vue'
import { useApi } from '~/composables/useApi'
import { useAppToast } from '~/composables/useAppToast'

definePageMeta({
  layout: 'admin'
})

const api = useApi()
const toast = useAppToast()

const activeTab = ref<'creators' | 'campaigns'>('creators')
const isLoading = ref(true)
const searchQuery = ref('')
const processingId = ref<string | null>(null)

// Data State
const allUsers = ref<any[]>([])
const allCampaigns = ref<any[]>([])

// Selected item for inspection modal
const selectedCreator = ref<any | null>(null)
const selectedCampaign = ref<any | null>(null)

async function fetchData() {
  isLoading.value = true
  try {
    // 1. Fetch users list for Creator Approvals
    const usersRes = await api.action.$post({
      json: { action: 'users/list' }
    })
    const usersBody = await usersRes.json()
    if (usersRes.ok && usersBody.code === 1) {
      allUsers.value = usersBody.data || []
    }

    // 2. Fetch campaigns for Campaign Approvals
    const restCampaignsRes = await api.campaigns.$get({
      query: { limit: '100' }
    })
    const restBody = await restCampaignsRes.json()
    if (restCampaignsRes.ok && restBody.code === 1 && restBody.data) {
      allCampaigns.value = restBody.data.items || []
    }
  } catch (err: any) {
    toast.error('Data Fetch Error', err.message || 'Could not fetch moderation items.')
  } finally {
    isLoading.value = false
  }
}

onMounted(() => {
  fetchData()
})

// All Platform Users & Role Approvals
const pendingCreators = computed(() => {
  return allUsers.value.filter(user => {
    const matchesSearch = searchQuery.value === '' ||
      user.username?.toLowerCase().includes(searchQuery.value.toLowerCase()) ||
      user.email?.toLowerCase().includes(searchQuery.value.toLowerCase()) ||
      user.country?.toLowerCase().includes(searchQuery.value.toLowerCase()) ||
      user.role?.toLowerCase().includes(searchQuery.value.toLowerCase())
    return matchesSearch
  })
})

// Pending Campaigns (status === 'DRAFT' or newly created campaigns)
const pendingCampaigns = computed(() => {
  return allCampaigns.value.filter(c => {
    const isPending = c.status === 'DRAFT' || c.status === 'PENDING'
    const matchesSearch = searchQuery.value === '' ||
      c.title?.toLowerCase().includes(searchQuery.value.toLowerCase()) ||
      c.category?.toLowerCase().includes(searchQuery.value.toLowerCase())
    return matchesSearch
  })
})

// Count of strictly PENDING items
const pendingCreatorsCount = computed(() => allUsers.value.filter(u => u.status === 'PENDING').length)
const pendingCampaignsCount = computed(() => allCampaigns.value.filter(c => c.status === 'DRAFT' || c.status === 'PENDING').length)

// Actions for Creators
async function updateCreatorStatus(userId: string, status: 'ACTIVE' | 'SUSPENDED', role?: 'ADMIN' | 'CREATOR') {
  processingId.value = userId
  try {
    const actionName = role ? 'users/update' : 'users/update-status'
    const payloadData = role ? { id: userId, status, role } : { id: userId, status }

    const res = await api.action.$post({
      json: {
        action: actionName,
        data: payloadData
      }
    })
    const body = await res.json()
    if (res.ok && body.code === 1) {
      const idx = allUsers.value.findIndex(u => u.id === userId)
      if (idx !== -1) {
        allUsers.value[idx].status = status
        if (role) allUsers.value[idx].role = role
      }
      if (selectedCreator.value?.id === userId) selectedCreator.value = null

      const roleMsg = role === 'ADMIN' ? ' as Administrator' : ''
      const statusText = status === 'ACTIVE' ? `Approved${roleMsg}` : 'Suspended'
      toast.success(`User ${statusText}`, `User account is now ${status}${roleMsg}.`)
    } else {
      toast.error('Action Failed', body.msg || 'Could not update user status.')
    }
  } catch (err: any) {
    toast.error('Network Error', err.message || 'Operation failed.')
  } finally {
    processingId.value = null
  }
}

// Actions for Campaigns
async function updateCampaignStatus(campaignId: string, status: 'PUBLIC' | 'DRAFT' | 'PAUSED') {
  processingId.value = campaignId
  try {
    const res = await api.action.$post({
      json: {
        action: 'campaigns/update-status',
        data: { id: campaignId, status }
      }
    })
    const body = await res.json()
    if (res.ok && body.code === 1) {
      const idx = allCampaigns.value.findIndex(c => c.id === campaignId)
      if (idx !== -1) allCampaigns.value[idx].status = status
      if (selectedCampaign.value?.id === campaignId) selectedCampaign.value = null

      const statusText = status === 'PUBLIC' ? 'Approved & Published' : 'Updated'
      toast.success(`Campaign ${statusText}`, `Campaign is now ${status}.`)
    } else {
      toast.error('Action Failed', body.msg || 'Could not update campaign status.')
    }
  } catch (err: any) {
    toast.error('Network Error', err.message || 'Operation failed.')
  } finally {
    processingId.value = null
  }
}

function formatDate(dateStr?: string) {
  if (!dateStr) return 'N/A'
  return new Date(dateStr).toLocaleDateString('en-US', {
    month: 'short',
    day: 'numeric',
    year: 'numeric'
  })
}
</script>

<template>
  <div class="mx-auto max-w-7xl space-y-8 pb-12 text-gray-100">
    <!-- Header -->
    <div class="flex flex-col gap-4 sm:flex-row sm:items-center sm:justify-between">
      <div>
        <div class="flex items-center gap-3">
          <h1 class="text-2xl font-bold tracking-tight text-white sm:text-3xl">Pending Approvals & Moderation Queue</h1>
          <UBadge color="warning" variant="soft" class="font-mono text-xs">
            {{ pendingCreatorsCount + pendingCampaignsCount }} REVIEWS NEEDED
          </UBadge>
        </div>
        <p class="mt-1 text-sm text-gray-400">
          Review new creator registrations and campaign content before approving them for live publication.
        </p>
      </div>

      <div class="flex items-center gap-3">
        <button :disabled="isLoading"
          class="inline-flex items-center gap-2 rounded-lg border border-gray-800 bg-gray-900 px-4 py-2.5 text-xs font-semibold text-gray-300 transition hover:bg-gray-800 hover:text-white disabled:opacity-50"
          @click="fetchData">
          <UIcon v-if="isLoading" name="i-heroicons-arrow-path" class="h-4 w-4 animate-spin text-primary-400" />
          <UIcon v-else name="i-heroicons-arrow-path" class="h-4 w-4 text-gray-400" />
          <span>{{ isLoading ? 'Refreshing...' : 'Refresh Queue' }}</span>
        </button>
      </div>
    </div>

    <!-- Navigation Tabs & Search Controls -->
    <div class="flex flex-col gap-4 border-b border-gray-800 pb-4 sm:flex-row sm:items-center sm:justify-between">
      <nav class="-mb-px flex space-x-6 overflow-x-auto" aria-label="Approvals Tabs">
        <button :class="[
          activeTab === 'creators'
            ? 'border-primary-500 text-primary-400'
            : 'border-transparent text-gray-400 hover:border-gray-700 hover:text-gray-200',
          'flex items-center gap-2.5 border-b-2 py-3 px-1 text-sm font-medium whitespace-nowrap'
        ]" @click="activeTab = 'creators'">
          <UIcon name="i-heroicons-users" class="h-5 w-5" />
          <span>User Accounts & Roles</span>
          <UBadge v-if="pendingCreatorsCount > 0" color="warning" variant="solid" size="xs">
            {{ pendingCreatorsCount }}
          </UBadge>
        </button>

        <button :class="[
          activeTab === 'campaigns'
            ? 'border-primary-500 text-primary-400'
            : 'border-transparent text-gray-400 hover:border-gray-700 hover:text-gray-200',
          'flex items-center gap-2.5 border-b-2 py-3 px-1 text-sm font-medium whitespace-nowrap'
        ]" @click="activeTab = 'campaigns'">
          <UIcon name="i-heroicons-megaphone" class="h-5 w-5" />
          <span>Campaign Approvals</span>
          <UBadge v-if="pendingCampaignsCount > 0" color="warning" variant="solid" size="xs">
            {{ pendingCampaignsCount }}
          </UBadge>
        </button>
      </nav>

      <div class="w-full sm:w-72">
        <UInput v-model="searchQuery" icon="i-heroicons-magnifying-glass" placeholder="Search by keyword..." size="sm"
          class="w-full" />
      </div>
    </div>

    <!-- TAB 1: User Accounts & Roles -->
    <div v-if="activeTab === 'creators'" class="space-y-6">
      <div v-if="isLoading" class="grid gap-6 md:grid-cols-2 lg:grid-cols-3">
        <div v-for="i in 3" :key="i" class="h-44 animate-pulse rounded-xl border border-gray-800 bg-gray-900/60 p-6" />
      </div>

      <div v-else-if="pendingCreators.length === 0"
        class="rounded-xl border border-gray-800 bg-gray-900 p-12 text-center text-gray-400">
        <UIcon name="i-heroicons-check-circle" class="mx-auto h-12 w-12 text-emerald-400" />
        <h3 class="mt-3 text-lg font-semibold text-white">Queue Cleared!</h3>
        <p class="mt-1 text-sm text-gray-500">There are currently no user accounts matching your search.</p>
      </div>

      <div v-else class="grid gap-6 md:grid-cols-2 lg:grid-cols-3">
        <div v-for="creator in pendingCreators" :key="creator.id"
          class="flex flex-col justify-between rounded-xl border border-gray-800 bg-gray-900 p-6 shadow-sm transition hover:border-gray-700">
          <div class="space-y-4">
            <div class="flex items-center justify-between">
              <div class="flex items-center gap-3">
                <div
                  class="relative h-12 w-12 shrink-0 overflow-hidden rounded-full border border-gray-700 bg-gray-800">
                  <img v-if="creator.avatar" :src="creator.avatar" :alt="creator.username"
                    class="h-full w-full object-cover" />
                  <div v-else class="flex h-full w-full items-center justify-center text-gray-400">
                    <UIcon name="i-heroicons-user" class="h-6 w-6" />
                  </div>
                </div>
                <div>
                  <h3 class="font-bold text-white text-base">{{ creator.username || 'Anonymous User' }}</h3>
                  <p class="text-xs text-gray-400 truncate max-w-[180px]">{{ creator.email }}</p>
                </div>
              </div>
              <div class="flex flex-col items-end gap-1">
                <UBadge :color="creator.role === 'ADMIN' ? 'error' : 'primary'" variant="solid" size="xs" class="font-bold uppercase">
                  {{ creator.role || 'CREATOR' }}
                </UBadge>
                <UBadge
                  :color="creator.status === 'ACTIVE' ? 'success' : (creator.status === 'PENDING' ? 'warning' : 'neutral')"
                  variant="soft" size="xs" class="font-semibold">
                  {{ creator.status || 'PENDING' }}
                </UBadge>
              </div>
            </div>

            <div class="space-y-2 border-t border-gray-800/80 pt-3 text-xs text-gray-300">
              <div class="flex justify-between">
                <span class="text-gray-500">Country:</span>
                <span class="font-semibold text-white">{{ creator.country || 'KH' }}</span>
              </div>
              <div class="flex justify-between">
                <span class="text-gray-500">Registered:</span>
                <span class="text-gray-400">{{ formatDate(creator.createdAt) }}</span>
              </div>
              <div v-if="creator.portfolioLink" class="flex justify-between truncate">
                <span class="text-gray-500 shrink-0 mr-2">Portfolio:</span>
                <a :href="creator.portfolioLink" target="_blank" class="truncate text-primary-400 hover:underline">
                  {{ creator.portfolioLink }}
                </a>
              </div>
            </div>
          </div>

          <div class="mt-6 flex flex-wrap items-center gap-2 border-t border-gray-800/80 pt-4">
            <button :disabled="processingId === creator.id"
              class="flex-1 inline-flex items-center justify-center gap-1.5 rounded-lg bg-indigo-600 px-3 py-2 text-xs font-semibold text-white transition hover:bg-indigo-500 disabled:opacity-50"
              @click="updateCreatorStatus(creator.id, 'ACTIVE', 'ADMIN')">
              <UIcon v-if="processingId === creator.id" name="i-heroicons-arrow-path" class="h-4 w-4 animate-spin" />
              <UIcon v-else name="i-heroicons-shield-check" class="h-4 w-4" />
              <span>Approve as Admin</span>
            </button>

            <button :disabled="processingId === creator.id"
              class="inline-flex items-center justify-center gap-1 rounded-lg border border-red-500/30 bg-red-500/10 px-2.5 py-2 text-xs font-semibold text-red-400 transition hover:bg-red-500/20 disabled:opacity-50"
              @click="updateCreatorStatus(creator.id, 'SUSPENDED')">
              <UIcon name="i-heroicons-x-mark" class="h-4 w-4" />
              <span>Suspend</span>
            </button>

            <button class="rounded-lg border border-gray-800 bg-gray-800 p-2 text-gray-400 hover:text-white transition"
              title="Inspect Details" @click="selectedCreator = creator">
              <UIcon name="i-heroicons-eye" class="h-4 w-4" />
            </button>
          </div>
        </div>
      </div>
    </div>

    <!-- TAB 2: Campaign Approvals -->
    <div v-if="activeTab === 'campaigns'" class="space-y-6">
      <div v-if="isLoading" class="grid gap-6 md:grid-cols-2 lg:grid-cols-3">
        <div v-for="i in 3" :key="i" class="h-56 animate-pulse rounded-xl border border-gray-800 bg-gray-900/60 p-6" />
      </div>

      <div v-else-if="pendingCampaigns.length === 0"
        class="rounded-xl border border-gray-800 bg-gray-900 p-12 text-center text-gray-400">
        <UIcon name="i-heroicons-check-circle" class="mx-auto h-12 w-12 text-emerald-400" />
        <h3 class="mt-3 text-lg font-semibold text-white">Queue Cleared!</h3>
        <p class="mt-1 text-sm text-gray-500">There are currently no campaigns requiring content moderation.</p>
      </div>

      <div v-else class="grid gap-6 md:grid-cols-2 lg:grid-cols-3">
        <div v-for="campaign in pendingCampaigns" :key="campaign.id"
          class="flex flex-col justify-between rounded-xl border border-gray-800 bg-gray-900 p-6 shadow-sm transition hover:border-gray-700">
          <div class="space-y-4">
            <div class="flex items-center justify-between">
              <UBadge color="primary" variant="soft" size="xs" class="font-semibold uppercase">
                {{ campaign.category || 'UNCATEGORIZED' }}
              </UBadge>
              <UBadge :color="campaign.status === 'PUBLIC' ? 'success' : 'warning'" variant="soft" size="xs"
                class="font-semibold">
                {{ campaign.status || 'DRAFT' }}
              </UBadge>
            </div>

            <!-- Media Preview Image / Video -->
            <div class="relative h-36 w-full overflow-hidden rounded-lg border border-gray-800 bg-gray-950">
              <img v-if="campaign.imageUrl" :src="campaign.imageUrl" :alt="campaign.title"
                class="h-full w-full object-cover" />
              <div v-else class="flex h-full w-full flex-col items-center justify-center text-gray-500">
                <UIcon name="i-heroicons-photo" class="h-8 w-8" />
                <span class="mt-1 text-xs">No preview media</span>
              </div>
            </div>

            <div>
              <h3 class="font-bold text-white text-base line-clamp-1">{{ campaign.title }}</h3>
              <p class="text-xs text-gray-400 mt-1 line-clamp-2">{{ campaign.description || 'No description provided.'
              }}</p>
            </div>
          </div>

          <div class="mt-6 flex items-center gap-2 border-t border-gray-800/80 pt-4">
            <button :disabled="processingId === campaign.id"
              class="flex-1 inline-flex items-center justify-center gap-1.5 rounded-lg bg-emerald-600 px-3 py-2 text-xs font-semibold text-white transition hover:bg-emerald-500 disabled:opacity-50"
              @click="updateCampaignStatus(campaign.id, 'PUBLIC')">
              <UIcon v-if="processingId === campaign.id" name="i-heroicons-arrow-path" class="h-4 w-4 animate-spin" />
              <UIcon v-else name="i-heroicons-check" class="h-4 w-4" />
              <span>Approve & Publish</span>
            </button>

            <button class="rounded-lg border border-gray-800 bg-gray-800 p-2 text-gray-400 hover:text-white transition"
              title="Inspect Campaign Details" @click="selectedCampaign = campaign">
              <UIcon name="i-heroicons-eye" class="h-4 w-4" />
            </button>
          </div>
        </div>
      </div>
    </div>

    <!-- Modal 1: Creator Detail Inspection -->
    <div v-if="selectedCreator"
      class="fixed inset-0 z-50 flex items-center justify-center bg-black/70 p-4 backdrop-blur-xs">
      <div
        class="w-full max-w-lg rounded-2xl border border-gray-800 bg-gray-900 p-6 shadow-2xl space-y-6 text-gray-100">
        <div class="flex items-center justify-between border-b border-gray-800 pb-4">
          <div class="flex items-center gap-3">
            <UIcon name="i-heroicons-user-circle" class="h-6 w-6 text-primary-400" />
            <h2 class="text-lg font-bold text-white">Creator Verification Details</h2>
          </div>
          <button class="text-gray-400 hover:text-white" @click="selectedCreator = null">
            <UIcon name="i-heroicons-x-mark" class="h-5 w-5" />
          </button>
        </div>

        <div class="space-y-4">
          <div class="flex items-center gap-4">
            <div class="relative h-16 w-16 overflow-hidden rounded-full border border-gray-700 bg-gray-800">
              <img v-if="selectedCreator.avatar" :src="selectedCreator.avatar" :alt="selectedCreator.username"
                class="h-full w-full object-cover" />
              <div v-else class="flex h-full w-full items-center justify-center text-gray-400">
                <UIcon name="i-heroicons-user" class="h-8 w-8" />
              </div>
            </div>
            <div>
              <h3 class="text-lg font-bold text-white">{{ selectedCreator.username }}</h3>
              <p class="text-sm text-gray-400">{{ selectedCreator.email }}</p>
              <UBadge color="warning" variant="soft" size="xs" class="mt-1">
                Status: {{ selectedCreator.status || 'PENDING' }}
              </UBadge>
            </div>
          </div>

          <div class="space-y-2 rounded-xl bg-gray-950 p-4 border border-gray-800 text-xs">
            <div class="flex justify-between">
              <span class="text-gray-400">User ID:</span>
              <span class="font-mono text-gray-200">{{ selectedCreator.id }}</span>
            </div>
            <div class="flex justify-between">
              <span class="text-gray-400">Country:</span>
              <span class="text-gray-200">{{ selectedCreator.country || 'Cambodia (KH)' }}</span>
            </div>
            <div v-if="selectedCreator.portfolioLink" class="flex justify-between">
              <span class="text-gray-400">Portfolio Link:</span>
              <a :href="selectedCreator.portfolioLink" target="_blank" class="text-primary-400 hover:underline">
                {{ selectedCreator.portfolioLink }}
              </a>
            </div>
          </div>
        </div>

        <div class="flex flex-wrap items-center justify-end gap-2.5 border-t border-gray-800 pt-4">
          <button
            class="rounded-lg border border-red-500/30 bg-red-500/10 px-3.5 py-2 text-xs font-semibold text-red-400 hover:bg-red-500/20 transition"
            @click="updateCreatorStatus(selectedCreator.id, 'SUSPENDED')">
            Suspend Account
          </button>
          <button
            class="rounded-lg bg-indigo-600 px-4 py-2 text-xs font-semibold text-white hover:bg-indigo-500 transition"
            @click="updateCreatorStatus(selectedCreator.id, 'ACTIVE', 'ADMIN')">
            Approve as Admin
          </button>
        </div>
      </div>
    </div>

    <!-- Modal 2: Campaign Detail Inspection -->
    <div v-if="selectedCampaign"
      class="fixed inset-0 z-50 flex items-center justify-center bg-black/70 p-4 backdrop-blur-xs">
      <div
        class="w-full max-w-xl rounded-2xl border border-gray-800 bg-gray-900 p-6 shadow-2xl space-y-6 text-gray-100 max-h-[90vh] overflow-y-auto">
        <div class="flex items-center justify-between border-b border-gray-800 pb-4">
          <div class="flex items-center gap-3">
            <UIcon name="i-heroicons-megaphone" class="h-6 w-6 text-primary-400" />
            <h2 class="text-lg font-bold text-white">Campaign Moderation Preview</h2>
          </div>
          <button class="text-gray-400 hover:text-white" @click="selectedCampaign = null">
            <UIcon name="i-heroicons-x-mark" class="h-5 w-5" />
          </button>
        </div>

        <div class="space-y-4">
          <div>
            <h3 class="text-xl font-bold text-white">{{ selectedCampaign.title }}</h3>
            <p class="text-xs text-gray-400 mt-1">{{ selectedCampaign.description }}</p>
          </div>

          <div v-if="selectedCampaign.imageUrl"
            class="relative h-48 w-full overflow-hidden rounded-xl border border-gray-800 bg-gray-950">
            <img :src="selectedCampaign.imageUrl" :alt="selectedCampaign.title" class="h-full w-full object-cover" />
          </div>

          <div v-if="selectedCampaign.adUnitCode" class="space-y-1">
            <label class="block text-xs font-semibold text-gray-300">Custom Ad Script / Tag Snippet</label>
            <pre
              class="w-full rounded-lg border border-gray-800 bg-gray-950 p-3 font-mono text-xs text-gray-300 overflow-x-auto">{{ selectedCampaign.adUnitCode }}</pre>
          </div>
        </div>

        <div class="flex items-center justify-end gap-3 border-t border-gray-800 pt-4">
          <button
            class="rounded-lg border border-gray-700 bg-gray-800 px-4 py-2 text-xs font-semibold text-gray-300 hover:bg-gray-700 transition"
            @click="selectedCampaign = null">
            Close
          </button>
          <button
            class="rounded-lg bg-emerald-600 px-5 py-2 text-xs font-semibold text-white hover:bg-emerald-500 transition"
            @click="updateCampaignStatus(selectedCampaign.id, 'PUBLIC')">
            Approve & Publish Live
          </button>
        </div>
      </div>
    </div>
  </div>
</template>
