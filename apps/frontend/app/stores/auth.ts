import { defineStore } from "pinia";
import { ref, computed } from "vue";
import { encryptData, decryptData } from "~/lib/crypto";

export type UserRole = "admin" | "creator" | "advertiser";
export type BackendUserRole = "ADMIN" | "CREATOR";
export type BackendUserStatus = "ACTIVE" | "SUSPENDED" | "PENDING";

export interface User {
  id: string;
  username: string;
  name: string;
  email: string;
  avatar?: string;
  role: UserRole;
  balance?: number;
  status?: string;
}

export interface BackendAuthUser {
  id: string;
  username: string;
  email: string;
  avatar?: string;
  role: BackendUserRole | UserRole;
  status?: BackendUserStatus | string;
}

export interface AuthSessionPayload {
  user: BackendAuthUser | User;
  token: string;
  refreshToken?: string;
  expiresAt?: string;
}

export interface ApiResponseEnvelope<T> {
  code: 1 | 0;
  msg: string;
  time: number;
  data: T;
}

export const MOCK_USERS: Record<UserRole, User> = {
  admin: {
    id: "usr_admin_01",
    username: "admin_master",
    name: "Platform Admin",
    email: "admin@newplatform.com",
    avatar: "https://api.dicebear.com/7.x/avataaars/svg?seed=Admin",
    role: "admin",
    balance: 50000.0,
    status: "active",
  },
  creator: {
    id: "usr_creator_01",
    username: "john_creator",
    name: "John Creator",
    email: "creator@newplatform.com",
    avatar: "https://api.dicebear.com/7.x/avataaars/svg?seed=Creator",
    role: "creator",
    balance: 1450.75,
    status: "active",
  },
  advertiser: {
    id: "usr_advertiser_01",
    username: "brand_advertiser",
    name: "Sarah Advertiser",
    email: "advertiser@newplatform.com",
    avatar: "https://api.dicebear.com/7.x/avataaars/svg?seed=Advertiser",
    role: "advertiser",
    balance: 3200.0,
    status: "active",
  },
};

function normalizeRole(
  role: BackendUserRole | UserRole | string | undefined,
): UserRole {
  if (!role) return "creator";

  const normalizedRole = role.toLowerCase();
  if (normalizedRole === "admin") return "admin";
  if (normalizedRole === "advertiser") return "advertiser";
  return "creator";
}

function normalizeStatus(status?: BackendUserStatus | string) {
  return status?.toLowerCase() || "active";
}

function buildDisplayName(
  user: Pick<BackendAuthUser, "username" | "email"> & { name?: string },
) {
  if (user.name?.trim()) return user.name.trim();

  const source = user.username || user.email.split("@")[0] || "User";
  return source
    .replace(/[._-]+/g, " ")
    .replace(/\b\w/g, (char) => char.toUpperCase())
    .trim();
}

function normalizeUser(user: BackendAuthUser | User): User {
  if (
    "name" in user &&
    user.name &&
    typeof user.role === "string" &&
    user.role === user.role.toLowerCase()
  ) {
    return {
      ...user,
      role: normalizeRole(user.role),
    };
  }

  return {
    id: user.id,
    username: user.username,
    name: buildDisplayName(user),
    email: user.email,
    avatar: user.avatar,
    role: normalizeRole(user.role),
    status: normalizeStatus(user.status),
  };
}

export const useAuthStore = defineStore("auth", () => {
  const user = ref<User | null>(null);
  const token = ref<string | null>(null);
  const encryptedPayload = ref<string | null>(null);

  const isAuthenticated = computed(() => !!token.value && !!user.value);
  const userRole = computed(() => user.value?.role || "public");

  // Initialize store state from encrypted persistent storage (if available)
  function initAuth() {
    if (import.meta.client) {
      const storedEncrypted = localStorage.getItem("auth_data_encrypted");
      if (storedEncrypted) {
        const decrypted = decryptData<AuthSessionPayload>(storedEncrypted);
        if (decrypted && decrypted.user && decrypted.token) {
          user.value = normalizeUser(decrypted.user);
          token.value = decrypted.token;
          encryptedPayload.value = storedEncrypted;
        }
      }
    }
  }

  /**
   * Handle user login response: encrypts full response payload before storing in state & localStorage
   */
  function handleLoginResponse(resData: AuthSessionPayload) {
    const normalizedUser = normalizeUser(resData.user);
    const normalizedPayload: AuthSessionPayload = {
      ...resData,
      user: normalizedUser,
    };
    const encryptedStr = encryptData(normalizedPayload);
    encryptedPayload.value = encryptedStr;
    user.value = normalizedUser;
    token.value = normalizedPayload.token;

    if (import.meta.client) {
      localStorage.setItem("auth_data_encrypted", encryptedStr);
    }
  }

  /**
   * Mock login helper for local development without backend response
   */
  function loginWithMock(role: UserRole = "creator") {
    const mockUser = MOCK_USERS[role];
    const mockResponseData: AuthSessionPayload = {
      user: mockUser,
      token: `mock_jwt_token_${role}_${Date.now()}`,
      refreshToken: `mock_refresh_${role}`,
      expiresAt: new Date(Date.now() + 86400000).toISOString(),
    };
    handleLoginResponse(mockResponseData);
  }

  /**
   * Clears auth state and encrypted storage
   */
  function logout() {
    user.value = null;
    token.value = null;
    encryptedPayload.value = null;

    if (import.meta.client) {
      localStorage.removeItem("auth_data_encrypted");
    }
  }

  function getDashboardPath(
    role: UserRole | null | undefined = user.value?.role,
  ) {
    return role === "admin"
      ? "/admin"
      : role === "advertiser"
        ? "/advertiser"
        : "/creator";
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
    logout,
    getDashboardPath,
  };
});
