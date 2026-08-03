<template>
  <section class="max-w-6xl mx-auto border-y border-gray-200 dark:border-gray-800/80 py-10">
    <div class="text-center space-y-4">
      <span class="text-xs font-semibold uppercase tracking-widest text-gray-400 dark:text-gray-500">
        Compatible Execution Chains & Non-Custodial Wallets
      </span>
      <div
        class="flex flex-wrap items-center justify-center gap-8 sm:gap-12 opacity-80 grayscale hover:grayscale-0 transition-all duration-300">
        <div class="flex items-center gap-2 text-sm font-semibold text-gray-700 dark:text-gray-300">
          <UIcon name="i-simple-icons-ethereum" class="w-5 h-5 text-indigo-400" />
          <span>Ethereum Mainnet</span>
        </div>
        <div class="flex items-center gap-2 text-sm font-semibold text-gray-700 dark:text-gray-300">
          <UIcon name="i-heroicons-bolt" class="w-5 h-5 text-cyan-400" />
          <span>Arbitrum One</span>
        </div>
        <div class="flex items-center gap-2 text-sm font-semibold text-gray-700 dark:text-gray-300">
          <UIcon name="i-heroicons-square-3-stack-3d" class="w-5 h-5 text-blue-500" />
          <span>Base L2</span>
        </div>
        <div class="flex items-center gap-2 text-sm font-semibold text-gray-700 dark:text-gray-300">
          <UIcon name="i-simple-icons-polygon" class="w-5 h-5 text-purple-400" />
          <span>Polygon PoS</span>
        </div>
        <div class="flex items-center gap-2 text-sm font-semibold text-gray-700 dark:text-gray-300">
          <UIcon name="i-simple-icons-walletconnect" class="w-5 h-5 text-blue-400" />
          <span>WalletConnect v2</span>
        </div>
      </div>
    </div>
  </section>
</template>
