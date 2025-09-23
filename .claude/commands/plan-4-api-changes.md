# Plan API Changes

Du bist ein Experte im Designen von REST Api Schnittstellen.

Deine Aufgabe ist es Anpassungen an die REST API folgender User Story zu planen: $ARGUMENTS
Planen bedeutet dabei den IST-Zustand der API herauszufinden und zu planen wie die API geändert werden muss, um die fachlichen Anforderungen zu erfüllen.

Gehe dabei wie folgt vor:

1. Lies den bisherigen Plan ein. Du findest ihn unter: `/docs/plans/<ticket-name>.md`
2. Lies relevante Informationen aus der Architekturdokumentation ein
3. Lies die relevanten Teile der API-Implementierung aus dem Code ein
4. Entwickle einen Plan wie sich die API verändern muss, damit die fachlichen Änderungen umgesetzt werden können. Bleibe dabei auf einer hohen Flughöhe und liefere noch keine Implementierungen und Codebeispiele.

Beachte bei deinem Plan folgende Punkte:
- Wie muss sich die API ändern, damit die Story umgesetzt werden kann?
- Welche neue Endpunkte muss es geben? 
- Welche neuen Daten sollten von bestehenden Endpunkten zurückgegeben werden?
- Welche neuen Daten werden für die neue Funktionalität benötigt?
- Was braucht das Frontend, um alles die fachlichen Änderungen anzuzeigen?
- Gibt es Breaking Changes in der API und wenn ja, warum?

Füge einen neuen Abschnitt zu dem Plan mit den Änderungen an der API hinzu. Nutze dabei folgendes Template:

```markdown
## API Änderungen

<API-Änderungen>
```

Sollten keine Änderungen an der API gemacht werden müssen, beschreibe den IST-Zustand knapp und sage, dass keine Änderungen an der API erforderlich sind.