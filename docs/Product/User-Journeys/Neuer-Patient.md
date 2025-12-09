# User Journey: Neuer Patient - Von der ersten Behandlung bis zur bezahlten Rechnung

Diese User Journey beschreibt den kompletten Prozess vom ersten Patientenkontakt bis zur bezahlten Rechnung eines Privatrezepts in Physio AI aus der Perspektive von Carsten Weber.

## Mermaid User Journey Diagramm

```mermaid
journey
    title Neuer Patient - Vollständiger Behandlungsprozess

    section Erster Kontakt
      Anruf von neuem Patienten entgegennehmen: 4: Carsten
      Neuen Patient im System anlegen: 2: Carsten
      Behandlungstermine mit Patient vereinbaren: 3: Carsten
      Vereinbarte Behandlungstermine in Kalender eintragen: 4: Carsten
      Terminbestätigung an Patient senden: 4: Carsten

    section Erste Behandlung
      Rezept vom Patienten in Empfang nehmen: 5: Patient, Carsten
      Erste Behandlung durchführen: 5: Carsten, Patient
      Rezept in das System einlesen: 4: Carsten
      KI-extrahierte Rezeptdaten auf Richtigkeit überprüfen: 3: Carsten
      Patientenstammdaten mit Rezeptinformationen anreichern: 3: Carsten
      Bereits vereinbarte Behandlungstermine dem Rezept zuordnen: 3: Carsten

    section Restliche Behandlungen
      Behandlung durchführen: 5: Carsten, Patient
      Behandlungsnotizen und -verlauf dokumentieren: 3: Carsten

    section Abrechnung
      Übersicht aller durchgeführten Behandlungen prüfen: 3: Carsten
      Rechnung für die erbrachten Leistungen erstellen: 3: Carsten
      Abrechnungstermine an das Rezept anheften: 3: Carsten
      Fertige Rechnung an den Patienten versenden: 2: Carsten

    section Zahlungsabwicklung
      Eingang der Patientenzahlung überwachen: 2: Carsten
      Behandlungsvorgang als abgeschlossen markieren: 5: Carsten
```
