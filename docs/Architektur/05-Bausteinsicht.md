# 5. Bausteinsicht

Die Bausteinsicht zeigt die statische Zerlegung des PhysioAI-Systems in Bausteine (Module, Komponenten, Subsysteme)
sowie deren Beziehungen. Diese Sicht entspricht dem "Grundriss" der Systemarchitektur.

## 5.1 Whitebox Gesamtsystem

Das PhysioAI-System besteht aus zwei Hauptbausteinen: einer Flutter App als Benutzeroberfläche und einem Backend für die Geschäftslogik. Das System integriert sich über standardisierte Schnittstellen mit externen Kalendern und KI-Anbietern.

### 5.1.1 Übersicht

```plantuml
@startuml
!theme plain

actor "Physiotherapeut" as PHYSIO

package "PhysioAI System" {
  [Flutter App] as CLIENT
  [Backend] as BACKEND
}

[Externer Kalender] as EXTCAL
[KI-Anbieter] as EXTAI

PHYSIO --> CLIENT : Bedienung
CLIENT --> BACKEND : HTTPS/REST
BACKEND <--> EXTCAL : CalDAV
BACKEND --> EXTAI : API Calls

@enduml
```

### 5.1.2 Enthaltene Bausteine

| Name | Verantwortlichkeit |
|------|-------------------|
| **Flutter App** | Benutzeroberfläche für Physiotherapeuten |
| **Backend** | Geschäftslogik, Datenhaltung und externe Integrationen |

## 5.2 Ebene 2

### 5.2.1 Whitebox Flutter App

Die Flutter App ist in fachliche Module strukturiert, die jeweils die Benutzeroberfläche für spezifische Bereiche der Physiotherapiepraxis bereitstellen.

#### Übersicht

```plantuml
@startuml
!theme plain

actor "Physiotherapeut" as PHYSIO

package "Flutter App" {
  [Patienten] as PAT
  [Rezepte] as REZ
  [Behandlungen] as BEH
  [Kalender] as KAL
  [Profil] as PROF
}

[Backend] as BACKEND <<external>>

' User Interactions
PHYSIO --> PAT
PHYSIO --> REZ
PHYSIO --> BEH
PHYSIO --> KAL
PHYSIO --> PROF


' External Dependencies
PAT --> BACKEND : REST API
REZ --> BACKEND : REST API
BEH --> BACKEND : REST API
KAL --> BACKEND : REST API
PROF --> BACKEND : REST API

@enduml
```

#### Enthaltene Bausteine

| Name | Verantwortlichkeit |
|------|-------------------|
| **Patienten** | Patientenverwaltung und -anzeige |
| **Rezepte** | Rezepterfassung und -verarbeitung |
| **Behandlungen** | Behandlungsplanung und -dokumentation |
| **Kalender** | Terminverwaltung und Kalenderansicht |
| **Profil** | Benutzerprofileinstellungen |

**Begründung der Struktur:**

Die fachlichen UI-Module entsprechen den Domain-Modulen des Backends und ermöglichen eine klare Trennung der Benutzeroberflächen-Verantwortlichkeiten. Jedes Modul kommuniziert direkt mit dem Backend über REST APIs.

### 5.2.2 Whitebox Backend

Das Backend ist in fachliche Module strukturiert, die jeweils spezifische Geschäftsbereiche der Physiotherapiepraxis abbilden.

#### Übersicht

```plantuml
@startuml
!theme plain

[Flutter App] as CLIENT <<external>>

package "Backend" {
  [Patienten] as PAT
  [Rezepte] as REZ
  [Behandlungen] as BEH
  [Profil] as PROF
}

[Externer Kalender] as EXTCAL <<external>>
[KI-Anbieter] as EXTAI <<external>>

' External Dependencies from Flutter
CLIENT --> PAT : REST API
CLIENT --> REZ : REST API
CLIENT --> BEH : REST API
CLIENT --> PROF : REST API


' External Dependencies
PROF <--> EXTCAL : CalDAV
REZ --> EXTAI : API Calls

@enduml
```

#### Enthaltene Bausteine

| Name | Verantwortlichkeit |
|------|-------------------|
| **Patienten** | Patientenstammdaten und Patientenverwaltung |
| **Rezepte** | KI-gestützte Rezeptverarbeitung und -verwaltung |
| **Behandlungen** | Behandlungsplanung und -dokumentation |
| **Profil** | Benutzerprofile und Kalenderintegration |

**Begründung der Struktur:**

Die fachlichen Module entsprechen den natürlichen Bounded Contexts der Physiotherapie-Domäne und folgen dem Domain-Driven Design. Jedes Modul ist für seinen spezifischen Geschäftsbereich verantwortlich und kommuniziert über die REST API mit der Flutter App.
