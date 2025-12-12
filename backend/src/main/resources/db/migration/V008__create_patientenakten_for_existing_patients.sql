-- Create Patientenakten for existing patients that don't have one yet
INSERT INTO patientenakten (id, patient_id, version)
SELECT gen_random_uuid(), p.id, 0
FROM patienten p
WHERE NOT EXISTS (
    SELECT 1 FROM patientenakten pa WHERE pa.patient_id = p.id
);
