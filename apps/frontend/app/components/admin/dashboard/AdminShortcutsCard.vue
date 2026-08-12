<script setup lang="ts">
</script>

<template>
  <div class="rounded-xl border border-gray-800 bg-gray-900 p-6 shadow-sm space-y-4">
    <h2 class="text-sm font-bold uppercase tracking-wider text-gray-400 border-b border-gray-800 pb-3">
      Admin Management Shortcuts
    </h2>

    <div class="grid gap-2.5">
      <NuxtLink
        to="/admin/approvals"
        class="flex items-center justify-between rounded-lg border border-gray-800 bg-gray-950/60 p-3 text-xs font-semibold text-gray-200 transition hover:border-gray-700 hover:bg-gray-800"
      >
        <div class="flex items-center gap-2.5">
          <UIcon name="i-heroicons-check-badge" class="h-4 w-4 text-amber-400" />
          <span>Campaign Approvals</span>
        </div>
        <UIcon name="i-heroicons-chevron-right" class="h-4 w-4 text-gray-500" />
      </NuxtLink>

      <NuxtLink
        to="/admin/approvals"
        class="flex items-center justify-between rounded-lg border border-gray-800 bg-gray-950/60 p-3 text-xs font-semibold text-gray-200 transition hover:border-gray-700 hover:bg-gray-800"
      >
        <div class="flex items-center gap-2.5">
          <UIcon name="i-heroicons-users" class="h-4 w-4 text-indigo-400" />
          <span>User Roles & Approvals</span>
        </div>
        <UIcon name="i-heroicons-chevron-right" class="h-4 w-4 text-gray-500" />
      </NuxtLink>

      <NuxtLink
        to="/admin/logs"
        class="flex items-center justify-between rounded-lg border border-gray-800 bg-gray-950/60 p-3 text-xs font-semibold text-gray-200 transition hover:border-gray-700 hover:bg-gray-800"
      >
        <div class="flex items-center gap-2.5">
          <UIcon name="i-heroicons-document-text" class="h-4 w-4 text-sky-400" />
          <span>System Security Logs</span>
        </div>
        <UIcon name="i-heroicons-chevron-right" class="h-4 w-4 text-gray-500" />
      </NuxtLink>

      <NuxtLink
        to="/admin/settings"
        class="flex items-center justify-between rounded-lg border border-gray-800 bg-gray-950/60 p-3 text-xs font-semibold text-gray-200 transition hover:border-gray-700 hover:bg-gray-800"
      >
        <div class="flex items-center gap-2.5">
          <UIcon name="i-heroicons-adjustments-horizontal" class="h-4 w-4 text-emerald-400" />
          <span>Telegram & Mail Dispatch Config</span>
        </div>
        <UIcon name="i-heroicons-chevron-right" class="h-4 w-4 text-gray-500" />
      </NuxtLink>
    </div>
  </div>
</template>
