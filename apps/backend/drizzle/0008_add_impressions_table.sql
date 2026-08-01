-- Migration: Add impressions table for campaign viewer tracking
CREATE TABLE impressions (
  id           TEXT    NOT NULL PRIMARY KEY,
  campaign_id  TEXT    NOT NULL REFERENCES campaigns(id) ON DELETE CASCADE,
  viewer_hash  TEXT    NOT NULL,
  created_at   INTEGER NOT NULL
);

CREATE INDEX idx_impressions_campaign_id ON impressions (campaign_id);
CREATE INDEX idx_impressions_campaign_viewer ON impressions (campaign_id, viewer_hash);
