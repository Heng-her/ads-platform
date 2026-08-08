CREATE INDEX IF NOT EXISTS `campaigns_public_feed_idx`
ON `campaigns` (`status`, `is_deleted`, `created_at` DESC, `id` DESC);
