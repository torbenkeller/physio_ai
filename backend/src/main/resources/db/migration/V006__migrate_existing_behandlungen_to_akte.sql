-- Migration bestehender Behandlungen in die Patientenakte

-- Patientenakten für alle Patienten erstellen, die Behandlungen haben
INSERT INTO patientenakten (id, patient_id, version)
SELECT gen_random_uuid(), patient_id, 0
FROM behandlungen
GROUP BY patient_id
ON CONFLICT (patient_id) DO NOTHING;

-- Bestehende Behandlungen in die Akte übernehmen
INSERT INTO akte_behandlungs_eintraege (
    id,
    patientenakte_id,
    behandlung_id,
    behandlungs_datum,
    notiz_inhalt,
    notiz_erstellt_am,
    ist_angepinnt,
    erstellt_am
)
SELECT
    gen_random_uuid(),
    pa.id,
    b.id,
    b.start_zeit,
    b.bemerkung,
    CASE WHEN b.bemerkung IS NOT NULL THEN b.start_zeit ELSE NULL END,
    false,
    b.start_zeit
FROM behandlungen b
JOIN patientenakten pa ON pa.patient_id = b.patient_id
ON CONFLICT (behandlung_id) DO NOTHING;
