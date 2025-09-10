---
Ticket-ID: PHSIOAI-018-STORY-abrechnungstermine-generieren
Created-At: 2025-09-10
Epic: PHSIOAI-015-EPIC-abrechnung
Status: To-Do
Blocked-By: 
Planning-Document:
---

# Abrechnungstermine generieren

## User Story
Als Physiotherapeut möchte ich Abrechnungstermine für ein Rezept generieren können, damit ich bei der Krankenkasse richtig abrechnen kann.

## Beschreibung
Diese User Story ermöglicht es Physiotherapeuten, automatisch Abrechnungstermine für ein spezifisches Rezept zu generieren. Abrechnungstermine sind ein wichtiges Dokument, das alle zu einem Rezept gehörigen Behandlungstermine auflistet und zur korrekten Dokumentation bei der Privatpatientenabrechnung benötigt wird. Das generierte Dokument wird später ausgedruckt und physisch an das entsprechende Rezept angeheftet.

Die Abrechnungstermine sind eine Liste von standardisierten Behandlungsdaten, die nach einem festen Schema berechnet werden und nicht den tatsächlichen Behandlungsterminen entsprechen müssen. Sie dienen als Nachweis der durchgeführten Behandlungen für die Versicherungsabrechnung.

## Akzeptanzkriterien
- [ ] Physiotherapeut kann für ein Rezept Abrechnungstermine generieren
- [ ] Abrechnungstermine werden nach festem Schema berechnet: erster Termin ist der nächste Montag, Mittwoch oder Freitag nach Rezeptausstellung
- [ ] Folgende Abrechnungstermine sind immer Montag, Mittwoch und Freitag jeder Woche
- [ ] Feiertage in Schleswig-Holstein werden bei der Berechnung übersprungen
- [ ] Anzahl der Abrechnungstermine entspricht der Anzahl durchgeführter Behandlungen des Rezepts

## Definition of Done
- [ ] Akzeptanzkriterien erfüllt
- [ ] Min. 1 Unit Test geschrieben
- [ ] Manuell getestet
- [ ] Dokumentation geupdated