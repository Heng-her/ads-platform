<script setup lang="ts">
import type { CampaignData } from '~/composables/useCampaigns'
import CampaignStatusToggle from '~/components/CampaignStatusToggle.vue'
import CampaignRowActions from '~/components/CampaignRowActions.vue'
import { getArticleUrl } from '~/lib/utils'

defineProps<{
  campaigns: CampaignData[]
  campaignPageInfo?: { items: CampaignData[]; page: number; totalPages: number }
  isLoading: boolean
  updatingStatusIds: Set<string>
  deletingCampaignIds: Set<string>
}>()

const emit = defineEmits<{
  (e: 'toggle-status', campaign: CampaignData, status: 'DRAFT' | 'PUBLIC'): void
  (e: 'delete', campaign: CampaignData): void
  (e: 'change-page', page: number): void
}>()
</script>

<template>
  <div class="border-t border-gray-200 dark:border-gray-800">
    <div class="no-scrollbar overflow-x-auto">
      <table class="w-full min-w-[720px] text-left text-xs">
        <thead class="bg-gray-50 text-gray-500 dark:bg-gray-950 dark:text-gray-400">
          <tr>
            <th class="px-4 py-3">Campaign</th>
            <th class="px-4 py-3">Category</th>
            <th class="px-4 py-3">Created</th>
            <th class="px-4 py-3">Visibility</th>
            <th class="px-4 py-3 text-right">Actions</th>
          </tr>
        </thead>
        <tbody class="divide-y divide-gray-100 dark:divide-gray-800">
          <tr v-for="campaign in campaigns" :key="campaign.id"
            class="hover:bg-gray-50 dark:hover:bg-gray-800/40">
            <td class="px-4 py-3">
              <div class="flex items-center gap-3">
                <img v-if="campaign.imageUrl" :src="campaign.imageUrl" alt=""
                  class="h-9 w-9 rounded object-cover" />
                <div v-else class="h-9 w-9 rounded bg-gray-100 dark:bg-gray-800" />
                <span class="max-w-64 truncate font-medium text-gray-900 dark:text-gray-100">{{ campaign.title
                }}</span>
              </div>
            </td>
            <td class="px-4 py-3 text-gray-500">{{ campaign.category || 'General' }}</td>
            <td class="px-4 py-3 text-gray-500">{{ new Date(campaign.createdAt).toLocaleDateString() }}</td>
            <td class="px-4 py-3">
              <CampaignStatusToggle :title="campaign.title" :status="campaign.status"
                :disabled="updatingStatusIds.has(campaign.id)" size="xs"
                @change="emit('toggle-status', campaign, $event)" />
            </td>
            <td class="px-4 py-3">
              <CampaignRowActions :article-url="getArticleUrl(campaign)"
                :edit-url="`/creator/campaigns/${campaign.id}/edit`"
                :deleting="deletingCampaignIds.has(campaign.id)" @delete="emit('delete', campaign)" />
            </td>
          </tr>
          <tr v-if="isLoading">
            <td colspan="5" class="px-4 py-8 text-center text-sm text-gray-500">Loading campaigns...</td>
          </tr>
          <tr v-else-if="!campaigns.length">
            <td colspan="5" class="px-4 py-8 text-center text-sm text-gray-500">No campaigns created by this user.
            </td>
          </tr>
        </tbody>
      </table>
    </div>
    <div v-if="campaignPageInfo && campaignPageInfo.totalPages > 1"
      class="flex items-center justify-between border-t border-gray-100 px-4 py-3 text-xs dark:border-gray-800">
      <span class="text-gray-500">Campaign page {{ campaignPageInfo.page }} of {{
        campaignPageInfo.totalPages }}</span>
      <div class="flex gap-2">
        <UButton color="neutral" variant="outline" size="xs" :disabled="campaignPageInfo.page === 1"
          @click="emit('change-page', campaignPageInfo.page - 1)">Previous</UButton>
        <UButton color="neutral" variant="outline" size="xs"
          :disabled="campaignPageInfo.page === campaignPageInfo.totalPages"
          @click="emit('change-page', campaignPageInfo.page + 1)">Next</UButton>
      </div>
    </div>
  </div>
</template>
