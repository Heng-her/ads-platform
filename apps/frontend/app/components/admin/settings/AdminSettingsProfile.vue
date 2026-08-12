<script setup lang="ts">
import { useAppToast } from '~/composables/useAppToast'
import type { CloudinaryUploadResponse } from '~/composables/useCloudinaryUpload'

export interface AdminProfile {
  username: string
  email: string
  avatar: string
}

const profile = defineModel<AdminProfile>({ required: true })
const toast = useAppToast()

function onAdminAvatarUploaded(payload: CloudinaryUploadResponse) {
  profile.value.avatar = payload.url
  toast.success('Avatar Uploaded', 'Admin profile picture updated successfully!')
}

function onAdminAvatarError(msg: string) {
  toast.error('Upload Failed', msg)
}
</script>

<template>
  <div class="space-y-6">
    <div class="rounded-xl border border-gray-800 bg-gray-900 p-6 shadow-sm">
      <h2 class="text-lg font-semibold text-white">Administrator Profile</h2>
      <p class="mt-1 text-sm text-gray-400">Update your personal admin account details and profile picture.</p>

      <div class="mt-6 grid gap-6 md:grid-cols-2">
        <!-- Avatar Preview & Upload -->
        <div class="col-span-2 space-y-3">
          <label class="block text-xs font-semibold text-gray-300">Profile Avatar Image</label>
          <div class="flex flex-col sm:flex-row items-start sm:items-center gap-4">
            <!-- Avatar Circle Preview -->
            <div
              class="relative h-20 w-20 shrink-0 overflow-hidden rounded-full border-2 border-primary-500/40 bg-gray-800 shadow-md group"
            >
              <img
                v-if="profile.avatar"
                :src="profile.avatar"
                alt="Admin Avatar"
                class="h-full w-full object-cover"
              />
              <div v-else class="flex h-full w-full items-center justify-center text-gray-400">
                <UIcon name="i-heroicons-user-shield" class="h-10 w-10" />
              </div>
              <button
                v-if="profile.avatar"
                type="button"
                title="Remove avatar"
                class="absolute inset-0 bg-black/60 text-white opacity-0 group-hover:opacity-100 transition flex items-center justify-center text-xs font-medium"
                @click="profile.avatar = ''"
              >
                Remove
              </button>
            </div>

            <!-- Media Uploader Component -->
            <div class="flex-1 w-full space-y-2">
              <AppMediaUploader
                folder="avatars"
                accept="image"
                label="Upload Avatar Image"
                hint="PNG, JPG, WEBP or GIF up to 10MB"
                @uploaded="onAdminAvatarUploaded"
                @error="onAdminAvatarError"
              />
            </div>
          </div>
          <!-- Optional URL input fallback -->
          <div class="space-y-1 pt-1">
            <label class="block text-[11px] text-gray-400">Or paste image URL directly</label>
            <input
              v-model="profile.avatar"
              type="url"
              placeholder="https://example.com/admin-avatar.jpg"
              class="w-full rounded-lg border border-gray-700 bg-gray-800 px-3.5 py-1.5 text-xs text-white focus:border-primary-500 focus:outline-none focus:ring-2 focus:ring-primary-500/20"
            />
          </div>
        </div>

        <div class="space-y-1">
          <label class="block text-xs font-semibold text-gray-300">Admin Display Name</label>
          <input
            v-model="profile.username"
            type="text"
            class="w-full rounded-lg border border-gray-700 bg-gray-800 px-3.5 py-2 text-sm text-white focus:border-primary-500 focus:outline-none focus:ring-2 focus:ring-primary-500/20"
          />
        </div>

        <div class="space-y-1">
          <label class="block text-xs font-semibold text-gray-300">Email Address (Admin Primary)</label>
          <input
            v-model="profile.email"
            type="email"
            disabled
            class="w-full cursor-not-allowed rounded-lg border border-gray-800 bg-gray-950/60 px-3.5 py-2 text-sm text-gray-400"
          />
        </div>
      </div>
    </div>
  </div>
</template>
