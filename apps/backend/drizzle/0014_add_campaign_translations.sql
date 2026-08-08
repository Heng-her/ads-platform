CREATE TABLE IF NOT EXISTS `campaign_translations` (
  `id` text PRIMARY KEY NOT NULL,
  `campaign_id` text NOT NULL REFERENCES `campaigns`(`id`) ON DELETE CASCADE,
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
CREATE UNIQUE INDEX IF NOT EXISTS `campaign_translations_campaign_locale_idx` ON `campaign_translations` (`campaign_id`, `locale`);
CREATE INDEX IF NOT EXISTS `campaign_translations_locale_idx` ON `campaign_translations` (`locale`);
