import { defineStore } from "pinia";
import { ref, computed } from "vue";
import { encryptData, decryptData } from "~/lib/crypto";

export type UserRole = "admin" | "creator";
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

function normalizeRole(
  role: BackendUserRole | UserRole | string | undefined,
): UserRole {
  if (!role) return "creator";

  const normalizedRole = role.toLowerCase();
  if (normalizedRole === "admin") return "admin";
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

  /**
   * Fetch current logged-in user profile from backend using `users/me` action.
   * ONLY executes if a Bearer token exists.
   */
  async function fetchUserMe() {
    initAuth();
    if (!token.value) return null;

    try {
      const api = useApi();
      const response = await api.action.$post({
        json: { action: "users/me" },
      });
      const body =
        (await response.json()) as ApiResponseEnvelope<BackendAuthUser>;
      if (response.ok && body.code === 1 && body.data) {
        user.value = normalizeUser(body.data);
        return user.value;
      } else {
        // If user was deleted or session is invalid, clear stale auth session
        logout();
      }
    } catch (error) {
      console.error("[users/me] fetch failed:", error);
    }
    return null;
  }


  // Initialize store state from encrypted persistent storage (if available)
  function initAuth() {
    if (import.meta.client) {
      if (user.value && token.value) return;
      const storedEncrypted = localStorage.getItem("data_xx2_");
      if (storedEncrypted) {
        const decrypted = decryptData<AuthSessionPayload>(storedEncrypted);
        if (decrypted && decrypted.token) {
          token.value = decrypted.token;
          if (decrypted.user) {
            user.value = normalizeUser(decrypted.user);
          }
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
      localStorage.setItem("data_xx2_", encryptedStr);
    }
  }

  function logout() {
    user.value = null;
    token.value = null;
    encryptedPayload.value = null;

    if (import.meta.client) {
      localStorage.removeItem("data_xx2_");
    }
  }

  function getDashboardPath(
    role: UserRole | null | undefined = user.value?.role,
  ) {
    return role === "admin" ? "/admin" : "/creator";
  }

  return {
    user,
    token,
    encryptedPayload,
    isAuthenticated,
    userRole,
    initAuth,
    fetchUserMe,
    handleLoginResponse,
    logout,
    getDashboardPath,
  };
});
