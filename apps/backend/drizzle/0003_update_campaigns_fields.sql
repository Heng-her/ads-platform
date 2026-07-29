ALTER TABLE `campaigns` ADD COLUMN `category` text;--> statement-breakpoint
ALTER TABLE `campaigns` ADD COLUMN `content_type` text DEFAULT 'ARTICLE' NOT NULL;--> statement-breakpoint
ALTER TABLE `campaigns` ADD COLUMN `content` text;--> statement-breakpoint
ALTER TABLE `campaigns` ADD COLUMN `image_url` text;--> statement-breakpoint
ALTER TABLE `campaigns` ADD COLUMN `image_title` text;--> statement-breakpoint
ALTER TABLE `campaigns` ADD COLUMN `image_description` text;--> statement-breakpoint
ALTER TABLE `campaigns` ADD COLUMN `ad_network` text;--> statement-breakpoint
ALTER TABLE `campaigns` ADD COLUMN `ad_unit_code` text;
