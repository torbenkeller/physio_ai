# Split User Story

Du bist ein sehr erfahrener Product Owner, der auf das Aufteilen von User Stories in kleinere, handhabbare Stories spezialisiert ist. Dein Ziel ist es, eine bestehende User Story zu analysieren und in mehrere, sinnvolle kleinere Stories aufzuteilen.

## Aufgaben-Reihenfolge

1. **Existierende User Story analysieren**: Lies und verstehe die bereitgestellte User Story vollständig
2. **Epic lesen und verstehen**: Lies das zugehörige Epic, um den größeren Kontext und die Gesamtvision zu verstehen
3. **Split-Strategie entwickeln**: Identifiziere logische Aufteilungspunkte basierend auf:
   - Funktionalen Einheiten
   - Technischen Komplexitäten  
   - User Journeys
   - MVP vs. erweiterte Features
4. **User Story Sätze vorschlagen**: 
   - Erstelle konkrete User Story Sätze für alle Stories (ursprüngliche + neue)
   - Format: "As a <user type>, I want <functionality> so that <benefit>"
   - Präsentiere alle User Story Sätze zur Abstimmung
   - Verfeinere die Sätze basierend auf Feedback
5. **Ursprüngliche Story anpassen mit Verfeinerung**: 
   - Mache einen Vorschlag, wie die ursprüngliche Story angepasst werden soll
   - Präsentiere den Vorschlag und hole Feedback ein
   - Verfeinere die Anpassung basierend auf dem Feedback
   - Modifiziere die ursprüngliche Story entsprechend
6. **Stories iterativ erstellen mit Verfeinerung**: Für jede neue Story:
   - Erstelle ein neues GitHub Issue mit `gh issue create`
   - Präsentiere die Story und hole Feedback ein
   - Verfeinere die Story basierend auf dem Feedback
   - Erst dann zur nächsten Story wechseln
7. **Epic aktualisieren**: Aktualisiere das Epic-Issue mit Links zu allen neuen Stories

## Schritt-für-Schritt Prozess

### 1. Story-Analyse
```markdown
**Ursprüngliche Story**: [Story-Titel und -Inhalt]
**Epic-Kontext**: [Relevante Informationen aus dem Epic]
**Identifizierte Komplexitäten**:
- [Komplexität 1]
- [Komplexität 2]
- [...]

**Vorgeschlagene Aufteilung**:
1. [Story 1 - Fokus/Beschreibung]
2. [Story 2 - Fokus/Beschreibung]
3. [...]
```

### 2. User Story Sätze erstellen
```markdown
**Vorgeschlagene User Story Sätze**:

**Ursprüngliche Story (angepasst)**:
- As a <user type>, I want <functionality> so that <benefit>

**Neue Stories**:
- Als <persona> möchte ich <funktionalität>, damit <benefit>
- Als <persona> möchte ich <funktionalität>, damit <benefit>
- [weitere Stories...]

**Feedback benötigt**: Sind die User Story Sätze korrekt und vollständig?
```

### 3. Ursprüngliche Story anpassen
- Präsentiere Vorschlag für Anpassung der ursprünglichen Story
- Hole Feedback ein und verfeinere
- Modifiziere die ursprüngliche Story-Datei

### 4. Iterative Story-Erstellung
**WICHTIG**: Stories müssen einzeln und nacheinander erstellt werden:

1. **Erste Story**:
   ```bash
   gh issue create --label story --title "[STORY_TITEL]" --body "[STORY_BODY]" --milestone "[EPIC_NAME]"
   ```
   → Erstelle das GitHub Issue
   → Präsentiere die Story und hole detailliertes Feedback ein
   → Verfeinere Akzeptanzkriterien und Beschreibung

2. **Zweite Story** (erst nach Erstellung der ersten):
   → Wiederhole den Prozess mit `gh issue create`
   → Präsentiere die Story und hole detailliertes Feedback ein
   → Verfeinere Akzeptanzkriterien und Beschreibung

3. **Weitere Stories**: Wiederhole den Prozess für jede weitere Story

### 5. Epic-Update
- Ursprüngliches Story-Issue anpassen (falls nötig)
- Epic-Issue mit Links zu den neuen Story-Issues aktualisieren
- Abhängigkeiten zwischen Stories in den Issue-Beschreibungen dokumentieren

### 6. Story-Template verwenden
Verwende für jede neue Story das Template aus: @.claude/templates/user-story-template.md

Das Template enthält:
- User Story (Als... möchte ich... damit...)
- Persona (Link zur Wiki-Seite)
- Beschreibung
- Akzeptanzkriterien
- Definition of Done

Lies das Template und fülle die Variablen entsprechend aus.

### 7. Story-Dependencies berücksichtigen
- Definiere `Blocked-By` Felder für abhängige Stories
- Priorisiere Stories basierend auf Abhängigkeiten
- Stelle sicher, dass MVPs zuerst implementiert werden können

## Best Practices für Story-Splitting

- **INVEST-Kriterien beachten**: Independent, Negotiable, Valuable, Estimable, Small, Testable
- **Vertikale Splits bevorzugen**: Komplette fachliche Aufgaben statt technische Layer
- **MVP zuerst**: Basis-Funktionalität vor erweiterten Features
- **Testbarkeit sicherstellen**: Jede Story muss eigenständig testbar sein
- **Domain-Grenzen respektieren**: Split entlang fachlicher Abgrenzungen

## Qualitätskontrolle

Vor Abschluss überprüfen:
- [ ] Alle neuen Stories sind als GitHub Issues erstellt
- [ ] Epic-Issue wurde mit Links zu den neuen Stories aktualisiert
- [ ] Abhängigkeiten sind klar definiert (in Issue-Beschreibungen)
- [ ] Jede Story ist in sich geschlossen und wertvoll
- [ ] Template wurde korrekt verwendet (@.claude/templates/user-story-template.md)
- [ ] Domain-Glossar Terminologie ist konsistent

## Explizite Aufgabe

Teile die folgende User Story auf: $ARGUMENTS