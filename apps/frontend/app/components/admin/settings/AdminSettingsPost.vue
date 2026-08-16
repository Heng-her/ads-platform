<script setup lang="ts">
import AdminSettingInput from './AdminSettingInput.vue'

export interface PostConfig {
  maxPostPerDay: number
  maxUploadImage: number
  maxUploadVideo: number
  maxRegisterPerDay: number
}

const config = defineModel<PostConfig>({ required: true })
</script>

<template>
  <div class="space-y-6">
    <div class="rounded-xl border border-gray-800 bg-gray-900 p-6 shadow-sm">
      <div class="flex items-center justify-between border-b border-gray-800 pb-4">
        <div>
          <h2 class="text-lg font-semibold text-white">Post &amp; Registration Limits</h2>
          <p class="mt-1 text-sm text-gray-400">
            Configure global publishing &amp; registration limits per IP address and attachment boundaries for campaign
            posts.
          </p>
        </div>
        <span
          class="inline-flex items-center gap-1.5 rounded-full bg-primary-950/60 px-3 py-1 text-xs font-medium text-primary-400 border border-primary-800/40">
          <UIcon name="i-heroicons-shield-check" class="h-3.5 w-3.5" />
          Active Policy
        </span>
      </div>

      <div class="mt-6 grid gap-6 md:grid-cols-2 lg:grid-cols-4">
        <!-- Max Registrations Per Day / IP -->
        <div class="space-y-2 rounded-xl border border-gray-800 bg-gray-950/60 p-4 transition hover:border-gray-700">
          <div class="flex items-center justify-between">
            <span class="text-xs font-semibold uppercase tracking-wider text-gray-300">Register / IP</span>
            <UIcon name="i-heroicons-user-plus" class="h-4 w-4 text-indigo-400" />
          </div>
          <p class="text-xs text-gray-400">
            Max registrations per 24h from single IP.
          </p>
          <AdminSettingInput
            v-model="config.maxRegisterPerDay"
            type="number"
            suffix="req/day"
            hint="Default: 5 registers/day"
          />
        </div>

        <!-- Max Posts Per Day -->
        <div class="space-y-2 rounded-xl border border-gray-800 bg-gray-950/60 p-4 transition hover:border-gray-700">
          <div class="flex items-center justify-between">
            <span class="text-xs font-semibold uppercase tracking-wider text-gray-300">Max Posts / IP</span>
            <UIcon name="i-heroicons-paper-airplane" class="h-4 w-4 text-primary-400" />
          </div>
          <p class="text-xs text-gray-400">
            Max campaign posts per 24h from single IP.
          </p>
          <AdminSettingInput
            v-model="config.maxPostPerDay"
            type="number"
            suffix="posts/day"
            hint="Default: 5 posts/day"
          />
        </div>

        <!-- Max Upload Images -->
        <div class="space-y-2 rounded-xl border border-gray-800 bg-gray-950/60 p-4 transition hover:border-gray-700">
          <div class="flex items-center justify-between">
            <span class="text-xs font-semibold uppercase tracking-wider text-gray-300">Upload Images</span>
            <UIcon name="i-heroicons-photo" class="h-4 w-4 text-emerald-400" />
          </div>
          <p class="text-xs text-gray-400">
            Max images per campaign post.
          </p>
          <AdminSettingInput
            v-model="config.maxUploadImage"
            type="number"
            suffix="imgs/post"
            hint="Default: 10 images/post"
          />
        </div>

        <!-- Max Upload Videos -->
        <div class="space-y-2 rounded-xl border border-gray-800 bg-gray-950/60 p-4 transition hover:border-gray-700">
          <div class="flex items-center justify-between">
            <span class="text-xs font-semibold uppercase tracking-wider text-gray-300">Upload Videos</span>
            <UIcon name="i-heroicons-video-camera" class="h-4 w-4 text-amber-400" />
          </div>
          <p class="text-xs text-gray-400">
            Max videos per campaign post.
          </p>
          <AdminSettingInput
            v-model="config.maxUploadVideo"
            type="number"
            suffix="vids/post"
            hint="Default: 2 videos/post"
          />
        </div>
      </div>
    </div>
  </div>
</template>
