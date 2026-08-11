import { ref } from 'vue'

export function useClipboard(resetDelayMs = 2000) {
  const isCopied = ref(false)
  const copiedId = ref<string | null>(null)
  let timer: ReturnType<typeof setTimeout> | null = null

  async function copy(text: string, id?: string): Promise<boolean> {
    if (typeof window === 'undefined' || !navigator.clipboard) return false

    try {
      await navigator.clipboard.writeText(text)
      isCopied.value = true
      if (id) copiedId.value = id

      if (timer) clearTimeout(timer)
      timer = setTimeout(() => {
        isCopied.value = false
        if (id && copiedId.value === id) copiedId.value = null
      }, resetDelayMs)

      return true
    } catch {
      return false
    }
  }

  return {
    isCopied,
    copiedId,
    copy,
  }
}
