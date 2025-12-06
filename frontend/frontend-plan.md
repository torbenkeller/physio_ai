# PhysioAI Frontend-Prototyp Plan

## Übersicht

Entwicklung eines React-basierten Frontend-Prototypen für die PhysioAI Physiotherapie-Praxisverwaltung. Zielbenutzer ist Carsten Weber, ein Einzelpraxis-Physiotherapeut mit ausschließlich Privatpatienten.

## 1. Seitenstruktur

### Hauptseiten

| Seite | Route | Beschreibung |
|-------|-------|--------------|
| **Dashboard** | `/` | Übersicht mit heutigen Terminen, offenen Rezepten, ausstehenden Zahlungen |
| **Kalender** | `/kalender` | Wochenansicht mit Behandlungsterminen und privaten Terminen |
| **Patienten** | `/patienten` | Liste aller Patienten mit Suchfunktion |
| **Patient Detail** | `/patienten/:id` | Patientenstammdaten, Behandlungshistorie, Rezepte |
| **Patient Anlegen** | `/patienten/neu` | Formular für neuen Patienten |
| **Rezepte** | `/rezepte` | Übersicht aller Rezepte mit Fortschrittsanzeige |
| **Rezept Detail** | `/rezepte/:id` | Rezeptdetails, zugeordnete Behandlungen |
| **Rezept Upload** | `/rezepte/upload` | KI-gestützte Rezepterfassung |
| **Abrechnung** | `/abrechnung` | Aktive Rezepte zur Abrechnung, Zahlungsstatus |
| **Profil** | `/profil` | Praxiseinstellungen, Kalenderintegration |

### Informationsarchitektur

```
PhysioAI
├── Dashboard (Startseite)
├── Kalender
│   └── Wochenansicht mit Terminen
├── Patienten
│   ├── Patientenliste
│   ├── Patient Anlegen
│   └── Patient Detail
│       ├── Stammdaten
│       ├── Behandlungshistorie
│       └── Rezepte des Patienten
├── Rezepte
│   ├── Rezeptübersicht
│   ├── Rezept Upload (KI)
│   └── Rezept Detail
├── Abrechnung
│   ├── Aktive Rezepte
│   └── Zahlungsübersicht
└── Profil
    └── Praxiseinstellungen
```

## 2. Navigation

### Hauptnavigation (Sidebar)

```
┌─────────────────────┐
│  PhysioAI           │
│  ─────────────────  │
│  📊 Dashboard       │
│  📅 Kalender        │
│  👥 Patienten       │
│  📋 Rezepte         │
│  💰 Abrechnung      │
│  ─────────────────  │
│  ⚙️ Profil          │
└─────────────────────┘
```

### Responsive Verhalten
- Desktop: Fixierte Sidebar links
- Tablet: Collapsible Sidebar
- Mobile: Bottom Navigation Bar

## 3. Visueller Aufbau

### Design System
- **UI Library**: shadcn/ui
- **Styling**: Tailwind CSS
- **Theme**: Light Mode (Praxis-freundlich)
- **Farben**: Neutral/Professional mit Akzentfarbe für CTAs

### Layout-Struktur
```
┌────────────────────────────────────────────┐
│ Header (Breadcrumbs, Quick Actions)        │
├────────┬───────────────────────────────────┤
│        │                                   │
│ Side-  │     Main Content Area             │
│ bar    │                                   │
│        │                                   │
│        │                                   │
└────────┴───────────────────────────────────┘
```

### Komponenten-Bibliothek (shadcn/ui)
- Button, Input, Label (Formulare)
- Card (Übersichten)
- Table (Listen)
- Dialog/Sheet (Modals)
- Calendar (Datumsauswahl)
- Select, Combobox (Dropdowns)
- Toast (Benachrichtigungen)
- Form (React Hook Form Integration)

## 4. State Management

### RTK Query Endpoints
```typescript
// Patienten API
useGetPatientenQuery()
useGetPatientQuery(id)
useCreatePatientMutation()
useUpdatePatientMutation()
useDeletePatientMutation()

// Behandlungen API
useGetBehandlungenQuery()
useGetBehandlungQuery(id)
useGetWeeklyCalendarQuery(date)
useCreateBehandlungMutation()
useUpdateBehandlungMutation()
useDeleteBehandlungMutation()
useVerschiebeBehandlungMutation()

// Rezepte API
useGetRezepteQuery()
useGetRezeptQuery(id)
useCreateRezeptMutation()
useUpdateRezeptMutation()
useDeleteRezeptMutation()
useUploadRezeptImageMutation()
useGetBehandlungsartenQuery()

// Profil API
useGetProfileQuery()
useCreateProfileMutation()
useUpdateProfileMutation()
```

## 5. TODO-Liste für Implementierung

### Phase 0: Projekt-Setup (BEREITS ERLEDIGT)
Das Projekt ist bereits konfiguriert mit:
- [x] Vite 7 (Rolldown) + React 19.2 + TypeScript
- [x] Tailwind CSS v4 + tailwindcss-animate
- [x] shadcn/ui konfiguriert (components.json)
- [x] Redux Toolkit + React-Redux installiert
- [x] React Router v7 installiert
- [x] React Hook Form + Zod installiert
- [x] Vitest + Testing Library + Playwright + MSW

**Noch zu tun:**
- [ ] shadcn/ui Basis-Komponenten installieren (npx shadcn@latest add)
- [ ] src/index.css mit Tailwind Directives erstellen
- [ ] Base Store + API Slice erstellen
- [ ] Router Setup

### Phase 1: Grundlegende UI-Komponenten
- [ ] shadcn/ui Komponenten installieren (Button, Input, Card, Table, etc.)
- [ ] App-Shell mit Sidebar Navigation erstellen
- [ ] Routing-Struktur aufsetzen
- [ ] Base API Slice für RTK Query erstellen

### Phase 2: Patienten-Feature
- [ ] Patienten API Endpoints definieren
- [ ] Patienten-Liste Seite erstellen
- [ ] Patient-Anlegen Formular erstellen
- [ ] Patient-Detail Seite erstellen
- [ ] Patient-Bearbeiten Funktionalität
- [ ] Patienten-Suche implementieren

### Phase 3: Kalender-Feature
- [ ] Behandlungen API Endpoints definieren
- [ ] Kalender Wochenansicht erstellen
- [ ] Kalender Navigation (Woche vor/zurück)
- [ ] Behandlungstermine im Kalender anzeigen
- [ ] Behandlungstermin erstellen (Click auf freien Slot)
- [ ] Behandlungstermin bearbeiten
- [ ] Patient einem Termin zuordnen

### Phase 4: Rezepte-Feature
- [ ] Rezepte API Endpoints definieren
- [ ] Rezepte-Übersicht Seite erstellen
- [ ] Rezept-Detail Seite erstellen
- [ ] Rezept-Upload Seite (Bild hochladen)
- [ ] KI-Extraktion Ergebnisanzeige
- [ ] Rezeptdaten Validierung/Korrektur UI
- [ ] Behandlungsarten Auswahl

### Phase 5: Abrechnung-Feature
- [ ] Aktive Rezepte mit Fortschrittsanzeige
- [ ] Rezept-Status Anzeige (offen, Rechnung gestellt, bezahlt)
- [ ] Status-Änderung UI

### Phase 6: Dashboard
- [ ] Dashboard Layout erstellen
- [ ] Heutige Termine Widget
- [ ] Offene Rezepte Widget
- [ ] Ausstehende Zahlungen Widget

### Phase 7: Profil-Feature
- [ ] Profil API Endpoints definieren
- [ ] Profil-Seite erstellen
- [ ] Praxisdaten bearbeiten

### Phase 8: Polish & Testing
- [ ] Responsive Design überprüfen
- [ ] Fehlerbehandlung verbessern
- [ ] Loading States hinzufügen
- [ ] Vitest Unit Tests
- [ ] Playwright E2E Tests

## 6. Kritische Dateien

### Zu erstellende Verzeichnisstruktur
```
frontend/src/
├── app/
│   ├── store.ts              # Redux Store
│   ├── api.ts                # RTK Query Base API
│   └── router.tsx            # React Router Setup
├── features/
│   ├── patienten/
│   │   ├── api/patientenApi.ts
│   │   ├── components/
│   │   │   ├── PatientenListe.tsx
│   │   │   ├── PatientForm.tsx
│   │   │   └── PatientDetail.tsx
│   │   ├── types/patient.types.ts
│   │   └── index.ts
│   ├── behandlungen/
│   │   ├── api/behandlungenApi.ts
│   │   ├── components/
│   │   │   ├── Kalender.tsx
│   │   │   ├── KalenderWoche.tsx
│   │   │   └── BehandlungForm.tsx
│   │   ├── types/behandlung.types.ts
│   │   └── index.ts
│   ├── rezepte/
│   │   ├── api/rezepteApi.ts
│   │   ├── components/
│   │   │   ├── RezepteListe.tsx
│   │   │   ├── RezeptUpload.tsx
│   │   │   └── RezeptDetail.tsx
│   │   ├── types/rezept.types.ts
│   │   └── index.ts
│   ├── abrechnung/
│   │   ├── components/
│   │   │   └── AbrechnungUebersicht.tsx
│   │   └── index.ts
│   └── profil/
│       ├── api/profileApi.ts
│       ├── components/ProfilSeite.tsx
│       └── index.ts
├── shared/
│   ├── components/
│   │   ├── ui/               # shadcn/ui Komponenten
│   │   ├── Layout.tsx
│   │   ├── Sidebar.tsx
│   │   └── PageHeader.tsx
│   ├── hooks/
│   └── utils/
├── App.tsx
└── main.tsx
```

## 7. Backend API Zusammenfassung

### Verfügbare Endpoints
- `GET/POST/PATCH/DELETE /patienten`
- `GET/POST/PUT/DELETE /behandlungen`
- `GET /behandlungen/calender/week?date=YYYY-MM-DD`
- `PUT /behandlungen/{id}/verschiebe`
- `GET/POST/PATCH/DELETE /rezepte`
- `POST /rezepte/createFromImage` (Multipart)
- `GET /rezepte/behandlungsarten`
- `GET/POST/PATCH /profile`

### Wichtige DTOs
- `PatientDto`, `PatientFormDto`
- `BehandlungDto`, `BehandlungFormDto`, `BehandlungKalenderDto`
- `RezeptDto`, `RezeptCreateDto`, `EingelesenesRezeptDto`
- `ProfileDto`, `ProfileFormDto`

## 8. Implementierungshinweise

### Deutsches UI
- Alle Labels, Buttons, Texte auf Deutsch
- Domain-Begriffe aus Glossar verwenden (Patient, Behandlung, Rezept, etc.)

### Kalender-Spezifikationen
- Arbeitszeiten: Mo-Fr 8-18 Uhr
- Standard-Behandlungsdauer: 90 Minuten
- Wochenansicht als Hauptansicht

### Validierungen
- Patient: Name + Geburtsdatum pflicht
- Behandlung: Patient + Start/Ende pflicht
- Rezept: Patient + Ausstellungsdatum + min. 1 Position

## 9. Konfiguration

### Backend-URL
- Development: `http://localhost:8080/api`
- Proxy in vite.config.ts konfigurieren

### Entwicklungsstrategie
- **Alle Features parallel** entwickeln
- **Echtes Backend** verwenden (kein MSW Mocking)
- Mit Playwright durch die Anwendung navigieren und CSS-Fehler beheben

## Nächste Schritte

1. ~~Projekt-Setup~~ (bereits erledigt)
2. src/ Grundstruktur erstellen (main.tsx, App.tsx, index.css)
3. shadcn/ui Komponenten installieren
4. App-Shell mit Sidebar Navigation erstellen
5. Redux Store + RTK Query Base API erstellen
6. Alle Feature-Module parallel implementieren:
   - Patienten (Liste, Detail, Form)
   - Kalender (Wochenansicht, Termine)
   - Rezepte (Liste, Upload, Detail)
   - Abrechnung (Übersicht)
   - Profil (Einstellungen)
7. Mit Playwright durch die Anwendung navigieren und CSS-Fehler beheben
