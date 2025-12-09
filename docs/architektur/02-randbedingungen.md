# 2. Randbedingungen

Diese Randbedingungen definieren externe Faktoren und unveränderliche Vorgaben, die das PhysioAI-System und dessen
Entwicklung einschränken.

## 2.1 Technische Randbedingungen

### Hardware-Randbedingungen

| Kategorie                | Randbedingung                               | Konsequenzen                                                                                                                           |
|--------------------------|---------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------|
| **Zielplattform**        | System muss auf Raspberry Pi lauffähig sein | - ARM-kompatible Builds erforderlich<br>- Optimierte Implementierung für ARM64-Architektur<br>- Berücksichtigung begrenzter Ressourcen |
| **Mindestanforderungen** | Raspberry Pi 5 (16GB RAM)                   | - Erweiterte Speicherkapazität verfügbar<br>- Bessere Performance für KI-Operationen<br>- Möglichkeit für In-Memory-Caching            |

## 2.2 Organisatorische Randbedingungen

### Betriebsrandbedingungen

| Kategorie             | Randbedingung                          | Konsequenzen                                                                                                                   |
|-----------------------|----------------------------------------|--------------------------------------------------------------------------------------------------------------------------------|
| **Deployment Target** | Raspberry Pi als Edge Device           | - Standalone Deployment erforderlich<br>- Lokale Datenhaltung notwendig<br>- Offline-Funktionalität für Kernfunktionen         |
| **Datenschutz**       | Lokale Datenhaltung (DSGVO-Compliance) | - Keine Cloud-Abhängigkeit für Patientendaten<br>- Lokale Backup-Strategien erforderlich<br>- Verschlüsselung sensitiver Daten |

### Betriebsumgebung

| Kategorie      | Randbedingung                            | Konsequenzen                                                                                                                   |
|----------------|------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------|
| **Zielgruppe** | Kleine bis mittlere Physiotherapiepraxen | - Einfache Installation und Wartung<br>- Geringe IT-Affinität berücksichtigen<br>- Benutzerfreundliche Oberfläche erforderlich |

## Konsequenzen der Randbedingungen

### Positive Auswirkungen

- **Datenschutz**: Vollständige Kontrolle über Patientendaten durch lokale Speicherung
- **Kosten**: Keine laufenden Cloud-Kosten oder Lizenzgebühren
- **Einfachheit**: Keine komplexe Netzwerk-Infrastruktur erforderlich

### Herausforderungen

- **Ressourcen**: Begrenzte Hardware-Ressourcen erfordern effiziente Implementierung
- **Updates**: Lokale Installation erschwert automatische Updates
- **Skalierung**: Hardware-Grenzen bei wachsenden Datenmengen
