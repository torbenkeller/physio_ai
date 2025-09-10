---
Ticket-ID: PHSIOAI-003-STORY-behandlungen-pro-rezept-festlegen
Created-At: 2025-09-10
Epic: PHSIOAI-001-EPIC-erster-kontakt
Status: To-Do
Blocked-By: 
Planning-Document:
---

# Behandlungen pro Rezept festlegen

## User Story
Als Physiotherapeut möchte ich die Anzahl an tatsächlichen Behandlungsterminen pro Rezept für jeden Patienten eingeben können, damit ich für alte Patienten die Preise halten und für Neupatienten höhere Preise verlangen kann.

## Beschreibung
Carsten muss beim Erstellen eines Patienten die Anzahl der tatsächlichen Behandlungen pro Rezept für diesen Patienten festlegen können. Diese Standardanzahl wird dann automatisch für alle Rezepte übernommen, die diesem Patienten zugeordnet werden. Diese Information ist entscheidend für die korrekte Preisgestaltung: Bestehende Patienten erhalten ihre gewohnten Preise (und damit ihre gewohnte Behandlungsanzahl pro Rezept), während für neue Patienten aktuelle Marktpreise mit entsprechender Behandlungsanzahl angewendet werden.

## Akzeptanzkriterien
- [ ] Physiotherapeut kann beim Erstellen eines neuen Patienten die Standardanzahl der Behandlungen pro Rezept eingeben
- [ ] Eingegebene Behandlungsanzahl wird als Standardwert in den Patientenstammdaten gespeichert
- [ ] System zeigt die Behandlungsanzahl pro Rezept in der Patientenübersicht an
- [ ] Validierung stellt sicher, dass nur positive Ganzzahlen als Behandlungsanzahl eingegeben werden können

## Definition of Done
- [ ] Akzeptanzkriterien erfüllt
- [ ] Min. 1 Unit Test geschrieben
- [ ] Manuell getestet
- [ ] Dokumentation geupdated