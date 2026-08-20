import { useApi } from '~/composables/useApi'
import { useAppToast } from '~/composables/useAppToast'
import { useGoogleIdentity } from '~/composables/useGoogleIdentity'

export function useGoogleSubscribe() {
  const api = useApi()
  const toast = useAppToast()
  const { promptOneTap } = useGoogleIdentity()

  function parseEmailFromIdToken(idToken: string): string | null {
    try {
      const base64Url = idToken.split('.')[1]
      if (!base64Url) return null
      const base64 = base64Url.replace(/-/g, '+').replace(/_/g, '/')
      const jsonPayload = decodeURIComponent(
        atob(base64)
          .split('')
          .map((c) => '%' + ('00' + c.charCodeAt(0).toString(16)).slice(-2))
          .join('')
      )
      const parsed = JSON.parse(jsonPayload)
      return parsed.email || null
    } catch {
      return null
    }
  }

  async function subscribeWithEmail(targetEmail: string) {
    if (!targetEmail || !targetEmail.includes('@')) {
      toast.error('Invalid Email', 'Please enter a valid email address.')
      return
    }

    try {
      const res = await api.action.$post({
        json: {
          action: 'subscribers/subscribe',
          data: {
            email: targetEmail.trim(),
            source: 'GOOGLE_ONE_TAP'
          }
        }
      })
      const result: any = await res.json()
      if (res.ok && result.code === 1) {
        toast.success('Subscribed Successfully!', result.msg || 'Thank you for subscribing to updates.')
        if (import.meta.client) {
          localStorage.setItem('platform_subscribed', 'true')
        }
      } else {
        toast.error('Subscription Failed', result.msg || 'Could not subscribe.')
      }
    } catch (err: any) {
      toast.error('Error', err.message || 'An unexpected error occurred.')
    }
  }

  async function handleGoogleCredential(idToken: string) {
    const extractedEmail = parseEmailFromIdToken(idToken)
    if (extractedEmail) {
      await subscribeWithEmail(extractedEmail)
    }
  }

  function triggerGoogleSubscribe() {
    if (import.meta.client) {
      const isAlreadySubscribed = localStorage.getItem('platform_subscribed') === 'true'
      if (!isAlreadySubscribed) {
        void promptOneTap(handleGoogleCredential)
      }
    }
  }

  return {
    triggerGoogleSubscribe,
    subscribeWithEmail,
    handleGoogleCredential
  }
}
