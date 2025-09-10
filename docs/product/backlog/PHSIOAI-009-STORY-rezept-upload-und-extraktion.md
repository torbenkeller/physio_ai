---
Ticket-ID: PHSIOAI-009-STORY-rezept-upload-und-extraktion
Created-At: 2025-09-10
Epic: PHSIOAI-008-EPIC-erste-behandlung
Status: To-Do
Blocked-By: 
Planning-Document:
---

# Rezept Upload und Extraktion

## User Story
Als Physiotherapeut möchte ich ein fotografiertes Rezept ins System hochladen können, damit das System automatisch alle Rezeptdaten extrahiert und ich Zeit bei der manuellen Eingabe spare.

## Beschreibung
Diese User Story bildet den ersten Schritt der Rezeptdigitalisierung in Physio AI. Während der ersten Behandlung eines bereits bestehenden Patienten (der für den ersten Behandlungstermin bereits angelegt wurde) soll Carsten das physische Papierrezept mit seinem Smartphone oder einer Kamera fotografieren und das Bild über die Patientendetailseite in das System hochladen können. Das System analysiert dann automatisch das hochgeladene Rezeptbild mittels KI-basierter Texterkennung und extrahiert alle relevanten Rezeptdaten wie Patientendaten, verordnete Behandlungen, Häufigkeit und Zeitraum.

Da der Patient bereits existiert, kann das System die extrahierten Patientendaten zur Validierung mit den bestehenden Patientenstammdaten abgleichen. Zusätzlich sollen extrahierte Stammdaten die bestehende Patientenakte anreichern, falls bestimmte Felder noch nicht ausgefüllt sind. Die automatische Extraktion reduziert den manuellen Aufwand erheblich und minimiert Eingabefehler. Carsten kann sich darauf konzentrieren, die extrahierten Daten zu validieren, anstatt alle Informationen manuell einzutippen.

## Akzeptanzkriterien
- [ ] Ein Upload-Bereich für Rezeptbilder ist in der Patientendetailseite integriert
- [ ] Das System akzeptiert gängige Bildformate (JPEG, PNG, PDF)
- [ ] Hochgeladene Bilder werden automatisch mittels OCR/KI analysiert
- [ ] Das System extrahiert Patientenstammdaten (Name, Geburtsdatum, Adresse) aus dem Rezept und gleicht diese mit den bestehenden Patientendaten ab
- [ ] Extrahierte Patientenstammdaten reichern automatisch die bestehende Patientenakte an, falls Felder noch nicht ausgefüllt sind
- [ ] Das System extrahiert verordnete Behandlungsarten und deren Häufigkeit
- [ ] Das System extrahiert den Verordnungszeitraum und das Ausstellungsdatum
- [ ] Extrahierte Daten werden in einer strukturierten Vorschau angezeigt
- [ ] Bei Unstimmigkeiten zwischen extrahierten und bestehenden Patientendaten wird eine Warnung angezeigt
- [ ] Bei unklaren oder unlesbaren Rezeptteilen wird eine entsprechende Warnung angezeigt

## Definition of Done
- [ ] Akzeptanzkriterien erfüllt
- [ ] Min. 1 Unit Test geschrieben
- [ ] Manuell getestet
- [ ] Dokumentation geupdated