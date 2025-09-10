---
Ticket-ID: PHSIOAI-007-STORY-patient-zuordnen
Created-At: 2025-09-10
Epic: PHSIOAI-001-EPIC-erster-kontakt
Status: To-Do
Blocked-By: 
Planning-Document:
---

# Patient einem Behandlungstermin zuordnen

## User Story
Als Physiotherapeut möchte ich einem Behandlungstermin einen Patienten zuordnen können, damit klar ist, wer behandelt wird.

## Beschreibung
Bei der Erstellung von Behandlungsterminen im Kalender muss zwingend ein Patient zugeordnet werden, da ein Behandlungstermin ohne Patient fachlich keinen Sinn macht. Diese Funktionalität stellt sicher, dass alle Termine von Anfang an korrekt einem Patienten zugeordnet sind. Die Patientenzuordnung erfolgt über die Auswahl aus der bestehenden Patientenliste durch Patientenidentifikation (Name, Geburtsdatum). Falls der Patient noch nicht im System existiert, muss er zunächst angelegt werden, bevor der Behandlungstermin erstellt werden kann.

## Akzeptanzkriterien
- [ ] Behandlungstermin kann nur erstellt werden, wenn gleichzeitig ein Patient zugeordnet wird
- [ ] Patient kann über Suchfunktion (Name, Geburtsdatum) aus der bestehenden Patientenliste ausgewählt werden
- [ ] Falls Patient nicht existiert, wird deutlicher Hinweis angezeigt mit Möglichkeit zum Anlegen des Patienten
- [ ] Zuordnung wird visuell im Kalender durch Patientenname im Termineintrag dargestellt
- [ ] Patientenzuordnung kann nachträglich geändert werden falls erforderlich (z.B. bei Terminübertragung)
- [ ] System verhindert das Erstellen von Behandlungsterminen ohne Patientenzuordnung

## Definition of Done
- [ ] Akzeptanzkriterien erfüllt
- [ ] Min. 1 Unit Test geschrieben
- [ ] Manuell getestet
- [ ] Dokumentation geupdated