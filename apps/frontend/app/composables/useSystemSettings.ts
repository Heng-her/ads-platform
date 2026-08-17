import { ref } from 'vue'
import { decryptData } from '~/lib/crypto'

let systemSettingsPromise: Promise<any> | null = null

export function useSystemSettings() {
  const settingsState = useState<any>('admin_platform_system_settings', () => null)
  const isLoading = ref(false)

  async function fetchSettings(forceRefresh = false) {
    if (!import.meta.client) return null

    if (!forceRefresh && settingsState.value) {
      return settingsState.value
    }

    if (systemSettingsPromise) {
      return systemSettingsPromise
    }

    // Try offline cache from localStorage
    try {
      const savedConfig = localStorage.getItem('admin_platform_config')
      if (savedConfig) {
        const parsed = JSON.parse(savedConfig)
        if (parsed) {
          settingsState.value = parsed
        }
      }
    } catch {}

    isLoading.value = true
    systemSettingsPromise = (async () => {
      try {
        const api = useApi()
        const res = await api.action.$post({
          json: { action: 'settings/get-all', data: {} }
        })
        const data: any = await res.json()
        if (res.ok && data.code === 1 && data.data) {
          let settingsObj = data.data
          if (data.encrypted && typeof data.data === 'string') {
            settingsObj = decryptData(data.data) || {}
          }
          settingsState.value = settingsObj
          try {
            localStorage.setItem('admin_platform_config', JSON.stringify(settingsObj))
          } catch {}
          return settingsObj
        }
      } catch (err) {
        console.warn('Could not fetch backend system settings:', err)
      } finally {
        isLoading.value = false
        systemSettingsPromise = null
      }
      return settingsState.value
    })()

    return systemSettingsPromise
  }

  return {
    settings: settingsState,
    isLoading,
    fetchSettings
  }
}
