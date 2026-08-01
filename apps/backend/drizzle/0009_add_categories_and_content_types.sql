-- Migration: Add system/custom categories, system content_types, and link campaigns

-- System categories (managed by ADMIN only)
CREATE TABLE system_categories (
  id         INTEGER PRIMARY KEY AUTOINCREMENT,
  name       TEXT    NOT NULL UNIQUE,
  created_at INTEGER NOT NULL
);

-- Custom categories (managed by CREATOR, private to owner)
CREATE TABLE custom_categories (
  id         INTEGER PRIMARY KEY AUTOINCREMENT,
  user_id    TEXT    NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  name       TEXT    NOT NULL,
  created_at INTEGER NOT NULL,
  UNIQUE(user_id, name)
);

-- System content types (managed by ADMIN only)
CREATE TABLE content_types (
  id         INTEGER PRIMARY KEY AUTOINCREMENT,
  name       TEXT    NOT NULL UNIQUE,
  created_at INTEGER NOT NULL
);

-- Seed default system content types
INSERT INTO content_types (name, created_at) VALUES
  ('ARTICLE', unixepoch()),
  ('BANNER',  unixepoch()),
  ('VIDEO',   unixepoch()),
  ('IMAGE',   unixepoch());

-- Seed default system categories
INSERT INTO system_categories (name, created_at) VALUES
  ('TECHNOLOGY', unixepoch()),
  ('NEWS',       unixepoch()),
  ('BUSINESS',   unixepoch()),
  ('SPORTS',     unixepoch());

-- Add custom_category_id FK to campaigns (nullable — only set when using a custom category)
ALTER TABLE campaigns ADD COLUMN custom_category_id INTEGER REFERENCES custom_categories(id) ON DELETE SET NULL;

CREATE INDEX idx_custom_categories_user_id ON custom_categories (user_id);
CREATE INDEX idx_campaigns_custom_category_id ON campaigns (custom_category_id);
