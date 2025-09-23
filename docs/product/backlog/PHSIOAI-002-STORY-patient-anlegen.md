---
Ticket-ID: PHSIOAI-002-STORY-patient-anlegen
Created-At: 2025-09-10
Epic: PHSIOAI-001-EPIC-erster-kontakt
Status: DONE
Blocked-By: 
Planning-Document: 
---

# Patient anlegen

## User Story
Als Physiotherapeut möchte ich neue Patienten aus Namen und Geburtsdatum im System anlegen können, damit Behandlungstermine einem Patienten zugeordnet werden können

## Beschreibung
Diese User Story ermöglicht es dem Physiotherapeuten, neue Patienten mit den grundlegenden Informationen (Name und Geburtsdatum) im PhysioAI System zu erfassen. Dies ist der erste Schritt im Onboarding-Prozess eines neuen Patienten und bildet die Grundlage für die weitere Terminplanung und Behandlungsverwaltung. Die Patientendaten müssen persistent gespeichert werden und für die spätere Zuordnung zu Behandlungsterminen verfügbar sein.

## Akzeptanzkriterien
- [ ] Ein neuer Patient kann mit Vor- und Nachname sowie Geburtsdatum angelegt werden
- [ ] Die eingegebenen Patientendaten werden validiert (Name nicht leer, gültiges Geburtsdatum)
- [ ] Der neue Patient wird persistent in der Datenbank gespeichert
- [ ] Nach erfolgreichem Anlegen wird eine Bestätigung angezeigt
- [ ] Der neu angelegte Patient ist sofort für die Terminzuordnung verfügbar

## Definition of Done
- [ ] Akzeptanzkriterien erfüllt
- [ ] Min. 1 Unit Test geschrieben
- [ ] Manuell getestet
- [ ] Dokumentation geupdated
