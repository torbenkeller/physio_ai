# User Story Template

Dieses Template definiert das Standard-Format für User Stories im PhysioAI Projekt.

---

## Template

```markdown
## User Story
Als {{ROLLE}} möchte ich {{FUNKTIONALITÄT}}, damit {{NUTZEN}}.

## Persona
{{PERSONA_LINK}}

## Beschreibung
{{BESCHREIBUNG}}

## Akzeptanzkriterien
- [ ] {{KRITERIUM_1}}
- [ ] {{KRITERIUM_2}}
- [ ] {{KRITERIUM_3}}

## Definition of Done
- [ ] Akzeptanzkriterien erfüllt
- [ ] Getestet (Unit/Integration)
- [ ] Code Review durchgeführt
- [ ] Dokumentation aktualisiert (falls nötig)
```

---

## Variablen-Beschreibung

| Variable | Beschreibung | Beispiel |
|----------|--------------|----------|
| `{{ROLLE}}` | Die Persona/Rolle des Nutzers (aus Glossar) | Physiotherapeut |
| `{{FUNKTIONALITÄT}}` | Was der Nutzer tun können soll | ein Rezept fotografieren und hochladen |
| `{{NUTZEN}}` | Der Mehrwert für den Nutzer | die Rezeptdaten automatisch erfasst werden |
| `{{PERSONA_LINK}}` | Link zur Persona im Wiki | [Carsten Weber](wiki-link) |
| `{{BESCHREIBUNG}}` | Detaillierte Erklärung der Story | Ausführlicher Kontext und Details |
| `{{KRITERIUM_N}}` | Testbare Akzeptanzkriterien | Rezeptbild wird im JPEG/PNG Format akzeptiert |

---

## Richtlinien

### User Story Satz
- Verwendet die ubiquitäre Sprache aus dem Glossar (`docs/architektur/glossary.md`)
- Format: "Als [Rolle] möchte ich [Funktionalität], damit [Nutzen]."
- Fokus auf den Geschäftswert, nicht auf technische Implementierung

### Persona
- Verlinkt zur entsprechenden Persona im GitHub Wiki
- Hauptpersona: Carsten Weber (Physiotherapeut)

### Beschreibung
- Erklärt den Kontext und Hintergrund
- Beschreibt das "Warum" hinter der Story
- Kann technische Randbedingungen enthalten

### Akzeptanzkriterien
- 3-7 spezifische, testbare Kriterien
- Als Checkbox-Liste formatiert
- Jedes Kriterium ist eigenständig überprüfbar
- Vermeidet vage Formulierungen wie "sollte gut funktionieren"

### Definition of Done
- Standard-DoD wird für alle Stories verwendet
- Kann bei Bedarf story-spezifisch erweitert werden
- Nicht reduzieren ohne triftigen Grund

---

## Hinweise zur Verwendung

- **Milestone/Epic**: Wird über GitHub CLI zugewiesen (`--milestone`), nicht im Body dupliziert
- **Labels**: Standard-Label `story` wird beim Erstellen hinzugefügt
- **Sprache**: Alle Inhalte auf Deutsch
- **Terminologie**: Nur Begriffe aus dem Domain-Glossar verwenden
