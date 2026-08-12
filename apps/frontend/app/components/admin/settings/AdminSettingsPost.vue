<script setup lang="ts">
export interface PostConfig {
  maxPostPerDay: number
  maxUploadImage: number
  maxUploadVideo: number
}

const config = defineModel<PostConfig>({ required: true })
</script>

<template>
  <div class="space-y-6">
    <div class="rounded-xl border border-gray-800 bg-gray-900 p-6 shadow-sm">
      <div class="flex items-center justify-between border-b border-gray-800 pb-4">
        <div>
          <h2 class="text-lg font-semibold text-white">Post & Campaign Limits</h2>
          <p class="mt-1 text-sm text-gray-400">
            Configure global publishing limits per IP address and attachment boundaries for campaign posts.
          </p>
        </div>
        <span class="inline-flex items-center gap-1.5 rounded-full bg-primary-950/60 px-3 py-1 text-xs font-medium text-primary-400 border border-primary-800/40">
          <UIcon name="i-heroicons-shield-check" class="h-3.5 w-3.5" />
          Active Policy
        </span>
      </div>

      <div class="mt-6 grid gap-6 md:grid-cols-3">
        <!-- Max Posts Per Day -->
        <div class="space-y-2 rounded-lg border border-gray-800 bg-gray-900/60 p-4 transition hover:border-gray-700">
          <div class="flex items-center justify-between">
            <label class="block text-xs font-semibold uppercase tracking-wider text-gray-300">
              Max Posts Per Day / IP
            </label>
            <UIcon name="i-heroicons-paper-airplane" class="h-4 w-4 text-primary-400" />
          </div>
          <p class="text-xs text-gray-400">
            Maximum number of campaign posts allowed per 24 hours from a single IP address.
          </p>
          <div class="relative pt-1">
            <input
              v-model.number="config.maxPostPerDay"
              type="number"
              min="1"
              max="100"
              class="w-full rounded-lg border border-gray-700 bg-gray-800 px-3.5 py-2 text-sm text-white focus:border-primary-500 focus:outline-none focus:ring-2 focus:ring-primary-500/20"
            />
            <div class="mt-1.5 text-right text-[11px] text-gray-500">Default: 5 posts/day</div>
          </div>
        </div>

        <!-- Max Upload Images -->
        <div class="space-y-2 rounded-lg border border-gray-800 bg-gray-900/60 p-4 transition hover:border-gray-700">
          <div class="flex items-center justify-between">
            <label class="block text-xs font-semibold uppercase tracking-wider text-gray-300">
              Max Upload Images
            </label>
            <UIcon name="i-heroicons-photo" class="h-4 w-4 text-emerald-400" />
          </div>
          <p class="text-xs text-gray-400">
            Maximum gallery / attachment images allowed per single campaign post.
          </p>
          <div class="relative pt-1">
            <input
              v-model.number="config.maxUploadImage"
              type="number"
              min="1"
              max="50"
              class="w-full rounded-lg border border-gray-700 bg-gray-800 px-3.5 py-2 text-sm text-white focus:border-primary-500 focus:outline-none focus:ring-2 focus:ring-primary-500/20"
            />
            <div class="mt-1.5 text-right text-[11px] text-gray-500">Default: 10 images/post</div>
          </div>
        </div>

        <!-- Max Upload Videos -->
        <div class="space-y-2 rounded-lg border border-gray-800 bg-gray-900/60 p-4 transition hover:border-gray-700">
          <div class="flex items-center justify-between">
            <label class="block text-xs font-semibold uppercase tracking-wider text-gray-300">
              Max Upload Videos
            </label>
            <UIcon name="i-heroicons-video-camera" class="h-4 w-4 text-amber-400" />
          </div>
          <p class="text-xs text-gray-400">
            Maximum video URLs / file uploads allowed per campaign for non-admin creators.
          </p>
          <div class="relative pt-1">
            <input
              v-model.number="config.maxUploadVideo"
              type="number"
              min="0"
              max="20"
              class="w-full rounded-lg border border-gray-700 bg-gray-800 px-3.5 py-2 text-sm text-white focus:border-primary-500 focus:outline-none focus:ring-2 focus:ring-primary-500/20"
            />
            <div class="mt-1.5 text-right text-[11px] text-gray-500">Default: 2 videos/post</div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>
