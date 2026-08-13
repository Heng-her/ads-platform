<script setup lang="ts">
const activeTab = defineModel<'platform' | 'dispatch' | 'post' | 'googleauth' | 'uploadapi' | 'adminprofile'>('activeTab', { default: 'platform' })
</script>

<template>
  <div class="border-b border-gray-800">
    <nav class="-mb-px flex space-x-6 overflow-x-auto" aria-label="Admin Tabs">
      <button
        :class="[
          activeTab === 'platform'
            ? 'border-primary-500 text-primary-400'
            : 'border-transparent text-gray-400 hover:border-gray-700 hover:text-gray-200',
          'flex items-center gap-2 border-b-2 py-3 px-1 text-sm font-medium whitespace-nowrap'
        ]"
        @click="activeTab = 'platform'"
      >
        <UIcon name="i-heroicons-adjustments-horizontal" class="h-4 w-4" />
        <span>Platform General</span>
      </button>

      <button
        :class="[
          activeTab === 'dispatch'
            ? 'border-primary-500 text-primary-400'
            : 'border-transparent text-gray-400 hover:border-gray-700 hover:text-gray-200',
          'flex items-center gap-2 border-b-2 py-3 px-1 text-sm font-medium whitespace-nowrap'
        ]"
        @click="activeTab = 'dispatch'"
      >
        <UIcon name="i-heroicons-paper-airplane" class="h-4 w-4" />
        <span>Telegram & Email Dispatch</span>
      </button>

      <button
        :class="[
          activeTab === 'post'
            ? 'border-primary-500 text-primary-400'
            : 'border-transparent text-gray-400 hover:border-gray-700 hover:text-gray-200',
          'flex items-center gap-2 border-b-2 py-3 px-1 text-sm font-medium whitespace-nowrap'
        ]"
        @click="activeTab = 'post'"
      >
        <UIcon name="i-heroicons-document-text" class="h-4 w-4" />
        <span>Post & Media Limits</span>
      </button>

      <button
        :class="[
          activeTab === 'googleauth'
            ? 'border-primary-500 text-primary-400'
            : 'border-transparent text-gray-400 hover:border-gray-700 hover:text-gray-200',
          'flex items-center gap-2 border-b-2 py-3 px-1 text-sm font-medium whitespace-nowrap'
        ]"
        @click="activeTab = 'googleauth'"
      >
        <UIcon name="i-heroicons-key" class="h-4 w-4 text-red-400" />
        <span>Google OAuth Config</span>
      </button>

      <button
        :class="[
          activeTab === 'uploadapi'
            ? 'border-primary-500 text-primary-400'
            : 'border-transparent text-gray-400 hover:border-gray-700 hover:text-gray-200',
          'flex items-center gap-2 border-b-2 py-3 px-1 text-sm font-medium whitespace-nowrap'
        ]"
        @click="activeTab = 'uploadapi'"
      >
        <UIcon name="i-heroicons-cloud-arrow-up" class="h-4 w-4 text-emerald-400" />
        <span>Upload API Config</span>
      </button>

      <button
        :class="[
          activeTab === 'adminprofile'
            ? 'border-primary-500 text-primary-400'
            : 'border-transparent text-gray-400 hover:border-gray-700 hover:text-gray-200',
          'flex items-center gap-2 border-b-2 py-3 px-1 text-sm font-medium whitespace-nowrap'
        ]"
        @click="activeTab = 'adminprofile'"
      >
        <UIcon name="i-heroicons-user-shield" class="h-4 w-4" />
        <span>Admin Profile</span>
      </button>
    </nav>
  </div>
</template>

