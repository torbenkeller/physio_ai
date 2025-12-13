# Flyway Migrations - Wichtige Hinweise

## Spring Data JDBC @Version Feld

**Wichtig:** Wenn du über Flyway-Migrationen neue Tabellen mit einem `version`-Feld für Spring Data JDBC erstellst:

### Das Problem
Spring Data JDBC verwendet das `@Version`-Feld, um zu erkennen, ob eine Entity neu ist oder bereits existiert:
- `version = 0` → Entity wird als **NEU** behandelt → **INSERT**
- `version > 0` → Entity wird als **existierend** behandelt → **UPDATE**

### Die Regel
Wenn du in einer Migration Daten **einfügst** (INSERT), setze `version = 1`, nicht `version = 0`:

```sql
-- FALSCH: Führt zu Duplicate Key Errors beim Update
INSERT INTO meine_tabelle (id, ..., version) VALUES (uuid, ..., 0);

-- RICHTIG: Spring Data JDBC erkennt die Entity als existierend
INSERT INTO meine_tabelle (id, ..., version) VALUES (uuid, ..., 1);
```

### Warum?
Wenn die Migration mit `version = 0` einfügt und die Anwendung später die Entity lädt und speichert:
1. Entity wird mit `version = 0` aus der Datenbank geladen
2. `save()` wird aufgerufen
3. Spring Data JDBC sieht `version = 0` und denkt: "Das ist eine neue Entity"
4. Spring Data JDBC versucht ein INSERT
5. **Fehler:** `duplicate key value violates unique constraint`

### Beispiel aus diesem Projekt
Siehe `V010__create_kalender_einstellungen.sql` und `V012__fix_kalender_einstellungen_version.sql` für ein konkretes Beispiel dieses Problems und seiner Lösung.
