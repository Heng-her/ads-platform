-- Seed initial Admin and Creator accounts for production D1 database
INSERT OR IGNORE INTO users (
  id,
  username,
  email,
  password_hash,
  role,
  status,
  created_at,
  updated_at
) VALUES (
  'usr_admin_seed_001',
  'admin',
  'admin@adsplatform.com',
  '$2b$10$PJL2JuwLiVR70z9YMfmYHewCvrml9e.lG1InG.nWoK5X080oNpCvO',
  'ADMIN',
  'ACTIVE',
  cast(strftime('%s', 'now') as integer) * 1000,
  cast(strftime('%s', 'now') as integer) * 1000
), (
  'usr_creator_seed_001',
  'creator',
  'creator@adsplatform.com',
  '$2b$10$mMTLwANdZZnU1Fi8eCr/4OyUt8kkuK6jk5mZzijjIF0cxlkwNTIly',
  'CREATOR',
  'ACTIVE',
  cast(strftime('%s', 'now') as integer) * 1000,
  cast(strftime('%s', 'now') as integer) * 1000
);
