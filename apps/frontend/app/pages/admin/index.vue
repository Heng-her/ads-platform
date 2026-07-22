<script setup lang="ts">
definePageMeta({
  layout: 'admin'
})
</script>

<template>
  <div class="space-y-6 text-gray-100">
    <div class="flex items-center justify-between">
      <h1 class="text-2xl font-bold">
        Admin Control Overview
      </h1>
      <UBadge color="error">
        Live Platform Audit
      </UBadge>
    </div>

    <div class="grid grid-cols-1 md:grid-cols-4 gap-6">
      <div class="p-4 bg-gray-900 border border-gray-800 rounded-lg">
        <p class="text-xs text-gray-400">
          Total System Users
        </p>
        <p class="text-2xl font-bold mt-1">
          24,510
        </p>
      </div>
      <div class="p-4 bg-gray-900 border border-gray-800 rounded-lg">
        <p class="text-xs text-gray-400">
          Pending Approvals
        </p>
        <p class="text-2xl font-bold mt-1 text-amber-400">
          8 Requests
        </p>
      </div>
      <div class="p-4 bg-gray-900 border border-gray-800 rounded-lg">
        <p class="text-xs text-gray-400">
          Platform Health
        </p>
        <p class="text-2xl font-bold mt-1 text-emerald-400">
          99.98%
        </p>
      </div>
      <div class="p-4 bg-gray-900 border border-gray-800 rounded-lg">
        <p class="text-xs text-gray-400">
          Security Alerts
        </p>
        <p class="text-2xl font-bold mt-1 text-gray-400">
          0 Critical
        </p>
      </div>
    </div>
  </div>
</template>
