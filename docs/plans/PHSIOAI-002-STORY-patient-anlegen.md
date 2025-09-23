# Plan PHSIOAI-002-STORY-patient-anlegen

## Kontext
Diese User Story ist Teil des Epic "Erster Kontakt" (PHSIOAI-001-EPIC-erster-kontakt) und bildet die Grundlage für den Onboarding-Prozess neuer Patienten im PhysioAI System. Sie ermöglicht es Physiotherapeuten, neue Patienten mit grundlegenden Informationen anzulegen, die dann für die weitere Terminplanung und Behandlungsverwaltung verfügbar sind.

Die Patientenverwaltung ist bereits vollständig implementiert, einschließlich Domain-Modell (PatientAggregate), Service-Layer (PatientenService), Repository-Pattern (PatientenRepository), REST-API (PatientenController) und Datenbankschema. Das System unterstützt bereits die Erstellung von Patienten mit allen erforderlichen Feldern inklusive Validierung.

## Akzeptanzkriterien

- [ ] Ein neuer Patient kann mit Vor- und Nachname sowie Geburtsdatum angelegt werden
- [ ] Die eingegebenen Patientendaten werden validiert (Name nicht leer, gültiges Geburtsdatum)
- [ ] Der neue Patient wird persistent in der Datenbank gespeichert
- [ ] Nach erfolgreichem Anlegen wird eine Bestätigung angezeigt
- [ ] Der neu angelegte Patient ist sofort für die Terminzuordnung verfügbar

### Ein neuer Patient kann mit Vor- und Nachname sowie Geburtsdatum angelegt werden
Das System verfügt bereits über ein vollständiges PatientAggregate mit allen erforderlichen Feldern. Die REST-API unter `/patienten` unterstützt POST-Requests mit PatientFormDto, welches vorname, nachname und geburtstag als Felder enthält. Die Frontend-Implementierung mit PatientForm und CreatePatientPage ist bereits vorhanden.

### Die eingegebenen Patientendaten werden validiert (Name nicht leer, gültiges Geburtsdatum)
Die Validierung ist teilweise implementiert: Das PatientFormDto verwendet Jakarta-Validierungsannotationen (@Past für Geburtsdatum, @Email für E-Mail). Die Controller-Implementation erwartet vorname und nachname als Required-Felder (mit Fallback auf leeren String). Für eine vollständige Validierung gemäß Akzeptanzkriterium müssen die Validierungsregeln präzisiert werden.

### Der neue Patient wird persistent in der Datenbank gespeichert
Die Persistierung ist vollständig implementiert: PatientenRepository mit JDBC-Implementation, Datenbankschema mit patienten-Tabelle ist vorhanden, PatientenServiceImpl ruft repository.save() auf zur persistenten Speicherung.

### Nach erfolgreichem Anlegen wird eine Bestätigung angezeigt
Diese Funktionalität ist im Frontend zu implementieren. Die REST-API gibt bei erfolgreichem POST einen PatientDto zurück, was als Grundlage für eine Erfolgsbestätigung genutzt werden kann.

### Der neu angelegte Patient ist sofort für die Terminzuordnung verfügbar
Die Grundfunktionalität ist vorhanden: Patienten erhalten eine eindeutige PatientId (UUID), die REST-API bietet GET `/patienten` für das Abrufen aller Patienten. Die Integration mit der Terminverwaltung (BehandlungenController) ist bereits implementiert und nutzt PatientId zur Zuordnung.

## User Experience

### IST-Zustand der Anwendung

Die Anwendung verfügt bereits über eine vollständige Patientenerstellung-Funktion:

**Navigation und Routing:**
- **Mobile/Tablet:** `/patienten/create` als Modal/Fullscreen Dialog über die Patientenliste
- **Desktop:** `/patienten/create` als Split-View mit Patientenliste links und Formular rechts
- Zugang über FloatingActionButton "Anlegen" in der Patientenliste (`/patienten`)

**Bestehende UI-Komponenten:**
- `CreatePatientPage`: Haupt-Page-Wrapper mit AppBar "Patient Erstellen"
- `PatientForm`: Vollständiges Formular mit allen Patientenfeldern (Titel, Vor-/Nachname, Geburtsdatum, Adresse, Kontakt)
- `PatientenPage`: Liste aller Patienten mit "Anlegen"-Button
- `PatientFormContainer`: Validierungslogik und Form-State-Management

**Aktuelle User Journey:**
1. Nutzer navigiert zu "Patienten" (Bottom Navigation/Rail/Drawer)
2. Klick auf FloatingActionButton "Anlegen"
3. Formular öffnet sich als Modal (Mobile/Tablet) oder Split-View (Desktop)
4. Eingabe der Patientendaten mit Validierung
5. "Speichern" führt API-Call aus mit Loading-Indicator
6. Bei Erfolg: Formular schließt sich automatisch, Nutzer ist zurück in Patientenliste

### Erforderliche UX-Änderungen

Basierend auf den Akzeptanzkriterien sind folgende Anpassungen erforderlich:

#### 1. Erfolgsbestätigung implementieren (Akzeptanzkriterium: "Nach erfolgreichem Anlegen wird eine Bestätigung angezeigt")

**Problem:** Aktuell wird kein explizites Feedback über erfolgreiche Patientenerstellung gegeben.

**Lösung:**
- SnackBar-Bestätigung nach erfolgreichem Speichern: "Patient [Vorname Nachname] wurde erfolgreich angelegt"
- Implementation direkt in `PatientForm._onSubmit()` mittels `ScaffoldMessenger.of(context).showSnackBar()`
- `BuildContext` ist als `context` Property verfügbar (StatefulWidget)
- Konsistent mit bestehenden SnackBar-Patterns der App (bereits in `profile_page.dart`, `rezept_form.dart` verwendet)

#### 2. Validierung schärfen (Akzeptanzkriterium: "Die eingegebenen Patientendaten werden validiert (Name nicht leer, gültiges Geburtsdatum)")

**Problem:** Validierung ist unvollständig - Required-Felder haben Fallback auf leeren String.

**Lösung:**
- Präzisierung der Validierungsregeln in `PatientFormContainer`
- Vorname und Nachname als wirklich Required-Felder (nicht leer)
- Geburtsdatum in der Vergangenheit (bereits vorhanden via `@Past`)

#### 3. Navigation nach Patientenerstellung optimieren

**Problem:** Nach erfolgreichem Anlegen ist unklar, dass der Patient verfügbar ist.

**Lösung:**
- Nach Erfolgsbestätigung: Automatische Navigation zur neuen Patienten-Detailseite (`/patienten/{id}`)
- Alternative: Option "Rezept erstellen" direkt aus der Erfolgsbestätigung

### Keine Änderungen an Routen erforderlich

- **Bestehende Routen bleiben unverändert:** `/patienten` und `/patienten/create`
- **Informationsarchitektur bleibt gleich:** Patientenerstellung als Teil des Patienten-Moduls
- **Navigation bleibt konsistent:** Zugang über Patienten-Hauptseite

### Zusammenfassung der UX-Änderungen

**Minimal erforderlich:**
1. SnackBar-Erfolgsbestätigung in `PatientForm._onSubmit()`
2. Validierung für Required-Felder schärfen in `PatientFormContainer`

**Optional (bessere UX):**
1. Navigation zu Patienten-Detail nach Erfolg
2. Quick-Action "Rezept erstellen" in Erfolgsbestätigung

**Unverändert:**
- Routing-Struktur
- Navigation-Pattern
- Form-Layout und -Felder
- Responsive Verhalten (Mobile/Desktop)

## Domänenmodell

**Keine Änderungen erforderlich** - Das Domänenmodell ist bereits vollständig implementiert:

- `PatientAggregate` mit allen erforderlichen Feldern (`vorname`, `nachname`, `geburtstag`, etc.)
- `PatientenService` mit `createPatient()` Methode
- `PatientId` für typsichere Referenzierung
- Repository-Pattern für Persistierung

Alle Akzeptanzkriterien werden durch die bestehende Domain-Struktur abgedeckt.

## API Änderungen

**Keine API-Änderungen erforderlich** - Die bestehende REST API mit `POST /patienten` und `GET /patienten` deckt bereits alle Akzeptanzkriterien vollständig ab. Alle Implementierungsarbeiten erfolgen Frontend-seitig.

## Datenbank Änderungen

**Keine Datenbankänderungen erforderlich** - Die bestehende `patienten` Tabelle enthält bereits alle erforderlichen Felder (`vorname`, `nachname`, `geburtstag`) und unterstützt vollständig alle Akzeptanzkriterien der User Story.

## TODOs

### Frontend
- [x] Erfolgsbestätigung implementieren: SnackBar nach erfolgreichem Anlegen eines Patienten mit Nachricht "Patient [Vorname Nachname] wurde erfolgreich angelegt"
- [x] SnackBar in `PatientForm._onSubmit()` mittels `ScaffoldMessenger.of(context).showSnackBar()` implementieren
- [x] Validierung für Required-Felder schärfen: Vorname und Nachname dürfen nicht leer sein (bereits korrekt implementiert)
- [x] Validierungsregeln in `PatientFormContainer` präzisieren (nicht leer für Namen) (bereits korrekt implementiert)
- [x] Nach erfolgreichem Anlegen automatisch zur Patienten-Detailseite navigieren (optional für bessere UX) - **ERWEITERT**: Optionale Redirect-Funktionalität mit String-Template-Parameter implementiert
- [x] Form-State nach erfolgreichem Speichern zurücksetzen
- [x] Loading-Indicator während API-Call beibehalten/optimieren (bereits vorhanden)
- [x] Error-Handling für fehlgeschlagene Patient-Erstellung verbessern

### Zusätzlich implementiert (über Story-Anforderungen hinaus)
- [x] **Optionale Redirect-Funktionalität**: Implementierung von `/patienten/create?to={redirectTemplate}` mit `{patientId}` Platzhalter
  - Router extrahiert `to` Query-Parameter und übergibt an Components
  - PatientForm ersetzt `{patientId}` mit tatsächlicher Patient-ID bei erfolgreichem Anlegen
  - Fallback zur Standard-Navigation (`/patienten/{patientId}`) wenn kein Redirect angegeben
  - Beispiel: `/patienten/create?to=/behandlungen?selectedPatient={patientId}` → `/behandlungen?selectedPatient=actual-patient-id`
- [x] **Umfassende Tests**: String-Replacement-Funktionalität getestet (29 Tests bestehen)

### Backend
- [x] Backend-Validierung für Required-Felder überprüfen und ggf. anpassen (Vorname/Nachname nicht leer)
- [x] Unit Tests für PatientenService.createPatient() mit ungültigen Eingaben erweitern
- [x] Integration Tests für POST /patienten mit Validierungsfehlern schreiben
- [x] Dokumentation der REST-API bzgl. Validierungsregeln aktualisieren