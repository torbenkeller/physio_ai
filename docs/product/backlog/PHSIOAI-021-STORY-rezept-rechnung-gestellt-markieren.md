---
Ticket-ID: PHSIOAI-021-STORY-rezept-rechnung-gestellt-markieren
Created-At: 2025-09-10
Epic: PHSIOAI-015-EPIC-abrechnung
Status: To-Do
Blocked-By: 
Planning-Document:
---

# Rezept als "Rechnung gestellt" markieren

## User Story
Als Physiotherapeut möchte ich ein Rezept als "Rechnung gestellt" markieren können, damit ich sehe, welche Rechnungen ich bereits versendet habe.

## Beschreibung
Nach der Erstellung und dem Versand einer Rechnung an einen Patienten muss der Physiotherapeut das entsprechende Rezept als "Rechnung gestellt" markieren können. Diese Funktion ermöglicht eine klare Übersicht über den Abrechnungsstatus aller Rezepte und verhindert versehentliche Doppel-Abrechnungen. Der Status wird persistent gespeichert und in der Rezeptübersicht visuell dargestellt, sodass der Therapeut auf einen Blick erkennen kann, welche Rezepte bereits abgerechnet wurden und welche noch ausstehen.

## Akzeptanzkriterien
- [ ] Ein Rezept kann über die Rezeptübersicht als "Rechnung gestellt" markiert werden
- [ ] Der Status "Rechnung gestellt" wird persistent in der Datenbank gespeichert
- [ ] Rezepte mit Status "Rechnung gestellt" werden in der Übersicht visuell unterscheidbar dargestellt (z.B. durch Icon oder Farbkodierung)
- [ ] Die Markierung kann nur bei Rezepten gesetzt werden, für die bereits eine Rechnung generiert wurde
- [ ] Ein bereits als "Rechnung gestellt" markiertes Rezept kann nicht versehentlich erneut abgerechnet werden

## Definition of Done
- [ ] Akzeptanzkriterien erfüllt
- [ ] Min. 1 Unit Test geschrieben
- [ ] Manuell getestet
- [ ] Dokumentation geupdated