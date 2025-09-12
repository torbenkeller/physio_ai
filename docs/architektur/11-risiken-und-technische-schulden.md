# 11. Risiken und technische Schulden

## 11.1 Risiken

### 11.1.1 Datenschutz (HOCH)
**Beschreibung**: Patientendaten werden aktuell nicht verschlüsselt in der Datenbank gespeichert.

**Auswirkung**: 
- Verletzung der DSGVO-Anforderungen
- Potenzielle rechtliche Konsequenzen bei Datenschutzverletzungen
- Reputationsschäden für die Praxis
- Unbefugter Zugriff auf sensible Gesundheitsdaten

**Eintrittswahrscheinlichkeit**: Niedrig bis Mittel
**Geschäftsauswirkung**: Hoch

**Aktueller Status**: Das Risiko wird bewusst in Kauf genommen für die aktuelle Entwicklungsphase.

**Mitigation**: 
- Implementierung einer Datenbankverschlüsselung geplant für zukünftige Version
- Zugriffsbeschränkungen auf Datenbankebene
- Sichere Netzwerkkonfiguration

## 11.2 Technische Schulden

### 11.2.1 Fehlende Datenverschlüsselung
**Beschreibung**: Keine Verschlüsselung sensibler Patientendaten in der Datenbank

**Auswirkung**:
- Sicherheitsrisiko bei Datenbankzugriffen
- Compliance-Probleme mit Datenschutzbestimmungen

**Geschätzte Aufwandshöhe**: Hoch (ca. 2-3 Sprints)
**Priorität**: Hoch