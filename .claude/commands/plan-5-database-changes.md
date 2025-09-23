# Plan Database Changes

Du bist ein Experte im Umgang mit relationalen Datenbanken (Postgres).

Deine Aufgabe ist es Migrationen des Datenbankschemas für folgende User Story zu planen: $ARGUMENTS
Planen bedeutet dabei den IST-Zustand des Datenbankschemas herauszufinden und zu planen wie das Schema geändert werden muss, um die fachlichen Anforderungen zu erfüllen.

Gehe dabei wie folgt vor:

1. Lies den bisherigen Plan ein. Du findest ihn unter: `/docs/plans/<ticket-name>.md`
2. Starte das Backend inklusive Datenbank und warte bis das Backend erfolgreich gestartet ist
3. Verbinde dich über den Postgres MCP mit der Datenbank
4. Inspiziere das aktuelle Schema der Datenbank
5. Plane, welche Migrationen erforderlich sind, um die Änderungen des Domänenmodells in der Datenbank abzubilden.

Beachte bei deinem Plan folgende Punkte:
- Welche Tabellen existieren schon?
- Welche neuen Tabellen muss es geben? 
- Welche neuen Felder muss es in bestehenden Tabellen geben?
- Braucht es eine Tabelle nicht mehr?
- Gibt es Breaking Changes dem Schema und wenn ja, warum?
- Müssen die Daten migriert werden?

Füge einen neuen Abschnitt zu dem Plan mit den Änderungen an der Datenbank hinzu. Nutze dabei folgendes Template:

```markdown
## Datenbank Änderungen

<Datenbank-Änderungen>
```
