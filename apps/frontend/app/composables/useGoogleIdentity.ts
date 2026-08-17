import { computed, ref } from "vue";
import { decryptData } from "~/lib/crypto";

interface GoogleCredentialResponse {
  credential?: string;
}

interface GoogleAccountsId {
  initialize: (options: {
    client_id: string;
    callback: (response: GoogleCredentialResponse) => void | Promise<void>;
    auto_select?: boolean;
    cancel_on_tap_outside?: boolean;
    use_fedcm_for_prompt?: boolean;
  }) => void;
  renderButton: (
    element: HTMLElement,
    options: {
      type?: "standard" | "icon";
      theme?: "outline" | "filled_blue" | "filled_black";
      size?: "large" | "medium" | "small";
      text?: "signin_with" | "signup_with" | "continue_with";
      shape?: "rectangular" | "pill" | "circle" | "square";
      logo_alignment?: "left" | "center";
      width?: number;
    },
  ) => void;
  prompt?: (notification?: (notification: any) => void) => void;
  cancel: () => void;
}

type GoogleWindow = Window & {
  google?: {
    accounts?: {
      id?: GoogleAccountsId;
    };
  };
};

let googleScriptPromise: Promise<void> | null = null;

function loadGoogleScript() {
  if (import.meta.server) return Promise.resolve();

  const googleWindow = window as GoogleWindow;
  if (googleWindow.google?.accounts?.id) return Promise.resolve();
  if (googleScriptPromise) return googleScriptPromise;

  googleScriptPromise = new Promise((resolve, reject) => {
    const existingScript = document.querySelector<HTMLScriptElement>(
      'script[data-google-identity="true"]',
    );
    if (existingScript) {
      existingScript.addEventListener("load", () => resolve(), { once: true });
      existingScript.addEventListener(
        "error",
        () => reject(new Error("Failed to load Google Identity Services.")),
        { once: true },
      );
      return;
    }

    const script = document.createElement("script");
    script.src = "https://accounts.google.com/gsi/client";
    script.async = true;
    script.defer = true;
    script.dataset.googleIdentity = "true";
    script.onload = () => resolve();
    script.onerror = () =>
      reject(new Error("Failed to load Google Identity Services."));
    document.head.appendChild(script);
  });

  return googleScriptPromise;
}

const adminClientId = ref("");
const adminEnabled = ref(true);
const isLoadingConfig = ref(true);
let isInitialized = false;

let settingsPromise: Promise<void> | null = null

async function fetchGoogleAuthSettings() {
  if (!import.meta.client) {
    isLoadingConfig.value = false
    return
  }

  const { fetchSettings } = useSystemSettings()
  const settingsObj = await fetchSettings()

  const gAuth = settingsObj?.googleauth
  if (gAuth) {
    if (gAuth.googleClientId !== undefined) {
      adminClientId.value = (gAuth.googleClientId || '').trim()
    }
    if (gAuth.enableGoogleAuth !== undefined) {
      adminEnabled.value = Boolean(gAuth.enableGoogleAuth)
    }
  }

  isLoadingConfig.value = false
}

export function useGoogleIdentity() {
  const config = useRuntimeConfig();

  if (import.meta.client && !isInitialized) {
    isInitialized = true;
    void fetchGoogleAuthSettings();
  }

  const clientId = computed(
    () =>
      adminClientId.value ||
      String((config.public as any)?.googleClientId || ""),
  );
  const isConfigured = computed(
    () => adminEnabled.value && Boolean(clientId.value),
  );

  async function initGoogleAuth() {
    await fetchGoogleAuthSettings();
  }

  async function renderButton(
    element: HTMLElement,
    onCredential: (idToken: string) => Promise<void> | void,
    options: {
      text?: "signin_with" | "signup_with" | "continue_with";
      width?: number;
    } = {},
  ) {
    await fetchGoogleAuthSettings();

    if (!isConfigured.value || !clientId.value) {
      throw new Error(
        "Google sign-in is disabled or not configured in Admin Settings.",
      );
    }

    await loadGoogleScript();

    const googleAccounts = (window as GoogleWindow).google?.accounts?.id;
    if (!googleAccounts) {
      throw new Error("Google Identity Services is unavailable.");
    }

    element.innerHTML = "";

    googleAccounts.initialize({
      client_id: clientId.value,
      auto_select: false,
      cancel_on_tap_outside: true,
      use_fedcm_for_prompt: true,
      callback: async (response) => {
        if (!response.credential) {
          throw new Error("Google did not return a credential.");
        }

        await onCredential(response.credential);
      },
    });

    googleAccounts.renderButton(element, {
      type: "standard",
      theme: "outline",
      size: "large",
      shape: "pill",
      logo_alignment: "left",
      text: options.text || "signin_with",
      width: options.width || 320,
    });
  }

  async function promptOneTap(
    onCredential: (idToken: string) => Promise<void> | void,
  ) {
    await fetchGoogleAuthSettings();

    if (!isConfigured.value || !clientId.value) {
      return;
    }

    await loadGoogleScript();

    const googleAccounts = (window as GoogleWindow).google?.accounts?.id;
    if (!googleAccounts) return;

    googleAccounts.initialize({
      client_id: clientId.value,
      auto_select: false,
      cancel_on_tap_outside: true,
      use_fedcm_for_prompt: true,
      callback: async (response) => {
        if (response.credential) {
          await onCredential(response.credential);
        }
      },
    });

    if (typeof googleAccounts.prompt === "function") {
      googleAccounts.prompt((notification: any) => {
        if (notification?.isNotDisplayed?.()) {
          console.warn(
            "[Google One Tap] Prompt not displayed reason:",
            notification.getNotDisplayedReason?.(),
          );
        } else if (notification?.isSkippedMoment?.()) {
          console.warn(
            "[Google One Tap] Prompt skipped reason:",
            notification.getSkippedReason?.(),
          );
        } else if (notification?.isDismissedMoment?.()) {
          console.warn(
            "[Google One Tap] Prompt dismissed reason:",
            notification.getDismissedReason?.(),
          );
        }
      });
    }
  }

  function cancelPrompt() {
    if (import.meta.client) {
      (window as GoogleWindow).google?.accounts?.id?.cancel();
    }
  }

  return {
    isConfigured,
    isLoadingConfig,
    initGoogleAuth,
    renderButton,
    promptOneTap,
    cancelPrompt,
  };
}
