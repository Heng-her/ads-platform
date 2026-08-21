import { ref, onMounted } from "vue";
import { useApi } from "~/composables/useApi";
import { useAppToast } from "~/composables/useAppToast";
import { useSystemSettings } from "~/composables/useSystemSettings";

// Active VAPID Public Key for Web Push Protocol
const DEFAULT_VAPID_PUBLIC_KEY =
  "BMKHUIgMv3UqzA2igg6C0hLcsP3yaAsAObt0BA__P5dGO8mClLzR04Yt5E-6Ft233LhEgq8p13MtgjR5AVXSbj4";

function urlBase64ToUint8Array(base64String: string): Uint8Array {
  const padding = "=".repeat((4 - (base64String.length % 4)) % 4);
  const base64 = (base64String + padding).replace(/-/g, "+").replace(/_/g, "/");
  const rawData = window.atob(base64);
  const outputArray = new Uint8Array(rawData.length);
  for (let i = 0; i < rawData.length; ++i) {
    outputArray[i] = rawData.charCodeAt(i);
  }
  return outputArray;
}

export function useWebPushNotification() {
  const api = useApi();
  const toast = useAppToast();
  const { fetchSettings } = useSystemSettings();

  const permissionState = ref<NotificationPermission | "unsupported">(
    "default",
  );
  const isSubscribed = ref(false);
  const isLoading = ref(false);

  function checkPermissionSupport() {
    if (import.meta.client) {
      if (!("Notification" in window) || !("serviceWorker" in navigator)) {
        permissionState.value = "unsupported";
        return false;
      }
      permissionState.value = Notification.permission;
      return true;
    }
    return false;
  }

  async function registerServiceWorker() {
    if (!import.meta.client || !("serviceWorker" in navigator)) return null;
    try {
      const reg = await navigator.serviceWorker.register("/sw.js");
      await navigator.serviceWorker.ready;
      return reg;
    } catch (err) {
      console.warn("[WebPush] Service worker registration failed:", err);
      return null;
    }
  }

  async function subscribeToNotifications(showToast = true) {
    if (!checkPermissionSupport()) {
      if (showToast) {
        toast.warning(
          "Not Supported",
          "Web Notifications are not supported on this browser.",
        );
      }
      return false;
    }

    isLoading.value = true;

    try {
      // 1. Request Browser Permission
      const permission = await Notification.requestPermission();
      permissionState.value = permission;

      if (permission !== "granted") {
        if (showToast) {
          toast.warning(
            "Permission Denied",
            "Browser notification permission was not granted.",
          );
        }
        isLoading.value = false;
        return false;
      }

      // 2. Register Service Worker and await ready state
      await registerServiceWorker();
      const activeReg = await navigator.serviceWorker.ready;

      if (!activeReg || !activeReg.active) {
        if (showToast) {
          toast.error(
            "Registration Error",
            "Service Worker is not active yet.",
          );
        }
        isLoading.value = false;
        return false;
      }

      // 3. Resolve active VAPID Public Key from System Settings (with fallback)
      let activeVapidKey = DEFAULT_VAPID_PUBLIC_KEY;
      try {
        const settingsObj = await fetchSettings();
        if (settingsObj?.dispatch?.vapidPublicKey) {
          activeVapidKey = settingsObj.dispatch.vapidPublicKey;
        }
      } catch (e) {
        console.warn(
          "[WebPush] Could not load VAPID key from settings, using default:",
          e,
        );
      }

      // 4. Always re-subscribe with active VAPID key to prevent stale key mismatches
      let subscription = await activeReg.pushManager.getSubscription();
      if (subscription) {
        try {
          await subscription.unsubscribe();
        } catch (e) {
          console.warn("[WebPush] Old subscription unsubscribe attempt:", e);
        }
      }

      const applicationServerKey = urlBase64ToUint8Array(activeVapidKey);
      subscription = await activeReg.pushManager.subscribe({
        userVisibleOnly: true,
        applicationServerKey: applicationServerKey as any,
      });

      // 4. Send subscription keys to Backend API
      const subJson = subscription.toJSON();
      const endpoint = subJson.endpoint;
      const p256dh = subJson.keys?.p256dh || "";
      const auth = subJson.keys?.auth || "";

      const res = await api.action.$post({
        json: {
          action: "notifications/subscribe",
          data: {
            endpoint,
            keys: { p256dh, auth },
          },
        },
      });

      const data: any = await res.json().catch(() => ({}));
      if (res.ok && (data.code === 1 || data.code === 0 || data.success)) {
        isSubscribed.value = true;
        if (showToast) {
          toast.success(
            "Notifications Active! 🎉",
            "You will now receive alerts when new campaigns are published.",
          );
        }
        return true;
      } else {
        if (showToast) {
          toast.error(
            "Subscription Error",
            data.msg || "Could not save notification subscription.",
          );
        }
        return false;
      }
    } catch (err: any) {
      console.error("[WebPush] Subscription error:", err);
      if (showToast) {
        toast.error(
          "Notification Error",
          err.message || "Failed to enable browser notifications.",
        );
      }
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  async function unsubscribeFromNotifications() {
    if (!import.meta.client || !("serviceWorker" in navigator)) return false;
    isLoading.value = true;

    try {
      const reg = await navigator.serviceWorker.ready;
      const subscription = await reg.pushManager.getSubscription();

      if (subscription) {
        const endpoint = subscription.endpoint;
        await subscription.unsubscribe();

        await api.action
          .$post({
            json: {
              action: "notifications/unsubscribe",
              data: { endpoint },
            },
          })
          .catch(() => {});
      }

      isSubscribed.value = false;
      toast.info(
        "Notifications Disabled",
        "You will no longer receive alerts.",
      );
      return true;
    } catch (err: any) {
      toast.error(
        "Unsubscribe Error",
        err.message || "Could not disable notifications.",
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  async function checkExistingSubscription() {
    if (!import.meta.client || !("serviceWorker" in navigator)) return;
    checkPermissionSupport();
    if (Notification.permission === "granted") {
      try {
        await subscribeToNotifications(false);
      } catch (err) {
        console.warn("[WebPush] Auto-sync subscription failed:", err);
      }
    }
  }

  onMounted(() => {
    checkExistingSubscription();
  });

  return {
    permissionState,
    isSubscribed,
    isLoading,
    subscribeToNotifications,
    unsubscribeFromNotifications,
    checkExistingSubscription,
  };
}
