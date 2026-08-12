<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { useApi } from '~/composables/useApi'
import { useAppToast } from '~/composables/useAppToast'
import AdminDashboardHeader from '~/components/admin/dashboard/AdminDashboardHeader.vue'
import AdminDashboardMetrics, { type AdminDashboardStats } from '~/components/admin/dashboard/AdminDashboardMetrics.vue'
import AdminTopCampaignsCard from '~/components/admin/dashboard/AdminTopCampaignsCard.vue'
import AdminCategoryDistributionCard from '~/components/admin/dashboard/AdminCategoryDistributionCard.vue'
import AdminTopCreatorsCard from '~/components/admin/dashboard/AdminTopCreatorsCard.vue'
import AdminShortcutsCard from '~/components/admin/dashboard/AdminShortcutsCard.vue'

definePageMeta({
  layout: 'admin'
})

const api = useApi()
const toast = useAppToast()

const isLoading = ref(true)
const stats = ref<AdminDashboardStats | null>(null)

async function fetchAdminStats() {
  isLoading.value = true
  try {
    const res = await api.dashboard.admin.stats.$get()
    const data = await res.json()
    if (res.ok && data.code === 1) {
      stats.value = data.data
    } else {
      toast.error('Failed to load stats', data.msg || 'Error fetching admin dashboard stats')
    }
  } catch (err: any) {
    toast.error('Network Error', err.message || 'Could not connect to API server')
  } finally {
    isLoading.value = false
  }
}

onMounted(() => {
  fetchAdminStats()
})
</script>

<template>
  <div class="mx-auto max-w-8xl space-y-8 pb-12 text-gray-100">
    <!-- Header & Action Bar -->
    <AdminDashboardHeader :is-loading="isLoading" @refresh="fetchAdminStats" />

    <!-- Metric Cards Grid & Skeleton Loader -->
    <AdminDashboardMetrics :is-loading="isLoading" :stats="stats" />

    <!-- Main Content Insights Layout -->
    <div v-if="stats" class="grid gap-8 lg:grid-cols-3">
      <!-- Left Column (2 Cols): Top Campaigns & Category Breakdown -->
      <div class="space-y-8 lg:col-span-2">
        <AdminTopCampaignsCard :top-campaigns="stats.topCampaigns" />
        <AdminCategoryDistributionCard
          :campaigns-by-category="stats.campaignsByCategory"
          :total-campaigns="stats.campaigns.total"
        />
      </div>

      <!-- Right Column (1 Col): Top Creators & Quick Command Center -->
      <div class="space-y-8 lg:col-span-1">
        <AdminTopCreatorsCard :top-creators="stats.topCreators" />
        <AdminShortcutsCard />
      </div>
    </div>
  </div>
</template>
