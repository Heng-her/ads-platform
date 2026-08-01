<template>
  <section class="max-w-6xl mx-auto space-y-12">
    <div class="text-center max-w-3xl mx-auto space-y-3">
      <UBadge color="primary" variant="subtle" class="font-mono text-xs uppercase">Decentralized Ad Infrastructure</UBadge>
      <h2 class="text-3xl sm:text-4xl font-extrabold text-gray-900 dark:text-white">
        Why Web3 Advertising Outperforms Traditional Networks
      </h2>
      <p class="text-sm sm:text-base text-gray-600 dark:text-gray-400">
        Eliminate blackbox network markups, fake click fraud, and 90-day payment delays with smart contract automation.
      </p>
    </div>

    <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
      <div class="p-6 rounded-2xl bg-white dark:bg-gray-900 border border-gray-200 dark:border-gray-800 space-y-4 hover:border-emerald-500/40 transition-colors">
        <div class="w-12 h-12 rounded-xl bg-emerald-500/10 text-emerald-500 flex items-center justify-center">
          <UIcon name="i-heroicons-lock-closed" class="w-6 h-6" />
        </div>
        <h3 class="text-lg font-bold text-gray-900 dark:text-white">Non-Custodial Ad Escrow</h3>
        <p class="text-xs text-gray-600 dark:text-gray-400 leading-relaxed">
          Campaign funds stay locked inside audited smart contract escrows. You maintain 100% wallet ownership and can pause or withdraw remaining budget at any time.
        </p>
      </div>

      <div class="p-6 rounded-2xl bg-white dark:bg-gray-900 border border-gray-200 dark:border-gray-800 space-y-4 hover:border-emerald-500/40 transition-colors">
        <div class="w-12 h-12 rounded-xl bg-teal-500/10 text-teal-500 flex items-center justify-center">
          <UIcon name="i-heroicons-shield-check" class="w-6 h-6" />
        </div>
        <h3 class="text-lg font-bold text-gray-900 dark:text-white">Cryptographic Fraud Protection</h3>
        <p class="text-xs text-gray-600 dark:text-gray-400 leading-relaxed">
          Every impression and click is validated via cryptographic Merkle proofs and decentralized verification nodes before escrow funds are micro-released.
        </p>
      </div>

      <div class="p-6 rounded-2xl bg-white dark:bg-gray-900 border border-gray-200 dark:border-gray-800 space-y-4 hover:border-emerald-500/40 transition-colors">
        <div class="w-12 h-12 rounded-xl bg-cyan-500/10 text-cyan-500 flex items-center justify-center">
          <UIcon name="i-heroicons-bolt" class="w-6 h-6" />
        </div>
        <h3 class="text-lg font-bold text-gray-900 dark:text-white">Instant Publisher Settlement</h3>
        <p class="text-xs text-gray-600 dark:text-gray-400 leading-relaxed">
          Publishers and creators receive programmatic payout streams directly to their crypto wallets as ad events occur—replacing 60-day payout cycles.
        </p>
      </div>
    </div>
  </section>
</template>
