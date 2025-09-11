---
Ticket-ID: PHSIOAI-009-STORY-rezept-upload-und-speicherung
Created-At: 2025-09-10
Epic: PHSIOAI-008-EPIC-erste-behandlung
Status: To-Do
Blocked-By: 
Planning-Document:
---

# Rezept Upload und Speicherung

## User Story
Als Physiotherapeut möchte ich ein fotografiertes Rezept ins System hochladen und speichern können, damit ich das Rezeptbild digital verfügbar habe und für die spätere Datenextraktion nutzen kann.

## Beschreibung
Diese User Story bildet den ersten Schritt der Rezeptdigitalisierung in Physio AI. Während der ersten Behandlung eines bereits bestehenden Patienten (der für den ersten Behandlungstermin bereits angelegt wurde) soll Carsten das physische Papierrezept mit seinem Smartphone oder einer Kamera fotografieren und das Bild über die Patientendetailseite in das System hochladen können. Das System speichert das Rezeptbild sicher und ordnet es dem entsprechenden Patienten zu.

Diese Story fokussiert sich ausschließlich auf den Upload-Mechanismus und die sichere Speicherung von Rezeptbildern, ohne die komplexe KI-basierte Datenextraktion. Dies ermöglicht es Carsten, Rezepte sofort digital zu archivieren und schafft die Grundlage für die nachgelagerte automatische Datenextraktion.

## Akzeptanzkriterien
- [ ] Ein Upload-Bereich für Rezeptbilder ist in der Patientendetailseite integriert
- [ ] Das System akzeptiert gängige Bildformate (JPEG, PNG, PDF)
- [ ] Hochgeladene Bilder werden sicher im System gespeichert
- [ ] Rezeptbilder werden dem entsprechenden Patienten zugeordnet
- [ ] Eine Vorschau des hochgeladenen Bildes wird angezeigt
- [ ] Upload-Status wird dem Benutzer angezeigt (Fortschritt, Erfolg, Fehler)
- [ ] Fehlermeldungen werden bei ungültigen Dateiformaten oder Upload-Problemen angezeigt

## Definition of Done
- [ ] Akzeptanzkriterien erfüllt
- [ ] Min. 1 Unit Test geschrieben
- [ ] Manuell getestet
- [ ] Dokumentation geupdated