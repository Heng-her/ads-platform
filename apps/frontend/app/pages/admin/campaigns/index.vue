<script setup lang="ts">
import { computed, onMounted, ref, watch } from 'vue'
import { useCampaigns, type AdminCampaignUser } from '~/composables/useCampaigns'

import AdminCampaignsHeader from '~/components/admin/campaigns/AdminCampaignsHeader.vue'
import AdminCampaignsSearchFilter from '~/components/admin/campaigns/AdminCampaignsSearchFilter.vue'
import AdminCampaignUserCard from '~/components/admin/campaigns/AdminCampaignUserCard.vue'

definePageMeta({ layout: 'admin' })

const { isLoading, fetchAdminCampaignUsers } = useCampaigns()
const users = ref<AdminCampaignUser[]>([])
const searchQuery = ref('')
const currentPage = ref(1)
const totalUsers = ref(0)
const totalPages = ref(1)

const userLabel = computed(() => `${totalUsers.value} ${totalUsers.value === 1 ? 'user' : 'users'}`)

async function loadData() {
  const data = await fetchAdminCampaignUsers({
    page: currentPage.value,
    limit: 4,
    search: searchQuery.value || undefined,
  })
  users.value = data.items
  totalUsers.value = data.total
  totalPages.value = data.totalPages
}

watch(searchQuery, () => {
  currentPage.value = 1
  loadData()
})

onMounted(loadData)
</script>

<template>
  <div class="space-y-6">
    <!-- Header -->
    <AdminCampaignsHeader />

    <!-- Search & Total Users Filter Bar -->
    <AdminCampaignsSearchFilter
      v-model="searchQuery"
      :user-label="userLabel"
    />

    <!-- Loading State -->
    <div v-if="isLoading && !users.length" class="py-16 text-center text-sm text-gray-500">
      <UIcon name="i-heroicons-arrow-path" class="mx-auto mb-2 h-6 w-6 animate-spin text-primary-400" />
      Loading users list...
    </div>

    <!-- Empty State -->
    <div v-else-if="!users.length"
      class="rounded-xl border border-dashed border-gray-300 py-16 text-center dark:border-gray-700">
      <UIcon name="i-heroicons-users" class="mx-auto mb-3 h-10 w-10 text-gray-400" />
      <h2 class="font-semibold text-gray-900 dark:text-gray-100">No users found</h2>
      <p class="mt-1 text-sm text-gray-500">Try a different name or email address.</p>
    </div>

    <!-- Users Cards List: 2 Cols x 2 Rows (4 Cards per Page) -->
    <div v-else class="grid gap-4 md:grid-cols-2">
      <AdminCampaignUserCard
        v-for="user in users"
        :key="user.id"
        :user="user"
      />
    </div>

    <!-- Pagination -->
    <div v-if="totalPages > 1" class="flex items-center justify-between pt-2">
      <span class="text-xs text-gray-500">Page {{ currentPage }} of {{ totalPages }}</span>
      <div class="flex gap-2">
        <UButton color="neutral" variant="outline" size="xs" :disabled="currentPage === 1"
          @click="currentPage--; loadData()">Previous</UButton>
        <UButton color="neutral" variant="outline" size="xs" :disabled="currentPage === totalPages"
          @click="currentPage++; loadData()">Next</UButton>
      </div>
    </div>
  </div>
</template>
