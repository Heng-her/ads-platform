import { defineStore } from 'pinia'
import { encryptData, decryptData } from '~/lib/crypto'

export interface User {
  id: string
  email: string
  name: string
  role?: string
}

export interface AuthResponse {
  user: User
  token: string
  expiresAt: string
}

export const useAuthStore = defineStore('auth', () => {
  const user = ref<User | null>(null)
  const token = ref<string | null>(null)
  const isAuthenticated = computed(() => !!token.value)
  const encryptedPayload = ref<string | null>(null)

  // Initialize store state from encrypted persistent storage (if available)
  function initAuth() {
    if (import.meta.client) {
      const storedEncrypted = localStorage.getItem('auth_data_encrypted')
      if (storedEncrypted) {
        const decrypted = decryptData<AuthResponse>(storedEncrypted)
        if (decrypted) {
          user.value = decrypted.user
          token.value = decrypted.token
          encryptedPayload.value = storedEncrypted
        }
      }
    }
  }

  /**
   * Handle user login response: encrypts full response payload before storing in state & localStorage
   */
  function handleLoginResponse(response: AuthResponse) {
    // 1. Encrypt raw login response payload
    const encryptedStr = encryptData(response)
    encryptedPayload.value = encryptedStr

    // 2. Set memory state
    user.value = response.user
    token.value = response.token

    // 3. Persist encrypted payload to localStorage safely on client
    if (import.meta.client) {
      localStorage.setItem('auth_data_encrypted', encryptedStr)
    }
  }

  /**
   * Clears auth state and encrypted storage
   */
  function logout() {
    user.value = null
    token.value = null
    encryptedPayload.value = null

    if (import.meta.client) {
      localStorage.removeItem('auth_data_encrypted')
    }
  }

  return {
    user,
    token,
    encryptedPayload,
    isAuthenticated,
    initAuth,
    handleLoginResponse,
    logout
  }
})
