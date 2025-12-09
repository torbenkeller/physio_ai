# 4. Lösungsstrategie

Die Lösungsstrategie beschreibt die grundlegenden Entscheidungen und Lösungsansätze für die wichtigsten Qualitätsziele
und Anforderungen des PhysioAI-Systems.

## 4.1 Technologieentscheidungen

Die folgende Tabelle zeigt die zentralen Technologieentscheidungen und deren Begründung:

| Qualitätsziel            | Lösungsansatz                                 | Begründung                                                                    |
|--------------------------|-----------------------------------------------|-------------------------------------------------------------------------------|
| **KI-Integration**       | OpenAI-kompatible APIs mit Plugin-Architektur | Flexibilität für verschiedene Anbieter, zukunftssicher für lokale Modelle     |
| **Lokale Installation**  | Raspberry Pi 5 mit Docker                     | Lokale Datenhaltung, Datenschutz, keine Cloud-Abhängigkeit für Kernfunktionen |
| **Persistierung**        | PostgreSQL auf Raspberry Pi                   | Bewährte, robuste Datenbank mit ACID-Eigenschaften                            |
| **Backend-Framework**    | Spring Boot + Kotlin                          | Produktive Entwicklung, starkes Ökosystem, JVM-Performance auf ARM64          |
| **Frontend-Framework**   | Flutter Desktop                               | Cross-Platform, native Performance, konsistente UX                            |
| **Kalender-Integration** | CalDAV-Standard (Apple-fokussiert)            | Standard-Protokoll, primäre Zielgruppe nutzt Apple-Geräte                     |

### Backend-Architektur

| Designprinzip       | Ansatz                                    | Begründung                                             |
|---------------------|-------------------------------------------|--------------------------------------------------------|
| **Architekturstil** | Hexagonale Architektur (Ports & Adapters) | Klare Trennung Domain/Infrastructure, hohe Testbarkeit |
| **Domain Modeling** | Domain-Driven Design mit Aggregates       | Fachlichkeit im Fokus, klare Bounded Contexts          |

## 4.2 Entscheidungen zur Erreichung der Qualitätsziele

### Performance (QS-1, QS-2)

| Maßnahme             | Umsetzung                                | Ziel                                                      |
|----------------------|------------------------------------------|-----------------------------------------------------------|
| **Frontend Caching** | Flutter mit Riverpod                     | < 300ms Kalendernavigation durch minimale Server-Requests |
| **Lokale Datenbank** | PostgreSQL auf selber Instanz wie Server | Schnelle Datenabfragen                                    |

### Zuverlässigkeit (QS-3, QS-6)

| Maßnahme                 | Umsetzung                           | Ziel                                        |
|--------------------------|-------------------------------------|---------------------------------------------|
| **Container-Management** | Docker Container mit Restart-Policy | Automatische Service-Recovery bei Abstürzen |
| **Tägliche Backups**     | Automatisierte PostgreSQL-Dumps     | Datenverlust max. 1 Tag                     |
| **Health Checks**        | Spring Boot Actuator                | Monitoring der Systemverfügbarkeit          |

### Funktionale Eignung (QS-4)

| Maßnahme                   | Umsetzung                        | Ziel                              |
|----------------------------|----------------------------------|-----------------------------------|
| **Multi-Model KI-Support** | Strategy Pattern für KI-Anbieter | 90% Erkennungsgenauigkeit         |
| **Strukturierte Prompts**  | Templating für KI-Anfragen       | Konsistente Extraktionsergebnisse |

### Benutzerfreundlichkeit (QS-5)

| Maßnahme               | Umsetzung                | Ziel                          |
|------------------------|--------------------------|-------------------------------|
| **Intuitive UI**       | Flutter Material Design  | 1h Einarbeitungszeit          |
| **Responsives Design** | Adaptive Flutter Layouts | Verschiedene Bildschirmgrößen |

### Wartbarkeit (QS-7)

| Maßnahme                 | Umsetzung                              | Ziel                          |
|--------------------------|----------------------------------------|-------------------------------|
| **CI/CD Pipeline**       | GitHub Actions + Docker Registry       | Automatisierte Updates        |
| **Update-Strategie**     | Docker Image Pull + Container Neustart | Minimale Downtime bei Updates |
| **Modulare Architektur** | Hexagonal Architecture                 | Einfache Erweiterbarkeit      |
