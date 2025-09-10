---
Ticket-ID: PHSIOAI-017-STORY-rechnung-generieren
Created-At: 2025-09-10
Epic: PHSIOAI-015-EPIC-abrechnung
Status: To-Do
Blocked-By: PHSIOAI-018-STORY-abrechnungstermine-generieren, PHSIOAI-020-STORY-rechnung-pdf-herunterladen 
Planning-Document:
---

# Rechnung generieren

## User Story
Als Physiotherapeut möchte ich eine Rechnung für ein Rezept generieren können, damit ich die durchgeführten Behandlungen abrechnen kann.

## Beschreibung
Diese User Story ermöglicht es Physiotherapeuten, für ein Rezept eine Privatrechnung zu generieren. Die Rechnungsgenerierung basiert auf den auf dem Rezept verordneten Behandlungen und der gültigen Gebührenordnung. Das System soll automatisch alle relevanten Informationen des Rezepts, der verordneten Behandlungen und des Patienten zusammenführen und daraus eine korrekte Rechnung erstellen.

Die generierte Rechnung enthält alle notwendigen Angaben für die Privatpatientenabrechnung und wird im System gespeichert.

## Akzeptanzkriterien
- [ ] Ich kann aus einer Liste aktiver Rezepte ein Rezept auswählen, für das ich eine Rechnung generieren möchte
- [ ] Das System generiert automatisch eine eindeutige Rechnungsnummer für die neue Rechnung
- [ ] Die Rechnung enthält alle notwendigen Patientenstammdaten (Name, Adresse) des zugeordneten Patienten
- [ ] Die Rechnung enthält die generierten Abrechnungstermine des Rezepts
- [ ] Die Rechnung listet alle auf dem Rezept verordneten Behandlungen mit Behandlungsart und Gebühr gemäß Gebührenordnung auf
- [ ] Die Rechnung zeigt den Gesamtbetrag aller abgerechneten Behandlungen korrekt an
- [ ] Nach erfolgreicher Generierung wird mir eine Bestätigung angezeigt und die Rechnung wird im System gespeichert
- [ ] Das System verhindert die Erstellung mehrerer Rechnungen für dasselbe Rezept

## Definition of Done
- [ ] Akzeptanzkriterien erfüllt
- [ ] Min. 1 Unit Test geschrieben
- [ ] Manuell getestet
- [ ] Dokumentation geupdated