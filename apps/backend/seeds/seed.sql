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

-- Seed default system settings for Admin Control Panel
INSERT OR IGNORE INTO system_settings (key, value_json, updated_at) VALUES 
('platform', '{"siteName":"New Platform","siteDescription":"Multi-role New Platform supporting Public browsing, Creator Studio, and Admin Control.","siteUrl":"http://localhost:3000","defaultLanguage":"en","allowRegistrations":true}', cast(strftime('%s', 'now') as integer) * 1000),
('dispatch', '{"telegramBotToken":"","telegramPublicChannelId":"","enablePublicChannel":true,"telegramAdminGroupId":"","enableAdminGroupAlerts":true,"mailSenderEmail":"notifications@adsplatform.com","mailSmtpHost":"smtp.gmail.com","mailSmtpPort":587,"mailSmtpUser":"","mailSmtpPassword":"","enableMail":true,"onUserSubmitMail":true,"onUserSubmitAdminGroup":true,"onPostPublishMail":true,"onPostPublishPublicChannel":true,"onPostPublishAdminGroup":true}', cast(strftime('%s', 'now') as integer) * 1000),
('post', '{"maxPostPerDay":5,"maxUploadImage":10,"maxUploadVideo":2,"maxRegisterPerDay":5}', cast(strftime('%s', 'now') as integer) * 1000),
('security', '{"creatorDeletionPassword":"admin"}', cast(strftime('%s', 'now') as integer) * 1000),
('googleauth', '{"googleClientId":"","googleClientSecret":"","enableGoogleAuth":false}', cast(strftime('%s', 'now') as integer) * 1000),
('upload', '{"uploadApiBaseUrl":"https://api-upload-image-8ym9.onrender.com","uploadApiKey":"crypten-api-key","uploadApiBypassSecret":"crypten-bypass-secret"}', cast(strftime('%s', 'now') as integer) * 1000);
