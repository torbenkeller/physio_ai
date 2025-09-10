# Neuer Patient (User Story Map)

User story mapping für den kompletten Behandlungsprozess eines neuen Patienten von Carsten Weber - vom ersten Kontakt bis zur bezahlten Rechnung eines Privatrezepts in Physio AI.

## Mapping

### Erster Kontakt

#### Anruf von neuem Patienten entgegennehmen
- Telefon klingelt und wird beantwortet
- Grund der Behandlung erfragen
- Anzahl der Behandlungen erfragen

#### Neuen Patient im System anlegen
- Patientenstammdaten (Name, Kontakt) erfragen
- Patientenstammdaten eingeben
- Behandlungen pro Rezept festlegen
- Patientenakte erstellen

#### Behandlungstermine mit Patient vereinbaren
- Kalender anzeigen
- Termine mit Patient abstimmen

#### Vereinbarte Behandlungstermine in den Kalender eintragen
- Patient dem Behandlungstermin zuordnen
- Termindauer basierend auf Behandlungsart festlegen
- Behandlungstermin im Kalender erstellen
- Terminbestätigung an Patient senden

### Erste Behandlung

#### Rezept vom Patienten in Empfang nehmen
- Physisches Rezept entgegennehmen
- Rezepts prüfen
- Rezept sicher verwahren
- Erste Behandlung durchführen

#### Rezept in das System einlesen/digitalisieren
- Rezept fotografieren
- Datei im System hochladen
- KI-Rezepterkennung starten

#### KI-extrahierte Rezeptdaten auf Richtigkeit überprüfen
- Extrahierte Daten mit Original vergleichen
- Behandlungsverordnungen kontrollieren
- Anzahl der Behandlungen verifizieren
- Fehler korrigieren falls nötig

#### Patientenstammdaten mit Rezeptinformationen anreichern
- Rezept zu Patientenakte hinzufügen

#### Bereits vereinbarte Behandlungstermine dem Rezept zuordnen
-  Bereits vereinbarte Behandlungstermine dem Rezept zuordnen

### Restliche Behandlungen

#### Behandlungsnotizen und -verlauf dokumentieren
- Notizen zur Behandlung und Fortschritten in Patientenakte vermerken
 
### Abrechnung

#### Übersicht aller durchgeführten Behandlungen prüfen
- Erfülltes Rezept identifizieren
- Erfülltes Rezept markieren

#### Rechnung für die erbrachten Leistungen erstellen
- Abrechnungstermine generieren
- Rechnungspositionen aus Rezeptpositionen und Gebührenordnung berechnen
- Rechnungsnummer vergeben
- Rechnungsdokument generieren

#### Abrechnungstermine an das Rezept anheften
- Abrechnungstermindokument generieren
- Abrechnungstermindokument ausdrucken
- Abrechnungstermindokument an Rezept anheften

#### Fertige Rechnung an den Patienten versenden
- Rechnungsdokument drucken
- Rechnung dem Patienten persönlich geben, oder per Post versenden
- Rezept als "in Zahlung" markieren

### Zahlungsabwicklung

#### Eingang der Patientenzahlung überwachen
- Zahlungseingänge regelmäßig prüfen
- Zahlungen den Rechnungen zuordnen
- Mahnwesen bei ausbleibender Zahlung
- Zahlungsstatus aktualisieren

#### Behandlungsvorgang als abgeschlossen markieren
- Rezept als abgeschlossen markieren