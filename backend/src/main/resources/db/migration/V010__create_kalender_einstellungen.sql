-- Create table for calendar settings in behandlungen context
CREATE TABLE kalender_einstellungen (
    id UUID PRIMARY KEY,
    external_calendar_url VARCHAR,
    version INT NOT NULL DEFAULT 0
);

-- Migrate existing external_calendar_url from profiles table
INSERT INTO kalender_einstellungen (id, external_calendar_url, version)
SELECT gen_random_uuid(), external_calendar_url, 0
FROM profiles
WHERE external_calendar_url IS NOT NULL
LIMIT 1;

-- If no profile had a calendar URL, create a default empty record
INSERT INTO kalender_einstellungen (id, external_calendar_url, version)
SELECT gen_random_uuid(), NULL, 0
WHERE NOT EXISTS (SELECT 1 FROM kalender_einstellungen);
