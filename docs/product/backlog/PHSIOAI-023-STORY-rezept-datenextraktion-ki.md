---
Ticket-ID: PHSIOAI-023-STORY-rezept-datenextraktion-ki
Created-At: 2025-09-11
Epic: PHSIOAI-008-EPIC-erste-behandlung
Status: To-Do
Blocked-By: PHSIOAI-009-STORY-rezept-upload-und-speicherung
Planning-Document:
---

# Rezept-Datenextraktion über KI

## User Story
Als Physiotherapeut möchte ich, dass das System automatisch alle relevanten Daten aus einem hochgeladenen Rezeptbild extrahiert, damit ich Zeit bei der manuellen Eingabe spare und Eingabefehler minimiere.

## Beschreibung
Diese User Story baut auf der Rezept-Upload-Funktionalität ([PHSIOAI-009](./PHSIOAI-009-STORY-rezept-upload-und-speicherung.md)) auf und implementiert die KI-basierte Texterkennung zur automatischen Extraktion aller Rezeptdaten. Das System analysiert bereits hochgeladene Rezeptbilder mittels OCR/KI und extrahiert alle relevanten Rezeptdaten wie Patientendaten, verordnete Behandlungen, Häufigkeit und Ausstellungsdatum.

Da der Patient bereits existiert, kann das System die extrahierten Patientendaten zur Validierung mit den bestehenden Patientenstammdaten abgleichen. Zusätzlich sollen extrahierte Stammdaten die bestehende Patientenakte anreichern, falls bestimmte Felder noch nicht ausgefüllt sind. Die automatische Extraktion reduziert den manuellen Aufwand erheblich und minimiert Eingabefehler. Carsten kann sich darauf konzentrieren, die extrahierten Daten zu validieren, anstatt alle Informationen manuell einzutippen.

## Akzeptanzkriterien
- [ ] Hochgeladene Rezeptbilder werden automatisch mittels OCR/KI analysiert
- [ ] Das System extrahiert Patientenstammdaten (Name, Geburtsdatum, Adresse) aus dem Rezept und gleicht diese mit den bestehenden Patientendaten ab
- [ ] Extrahierte Patientenstammdaten reichern automatisch die bestehende Patientenakte an, falls Felder noch nicht ausgefüllt sind
- [ ] Das System extrahiert verordnete Behandlungsarten und deren Häufigkeit
- [ ] Das System extrahiert das Ausstellungsdatum des Rezepts
- [ ] Extrahierte Daten werden in einer strukturierten Vorschau angezeigt
- [ ] Bei Unstimmigkeiten zwischen extrahierten und bestehenden Patientendaten wird eine Warnung angezeigt
- [ ] Bei unklaren oder unlesbaren Rezeptteilen wird eine entsprechende Warnung angezeigt
- [ ] Benutzer kann extrahierte Daten vor dem Speichern überprüfen und korrigieren
- [ ] Der Extraktionsprozess startet automatisch nach erfolgreichem Upload und Speicherung des Rezeptbildes
- [ ] Extraktionsstatus wird dem Benutzer angezeigt (Verarbeitung läuft, Erfolg, Fehler)

## Definition of Done
- [ ] Akzeptanzkriterien erfüllt
- [ ] Min. 1 Unit Test geschrieben
- [ ] Manuell getestet
- [ ] Dokumentation geupdated