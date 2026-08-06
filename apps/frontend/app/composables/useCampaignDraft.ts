import type { CampaignImageItem } from './useCampaigns'

export interface CampaignDraftForm {
  title: string
  description: string
  category: string
  contentType: string
  content: string
  imageUrl: string
  imageTitle: string
  imageDescription: string
  images: CampaignImageItem[]
  videoUrls: string[]
  adNetwork: string
  adUnitCode: string
  status: 'DRAFT' | 'PUBLIC'
}

interface CampaignDraftRecord {
  key: string
  updatedAt: number
  form: CampaignDraftForm
}

const DATABASE_NAME = 'ads-platform-drafts'
const DATABASE_VERSION = 1
const STORE_NAME = 'campaign-drafts'

function isIndexedDbAvailable() {
  return import.meta.client && typeof window.indexedDB !== 'undefined'
}

function requestResult<T>(request: IDBRequest<T>) {
  return new Promise<T>((resolve, reject) => {
    request.onsuccess = () => resolve(request.result)
    request.onerror = () => reject(request.error)
  })
}

function openDatabase() {
  return new Promise<IDBDatabase>((resolve, reject) => {
    const request = window.indexedDB.open(DATABASE_NAME, DATABASE_VERSION)

    request.onupgradeneeded = () => {
      if (!request.result.objectStoreNames.contains(STORE_NAME)) {
        request.result.createObjectStore(STORE_NAME, { keyPath: 'key' })
      }
    }
    request.onsuccess = () => resolve(request.result)
    request.onerror = () => reject(request.error)
  })
}

export function useCampaignDraft() {
  async function getDraft(key: string) {
    if (!isIndexedDbAvailable()) return null

    let database: IDBDatabase | undefined
    try {
      database = await openDatabase()
      const transaction = database.transaction(STORE_NAME, 'readonly')
      const record = await requestResult<CampaignDraftRecord | undefined>(
        transaction.objectStore(STORE_NAME).get(key),
      )
      return record?.form || null
    } catch (error) {
      console.warn('[CampaignDraft] Failed to read draft:', error)
      return null
    } finally {
      database?.close()
    }
  }

  async function saveDraft(key: string, form: CampaignDraftForm) {
    if (!isIndexedDbAvailable()) return false

    let database: IDBDatabase | undefined
    try {
      database = await openDatabase()
      const transaction = database.transaction(STORE_NAME, 'readwrite')
      transaction.objectStore(STORE_NAME).put({
        key,
        updatedAt: Date.now(),
        form: JSON.parse(JSON.stringify(form)) as CampaignDraftForm,
      } satisfies CampaignDraftRecord)
      await new Promise<void>((resolve, reject) => {
        transaction.oncomplete = () => resolve()
        transaction.onerror = () => reject(transaction.error)
        transaction.onabort = () => reject(transaction.error)
      })
      return true
    } catch (error) {
      console.warn('[CampaignDraft] Failed to save draft:', error)
      return false
    } finally {
      database?.close()
    }
  }

  async function removeDraft(key: string) {
    if (!isIndexedDbAvailable()) return false

    let database: IDBDatabase | undefined
    try {
      database = await openDatabase()
      const transaction = database.transaction(STORE_NAME, 'readwrite')
      transaction.objectStore(STORE_NAME).delete(key)
      await new Promise<void>((resolve, reject) => {
        transaction.oncomplete = () => resolve()
        transaction.onerror = () => reject(transaction.error)
        transaction.onabort = () => reject(transaction.error)
      })
      return true
    } catch (error) {
      console.warn('[CampaignDraft] Failed to remove draft:', error)
      return false
    } finally {
      database?.close()
    }
  }

  return {
    getDraft,
    saveDraft,
    removeDraft,
  }
}