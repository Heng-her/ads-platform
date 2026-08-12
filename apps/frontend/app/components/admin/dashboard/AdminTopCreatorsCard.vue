<script setup lang="ts">
export interface TopCreatorItem {
  id: string
  username: string
  avatar: string | null
  campaignCount: number
}

defineProps<{
  topCreators: TopCreatorItem[]
}>()
</script>

<template>
  <div class="rounded-xl border border-gray-800 bg-gray-900 p-6 shadow-sm">
    <div class="flex items-center justify-between border-b border-gray-800 pb-4">
      <div class="flex items-center gap-2">
        <UIcon name="i-heroicons-trophy" class="h-5 w-5 text-amber-400" />
        <h2 class="text-lg font-semibold text-white">Top Creator Spotlight</h2>
      </div>
    </div>

    <div v-if="topCreators.length === 0" class="py-8 text-center text-sm text-gray-500">
      No creators recorded yet.
    </div>

    <div v-else class="mt-4 divide-y divide-gray-800/60">
      <div v-for="creator in topCreators" :key="creator.id" class="flex items-center justify-between py-3">
        <div class="flex items-center gap-3 min-w-0">
          <div class="relative h-10 w-10 shrink-0 overflow-hidden rounded-full border border-gray-700 bg-gray-800">
            <img v-if="creator.avatar" :src="creator.avatar" :alt="creator.username" class="h-full w-full object-cover" />
            <div v-else class="flex h-full w-full items-center justify-center text-gray-400">
              <UIcon name="i-heroicons-user" class="h-5 w-5" />
            </div>
          </div>
          <div class="truncate">
            <p class="truncate text-sm font-semibold text-white">{{ creator.username }}</p>
            <p class="text-xs text-gray-500 font-mono">ID: {{ creator.id.substring(0, 8) }}...</p>
          </div>
        </div>

        <UBadge color="primary" variant="soft" size="xs" class="shrink-0 font-semibold">
          {{ creator.campaignCount }} Campaigns
        </UBadge>
      </div>
    </div>
  </div>
</template>
