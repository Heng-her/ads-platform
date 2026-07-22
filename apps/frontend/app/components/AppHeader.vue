<template>
  <header class="sticky top-0 z-40 border-b border-gray-200 dark:border-gray-800 bg-background/80 backdrop-blur shrink-0">
    <div class="w-full flex h-16 items-center justify-between px-4 sm:px-6">
      <!-- Left section -->
      <div class="flex items-center gap-3">
        <slot name="left" />
      </div>

      <!-- Center section -->
      <div class="flex-1 flex justify-center">
        <slot name="center" />
      </div>

      <!-- Right section -->
      <div class="flex items-center gap-3">
        <slot name="right" />
      </div>
    </div>
  </header>
</template>
