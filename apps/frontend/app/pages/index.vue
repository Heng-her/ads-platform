<script setup lang="ts">
import { useAuthStore } from '~/stores/auth'
import { encryptData, decryptData } from '~/lib/crypto'
import { useCustomSeoMeta } from '~/lib/seo/metadata'

useCustomSeoMeta({
  title: 'Home',
  description: 'Welcome to Ads Platform - Modern advertising network connecting advertisers and publishers.',
  path: '/'
})

const authStore = useAuthStore()

// Local demo state
const email = ref('user@example.com')
const password = ref('password123')

// Custom raw text encryption testing
const customInput = ref('Hello, Nuxt Encryption!')
const customEncrypted = ref('')
const customDecrypted = ref('')

onMounted(() => {
  authStore.initAuth()
})

function onSimulateLogin() {
  // Simulated server login response payload
  const mockResponse = {
    user: {
      id: 'usr_1029',
      email: email.value,
      name: 'Jane Doe',
      role: 'Administrator'
    },
    token: 'jwt_mock_token_xyz987654321',
    expiresAt: new Date(Date.now() + 86400000).toISOString()
  }

  // Pass to Pinia store (which encrypts automatically)
  authStore.handleLoginResponse(mockResponse)
}

function onEncryptCustom() {
  customEncrypted.value = encryptData(customInput.value)
  customDecrypted.value = ''
}

function onDecryptCustom() {
  if (customEncrypted.value) {
    const result = decryptData<string>(customEncrypted.value)
    customDecrypted.value = result || 'Failed to decrypt'
  }
}
</script>

<template>
  <UContainer class="py-10 max-w-4xl space-y-8">
    <UCard>
      <template #header>
        <div class="flex items-center justify-between">
          <h2 class="text-xl font-bold">1. User Login & Response Payload Encryption</h2>
          <UBadge :color="authStore.isAuthenticated ? 'success' : 'neutral'">
            {{ authStore.isAuthenticated ? 'Authenticated' : 'Not Logged In' }}
          </UBadge>
        </div>
      </template>

      <div v-if="!authStore.isAuthenticated" class="space-y-4 max-w-md">
        <div>
          <label class="block text-sm font-medium mb-1">Email</label>
          <UInput v-model="email" type="email" placeholder="Email" />
        </div>
        <div>
          <label class="block text-sm font-medium mb-1">Password</label>
          <UInput v-model="password" type="password" placeholder="Password" />
        </div>
        <UButton color="primary" @click="onSimulateLogin">
          Simulate Login & Encrypt Response
        </UButton>
      </div>

      <div v-else class="space-y-6">
        <div class="bg-green-500/10 p-4 rounded-lg border border-green-500/20">
          <h3 class="font-semibold text-green-500">Decrypted Active User Session (Memory State):</h3>
          <pre class="mt-2 text-xs overflow-x-auto p-2 bg-black/20 rounded">{{ authStore.user }}</pre>
        </div>

        <div>
          <h3 class="font-semibold text-amber-500">Encrypted Payload Stored in localStorage ('auth_data_encrypted'):
          </h3>
          <p class="text-xs break-all font-mono p-3 bg-neutral-900 rounded border border-neutral-800 mt-2">
            {{ authStore.encryptedPayload }}
          </p>
        </div>

        <UButton color="error" variant="soft" @click="authStore.logout">
          Logout & Clear Encrypted Store
        </UButton>
      </div>
    </UCard>

    <UCard>
      <template #header>
        <h2 class="text-xl font-bold">2. Quick Test: Encrypt / Decrypt Any Data</h2>
      </template>

      <div class="space-y-4">
        <div>
          <label class="block text-sm font-medium mb-1">Input Text / Payload</label>
          <UInput v-model="customInput" placeholder="Enter text to encrypt..." />
        </div>

        <div class="flex gap-2">
          <UButton color="neutral" @click="onEncryptCustom">Encrypt Text</UButton>
          <UButton color="neutral" variant="outline" :disabled="!customEncrypted" @click="onDecryptCustom">
            Decrypt Text
          </UButton>
        </div>

        <div v-if="customEncrypted" class="space-y-2 pt-2">
          <div>
            <span class="text-xs text-neutral-400">Ciphertext (Encrypted):</span>
            <div class="text-xs font-mono break-all p-2 bg-neutral-900 rounded border border-neutral-800">
              {{ customEncrypted }}
            </div>
          </div>
          <div v-if="customDecrypted">
            <span class="text-xs text-neutral-400">Decrypted Output:</span>
            <div class="text-xs font-mono p-2 bg-green-950/40 border border-green-500/30 text-green-400 rounded">
              {{ customDecrypted }}
            </div>
          </div>
        </div>
      </div>
    </UCard>
  </UContainer>
</template>
