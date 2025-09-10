---
Ticket-ID: PHSIOAI-011-STORY-automatische-termin-zuordnung
Created-At: 2025-09-10
Epic: PHSIOAI-008-EPIC-erste-behandlung
Status: To-Do
Blocked-By: PHSIOAI-009-STORY-rezept-upload-und-extraktion, PHSIOAI-010-STORY-rezeptdaten-validierung
Planning-Document:
---

# Automatische Termin-Zuordnung

## User Story
Als Physiotherapeut möchte ich dass das System automatisch alle passenden bestehenden Behandlungstermine einem Rezept zuordnet, damit ich diese nicht manuell verknüpfen muss.

## Beschreibung
Nach der erfolgreichen Digitalisierung und Validierung eines Rezepts soll das System automatisch alle bereits im Kalender vorhandenen Behandlungstermine identifizieren, die zu diesem Rezept gehören könnten. Die Zuordnung erfolgt basierend auf dem Patienten und dem Zeitraum der Rezeptgültigkeit. Dies optimiert den Workflow erheblich, da Carsten oft bereits Termine für einen Patienten vereinbart hat, bevor das physische Rezept vorliegt.

Das System muss dabei intelligent vorgehen:
- Bestehende Behandlungstermine des Patienten ohne Rezeptzuordnung identifizieren
- Terminanzahl mit den verordneten Behandlungen auf dem Rezept abgleichen
- Automatische Vorschläge für die Zuordnung erstellen
- Möglichkeit zur manuellen Korrektur der automatischen Zuordnung bereitstellen

## Akzeptanzkriterien
- [ ] System identifiziert alle bestehenden Behandlungstermine des Patienten ohne Rezeptzuordnung
- [ ] Physiotherapeut kann die automatische Zuordnung vor der Bestätigung einsehen und prüfen
- [ ] Physiotherapeut kann einzelne Zuordnungen manuell korrigieren oder entfernen
- [ ] System verhindert die Zuordnung von mehr Terminen als die im Patienten hinterlegte Anzahl an Behandlungen pro Rezept
- [ ] Nach erfolgreicher Zuordnung sind alle Termine korrekt mit dem Rezept verknüpft

## Definition of Done
- [ ] Akzeptanzkriterien erfüllt
- [ ] Min. 1 Unit Test geschrieben
- [ ] Manuell getestet
- [ ] Dokumentation geupdated