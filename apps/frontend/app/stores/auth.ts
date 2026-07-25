import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import { encryptData, decryptData } from '~/lib/crypto'

export type UserRole = 'admin' | 'creator' | 'advertiser'

export interface User {
  id: string
  username: string
  name: string
  email: string
  avatar?: string
  role: UserRole
  balance?: number
  status?: string
}

export interface AuthResponse {
  code: number
  msg: string
  data: {
    user: User
    token: string
    refreshToken?: string
    expiresAt?: string
  }
}

export const MOCK_USERS: Record<UserRole, User> = {
  admin: {
    id: 'usr_admin_01',
    username: 'admin_master',
    name: 'Platform Admin',
    email: 'admin@newplatform.com',
    avatar: 'https://api.dicebear.com/7.x/avataaars/svg?seed=Admin',
    role: 'admin',
    balance: 50000.00,
    status: 'active'
  },
  creator: {
    id: 'usr_creator_01',
    username: 'john_creator',
    name: 'John Creator',
    email: 'creator@newplatform.com',
    avatar: 'https://api.dicebear.com/7.x/avataaars/svg?seed=Creator',
    role: 'creator',
    balance: 1450.75,
    status: 'active'
  },
  advertiser: {
    id: 'usr_advertiser_01',
    username: 'brand_advertiser',
    name: 'Sarah Advertiser',
    email: 'advertiser@newplatform.com',
    avatar: 'https://api.dicebear.com/7.x/avataaars/svg?seed=Advertiser',
    role: 'advertiser',
    balance: 3200.00,
    status: 'active'
  }
}

export const useAuthStore = defineStore('auth', () => {
  const user = ref<User | null>(null)
  const token = ref<string | null>(null)
  const encryptedPayload = ref<string | null>(null)

  const isAuthenticated = computed(() => !!token.value && !!user.value)
  const userRole = computed(() => user.value?.role || 'public')

  // Initialize store state from encrypted persistent storage (if available)
  function initAuth() {
    if (import.meta.client) {
      const storedEncrypted = localStorage.getItem('auth_data_encrypted')
      if (storedEncrypted) {
        const decrypted = decryptData<AuthResponse['data']>(storedEncrypted)
        if (decrypted && decrypted.user && decrypted.token) {
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
  function handleLoginResponse(resData: AuthResponse['data']) {
    const encryptedStr = encryptData(resData)
    encryptedPayload.value = encryptedStr
    user.value = resData.user
    token.value = resData.token

    if (import.meta.client) {
      localStorage.setItem('auth_data_encrypted', encryptedStr)
    }
  }

  /**
   * Mock login helper for local development without backend response
   */
  function loginWithMock(role: UserRole = 'creator') {
    const mockUser = MOCK_USERS[role]
    const mockResponseData: AuthResponse['data'] = {
      user: mockUser,
      token: `mock_jwt_token_${role}_${Date.now()}`,
      refreshToken: `mock_refresh_${role}`,
      expiresAt: new Date(Date.now() + 86400000).toISOString()
    }
    handleLoginResponse(mockResponseData)
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
    userRole,
    initAuth,
    handleLoginResponse,
    loginWithMock,
    logout
  }
})
