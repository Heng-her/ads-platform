import { computed } from "vue";

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

export function useGoogleIdentity() {
  const config = useRuntimeConfig();
  const clientId = computed(() =>
    String((config.public as any)?.googleClientId || ""),
  );
  const isConfigured = computed(() => Boolean(clientId.value));
  console.log("googleClientId:", clientId.value);

  async function renderButton(
    element: HTMLElement,
    onCredential: (idToken: string) => Promise<void> | void,
    options: {
      text?: "signin_with" | "signup_with" | "continue_with";
      width?: number;
    } = {},
  ) {
    if (!clientId.value) {
      throw new Error(
        "Google sign-in is not configured. Set NUXT_PUBLIC_GOOGLE_CLIENT_ID.",
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

  function cancelPrompt() {
    if (import.meta.client) {
      (window as GoogleWindow).google?.accounts?.id?.cancel();
    }
  }

  return {
    isConfigured,
    renderButton,
    cancelPrompt,
  };
}
