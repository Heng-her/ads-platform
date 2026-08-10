<script setup lang="ts">
import { computed, onMounted, ref } from 'vue'
import { useApi } from '~/composables/useApi'

definePageMeta({ layout: 'admin' })

type AuditLog = {
  id: string
  userId: string | null
  ipAddress: string | null
  action: string
  details: string | null
  createdAt: string
}

const api = useApi()
const logs = ref<AuditLog[]>([])
const isLoading = ref(false)
const errorMessage = ref('')
const currentPage = ref(1)
const totalPages = ref(1)
const totalLogs = ref(0)
const ipAddress = ref('')
const device = ref('')
const fromDate = ref('')
const toDate = ref('')
const clearBeforeDate = ref('')
const isClearing = ref(false)

function toStartOfDay(value: string) {
  return value ? new Date(`${value}T00:00:00`).toISOString() : undefined
}

function toEndOfDay(value: string) {
  return value ? new Date(`${value}T23:59:59.999`).toISOString() : undefined
}

function getDevice(log: AuditLog) {
  try {
    return JSON.parse(log.details || '{}').userAgent || 'Unknown device'
  } catch {
    return 'Unknown device'
  }
}

function formatDate(value: string) {
  return new Date(value).toLocaleString()
}

async function loadLogs(page = currentPage.value) {
  currentPage.value = page
  isLoading.value = true
  errorMessage.value = ''
  try {
    const response = await api['audit-logs'].$get({
      query: {
        page: String(page),
        limit: '25',
        ipAddress: ipAddress.value || undefined,
        device: device.value || undefined,
        from: toStartOfDay(fromDate.value),
        to: toEndOfDay(toDate.value),
      },
    })
    const body = await response.json()
    if (!response.ok || body.code !== 1) throw new Error(body.msg || 'Failed to load logs')
    logs.value = body.data.items || []
    totalPages.value = body.data.pagination?.totalPages || 1
    totalLogs.value = body.data.pagination?.total || 0
  } catch (error: any) {
    errorMessage.value = error.message || 'Failed to load logs'
    logs.value = []
  } finally {
    isLoading.value = false
  }
}

function applyFilters() {
  loadLogs(1)
}

function resetFilters() {
  ipAddress.value = ''
  device.value = ''
  fromDate.value = ''
  toDate.value = ''
  loadLogs(1)
}

const clearButtonLabel = computed(() => clearBeforeDate.value ? `Clear logs before ${clearBeforeDate.value}` : 'Clear all logs')

async function clearLogs() {
  const scope = clearBeforeDate.value ? `all logs before ${clearBeforeDate.value}` : 'all audit logs'
  if (!window.confirm(`Are you sure you want to permanently delete ${scope}? This cannot be undone.`)) return

  isClearing.value = true
  try {
    const before = toStartOfDay(clearBeforeDate.value)
    const response = await api['audit-logs'].$delete({ query: { before } })
    const body = await response.json()
    if (!response.ok || body.code !== 1) throw new Error(body.msg || 'Failed to clear logs')
    clearBeforeDate.value = ''
    await loadLogs(1)
  } catch (error: any) {
    errorMessage.value = error.message || 'Failed to clear logs'
  } finally {
    isClearing.value = false
  }
}

onMounted(() => loadLogs())
</script>

<template>
  <div class="space-y-6">
    <div
      class="flex flex-col gap-4 border-b border-gray-200 pb-5 dark:border-gray-800 sm:flex-row sm:items-end sm:justify-between">
      <div>
        <p class="text-xs font-bold uppercase tracking-[0.16em] text-primary">Administration</p>
        <h1 class="mt-1 text-2xl font-bold text-gray-900 dark:text-white">Audit logs</h1>
        <p class="mt-1 text-sm text-gray-500 dark:text-gray-400">Review recorded requests, including IP addresses and
          device information.</p>
      </div>
      <p class="rounded-xl bg-gray-100 px-3 py-2 text-xs font-bold text-gray-600 dark:bg-gray-800 dark:text-gray-300">{{
        totalLogs }} matching logs</p>
    </div>

    <section class="rounded-2xl border border-gray-200 bg-white p-4 shadow-sm dark:border-gray-800 dark:bg-gray-900">
      <div class="grid gap-3 sm:grid-cols-2 lg:grid-cols-4">
        <UInput v-model="ipAddress" label="IP address" placeholder="e.g. 192.168.1" icon="i-heroicons-globe-alt"
          @keyup.enter="applyFilters" />
        <UInput v-model="device" label="Device or browser" placeholder="e.g. iPhone, Chrome"
          icon="i-heroicons-device-phone-mobile" @keyup.enter="applyFilters" />
        <label class="space-y-1 text-xs font-semibold text-gray-600 dark:text-gray-300">From date
          <input v-model="fromDate" type="date"
            class="h-9 w-full rounded-lg border border-gray-200 bg-white px-3 text-sm text-gray-900 dark:border-gray-700 dark:bg-gray-950 dark:text-white" />
        </label>
        <label class="space-y-1 text-xs font-semibold text-gray-600 dark:text-gray-300">To date
          <input v-model="toDate" type="date"
            class="h-9 w-full rounded-lg border border-gray-200 bg-white px-3 text-sm text-gray-900 dark:border-gray-700 dark:bg-gray-950 dark:text-white" />
        </label>
      </div>
      <div
        class="mt-4 flex flex-wrap items-center justify-between gap-3 border-t border-gray-100 pt-4 dark:border-gray-800">
        <div class="flex gap-2">
          <UButton color="primary" size="sm" icon="i-heroicons-funnel" @click="applyFilters">Apply filters</UButton>
          <UButton color="neutral" variant="ghost" size="sm" @click="resetFilters">Reset</UButton>
        </div>
        <div class="flex flex-wrap items-end gap-2">
          <label class="space-y-1 text-xs font-semibold text-gray-500 dark:text-gray-400">Clear before date (optional)
            <input v-model="clearBeforeDate" type="date"
              class="block h-9 rounded-lg border border-gray-200 bg-white px-3 text-sm text-gray-900 dark:border-gray-700 dark:bg-gray-950 dark:text-white" />
          </label>
          <UButton color="error" variant="soft" size="sm" icon="i-heroicons-trash" :loading="isClearing"
            @click="clearLogs">{{ clearButtonLabel }}</UButton>
        </div>
      </div>
    </section>

    <p v-if="errorMessage"
      class="rounded-xl border border-red-200 bg-red-50 p-3 text-sm font-medium text-red-700 dark:border-red-900/60 dark:bg-red-950/30 dark:text-red-300">
      {{ errorMessage }}</p>

    <section class="overflow-hidden rounded-2xl border border-gray-200 bg-white dark:border-gray-800 dark:bg-gray-900">
      <div v-if="isLoading" class="p-12 text-center text-sm text-gray-500">
        <UIcon name="i-heroicons-arrow-path" class="mr-2 inline h-5 w-5 animate-spin" />Loading logs…
      </div>
      <div v-else-if="logs.length === 0" class="p-12 text-center text-sm text-gray-500">No audit logs match these
        filters.</div>
      <div v-else class="no-scrollbar overflow-x-auto">
        <table class="w-full min-w-[900px] text-left text-xs">
          <thead
            class="border-b border-gray-200 bg-gray-50 text-gray-500 dark:border-gray-800 dark:bg-gray-950 dark:text-gray-400">
            <tr>
              <th class="px-4 py-3 font-bold">Time</th>
              <th class="px-4 py-3 font-bold">Action</th>
              <th class="px-4 py-3 font-bold">IP address</th>
              <th class="px-4 py-3 font-bold">Device / browser</th>
              <th class="px-4 py-3 font-bold">User ID</th>
            </tr>
          </thead>
          <tbody class="divide-y divide-gray-100 dark:divide-gray-800">
            <tr v-for="log in logs" :key="log.id" class="text-gray-700 dark:text-gray-300">
              <td class="whitespace-nowrap px-4 py-3 text-gray-500 dark:text-gray-400">{{ formatDate(log.createdAt) }}
              </td>
              <td class="whitespace-nowrap px-4 py-3 font-mono font-bold text-primary">{{ log.action }}</td>
              <td class="whitespace-nowrap px-4 py-3 font-mono">{{ log.ipAddress || 'Unknown' }}</td>
              <td class="max-w-xs truncate px-4 py-3" :title="getDevice(log)">{{ getDevice(log) }}</td>
              <td class="max-w-[12rem] truncate px-4 py-3 font-mono text-gray-500" :title="log.userId || ''">{{
                log.userId || 'Anonymous' }}</td>
            </tr>
          </tbody>
        </table>
      </div>
    </section>

    <div v-if="totalPages > 1" class="flex items-center justify-between">
      <span class="text-sm text-gray-500 dark:text-gray-400">Page {{ currentPage }} of {{ totalPages }}</span>
      <div class="flex gap-2">
        <UButton color="neutral" variant="outline" size="sm" :disabled="currentPage === 1"
          @click="loadLogs(currentPage - 1)">Previous</UButton>
        <UButton color="neutral" variant="outline" size="sm" :disabled="currentPage === totalPages"
          @click="loadLogs(currentPage + 1)">Next</UButton>
      </div>
    </div>
  </div>
</template>
