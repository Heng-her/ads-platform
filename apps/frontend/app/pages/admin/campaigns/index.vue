<script setup lang="ts">
import { computed, onMounted, ref, watch } from 'vue'
import { useCampaigns, type AdminCampaignUser, type CampaignData } from '~/composables/useCampaigns'
import { getArticleUrl } from '~/lib/utils'

definePageMeta({ layout: 'admin' })

const { isLoading, fetchAdminCampaignUsers, fetchAdminUserCampaigns, updateCampaignStatus, deleteCampaign } = useCampaigns()
const users = ref<AdminCampaignUser[]>([])
const searchQuery = ref('')
const currentPage = ref(1)
const totalUsers = ref(0)
const totalPages = ref(1)
const expandedUserIds = ref<Set<string>>(new Set())
const campaignPages = ref<Record<string, { items: CampaignData[]; page: number; totalPages: number }>>({})
const loadingCampaignUserIds = ref<Set<string>>(new Set())
const updatingStatusIds = ref<Set<string>>(new Set())
const deletingCampaignIds = ref<Set<string>>(new Set())

const userLabel = computed(() => `${totalUsers.value} ${totalUsers.value === 1 ? 'user' : 'users'}`)

async function loadData() {
  const data = await fetchAdminCampaignUsers({
    page: currentPage.value,
    search: searchQuery.value || undefined,
  })
  users.value = data.items
  totalUsers.value = data.total
  totalPages.value = data.totalPages
}

function campaignsFor(userId: string) {
  return campaignPages.value[userId]?.items ?? []
}

function campaignPageFor(userId: string) {
  return campaignPages.value[userId]
}

async function loadUserCampaigns(userId: string, page = 1) {
  loadingCampaignUserIds.value = new Set(loadingCampaignUserIds.value).add(userId)
  try {
    const data = await fetchAdminUserCampaigns(userId, page)
    campaignPages.value = { ...campaignPages.value, [userId]: { items: data.items, page, totalPages: data.totalPages } }
  } finally {
    const next = new Set(loadingCampaignUserIds.value)
    next.delete(userId)
    loadingCampaignUserIds.value = next
  }
}

async function toggleUser(userId: string) {
  const next = new Set(expandedUserIds.value)
  if (next.has(userId)) {
    next.delete(userId)
  } else {
    next.add(userId)
    if (!campaignPages.value[userId]) await loadUserCampaigns(userId)
  }
  expandedUserIds.value = next
}

async function handleStatusToggle(campaign: CampaignData, status: 'DRAFT' | 'PUBLIC') {
  if (updatingStatusIds.value.has(campaign.id)) return

  updatingStatusIds.value = new Set(updatingStatusIds.value).add(campaign.id)
  try {
    await updateCampaignStatus(campaign.id, status)
    campaign.status = status
  } catch (err: any) {
    alert(err.message || 'Failed to update campaign status')
  } finally {
    const next = new Set(updatingStatusIds.value)
    next.delete(campaign.id)
    updatingStatusIds.value = next
  }
}

async function removeCampaign(user: AdminCampaignUser, campaign: CampaignData) {
  if (!confirm(`Delete “${campaign.title}”? This can only be restored from the database.`)) return
  deletingCampaignIds.value = new Set(deletingCampaignIds.value).add(campaign.id)
  try {
    await deleteCampaign(campaign.id)
    const userCampaignPage = campaignPages.value[user.id]
    if (userCampaignPage) {
      campaignPages.value = { ...campaignPages.value, [user.id]: { ...userCampaignPage, items: userCampaignPage.items.filter((item) => item.id !== campaign.id) } }
    }
    user.publicPosts = user.publicPosts.filter((item) => item.id !== campaign.id)
  } catch (err: any) {
    alert(err.message || 'Failed to delete campaign')
  } finally {
    const next = new Set(deletingCampaignIds.value)
    next.delete(campaign.id)
    deletingCampaignIds.value = next
  }
}

watch(searchQuery, () => {
  currentPage.value = 1
  expandedUserIds.value = new Set()
  campaignPages.value = {}
  loadData()
})

onMounted(loadData)
</script>

<template>
  <div class="space-y-6">
    <div class="flex flex-col gap-4 border-b border-gray-200 pb-4 sm:flex-row sm:items-center sm:justify-between dark:border-gray-800">
      <div>
        <p class="text-xs font-semibold uppercase tracking-wider text-primary-600 dark:text-primary-400">Campaign oversight</p>
        <h1 class="mt-1 text-xl font-bold text-gray-900 dark:text-gray-100">Users &amp; published posts</h1>
        <p class="mt-1 text-sm text-gray-500 dark:text-gray-400">Review every user, their three latest public posts, and their complete campaign history.</p>
      </div>
      <UButton to="/creator/campaigns/create" color="primary" icon="i-heroicons-plus" size="sm">New Campaign</UButton>
    </div>

    <div class="flex flex-col gap-3 rounded-xl border border-gray-200 bg-white p-3 sm:flex-row sm:items-center sm:justify-between dark:border-gray-800 dark:bg-gray-900">
      <UInput v-model="searchQuery" icon="i-heroicons-magnifying-glass" placeholder="Search users by name or email..." size="sm" class="w-full sm:max-w-md" />
      <span class="text-xs font-medium text-gray-500 dark:text-gray-400">{{ userLabel }}</span>
    </div>

    <div v-if="isLoading && !users.length" class="py-16 text-center text-sm text-gray-500">
      <UIcon name="i-heroicons-arrow-path" class="mx-auto mb-2 h-6 w-6 animate-spin" />
      Loading users and campaigns...
    </div>

    <div v-else-if="!users.length" class="rounded-xl border border-dashed border-gray-300 py-16 text-center dark:border-gray-700">
      <UIcon name="i-heroicons-users" class="mx-auto mb-3 h-10 w-10 text-gray-400" />
      <h2 class="font-semibold text-gray-900 dark:text-gray-100">No users found</h2>
      <p class="mt-1 text-sm text-gray-500">Try a different name or email address.</p>
    </div>

    <div v-else class="space-y-4">
      <article v-for="user in users" :key="user.id" class="overflow-hidden rounded-xl border border-gray-200 bg-white dark:border-gray-800 dark:bg-gray-900">
        <header class="flex flex-col gap-4 p-4 sm:flex-row sm:items-center sm:justify-between">
          <div class="flex min-w-0 items-center gap-3">
            <img v-if="user.avatar" :src="user.avatar" :alt="user.username" class="h-11 w-11 rounded-full object-cover" />
            <div v-else class="flex h-11 w-11 items-center justify-center rounded-full bg-primary-100 font-semibold text-primary-700 dark:bg-primary-950 dark:text-primary-300">{{ user.username.charAt(0).toUpperCase() }}</div>
            <div class="min-w-0">
              <div class="flex flex-wrap items-center gap-2">
                <h2 class="truncate font-semibold text-gray-900 dark:text-gray-100">{{ user.username }}</h2>
                <UBadge :color="user.status === 'ACTIVE' ? 'success' : 'warning'" variant="soft" size="xs">{{ user.status }}</UBadge>
              </div>
              <p class="truncate text-xs text-gray-500 dark:text-gray-400">{{ user.email }} · Campaigns load on demand</p>
            </div>
          </div>
          <UButton color="neutral" variant="outline" size="sm" :icon="expandedUserIds.has(user.id) ? 'i-heroicons-chevron-up' : 'i-heroicons-chevron-down'" @click="toggleUser(user.id)">
            {{ expandedUserIds.has(user.id) ? 'Hide campaigns' : 'View campaigns' }}
          </UButton>
        </header>

        <section class="border-t border-gray-100 bg-gray-50/70 p-4 dark:border-gray-800 dark:bg-gray-950/30">
          <div class="mb-3 flex items-center justify-between">
            <h3 class="text-xs font-semibold uppercase tracking-wider text-gray-500">Latest public posts</h3>
            <span class="text-xs text-gray-400">Newest first · up to 3</span>
          </div>
          <div v-if="user.publicPosts.length" class="grid gap-3 md:grid-cols-3">
            <NuxtLink v-for="post in user.publicPosts" :key="post.id" :to="getArticleUrl(post)" target="_blank" class="group overflow-hidden rounded-lg border border-gray-200 bg-white transition hover:border-primary-300 hover:shadow-sm dark:border-gray-800 dark:bg-gray-900">
              <img v-if="post.imageUrl" :src="post.imageUrl" :alt="post.imageTitle || post.title" class="h-28 w-full object-cover" />
              <div v-else class="flex h-28 items-center justify-center bg-gray-100 text-gray-400 dark:bg-gray-800"><UIcon name="i-heroicons-photo" class="h-6 w-6" /></div>
              <div class="p-3">
                <p class="line-clamp-1 text-sm font-semibold text-gray-900 group-hover:text-primary-600 dark:text-gray-100">{{ post.title }}</p>
                <p class="mt-1 text-xs text-gray-500">{{ post.category || 'General' }} · {{ new Date(post.createdAt).toLocaleDateString() }}</p>
              </div>
            </NuxtLink>
          </div>
          <p v-else class="rounded-lg border border-dashed border-gray-200 bg-white px-3 py-2 text-center text-sm text-gray-500 dark:border-gray-800 dark:bg-gray-900">This user has no public posts yet.</p>
        </section>

        <section v-if="expandedUserIds.has(user.id)" class="border-t border-gray-200 dark:border-gray-800">
          <div class="no-scrollbar overflow-x-auto">
            <table class="w-full min-w-[720px] text-left text-xs">
              <thead class="bg-gray-50 text-gray-500 dark:bg-gray-950 dark:text-gray-400"><tr><th class="px-4 py-3">Campaign</th><th class="px-4 py-3">Category</th><th class="px-4 py-3">Created</th><th class="px-4 py-3">Visibility</th><th class="px-4 py-3 text-right">Actions</th></tr></thead>
              <tbody class="divide-y divide-gray-100 dark:divide-gray-800">
                <tr v-for="campaign in campaignsFor(user.id)" :key="campaign.id" class="hover:bg-gray-50 dark:hover:bg-gray-800/40">
                  <td class="px-4 py-3"><div class="flex items-center gap-3"><img v-if="campaign.imageUrl" :src="campaign.imageUrl" alt="" class="h-9 w-9 rounded object-cover" /><div v-else class="h-9 w-9 rounded bg-gray-100 dark:bg-gray-800" /><span class="max-w-64 truncate font-medium text-gray-900 dark:text-gray-100">{{ campaign.title }}</span></div></td>
                  <td class="px-4 py-3 text-gray-500">{{ campaign.category || 'General' }}</td>
                  <td class="px-4 py-3 text-gray-500">{{ new Date(campaign.createdAt).toLocaleDateString() }}</td>
                  <td class="px-4 py-3"><CampaignStatusToggle :title="campaign.title" :status="campaign.status" :disabled="updatingStatusIds.has(campaign.id)" size="xs" @change="handleStatusToggle(campaign, $event)" /></td>
                  <td class="px-4 py-3"><CampaignRowActions :article-url="getArticleUrl(campaign)" :edit-url="`/creator/campaigns/${campaign.id}/edit`" :deleting="deletingCampaignIds.has(campaign.id)" @delete="removeCampaign(user, campaign)" /></td>
                </tr>
                <tr v-if="loadingCampaignUserIds.has(user.id)"><td colspan="5" class="px-4 py-8 text-center text-sm text-gray-500">Loading campaigns...</td></tr>
                <tr v-else-if="!campaignsFor(user.id).length"><td colspan="5" class="px-4 py-8 text-center text-sm text-gray-500">No campaigns created by this user.</td></tr>
              </tbody>
            </table>
          </div>
          <div v-if="campaignPageFor(user.id) && campaignPageFor(user.id)!.totalPages > 1" class="flex items-center justify-between border-t border-gray-100 px-4 py-3 text-xs dark:border-gray-800">
            <span class="text-gray-500">Campaign page {{ campaignPageFor(user.id)!.page }} of {{ campaignPageFor(user.id)!.totalPages }}</span>
            <div class="flex gap-2">
              <UButton color="neutral" variant="outline" size="xs" :disabled="campaignPageFor(user.id)!.page === 1" @click="loadUserCampaigns(user.id, campaignPageFor(user.id)!.page - 1)">Previous</UButton>
              <UButton color="neutral" variant="outline" size="xs" :disabled="campaignPageFor(user.id)!.page === campaignPageFor(user.id)!.totalPages" @click="loadUserCampaigns(user.id, campaignPageFor(user.id)!.page + 1)">Next</UButton>
            </div>
          </div>
        </section>
      </article>

      <div v-if="totalPages > 1" class="flex items-center justify-between">
        <span class="text-xs text-gray-500">Page {{ currentPage }} of {{ totalPages }}</span>
        <div class="flex gap-2">
          <UButton color="neutral" variant="outline" size="xs" :disabled="currentPage === 1" @click="currentPage--; loadData()">Previous</UButton>
          <UButton color="neutral" variant="outline" size="xs" :disabled="currentPage === totalPages" @click="currentPage++; loadData()">Next</UButton>
        </div>
      </div>
    </div>
  </div>
</template>
