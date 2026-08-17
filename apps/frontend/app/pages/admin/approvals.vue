<script setup lang="ts">
import { ref, onMounted, computed } from 'vue'
import { useApi } from '~/composables/useApi'
import { useAppToast } from '~/composables/useAppToast'

import ApprovalsHeader from '~/components/admin/approvals/ApprovalsHeader.vue'
import ApprovalsSearchFilter from '~/components/admin/approvals/ApprovalsSearchFilter.vue'
import ApprovalsUserCard from '~/components/admin/approvals/ApprovalsUserCard.vue'
import type { UserRecord } from '~/components/admin/approvals/ApprovalsUserCard.vue'
import ApprovalsUserDetailModal from '~/components/admin/approvals/ApprovalsUserDetailModal.vue'
import ApprovalsDeleteCreatorModal from '~/components/admin/approvals/ApprovalsDeleteCreatorModal.vue'

import { useAuthStore } from '~/stores/auth'

definePageMeta({
  layout: 'admin'
})

const api = useApi()
const toast = useAppToast()
const authStore = useAuthStore()

const isLoading = ref(true)
const searchQuery = ref('')
const processingId = ref<string | null>(null)

// Data State for Users
const allUsers = ref<UserRecord[]>([])

// Selected user for inspection modal
const selectedCreator = ref<UserRecord | null>(null)

async function fetchData() {
  isLoading.value = true
  try {
    const usersRes = await api.action.$post({
      json: { action: 'users/list' }
    })
    const usersBody: any = await usersRes.json()
    if (usersRes.ok && usersBody.code === 1) {
      allUsers.value = usersBody.data || []
    } else {
      toast.error('Fetch Error', usersBody.msg || 'Could not fetch users list.')
    }
  } catch (err: any) {
    toast.error('Data Fetch Error', err.message || 'Could not fetch users list.')
  } finally {
    isLoading.value = false
  }
}

onMounted(() => {
  fetchData()
})

// Filtered Users List (Excludes the currently logged-in Admin user)
const filteredUsers = computed(() => {
  return allUsers.value.filter(user => {
    // Hide current logged-in user
    if (authStore.user?.id && user.id === authStore.user.id) {
      return false
    }

    const q = searchQuery.value.toLowerCase()
    return q === '' ||
      user.username?.toLowerCase().includes(q) ||
      user.email?.toLowerCase().includes(q) ||
      user.country?.toLowerCase().includes(q) ||
      user.role?.toLowerCase().includes(q)
  })
})

// Count of PENDING registrations
const pendingUsersCount = computed(() => allUsers.value.filter(u => u.status === 'PENDING').length)

// Delete Creator Confirmation Modal State
const showDeleteModal = ref(false)
const creatorToDelete = ref<UserRecord | null>(null)
const adminDeletePassword = ref('')
const isDeleting = ref(false)
const deleteErrorMessage = ref('')

function openDeleteModal(user: UserRecord) {
  creatorToDelete.value = user
  adminDeletePassword.value = ''
  deleteErrorMessage.value = ''
  showDeleteModal.value = true
}

function closeDeleteModal() {
  showDeleteModal.value = false
  creatorToDelete.value = null
  adminDeletePassword.value = ''
  deleteErrorMessage.value = ''
}

async function confirmDeleteCreator() {
  if (!creatorToDelete.value) return
  if (!adminDeletePassword.value.trim()) {
    deleteErrorMessage.value = 'Please enter the creator deletion security password.'
    return
  }

  isDeleting.value = true
  deleteErrorMessage.value = ''

  try {
    const res = await api.action.$post({
      json: {
        action: 'users/delete',
        data: {
          id: creatorToDelete.value.id,
          password: adminDeletePassword.value
        }
      }
    })
    const body: any = await res.json()
    if (res.ok && body.code === 1) {
      const deletedId = creatorToDelete.value.id
      allUsers.value = allUsers.value.filter(u => u.id !== deletedId)
      if (selectedCreator.value?.id === deletedId) {
        selectedCreator.value = null
      }
      toast.success('Creator Deleted', body.msg || `Creator ${creatorToDelete.value.username} has been permanently deleted.`)
      closeDeleteModal()
    } else {
      deleteErrorMessage.value = body.msg || 'Could not delete creator account.'
      toast.error('Deletion Failed', deleteErrorMessage.value)
    }
  } catch (err: any) {
    deleteErrorMessage.value = err.message || 'Operation failed due to network error.'
    toast.error('Delete Error', deleteErrorMessage.value)
  } finally {
    isDeleting.value = false
  }
}

// Actions for User Status & Role Update
async function updateUserStatus(userId: string, status: 'ACTIVE' | 'SUSPENDED', role?: 'ADMIN' | 'CREATOR') {
  processingId.value = userId
  try {
    const actionName = role ? 'users/update' : 'users/update-status'
    const payloadData = role ? { id: userId, status, role } : { id: userId, status }

    const res = await api.action.$post({
      json: {
        action: actionName,
        data: payloadData
      }
    })
    const body: any = await res.json()
    if (res.ok && body.code === 1) {
      const target = allUsers.value.find(u => u.id === userId)
      if (target) {
        target.status = status
        if (role) target.role = role
      }
      if (selectedCreator.value?.id === userId) selectedCreator.value = null

      const roleMsg = role === 'ADMIN' ? ' as Administrator' : (role === 'CREATOR' ? ' as Creator' : '')
      const statusText = status === 'ACTIVE' ? `Approved${roleMsg}` : 'Suspended'
      toast.success(`User ${statusText}`, `User account is now ${status}${roleMsg}.`)
    } else {
      toast.error('Action Failed', body.msg || 'Could not update user status.')
    }
  } catch (err: any) {
    toast.error('Network Error', err.message || 'Operation failed.')
  } finally {
    processingId.value = null
  }
}
</script>

<template>
  <div class="mx-auto max-w-8xl space-y-8 pb-12 text-gray-100">
    <!-- Header -->
    <ApprovalsHeader
      :pending-users-count="pendingUsersCount"
      :is-loading="isLoading"
      @refresh="fetchData"
    />

    <!-- Search Controls -->
    <ApprovalsSearchFilter
      v-model="searchQuery"
      :total-count="filteredUsers.length"
    />

    <!-- User Accounts List Grid -->
    <div class="space-y-6">
      <div v-if="isLoading" class="grid gap-6 md:grid-cols-2 lg:grid-cols-3">
        <div v-for="i in 3" :key="i" class="h-48 animate-pulse rounded-xl border border-gray-800 bg-gray-900/60 p-6" />
      </div>

      <div v-else-if="filteredUsers.length === 0"
        class="rounded-xl border border-gray-800 bg-gray-900 p-12 text-center text-gray-400">
        <UIcon name="i-heroicons-check-circle" class="mx-auto h-12 w-12 text-emerald-400" />
        <h3 class="mt-3 text-lg font-semibold text-white">No Users Found</h3>
        <p class="mt-1 text-sm text-gray-500">There are currently no user accounts matching your search query.</p>
      </div>

      <div v-else class="grid gap-6 md:grid-cols-2 lg:grid-cols-3">
        <ApprovalsUserCard
          v-for="user in filteredUsers"
          :key="user.id"
          :user="user"
          :processing-id="processingId"
          @update-status="updateUserStatus"
          @open-delete="openDeleteModal"
          @inspect="selectedCreator = user"
        />
      </div>
    </div>

    <!-- Modal: User Detail Inspection & Role Control -->
    <ApprovalsUserDetailModal
      :user="selectedCreator"
      @close="selectedCreator = null"
      @update-status="updateUserStatus"
      @open-delete="openDeleteModal"
    />

    <!-- Modal: Creator Delete Security Confirmation -->
    <ApprovalsDeleteCreatorModal
      v-model:open="showDeleteModal"
      v-model:admin-delete-password="adminDeletePassword"
      :creator-to-delete="creatorToDelete"
      :is-deleting="isDeleting"
      :delete-error-message="deleteErrorMessage"
      @close="closeDeleteModal"
      @confirm="confirmDeleteCreator"
    />
  </div>
</template>
