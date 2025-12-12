-- Patientenakte Schema für chronologischen Behandlungsverlauf

-- Patientenakte (1:1 zu Patient)
CREATE TABLE patientenakten (
    id UUID PRIMARY KEY,
    patient_id UUID NOT NULL UNIQUE REFERENCES patienten(id) ON DELETE CASCADE,
    version INTEGER DEFAULT 0 NOT NULL
);

-- Behandlungs-Einträge (aus Events synchronisiert)
CREATE TABLE akte_behandlungs_eintraege (
    id UUID PRIMARY KEY,
    patientenakte_id UUID NOT NULL REFERENCES patientenakten(id) ON DELETE CASCADE,
    behandlung_id UUID NOT NULL UNIQUE,
    behandlungs_datum TIMESTAMP NOT NULL,
    notiz_inhalt TEXT,
    notiz_erstellt_am TIMESTAMP,
    notiz_aktualisiert_am TIMESTAMP,
    ist_angepinnt BOOLEAN DEFAULT FALSE NOT NULL,
    erstellt_am TIMESTAMP NOT NULL
);

-- Freie Notizen (vom Therapeuten erstellt)
CREATE TABLE akte_freie_notizen (
    id UUID PRIMARY KEY,
    patientenakte_id UUID NOT NULL REFERENCES patientenakten(id) ON DELETE CASCADE,
    kategorie VARCHAR(50) NOT NULL,
    inhalt TEXT NOT NULL,
    ist_angepinnt BOOLEAN DEFAULT FALSE NOT NULL,
    erstellt_am TIMESTAMP NOT NULL,
    aktualisiert_am TIMESTAMP
);

-- Indizes für Performance
CREATE INDEX idx_akte_behandlungs_eintraege_patientenakte ON akte_behandlungs_eintraege(patientenakte_id);
CREATE INDEX idx_akte_behandlungs_eintraege_behandlung ON akte_behandlungs_eintraege(behandlung_id);
CREATE INDEX idx_akte_freie_notizen_patientenakte ON akte_freie_notizen(patientenakte_id);
