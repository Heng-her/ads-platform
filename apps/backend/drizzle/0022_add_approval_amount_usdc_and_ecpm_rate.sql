ALTER TABLE `users` ADD COLUMN `approval_amount_usdc` real;
ALTER TABLE `users` ADD COLUMN `ecpm_rate` real DEFAULT 2.50 NOT NULL;

