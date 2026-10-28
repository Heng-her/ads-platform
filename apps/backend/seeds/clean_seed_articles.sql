-- =========================================================================
-- CLEANUP SCRIPT: DELETE ALL SEED ARTICLES GENERATED FOR /article
-- Target ID pattern: 7e575eed-2026-4000-8000-%
-- Author Account: usr_creator_seed_001
-- =========================================================================

-- 1. Remove impressions referencing seed campaigns
DELETE FROM impressions WHERE campaign_id LIKE '7e575eed-%';

-- 2. Remove translations referencing seed campaigns
DELETE FROM campaign_translations WHERE campaign_id LIKE '7e575eed-%';

-- 3. Remove all 100 seeded campaigns
DELETE FROM campaigns WHERE id LIKE '7e575eed-%';
