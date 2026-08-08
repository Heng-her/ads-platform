<template>
  <ClientOnly>
    <div
      v-if="isTranslating"
      class="fixed bottom-5 left-1/2 z-[9999] flex -translate-x-1/2 items-center gap-2 rounded-full bg-[#0F75BC] px-4 py-2 text-sm font-medium text-white shadow-lg"
      data-no-google-translate
      role="status"
      aria-live="polite"
    >
      <span class="inline-block h-4 w-4 animate-spin rounded-full border-2 border-white border-t-transparent" aria-hidden="true" />
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

async function translateTexts(texts: string[], target: string) {
  const translations = new Map<string, string>()
  const missingTexts = Array.from(new Set(texts.filter((text) => !TEXT_CACHE.has(`${target}:${text}`))))

  for (let index = 0; index < missingTexts.length; index += BATCH_SIZE) {
    const batch = missingTexts.slice(index, index + BATCH_SIZE)
    try {
      const data = await $fetch<{ translations?: string[]; error?: string }>("/api/translate", {
        method: "POST",
        body: {
          texts: batch,
          target,
        },
      })

      if (data.error) {
        throw new Error(data.error)
      }

      batch.forEach((text, batchIndex) => {
        TEXT_CACHE.set(`${target}:${text}`, decodeHtmlEntities(data.translations?.[batchIndex] || text))
      })
    } catch (error) {
      console.error("Translation batch failed:", error)
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
    isTranslating.value = true
    if (typeof document !== "undefined") {
      document.documentElement.lang = targetLang
    }

    // Translate page title and head meta tags if present
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
