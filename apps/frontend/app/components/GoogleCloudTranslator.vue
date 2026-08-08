<template>
  <ClientOnly>
    <div v-if="isTranslating"
      class="fixed bottom-5 left-1/2 z-[9999] flex -translate-x-1/2 items-center gap-2 rounded-full bg-[#0F75BC] px-4 py-2 text-sm font-medium text-white shadow-lg"
      data-no-google-translate role="status" aria-live="polite">
      <span class="inline-block h-4 w-4 animate-spin rounded-full border-2 border-white border-t-transparent"
        aria-hidden="true" />
      <span>Translating...</span>
    </div>
  </ClientOnly>
</template>

<script setup lang="ts">
import { ref, computed, watch, onMounted, onUnmounted } from 'vue'

const route = useRoute()
const localeCookie = useCookie<string>('locale', { default: () => 'en' })
const articleLocaleCookie = useCookie<string>('article-locale', { default: () => 'en' })
const isTranslating = ref(false)

const targetLanguage = computed(() => {
  const queryLang = route.query.locale as string
  if (queryLang) return queryLang
  if (localeCookie.value && localeCookie.value !== 'en') return localeCookie.value
  if (articleLocaleCookie.value && articleLocaleCookie.value !== 'en') return articleLocaleCookie.value
  return localeCookie.value || 'en'
})

const ATTRIBUTES_TO_TRANSLATE = ["placeholder", "title", "aria-label"] as const
const BATCH_SIZE = 80
const DEBOUNCE_MS = 250
const TEXT_CACHE = new Map<string, string>()
const originalTextValues = new WeakMap<Text, string>()
const originalAttributeValues = new WeakMap<Element, Partial<Record<(typeof ATTRIBUTES_TO_TRANSLATE)[number], string>>>()

// ============================================================================
// IndexedDB Persistent Storage Engine for Fast Refresh & Instant Load
// ============================================================================
const DB_NAME = "translation_cache_db"
const STORE_NAME = "translations"
const DB_VERSION = 1

function openTranslationDb(): Promise<IDBDatabase> {
  return new Promise((resolve, reject) => {
    if (typeof window === "undefined" || !("indexedDB" in window)) {
      return reject(new Error("IndexedDB not supported"))
    }
    const request = indexedDB.open(DB_NAME, DB_VERSION)

    request.onupgradeneeded = () => {
      const db = request.result
      if (!db.objectStoreNames.contains(STORE_NAME)) {
        db.createObjectStore(STORE_NAME)
      }
    }

    request.onsuccess = () => resolve(request.result)
    request.onerror = () => reject(request.error)
  })
}

async function loadFromIndexedDbKeys(keys: string[]): Promise<Map<string, string>> {
  const result = new Map<string, string>()
  if (keys.length === 0) return result
  try {
    const db = await openTranslationDb()
    const tx = db.transaction(STORE_NAME, "readonly")
    const store = tx.objectStore(STORE_NAME)

    await Promise.all(
      keys.map(
        (key) =>
          new Promise<void>((resolve) => {
            const req = store.get(key)
            req.onsuccess = () => {
              if (req.result) {
                result.set(key, req.result)
              }
              resolve()
            }
            req.onerror = () => resolve()
          })
      )
    )
  } catch {
    // Fallback gracefully if IndexedDB is restricted or unavailable
  }
  return result
}

async function saveToIndexedDbEntries(entries: Map<string, string>): Promise<void> {
  if (entries.size === 0) return
  try {
    const db = await openTranslationDb()
    const tx = db.transaction(STORE_NAME, "readwrite")
    const store = tx.objectStore(STORE_NAME)

    entries.forEach((value, key) => {
      store.put(value, key)
    })
  } catch {
    // Fallback gracefully
  }
}

let timeoutId: ReturnType<typeof setTimeout> | null = null
let requestId = 0
let observer: MutationObserver | null = null

function shouldSkipElement(element: Element | null) {
  if (!element) return true

  return Boolean(
    element.closest(
      [
        "script",
        "style",
        "noscript",
        "textarea",
        "select",
        "option",
        "pre",
        "code",
        "kbd",
        "samp",
        "svg",
        "[contenteditable='true']",
        "[translate='no']",
        "[data-no-google-translate]",
        ".notranslate",
      ].join(",")
    )
  )
}

function isMeaningfulText(value: string) {
  const text = value.trim()

  if (text.length < 2) return false
  if (/^[\d\s.,:;!?'"`~@#$%^&*()[\]{}+=/_\\|-]+$/.test(text)) return false
  if (/^(https?:\/\/|mailto:|tel:)/i.test(text)) return false

  return true
}

function decodeHtmlEntities(value: string) {
  if (typeof document === "undefined") return value
  const textarea = document.createElement("textarea")
  textarea.innerHTML = value
  return textarea.value
}

function collectTextNodes(root: ParentNode) {
  const nodes: Text[] = []
  const walker = document.createTreeWalker(root, NodeFilter.SHOW_TEXT, {
    acceptNode(node) {
      const parent = node.parentElement

      if (shouldSkipElement(parent) || !isMeaningfulText(node.nodeValue || "")) {
        return NodeFilter.FILTER_REJECT
      }

      return NodeFilter.FILTER_ACCEPT
    },
  })

  let currentNode = walker.nextNode()

  while (currentNode) {
    nodes.push(currentNode as Text)
    currentNode = walker.nextNode()
  }

  return nodes
}

function collectAttributeElements(root: ParentNode) {
  const elements = Array.from(root.querySelectorAll<HTMLElement>(ATTRIBUTES_TO_TRANSLATE.map((attr) => `[${attr}]`).join(",")))

  return elements.filter((element) => !shouldSkipElement(element))
}

async function fetchClientTranslate(texts: string[], target: string): Promise<string[]> {
  if (texts.length === 0) return []

  const normTarget = target === "zh" ? "zh-CN" : target

  // Attempt 1: Direct browser Google Translate batch request
  try {
    const url = new URL("https://translate.googleapis.com/translate_a/single")
    url.searchParams.set("client", "gtx")
    url.searchParams.set("sl", "auto")
    url.searchParams.set("tl", normTarget)
    url.searchParams.set("dt", "t")
    url.searchParams.set("q", texts.join("\n"))

    const res = await fetch(url.toString())
    if (res.ok) {
      const data = await res.json()
      const sentences = data[0] || []
      const results = texts.map((text, index) => {
        const sentence = sentences[index]
        const translated = sentence && sentence[0] ? sentence[0].replace(/\n$/, "").trim() : text
        return translated || text
      })
      if (results.length === texts.length) {
        return results
      }
    }
  } catch {
    // Fall through to MyMemory backup
  }

  // Attempt 2: MyMemory API fallback
  try {
    const results = await Promise.all(
      texts.map(async (text) => {
        try {
          const res = await fetch(
            `https://api.mymemory.translated.net/get?q=${encodeURIComponent(text)}&langpair=auto|${normTarget}`
          )
          if (!res.ok) return text
          const data = await res.json()
          const translated = data?.responseData?.translatedText
          return translated && typeof translated === "string" ? translated : text
        } catch {
          return text
        }
      })
    )
    return results
  } catch {
    return texts
  }
}

async function translateTexts(texts: string[], target: string) {
  const translations = new Map<string, string>()
  const keysNeeded = Array.from(new Set(texts.map((t) => `${target}:${t}`)))

  // 1. Check in-memory cache first
  const missingKeysForMem = keysNeeded.filter((key) => !TEXT_CACHE.has(key))

  // 2. Load missing keys from IndexedDB if available
  if (missingKeysForMem.length > 0) {
    const dbResults = await loadFromIndexedDbKeys(missingKeysForMem)
    dbResults.forEach((val, key) => {
      TEXT_CACHE.set(key, val)
    })
  }

  // 3. Determine remaining texts that still need API translation
  const missingTexts = Array.from(new Set(texts.filter((text) => !TEXT_CACHE.has(`${target}:${text}`))))

  // 4. If any texts are missing, translate via API in background batches and save to IndexedDB
  if (missingTexts.length > 0) {
    const newDbEntries = new Map<string, string>()
    for (let index = 0; index < missingTexts.length; index += BATCH_SIZE) {
      const batch = missingTexts.slice(index, index + BATCH_SIZE)
      let translatedBatch: string[] = []

      try {
        const data = await $fetch<{ translations?: string[]; error?: string }>("/api/translate", {
          method: "POST",
          body: {
            texts: batch,
            target,
          },
        })

        if (Array.isArray(data?.translations) && data.translations.length === batch.length) {
          translatedBatch = data.translations
        }
      } catch (error) {
        console.warn("Server translation endpoint unavailable, using client-side fallback:", error)
      }

      // If server API failed or returned untranslated results, use browser direct fallback
      if (translatedBatch.length === 0 || (target !== "en" && translatedBatch.every((t, i) => t === batch[i]))) {
        translatedBatch = await fetchClientTranslate(batch, target)
      }

      batch.forEach((text, batchIndex) => {
        const translated = decodeHtmlEntities(translatedBatch[batchIndex] || text)
        const cacheKey = `${target}:${text}`
        TEXT_CACHE.set(cacheKey, translated)
        newDbEntries.set(cacheKey, translated)
      })
    }

    if (newDbEntries.size > 0) {
      void saveToIndexedDbEntries(newDbEntries)
    }
  }

  texts.forEach((text) => {
    translations.set(text, TEXT_CACHE.get(`${target}:${text}`) || text)
  })

  return translations
}

function restoreOriginalText(root: ParentNode) {
  collectTextNodes(root).forEach((node) => {
    const originalValue = originalTextValues.get(node)

    if (originalValue) {
      node.nodeValue = originalValue
    }
  })

  collectAttributeElements(root).forEach((element) => {
    const originalAttributes = originalAttributeValues.get(element)

    ATTRIBUTES_TO_TRANSLATE.forEach((attribute) => {
      const originalValue = originalAttributes?.[attribute]

      if (originalValue) {
        element.setAttribute(attribute, originalValue)
      }
    })
  })
}

async function translatePage() {
  if (typeof document === "undefined") return

  const currentRequestId = ++requestId
  const targetLang = targetLanguage.value || "en"
  const root = document.body

  if (targetLang === "en") {
    restoreOriginalText(root)
    isTranslating.value = false
    return
  }

  const textNodes = collectTextNodes(root)
  const attributeElements = collectAttributeElements(root)
  const sourceValues: string[] = []

  textNodes.forEach((node) => {
    if (!originalTextValues.has(node)) {
      originalTextValues.set(node, node.nodeValue || "")
    }

    const originalValue = originalTextValues.get(node) || ""

    if (isMeaningfulText(originalValue)) {
      sourceValues.push(originalValue.trim())
    }
  })

  attributeElements.forEach((element) => {
    const storedAttributes = originalAttributeValues.get(element) || {}

    ATTRIBUTES_TO_TRANSLATE.forEach((attribute) => {
      const value = element.getAttribute(attribute)

      if (!value || !isMeaningfulText(value)) return

      if (!storedAttributes[attribute]) {
        storedAttributes[attribute] = value
      }

      sourceValues.push(storedAttributes[attribute]!.trim())
    })

    originalAttributeValues.set(element, storedAttributes)
  })

  if (sourceValues.length === 0) {
    isTranslating.value = false
    return
  }

  try {
    // Only show translating indicator if there are texts missing in cache
    const uncachedTexts = sourceValues.filter((text) => !TEXT_CACHE.has(`${targetLang}:${text}`))
    if (uncachedTexts.length > 0) {
      isTranslating.value = true
    }

    if (typeof document !== "undefined") {
      document.documentElement.lang = targetLang
    }

    if (typeof document !== "undefined" && document.title && isMeaningfulText(document.title)) {
      sourceValues.push(document.title.trim())
    }

    const translations = await translateTexts(sourceValues, targetLang)

    if (currentRequestId !== requestId) return

    if (typeof document !== "undefined" && document.title) {
      const translatedTitle = translations.get(document.title.trim())
      if (translatedTitle) {
        document.title = translatedTitle
      }
    }

    textNodes.forEach((node) => {
      const originalValue = originalTextValues.get(node) || ""
      const translatedValue = translations.get(originalValue.trim())

      if (translatedValue) {
        node.nodeValue = originalValue.replace(originalValue.trim(), translatedValue)
      }
    })

    attributeElements.forEach((element) => {
      const originalAttributes = originalAttributeValues.get(element)

      ATTRIBUTES_TO_TRANSLATE.forEach((attribute) => {
        const originalValue = originalAttributes?.[attribute]
        const translatedValue = originalValue ? translations.get(originalValue.trim()) : ""

        if (translatedValue) {
          element.setAttribute(attribute, translatedValue)
        }
      })
    })
  } catch (error) {
    console.error("Page translation error:", error)
  } finally {
    if (currentRequestId === requestId) {
      isTranslating.value = false
    }
  }
}

function scheduleTranslation() {
  if (timeoutId) {
    clearTimeout(timeoutId)
  }

  timeoutId = setTimeout(() => {
    void translatePage()
  }, DEBOUNCE_MS)
}

onMounted(() => {
  scheduleTranslation()

  observer = new MutationObserver((mutations) => {
    const hasNewNodes = mutations.some((mutation) =>
      Array.from(mutation.addedNodes).some((node) => {
        if (node.nodeType === Node.TEXT_NODE) {
          return !shouldSkipElement(node.parentElement)
        }

        if (node.nodeType === Node.ELEMENT_NODE) {
          return !shouldSkipElement(node as Element)
        }

        return false
      })
    )

    if (hasNewNodes) {
      scheduleTranslation()
    }
  })

  observer.observe(document.body, {
    childList: true,
    subtree: true,
  })
})

watch(targetLanguage, () => {
  scheduleTranslation()
})

onUnmounted(() => {
  if (observer) {
    observer.disconnect()
  }
  if (timeoutId) {
    clearTimeout(timeoutId)
  }
})
</script>
