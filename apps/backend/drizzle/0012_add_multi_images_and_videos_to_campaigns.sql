-- Migration: add images and video_urls JSON columns to campaigns table
ALTER TABLE campaigns ADD COLUMN images TEXT;
ALTER TABLE campaigns ADD COLUMN video_urls TEXT;
