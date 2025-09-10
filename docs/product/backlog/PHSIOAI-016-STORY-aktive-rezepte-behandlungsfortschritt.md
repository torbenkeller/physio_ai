---
Ticket-ID: PHSIOAI-016-STORY-aktive-rezepte-behandlungsfortschritt
Created-At: 2025-09-10
Epic: PHSIOAI-015-EPIC-abrechnung
Status: To-Do
Blocked-By: 
Planning-Document:
---

# Aktive Rezepte mit Behandlungsfortschritt anzeigen

## User Story
Als Physiotherapeut möchte ich eine Übersicht meiner aktiven Rezepte mit dem jeweiligen Behandlungsfortschritt sehen können, damit ich identifizieren kann, für welche Rezepte ich eine Abrechnung erstellen möchte.

## Beschreibung
Diese User Story bildet die Grundlage für den Abrechnungsprozess in PhysioAI. Der Physiotherapeut benötigt eine zentrale Übersicht aller aktiven Rezepte mit dem jeweiligen Behandlungsfortschritt, um fundierte Entscheidungen darüber treffen zu können, ob die Rechnung für ein Rezept bereits erstellt werden soll. Die Übersicht zeigt sowohl vollständig abgeschlossene Rezepte (alle für den Patienten festgelegten Behandlungen durchgeführt) als auch teilweise abgeschlossene Rezepte, bei denen der Physiotherapeut entscheiden kann, ob die Rechnung bereits vorab erstellt werden soll, um sie zur letzten Behandlung übergeben oder versenden zu können.

Die Anzeige soll es ermöglichen, schnell zu erkennen, bei welchen Rezepten die Rechnung erstellt werden soll, und den Übergang zur Rechnungserstellung zu erleichtern.

## Akzeptanzkriterien
- [ ] Eine Übersichtsseite "Aktive Rezepte" zeigt alle Rezepte an, die noch nicht vollständig abgerechnet wurden
- [ ] Für jedes Rezept wird der Behandlungsfortschritt angezeigt (z.B. "8 von 12 Behandlungen durchgeführt"), basierend auf der für den Patienten festgelegten Anzahl Behandlungen pro Rezept
- [ ] Jedes Rezept zeigt die wichtigsten Patientenstammdaten (Name, Geburtsdatum) zur Patientenidentifikation an
- [ ] Rezepte können nach verschiedenen Kriterien gefiltert werden (z.B. vollständig abgeschlossen, teilweise abgeschlossen, Patient)
- [ ] Von jedem Rezept aus kann direkt zur Rechnungserstellung navigiert werden
- [ ] Die Anzeige wird automatisch aktualisiert, wenn neue Behandlungstermine hinzugefügt oder als durchgeführt markiert werden

## Definition of Done
- [ ] Akzeptanzkriterien erfüllt
- [ ] Min. 1 Unit Test geschrieben
- [ ] Manuell getestet
- [ ] Dokumentation geupdated