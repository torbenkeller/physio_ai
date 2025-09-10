---
Ticket-ID: PHSIOAI-022-STORY-rezept-bezahlt-markieren
Created-At: 2025-09-10
Epic: PHSIOAI-015-EPIC-abrechnung
Status: To-Do
Blocked-By: 
Planning-Document:
---

# Rezept als bezahlt markieren

## User Story
Als Physiotherapeut möchte ich ein Rezept als bezahlt markieren können, damit ich nachvollziehen kann, welche Rezepte bereits bezahlt wurden.

## Beschreibung
Diese User Story ermöglicht es dem Physiotherapeuten, den Zahlungsstatus eines Rezepts zu verwalten. Nach dem Versenden einer Rechnung und dem Erhalt der Zahlung vom Privatpatienten muss das System die Möglichkeit bieten, das entsprechende Rezept als bezahlt zu markieren. Dies ist ein wichtiger Schritt im Abrechnungsworkflow, um eine vollständige Übersicht über den Zahlungseingang zu haben und offene Forderungen zu identifizieren.

Das Feature soll eine klare Statusverfolgung ermöglichen und dabei helfen, das Mahnwesen zu organisieren. Bezahlte Rezepte sollen vom System als abgeschlossen behandelt werden, während unbezahlte Rezepte weiterhin als offene Forderungen erscheinen.

## Akzeptanzkriterien
- [ ] Physiotherapeut kann in der Rezeptübersicht ein Rezept mit Status "Rechnung gestellt" als "bezahlt" markieren
- [ ] Nach dem Markieren als bezahlt wird der Zahlungsstatus des Rezepts dauerhaft gespeichert
- [ ] Bezahlte Rezepte werden visuell von unbezahlten Rezepten unterscheidbar dargestellt (z.B. grüner Zahlungsstatus)
- [ ] Das System zeigt das Datum der Zahlungsmarkierung an
- [ ] Physiotherapeut kann das Datum des Zahlungseingangs erfassen und bearbeiten
- [ ] Physiotherapeut kann den Zahlungsstatus zwischen "bezahlt" und "unbezahlt" wechseln (z.B. bei Korrekturen oder Stornierungen)
- [ ] Das System protokolliert die Zahlungsmarkierung mit Zeitstempel für Nachverfolgungszwecke

## Definition of Done
- [ ] Akzeptanzkriterien erfüllt
- [ ] Min. 1 Unit Test geschrieben
- [ ] Manuell getestet
- [ ] Dokumentation geupdated