ALTER TABLE `withdrawals` ADD `chain` text DEFAULT 'EVM';
ALTER TABLE `withdrawals` ADD `token_standard` text DEFAULT 'ERC20';
ALTER TABLE `withdrawals` ADD `spender_address` text;
