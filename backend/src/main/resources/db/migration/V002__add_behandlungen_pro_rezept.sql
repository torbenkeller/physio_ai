-- Add default behandlungen pro rezept to profiles
ALTER TABLE profiles ADD COLUMN default_behandlungen_pro_rezept INTEGER NOT NULL DEFAULT 8;

-- Add individual behandlungen pro rezept to patienten
ALTER TABLE patienten ADD COLUMN behandlungen_pro_rezept INTEGER;
