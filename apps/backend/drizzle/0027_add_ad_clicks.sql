CREATE TABLE `ad_clicks` (
	`id` text PRIMARY KEY NOT NULL,
	`campaign_id` text REFERENCES `campaigns`(`id`) ON DELETE set null,
	`creator_id` text NOT NULL REFERENCES `users`(`id`) ON DELETE cascade,
	`provider` text NOT NULL,
	`format` text NOT NULL,
	`placement` text NOT NULL,
	`viewer_hash` text NOT NULL,
	`created_at` integer NOT NULL
);
--> statement-breakpoint
CREATE INDEX `idx_ad_clicks_campaign_id` ON `ad_clicks` (`campaign_id`);--> statement-breakpoint
CREATE INDEX `idx_ad_clicks_creator_id` ON `ad_clicks` (`creator_id`);--> statement-breakpoint
CREATE INDEX `idx_ad_clicks_created_at` ON `ad_clicks` (`created_at`);
