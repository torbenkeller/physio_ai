-- Remove external_calendar_url column from profiles table
-- Data has been migrated to kalender_einstellungen table in V010
ALTER TABLE profiles DROP COLUMN IF EXISTS external_calendar_url;
