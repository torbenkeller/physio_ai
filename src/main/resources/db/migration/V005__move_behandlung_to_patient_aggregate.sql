-- Move behandlung from rezept aggregate to patient aggregate
-- Make rezept_id optional and add patient_id reference

-- Drop the existing foreign key constraint and non-null constraint on rezept_id
ALTER TABLE behandlungen DROP CONSTRAINT behandlungen_rezept_id_fkey;
ALTER TABLE behandlungen ALTER COLUMN rezept_id DROP NOT NULL;

-- Add patient_id column and foreign key constraint
ALTER TABLE behandlungen ADD COLUMN patient_id uuid NOT NULL REFERENCES patienten(id);

-- Remove the index column as it's no longer needed for ordering within rezept
ALTER TABLE behandlungen DROP COLUMN index;

-- Add foreign key back for rezept_id as optional reference
ALTER TABLE behandlungen ADD CONSTRAINT behandlungen_rezept_id_fkey 
    FOREIGN KEY (rezept_id) REFERENCES rezepte(id);