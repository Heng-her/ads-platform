CREATE TABLE IF NOT EXISTS `withdrawals` (
	`id` text PRIMARY KEY NOT NULL,
	`creator_id` text NOT NULL,
	`creator_name` text NOT NULL,
	`creator_email` text NOT NULL,
	`creator_avatar` text,
	`amount` real NOT NULL,
	`adsense_share` real DEFAULT 0 NOT NULL,
	`adsterra_share` real DEFAULT 0 NOT NULL,
	`method` text DEFAULT 'Web3 ETH Transfer' NOT NULL,
	`wallet_address` text NOT NULL,
	`network` text DEFAULT 'Arbitrum One' NOT NULL,
	`token` text DEFAULT 'ETH' NOT NULL,
	`crypto_amount` text NOT NULL,
	`status` text DEFAULT 'PENDING' NOT NULL,
	`tx_hash` text,
	`rejection_reason` text,
	`created_at` integer NOT NULL
);
