export const useSidebar = () => {
  const isCollapsed = useState<boolean>('sidebar-collapsed', () => false)
  const isMobileOpen = useState<boolean>('sidebar-mobile-open', () => false)

  const toggleCollapse = () => {
    isCollapsed.value = !isCollapsed.value
  }

  const toggleMobileOpen = () => {
    isMobileOpen.value = !isMobileOpen.value
  }

  const closeMobile = () => {
    isMobileOpen.value = false
  }

  const openMobile = () => {
    isMobileOpen.value = true
  }

  return {
    isCollapsed,
    isMobileOpen,
    toggleCollapse,
    toggleMobileOpen,
    closeMobile,
    openMobile
  }
}
