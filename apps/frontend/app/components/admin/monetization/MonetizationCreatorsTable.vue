<script setup lang="ts">
export interface CreatorAccount {
  id: string
  username: string
  email: string
  avatar: string | null
  role: string
  status: string
  ecpmRate?: number
}

const props = defineProps<{
  creators: CreatorAccount[]
  isLoading: boolean
  isUpdatingEcpm: boolean
  editingCreatorId: string | null
  globalDefaultEcpm: number
  averageCpm: number
  creatorRevenueSharePercent: number
  monetizationEngine: 'DYNAMIC_AD_NETWORKS' | 'FIXED_ECPM'
}>()

const tempEcpmRate = defineModel<number>('tempEcpmRate', { default: 2.50 })

const emit = defineEmits<{
  (e: 'set-all-auto'): void
  (e: 'refresh'): void
  (e: 'toggle-model', creator: CreatorAccount): void
  (e: 'start-edit', creator: CreatorAccount): void
  (e: 'cancel-edit'): void
  (e: 'save-ecpm', creatorId: string): void
}>()
</script>

<template>
  <div class="rounded-xl border border-gray-800 bg-gray-900 p-6 shadow-sm space-y-4">
    <div class="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
      <div>
        <h2 class="text-lg font-semibold text-white flex items-center gap-2">
          <UIcon name="i-heroicons-users" class="h-5 w-5 text-primary-400" />
          Creator Account Monetization Status
        </h2>
        <p class="text-sm text-gray-400">
          Manage monetization payout models (Auto AdSense & Adsterra API Share vs Custom eCPM rates) per creator.
        </p>
      </div>

      <div class="flex items-center gap-2">
        <button
          class="inline-flex items-center gap-1.5 rounded-lg border border-emerald-500/30 bg-emerald-500/10 px-3 py-1.5 text-xs font-semibold text-emerald-400 hover:bg-emerald-500/20 transition"
          @click="emit('set-all-auto')"
        >
          <UIcon name="i-heroicons-bolt" class="h-3.5 w-3.5 text-emerald-400" />
          <span>Set All to Auto AdSense & Adsterra</span>
        </button>

        <button
          :disabled="isLoading"
          class="inline-flex items-center gap-2 rounded-lg border border-gray-700 bg-gray-800 px-3 py-1.5 text-xs font-semibold text-gray-300 hover:bg-gray-700 disabled:opacity-50"
          @click="emit('refresh')"
        >
          <UIcon v-if="isLoading" name="i-heroicons-arrow-path" class="h-3.5 w-3.5 animate-spin" />
          <UIcon v-else name="i-heroicons-arrow-path" class="h-3.5 w-3.5 text-gray-400" />
          <span>Refresh</span>
        </button>
      </div>
    </div>

    <div v-if="isLoading" class="py-12 text-center text-sm text-gray-400">
      <UIcon name="i-heroicons-arrow-path" class="h-6 w-6 animate-spin mx-auto text-primary-500 mb-2" />
      Loading creator accounts...
    </div>

    <div v-else-if="creators.length === 0" class="py-12 text-center text-sm text-gray-500">
      No creators found in system.
    </div>

    <div v-else class="overflow-x-auto">
      <table class="w-full text-left text-sm text-gray-300">
        <thead class="bg-gray-950/60 text-xs uppercase tracking-wider text-gray-400 border-b border-gray-800">
          <tr>
            <th class="px-4 py-3 font-semibold">Creator</th>
            <th class="px-4 py-3 font-semibold">Email</th>
            <th class="px-4 py-3 font-semibold">Monetization Source</th>
            <th class="px-4 py-3 font-semibold">Effective Yield / Rate</th>
            <th class="px-4 py-3 font-semibold text-right">Actions</th>
          </tr>
        </thead>
        <tbody class="divide-y divide-gray-800/60">
          <tr v-for="creator in creators" :key="creator.id" class="hover:bg-gray-800/30">
            <td class="px-4 py-3">
              <div class="flex items-center gap-3">
                <div
                  class="h-8 w-8 rounded-full bg-primary-500/20 text-primary-400 flex items-center justify-center font-bold text-xs shrink-0 overflow-hidden"
                >
                  <img v-if="creator.avatar" :src="creator.avatar" class="h-full w-full object-cover" />
                  <span v-else>{{ creator.username?.charAt(0).toUpperCase() || 'C' }}</span>
                </div>
                <div>
                  <p class="font-semibold text-white text-sm">{{ creator.username }}</p>
                  <p class="text-[11px] text-gray-500">ID: {{ creator.id }}</p>
                </div>
              </div>
            </td>
            <td class="px-4 py-3 text-xs text-gray-400">{{ creator.email }}</td>

            <!-- Monetization Source Badge -->
            <td class="px-4 py-3">
              <UBadge
                v-if="creator.ecpmRate === undefined || monetizationEngine === 'DYNAMIC_AD_NETWORKS'"
                color="success"
                variant="soft"
                size="xs"
                class="font-semibold gap-1"
              >
                <UIcon name="i-heroicons-bolt" class="w-3.5 h-3.5 text-emerald-400" />
                <span>Auto: AdSense + Adsterra</span>
              </UBadge>
              <UBadge v-else color="warning" variant="soft" size="xs" class="font-semibold gap-1">
                <UIcon name="i-heroicons-tag" class="w-3.5 h-3.5 text-amber-400" />
                <span>Custom Override</span>
              </UBadge>
            </td>

            <!-- Effective Rate / Yield -->
            <td class="px-4 py-3 font-semibold">
              <div v-if="editingCreatorId === creator.id" class="flex items-center gap-2">
                <span class="text-xs text-gray-400">$</span>
                <input
                  v-model.number="tempEcpmRate"
                  type="number"
                  step="0.25"
                  min="0"
                  class="w-24 rounded border border-primary-500 bg-gray-800 px-2 py-1 text-xs text-white focus:outline-none"
                />
                <span class="text-[11px] text-gray-400">/ 1k views</span>
              </div>

              <div
                v-else-if="creator.ecpmRate === undefined || monetizationEngine === 'DYNAMIC_AD_NETWORKS'"
                class="flex items-center gap-1.5 text-emerald-400 font-bold"
              >
                <span>${{ (averageCpm * (creatorRevenueSharePercent / 100)).toFixed(2) }}</span>
                <span class="text-[11px] font-normal text-gray-400">/ 1k views ({{ creatorRevenueSharePercent }}% Share)</span>
              </div>

              <div v-else class="flex items-center gap-1.5 text-amber-400 font-bold">
                <span>${{ (creator.ecpmRate ?? globalDefaultEcpm).toFixed(2) }}</span>
                <span class="text-[11px] font-normal text-gray-400">/ 1k views</span>
              </div>
            </td>

            <!-- Action Controls -->
            <td class="px-4 py-3 text-right">
              <div v-if="editingCreatorId === creator.id" class="flex items-center justify-end gap-2">
                <button
                  :disabled="isUpdatingEcpm"
                  class="inline-flex items-center gap-1 rounded bg-primary-600 px-2.5 py-1 text-xs font-semibold text-white hover:bg-primary-500 disabled:opacity-50"
                  @click="emit('save-ecpm', creator.id)"
                >
                  <UIcon v-if="isUpdatingEcpm" name="i-heroicons-arrow-path" class="h-3 w-3 animate-spin" />
                  <span>Save</span>
                </button>
                <button
                  class="rounded border border-gray-700 px-2.5 py-1 text-xs font-medium text-gray-400 hover:bg-gray-800"
                  @click="emit('cancel-edit')"
                >
                  Cancel
                </button>
              </div>

              <div v-else class="flex items-center justify-end gap-2">
                <button
                  class="inline-flex items-center gap-1 rounded border border-gray-700 bg-gray-800 px-2.5 py-1 text-xs font-medium text-gray-300 hover:bg-gray-700"
                  @click="emit('toggle-model', creator)"
                >
                  <UIcon v-if="creator.ecpmRate !== undefined" name="i-heroicons-bolt" class="h-3.5 w-3.5 text-emerald-400" />
                  <UIcon v-else name="i-heroicons-tag" class="h-3.5 w-3.5 text-amber-400" />
                  <span>{{ creator.ecpmRate !== undefined ? 'Switch to Auto' : 'Set Custom Rate' }}</span>
                </button>

                <button
                  v-if="creator.ecpmRate !== undefined"
                  class="inline-flex items-center gap-1 rounded border border-gray-700 bg-gray-800 px-2 py-1 text-xs font-medium text-primary-400 hover:bg-gray-700"
                  @click="emit('start-edit', creator)"
                >
                  <UIcon name="i-heroicons-pencil-square" class="h-3.5 w-3.5" />
                </button>
              </div>
            </td>
          </tr>
        </tbody>
      </table>
    </div>
  </div>
</template>
