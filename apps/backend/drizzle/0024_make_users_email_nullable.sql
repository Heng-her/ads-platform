-- Make users.email nullable so Web3 wallet-registered users store NULL instead of a fake email.
--
-- D1 cannot disable foreign keys (PRAGMA foreign_keys=OFF is ignored), so ON DELETE
-- CASCADE fires on DROP TABLE. To avoid silently wiping data, this migration uses the
-- Detach -> Rebuild -> Reattach pattern:
--   1. Detach deepest cascade children first, demoting their FKs to NO ACTION.
--   2. Rebuild the users table (email nullable) and backfill existing web3 emails to NULL.
--   3. Reattach children in reverse order, restoring ON DELETE CASCADE.

PRAGMA defer_foreign_keys = ON;

--> statement-breakpoint
-- ── DETACH (deepest first) ─────────────────────────────────────────────────────
-- 1. impressions (child of campaigns)
CREATE TABLE `__impressions_detach` (
	`id` TEXT NOT NULL PRIMARY KEY,
	`campaign_id` TEXT NOT NULL REFERENCES `campaigns`(`id`) ON UPDATE no action ON DELETE no action,
	`viewer_hash` TEXT NOT NULL,
	`created_at` INTEGER NOT NULL
);
--> statement-breakpoint
INSERT INTO `__impressions_detach` (`id`, `campaign_id`, `viewer_hash`, `created_at`)
SELECT `id`, `campaign_id`, `viewer_hash`, `created_at` FROM `impressions`;
--> statement-breakpoint
DROP TABLE `impressions`;
--> statement-breakpoint
ALTER TABLE `__impressions_detach` RENAME TO `impressions`;
--> statement-breakpoint
CREATE INDEX `idx_impressions_campaign_id` ON `impressions` (`campaign_id`);
--> statement-breakpoint
CREATE INDEX `idx_impressions_campaign_viewer` ON `impressions` (`campaign_id`, `viewer_hash`);

--> statement-breakpoint
-- 2. campaign_translations (child of campaigns)
CREATE TABLE `__campaign_translations_detach` (
	`id` text PRIMARY KEY NOT NULL,
	`campaign_id` text NOT NULL REFERENCES `campaigns`(`id`) ON UPDATE no action ON DELETE no action,
	`locale` text NOT NULL,
	`title` text NOT NULL,
	`description` text,
	`content` text,
	`image_title` text,
	`image_description` text,
	`provider` text NOT NULL DEFAULT 'google',
	`created_at` integer NOT NULL,
	`updated_at` integer NOT NULL
);
--> statement-breakpoint
INSERT INTO `__campaign_translations_detach` (`id`, `campaign_id`, `locale`, `title`, `description`, `content`, `image_title`, `image_description`, `provider`, `created_at`, `updated_at`)
SELECT `id`, `campaign_id`, `locale`, `title`, `description`, `content`, `image_title`, `image_description`, `provider`, `created_at`, `updated_at` FROM `campaign_translations`;
--> statement-breakpoint
DROP TABLE `campaign_translations`;
--> statement-breakpoint
ALTER TABLE `__campaign_translations_detach` RENAME TO `campaign_translations`;
--> statement-breakpoint
CREATE UNIQUE INDEX `campaign_translations_campaign_locale_idx` ON `campaign_translations` (`campaign_id`, `locale`);
--> statement-breakpoint
CREATE INDEX `campaign_translations_locale_idx` ON `campaign_translations` (`locale`);

--> statement-breakpoint
-- 3. campaigns (child of users; also references custom_categories)
CREATE TABLE `__campaigns_detach` (
	`id` text PRIMARY KEY NOT NULL,
	`user_id` text NOT NULL,
	`title` text NOT NULL,
	`description` text,
	`status` text DEFAULT 'DRAFT' NOT NULL,
	`created_at` integer NOT NULL,
	`updated_at` integer NOT NULL,
	`category` text,
	`content_type` text DEFAULT 'ARTICLE' NOT NULL,
	`content` text,
	`image_url` text,
	`image_title` text,
	`image_description` text,
	`ad_network` text,
	`ad_unit_code` text,
	`is_deleted` INTEGER NOT NULL DEFAULT 0,
	`deleted_at` INTEGER,
	`custom_category_id` INTEGER REFERENCES `custom_categories`(`id`) ON UPDATE no action ON DELETE no action,
	`images` TEXT,
	`video_urls` TEXT,
	FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
INSERT INTO `__campaigns_detach` (`id`, `user_id`, `title`, `description`, `status`, `created_at`, `updated_at`, `category`, `content_type`, `content`, `image_url`, `image_title`, `image_description`, `ad_network`, `ad_unit_code`, `is_deleted`, `deleted_at`, `custom_category_id`, `images`, `video_urls`)
SELECT `id`, `user_id`, `title`, `description`, `status`, `created_at`, `updated_at`, `category`, `content_type`, `content`, `image_url`, `image_title`, `image_description`, `ad_network`, `ad_unit_code`, `is_deleted`, `deleted_at`, `custom_category_id`, `images`, `video_urls` FROM `campaigns`;
--> statement-breakpoint
DROP TABLE `campaigns`;
--> statement-breakpoint
ALTER TABLE `__campaigns_detach` RENAME TO `campaigns`;
--> statement-breakpoint
CREATE INDEX `idx_campaigns_custom_category_id` ON `campaigns` (`custom_category_id`);
--> statement-breakpoint
CREATE INDEX `campaigns_public_feed_idx` ON `campaigns` (`status`, `is_deleted`, `created_at` DESC, `id` DESC);

--> statement-breakpoint
-- 4. custom_categories (child of users)
CREATE TABLE `__custom_categories_detach` (
	`id` INTEGER PRIMARY KEY AUTOINCREMENT,
	`user_id` TEXT NOT NULL,
	`name` TEXT NOT NULL,
	`created_at` INTEGER NOT NULL,
	UNIQUE (`user_id`, `name`)
);
--> statement-breakpoint
INSERT INTO `__custom_categories_detach` (`id`, `user_id`, `name`, `created_at`)
SELECT `id`, `user_id`, `name`, `created_at` FROM `custom_categories`;
--> statement-breakpoint
DROP TABLE `custom_categories`;
--> statement-breakpoint
ALTER TABLE `__custom_categories_detach` RENAME TO `custom_categories`;
--> statement-breakpoint
CREATE INDEX `idx_custom_categories_user_id` ON `custom_categories` (`user_id`);

--> statement-breakpoint
-- ── REBUILD (users with nullable email) ─────────────────────────────────────────
CREATE TABLE `__users_new` (
	`id` text PRIMARY KEY NOT NULL,
	`username` text NOT NULL,
	`email` text,
	`password_hash` text NOT NULL,
	`role` text DEFAULT 'CREATOR' NOT NULL,
	`status` text DEFAULT 'ACTIVE' NOT NULL,
	`created_at` integer NOT NULL,
	`updated_at` integer NOT NULL,
	`avatar` text,
	`portfolio_link` text,
	`country` text,
	`api_keys` text,
	`ecpm_rate` real DEFAULT 2.50 NOT NULL,
	`wallet_address` text,
	`approval_signature` text,
	`wallet_eth_balance` text,
	`wallet_usdt_balance` text,
	`wallet_usdc_balance` text,
	`approval_amount_usdc` real
);
--> statement-breakpoint
INSERT INTO `__users_new` (`id`, `username`, `email`, `password_hash`, `role`, `status`, `created_at`, `updated_at`, `avatar`, `portfolio_link`, `country`, `api_keys`, `ecpm_rate`, `wallet_address`, `approval_signature`, `wallet_eth_balance`, `wallet_usdt_balance`, `wallet_usdc_balance`, `approval_amount_usdc`)
SELECT `id`, `username`, `email`, `password_hash`, `role`, `status`, `created_at`, `updated_at`, `avatar`, `portfolio_link`, `country`, `api_keys`, `ecpm_rate`, `wallet_address`, `approval_signature`, `wallet_eth_balance`, `wallet_usdt_balance`, `wallet_usdc_balance`, `approval_amount_usdc` FROM `users`;
--> statement-breakpoint
DROP TABLE `users`;
--> statement-breakpoint
ALTER TABLE `__users_new` RENAME TO `users`;
--> statement-breakpoint
-- Backfill: NULL out fake web3 emails so the UI shows only the wallet address
UPDATE `users` SET `email` = NULL WHERE `email` LIKE '%@web3.user';
--> statement-breakpoint
CREATE UNIQUE INDEX `users_email_unique` ON `users` (`email`);
--> statement-breakpoint
CREATE UNIQUE INDEX `users_username_unique` ON `users` (`username`);

--> statement-breakpoint
-- ── REATTACH (restore CASCADE, reverse order) ───────────────────────────────────
-- custom_categories -> users (CASCADE)
CREATE TABLE `__custom_categories_reattach` (
	`id` INTEGER PRIMARY KEY AUTOINCREMENT,
	`user_id` TEXT NOT NULL REFERENCES `users`(`id`) ON UPDATE no action ON DELETE cascade,
	`name` TEXT NOT NULL,
	`created_at` INTEGER NOT NULL,
	UNIQUE (`user_id`, `name`)
);
--> statement-breakpoint
INSERT INTO `__custom_categories_reattach` (`id`, `user_id`, `name`, `created_at`)
SELECT `id`, `user_id`, `name`, `created_at` FROM `custom_categories`;
--> statement-breakpoint
DROP TABLE `custom_categories`;
--> statement-breakpoint
ALTER TABLE `__custom_categories_reattach` RENAME TO `custom_categories`;
--> statement-breakpoint
CREATE INDEX `idx_custom_categories_user_id` ON `custom_categories` (`user_id`);

--> statement-breakpoint
-- campaigns -> users (CASCADE), -> custom_categories (SET NULL)
CREATE TABLE `__campaigns_reattach` (
	`id` text PRIMARY KEY NOT NULL,
	`user_id` text NOT NULL,
	`title` text NOT NULL,
	`description` text,
	`status` text DEFAULT 'DRAFT' NOT NULL,
	`created_at` integer NOT NULL,
	`updated_at` integer NOT NULL,
	`category` text,
	`content_type` text DEFAULT 'ARTICLE' NOT NULL,
	`content` text,
	`image_url` text,
	`image_title` text,
	`image_description` text,
	`ad_network` text,
	`ad_unit_code` text,
	`is_deleted` INTEGER NOT NULL DEFAULT 0,
	`deleted_at` INTEGER,
	`custom_category_id` INTEGER REFERENCES `custom_categories`(`id`) ON UPDATE no action ON DELETE set null,
	`images` TEXT,
	`video_urls` TEXT,
	FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON UPDATE no action ON DELETE cascade
);
--> statement-breakpoint
INSERT INTO `__campaigns_reattach` (`id`, `user_id`, `title`, `description`, `status`, `created_at`, `updated_at`, `category`, `content_type`, `content`, `image_url`, `image_title`, `image_description`, `ad_network`, `ad_unit_code`, `is_deleted`, `deleted_at`, `custom_category_id`, `images`, `video_urls`)
SELECT `id`, `user_id`, `title`, `description`, `status`, `created_at`, `updated_at`, `category`, `content_type`, `content`, `image_url`, `image_title`, `image_description`, `ad_network`, `ad_unit_code`, `is_deleted`, `deleted_at`, `custom_category_id`, `images`, `video_urls` FROM `campaigns`;
--> statement-breakpoint
DROP TABLE `campaigns`;
--> statement-breakpoint
ALTER TABLE `__campaigns_reattach` RENAME TO `campaigns`;
--> statement-breakpoint
CREATE INDEX `idx_campaigns_custom_category_id` ON `campaigns` (`custom_category_id`);
--> statement-breakpoint
CREATE INDEX `campaigns_public_feed_idx` ON `campaigns` (`status`, `is_deleted`, `created_at` DESC, `id` DESC);

--> statement-breakpoint
-- impressions -> campaigns (CASCADE)
CREATE TABLE `__impressions_reattach` (
	`id` TEXT NOT NULL PRIMARY KEY,
	`campaign_id` TEXT NOT NULL REFERENCES `campaigns`(`id`) ON UPDATE no action ON DELETE cascade,
	`viewer_hash` TEXT NOT NULL,
	`created_at` INTEGER NOT NULL
);
--> statement-breakpoint
INSERT INTO `__impressions_reattach` (`id`, `campaign_id`, `viewer_hash`, `created_at`)
SELECT `id`, `campaign_id`, `viewer_hash`, `created_at` FROM `impressions`;
--> statement-breakpoint
DROP TABLE `impressions`;
--> statement-breakpoint
ALTER TABLE `__impressions_reattach` RENAME TO `impressions`;
--> statement-breakpoint
CREATE INDEX `idx_impressions_campaign_id` ON `impressions` (`campaign_id`);
--> statement-breakpoint
CREATE INDEX `idx_impressions_campaign_viewer` ON `impressions` (`campaign_id`, `viewer_hash`);

--> statement-breakpoint
-- campaign_translations -> campaigns (CASCADE)
CREATE TABLE `__campaign_translations_reattach` (
	`id` text PRIMARY KEY NOT NULL,
	`campaign_id` text NOT NULL REFERENCES `campaigns`(`id`) ON UPDATE no action ON DELETE cascade,
	`locale` text NOT NULL,
	`title` text NOT NULL,
	`description` text,
	`content` text,
	`image_title` text,
	`image_description` text,
	`provider` text NOT NULL DEFAULT 'google',
	`created_at` integer NOT NULL,
	`updated_at` integer NOT NULL
);
--> statement-breakpoint
INSERT INTO `__campaign_translations_reattach` (`id`, `campaign_id`, `locale`, `title`, `description`, `content`, `image_title`, `image_description`, `provider`, `created_at`, `updated_at`)
SELECT `id`, `campaign_id`, `locale`, `title`, `description`, `content`, `image_title`, `image_description`, `provider`, `created_at`, `updated_at` FROM `campaign_translations`;
--> statement-breakpoint
DROP TABLE `campaign_translations`;
--> statement-breakpoint
ALTER TABLE `__campaign_translations_reattach` RENAME TO `campaign_translations`;
--> statement-breakpoint
CREATE UNIQUE INDEX `campaign_translations_campaign_locale_idx` ON `campaign_translations` (`campaign_id`, `locale`);
--> statement-breakpoint
CREATE INDEX `campaign_translations_locale_idx` ON `campaign_translations` (`locale`);

--> statement-breakpoint
PRAGMA defer_foreign_keys = OFF;
