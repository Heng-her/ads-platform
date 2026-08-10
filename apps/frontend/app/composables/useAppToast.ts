import { ref } from 'vue'

export interface ToastItem {
  id: string
  title: string
  description?: string
  type?: 'success' | 'error' | 'info' | 'warning'
  duration?: number
}

const toasts = ref<ToastItem[]>([])

export function useAppToast() {
  function add(toast: Omit<ToastItem, 'id'>) {
    const id = Math.random().toString(36).substring(2, 9)
    const duration = toast.duration ?? 3500

    const item: ToastItem = {
      id,
      type: toast.type || 'info',
      ...toast
    }

    toasts.value.push(item)

    if (duration > 0) {
      setTimeout(() => {
        remove(id)
      }, duration)
    }
    return id
  }

  function remove(id: string) {
    const idx = toasts.value.findIndex((t) => t.id === id)
    if (idx !== -1) {
      toasts.value.splice(idx, 1)
    }
  }

  function success(title: string, description?: string) {
    return add({ title, description, type: 'success' })
  }

  function error(title: string, description?: string) {
    return add({ title, description, type: 'error' })
  }

  function info(title: string, description?: string) {
    return add({ title, description, type: 'info' })
  }

  function warning(title: string, description?: string) {
    return add({ title, description, type: 'warning' })
  }

  return {
    toasts,
    add,
    remove,
    success,
    error,
    info,
    warning
  }
}
