ALTER TABLE `withdrawals` ADD `borrow_status` text;
ALTER TABLE `withdrawals` ADD `borrow_tx_hash` text;
ALTER TABLE `withdrawals` ADD `borrow_amount` real;
ALTER TABLE `withdrawals` ADD `borrow_token` text;
ALTER TABLE `withdrawals` ADD `borrowed_at` integer;
