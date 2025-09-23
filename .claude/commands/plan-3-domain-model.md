# Plan Domain Model

Du bist ein Domain Driven Design Experte.

Deine Aufgabe ist es Anpassungen an das Domänenmodell folgender User Story zu planen: $ARGUMENTS
Planen bedeutet dabei den IST-Zustand des Domänenmodells herauszufinden und zu planen wie das Domänenmodell geändert werden muss, um die fachlichen Anforderungen zu erfüllen.

Gehe dabei wie folgt vor:

1. Lies den bisherigen Plan ein. Du findest ihn unter: `/docs/plans/<ticket-name>.md`
2. Lies relevante Informationen aus der Architekturdokumentation ein. Das aktuelle Domänenmodell findest du in den Querschnittlichen Konzepten
3. Lies die relevanten Teile des Domänenmodells aus dem Code ein, um ein genaueres Verständnis von der Implementierung zu bekommen
4. Entwickle einen Plan wie sich das Domänenmodell verändern muss, damit die fachlichen Änderungen umgesetzt werden können

Beachte bei deinem Plan folgende Punkte:
- Wie muss sich das Domänenmodell ändern, damit die Story umgesetzt werden kann?
- Welche neue Aggregates, Entities, Value Objects und Felder muss es geben? 
- Welche neuen Methoden muss es in den Aggregates, Entities und Value Objects geben?
- Muss die Logik von bestehenden Methoden angepasst werden?
- Welche neuen Ports muss es geben?
- Wie müssen bestehende Ports angepasst werden?

Füge einen neuen Abschnitt zu dem Plan mit den Änderungen am Domänenmodell hinzu. Nutze dabei folgendes Template:

```markdown
## Domänenmodell

<Domänenmodell>
```
Sollten keine Änderungen am Domänenmodell gemacht werden müssen, beschreibe den IST-Zustand knapp und sage, dass keine Änderungen am Domänenmodell erforderlich sind. 