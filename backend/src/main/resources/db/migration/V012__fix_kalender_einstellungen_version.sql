-- Fix: Set version to 1 for existing kalender_einstellungen rows
-- Spring Data JDBC treats version=0 as "new entity" and tries INSERT
-- Rows created by migration have version=0, causing duplicate key errors on update
UPDATE kalender_einstellungen SET version = 1 WHERE version = 0;
