export default defineNuxtRouteMiddleware((to) => {
  const isAdminOrCreator = to.path.startsWith('/admin') || to.path.startsWith('/creator')
  if (!isAdminOrCreator) {
    to.meta.colorMode = 'light'
  }
})

