export function usePushNotification() {
  const permission = ref<NotificationPermission | 'unsupported'>('default')
  const isIOS = ref(false)
  const isStandalone = ref(false)
  const isSubscribed = ref(false)
  const swRegistration = ref<ServiceWorkerRegistration | null>(null)

  const checkStatus = () => {
    if (import.meta.server) return

    isIOS.value = /iPad|iPhone|iPod/.test(navigator.userAgent) && !(window as any).MSStream
    isStandalone.value = window.matchMedia('(display-mode: standalone)').matches || (navigator as any).standalone

    if (!('Notification' in window)) {
      permission.value = 'unsupported'
    } else {
      permission.value = Notification.permission
    }
  }

  const initServiceWorker = async () => {
    if (import.meta.server || !('serviceWorker' in navigator)) return null

    try {
      const reg = await navigator.serviceWorker.register('/sw.js')
      swRegistration.value = reg
      return reg
    } catch (err) {
      console.error('Service Worker registration failed:', err)
      return null
    }
  }

  const requestAndSubscribe = async (apiBaseUrl?: string) => {
    if (import.meta.server) return false

    if (isIOS.value && !isStandalone.value) {
      alert("iPhone Requirement:\n\n1. Tap Safari's Share button\n2. Select 'Add to Home Screen'\n3. Open app from Home Screen to enable notifications!")
      return false
    }

    if (!('Notification' in window)) {
      alert('This browser does not support web notifications.')
      return false
    }

    let perm: NotificationPermission = 'default'
    try {
      perm = await Notification.requestPermission()
    } catch (e) {
      perm = await new Promise((resolve) => {
        Notification.requestPermission((res) => resolve(res))
      })
    }

    permission.value = perm

    if (perm === 'granted') {
      const reg = swRegistration.value || (await initServiceWorker())
      if (reg) {
        try {
          // Subscribe or get existing subscription
          let sub = await reg.pushManager.getSubscription()
          if (!sub) {
            // Subscribe if public VAPID key is provided or default
            sub = await reg.pushManager.subscribe({
              userVisibleOnly: true
            }).catch(() => null)
          }

          if (sub) {
            isSubscribed.value = true
            // Post subscription to backend API action endpoint
            const apiEndpoint = apiBaseUrl || '/api/action'
            await $fetch(apiEndpoint, {
              method: 'POST',
              body: {
                action: 'notifications/subscribe',
                data: {
                  endpoint: sub.endpoint,
                  keys: {
                    p256dh: sub.toJSON().keys?.p256dh || '',
                    auth: sub.toJSON().keys?.auth || ''
                  }
                }
              }
            }).catch((err) => console.warn('Failed to send push subscription to backend API:', err))
          }
        } catch (err) {
          console.warn('Push manager subscription warning:', err)
        }
      }

      await sendTestNotification('Notifications Enabled! 🎉', 'Mobile & Desktop notifications are now active on Ads Platform.')
      return true
    } else if (perm === 'denied') {
      alert("Notification permission is DENIED.\n\nTo fix on Android:\n1. Tap Lock/Tune icon next to URL\n2. Change Notifications to ALLOW\n3. Check Android Settings > Apps > Chrome > Notifications is ON.")
      return false
    }

    return false
  }

  const sendTestNotification = async (title: string, body: string, url = '/') => {
    if (import.meta.server || permission.value !== 'granted') return

    const options = {
      body,
      icon: '/ads-platform.png',
      badge: '/ads-platform.png',
      vibrate: [200, 100, 200],
      data: { url }
    }

    // Service Worker method (Mobile Chrome & iOS)
    if ('serviceWorker' in navigator) {
      try {
        const reg = swRegistration.value || (await navigator.serviceWorker.ready)
        if (reg && 'showNotification' in reg) {
          await reg.showNotification(title, options)
          return
        }
      } catch (e) {
        console.warn('SW showNotification failed, trying fallback:', e)
      }
    }

    // Fallback for Desktop
    try {
      new Notification(title, options)
    } catch (e) {
      console.error('Desktop Notification fallback error:', e)
    }
  }

  onMounted(() => {
    checkStatus()
    initServiceWorker()
  })

  return {
    permission,
    isIOS,
    isStandalone,
    isSubscribed,
    requestAndSubscribe,
    sendTestNotification
  }
}
