<template>
  <section class="max-w-6xl mx-auto space-y-8">
    <div class="text-center max-w-3xl mx-auto space-y-3">
      <UBadge color="neutral" variant="outline" class="font-mono text-xs uppercase">Engineering Milestones</UBadge>
      <h2 class="text-3xl sm:text-4xl font-extrabold text-gray-900 dark:text-white">
        Protocol Development Roadmap
      </h2>
      <p class="text-sm text-gray-600 dark:text-gray-400">
        Transparent execution milestones from testnet core to cross-chain DAO governance.
      </p>
    </div>

    <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
      <div class="p-5 rounded-xl bg-white dark:bg-gray-900 border border-emerald-500/40 space-y-2">
        <UBadge color="success" size="xs">Phase 1 • Live</UBadge>
        <h3 class="text-sm font-bold text-gray-900 dark:text-white">Smart Escrow Core</h3>
        <p class="text-xs text-gray-600 dark:text-gray-400 leading-relaxed">
          Arbitrum testnet smart contracts, wallet connection SDK, and basic impression logging.
        </p>
      </div>

      <div class="p-5 rounded-xl bg-white dark:bg-gray-900 border border-gray-200 dark:border-gray-800 space-y-2">
        <UBadge color="neutral" variant="subtle" size="xs">Phase 2 • Q3 2026</UBadge>
        <h3 class="text-sm font-bold text-gray-900 dark:text-white">Multi-Chain Layer 2</h3>
        <p class="text-xs text-gray-600 dark:text-gray-400 leading-relaxed">
          Base, Polygon PoS integration with cross-chain escrow messaging using CCIP.
        </p>
      </div>

      <div class="p-5 rounded-xl bg-white dark:bg-gray-900 border border-gray-200 dark:border-gray-800 space-y-2">
        <UBadge color="neutral" variant="subtle" size="xs">Phase 3 • Q4 2026</UBadge>
        <h3 class="text-sm font-bold text-gray-900 dark:text-white">ZK Fraud Proof Engine</h3>
        <p class="text-xs text-gray-600 dark:text-gray-400 leading-relaxed">
          Zero-Knowledge proof verification for privacy-preserving ad impression fraud protection.
        </p>
      </div>

      <div class="p-5 rounded-xl bg-white dark:bg-gray-900 border border-gray-200 dark:border-gray-800 space-y-2">
        <UBadge color="neutral" variant="subtle" size="xs">Phase 4 • 2027</UBadge>
        <h3 class="text-sm font-bold text-gray-900 dark:text-white">DAO Governance</h3>
        <p class="text-xs text-gray-600 dark:text-gray-400 leading-relaxed">
          Transition platform parameters, fee schedules, and validator registry to decentralized token governance.
        </p>
      </div>
    </div>
  </section>
</template>
