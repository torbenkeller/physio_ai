# 10. Qualitätsanforderungen

## 10.1 Qualitätsbaum

### Performance
- **Reaktionszeit**: Schnelle Systemantworten für flüssige Arbeitsabläufe
- **Durchsatz**: Effiziente Verarbeitung von Rezept-Uploads

### Zuverlässigkeit
- **Verfügbarkeit**: Hohe Systemverfügbarkeit während Arbeitszeiten
- **Datenintegrität**: Sichere Speicherung und Backup von Patientendaten

### Benutzerfreundlichkeit
- **Lernbarkeit**: Einfache Einarbeitung für neue Mitarbeiter
- **Bedienbarkeit**: Intuitive Nutzung auch während Telefonaten

### Funktionale Eignung
- **Genauigkeit**: Präzise KI-gestützte Datenextraktion aus Rezepten
- **Vollständigkeit**: Alle erforderlichen Praxisfunktionen verfügbar

### Wartbarkeit
- **Änderbarkeit**: Einfache Updates ohne Betriebsunterbrechung

## 10.2 Qualitätsszenarien

Die folgenden Szenarien konkretisieren die Qualitätsanforderungen nach dem Muster: 
**Umgebung, Persona, Event, Artefakt, Antwort, Messung**

### Performance-Szenarien

#### QS-1: KI-Rezeptverarbeitung
In der normalen Nachbearbeitung lädt ein Physiotherapeut ein Rezeptbild in das PhysioAI-System hoch. Die vollständige Extraktion der Patientendaten ist innerhalb von 20 Sekunden abgeschlossen für 95% aller Uploads.

#### QS-2: Kalendernavigation  
Während eines Terminbuchungsanrufs navigiert ein Physiotherapeut durch den Kalender zwischen verschiedenen Wochen. Die Kalenderansicht lädt und wird interaktiv innerhalb von 300ms für 95% der Navigationsaktionen.

### Verfügbarkeits-Szenarien

#### QS-3: Systemverfügbarkeit
Während der Arbeitszeiten (8:00-18:00 Uhr) ist das PhysioAI-System verfügbar und funktionsfähig. Ausfälle sind auf maximal einen Arbeitstag pro Monat begrenzt für 99% der Betriebsmonate. Nächtliche Wartungsarbeiten haben keine Auswirkungen auf den Praxisbetrieb.

### Genauigkeits-Szenarien

#### QS-4: KI-Datenextraktion
Bei der Nachbearbeitung verarbeitet das PhysioAI-System hochgeladene Rezeptbilder mittels KI-Extraktion. Die automatisch extrahierten Patientendaten sind zu 90% korrekt und vollständig, sodass maximal 1 von 10 Rezepten manuell nachbearbeitet werden muss.

### Benutzerfreundlichkeits-Szenarien

#### QS-5: Einarbeitungszeit
Ein neuer Physiotherapeut erhält eine einstündige Einführungsschulung in das PhysioAI-System. Nach dieser Schulung kann er alle Grundfunktionen (Terminbuchung, Patientenanlage, Rezept-Upload) selbstständig ohne weitere Hilfe ausführen.

### Sicherheits-Szenarien

#### QS-6: Datensicherung
Das PhysioAI-System erstellt automatisch täglich Backups aller Patientendaten und Termine. Bei einem Datenverlust können die Backups manuell eingespielt werden, um den vollständigen Datensatz zu 99% wiederherzustellen (maximal 1 Tag Datenverlust).

### Wartbarkeits-Szenarien

#### QS-7: Software-Updates
Während nächtlicher Wartungszeiten (22:00-06:00 Uhr) kann das PhysioAI-System für Software-Updates offline gehen. Wartungsarbeiten sind ohne Beeinträchtigung des Praxisbetriebs möglich.

## 10.3 Systemgrenzen

### Skalierbarkeit
- **Single-Tenant-System**: Ausgelegt für eine Physiotherapiepraxis
- **Rezeptvolumen**: Maximal 10 Rezepte täglich
- **Nutzeranzahl**: Begrenzt auf Praxisteam (1-3 Personen gleichzeitig)