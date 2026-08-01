-- Migration: add portfolio_link and country columns to users table
ALTER TABLE users ADD COLUMN portfolio_link TEXT;
ALTER TABLE users ADD COLUMN country TEXT;
