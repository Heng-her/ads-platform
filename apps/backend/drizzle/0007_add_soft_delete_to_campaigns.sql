-- Migration: Add soft delete fields to campaigns table
ALTER TABLE campaigns ADD COLUMN is_deleted INTEGER NOT NULL DEFAULT 0;
ALTER TABLE campaigns ADD COLUMN deleted_at INTEGER;
