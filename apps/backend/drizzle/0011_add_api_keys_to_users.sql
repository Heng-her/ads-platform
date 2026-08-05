-- Migration: add api_keys JSON column to users table
ALTER TABLE users ADD COLUMN api_keys TEXT;
