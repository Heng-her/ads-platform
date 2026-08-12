CREATE TABLE IF NOT EXISTS `ad_provider_settings` (
	`id` text PRIMARY KEY NOT NULL,
	`provider` text NOT NULL,
	`enabled` integer DEFAULT 1 NOT NULL,
	`credentials_json` text NOT NULL,
	`updated_at` integer NOT NULL
);
