# 9. Architekturentscheidungen

Dieses Kapitel dokumentiert wichtige, teure, riskante, kritische oder ungewöhnliche Architekturentscheidungen im ADR-Format (Architecture Decision Record).

## ADR-Template

Für neue Entscheidungen kann folgendes Template verwendet werden:

```markdown
## ADR-XXX: [Titel der Entscheidung]

**Status:** [Vorgeschlagen | Akzeptiert | Abgelöst | Veraltet]
**Datum:** YYYY-MM-DD
**Beteiligte:** [Namen]

### Kontext

[Beschreibung der Ausgangssituation und des Problems, das gelöst werden muss]

### Entscheidung

[Die getroffene Entscheidung und ihre Begründung]

### Alternativen

[Betrachtete Alternativen und warum sie abgelehnt wurden]

### Konsequenzen

**Positiv:**
- [Vorteile der Entscheidung]

**Negativ:**
- [Nachteile und Risiken]

**Neutral:**
- [Weitere Auswirkungen]
```

---

## ADR-001: Container-Orchestrierung

**Status:** Akzeptiert
**Datum:** 2025-12-09
**Beteiligte:** Torben Keller

### Kontext

Das PhysioAI-System benötigt eine Lösung zur Orchestrierung mehrerer Container (Frontend, Backend, Datenbank) auf einem einzelnen Raspberry Pi 5. Es werden sowohl eine Production-Umgebung als auch temporäre PR-Preview-Umgebungen benötigt.

Anforderungen:
- Multi-Container-Management auf Single-Node
- Deklarative Konfiguration (Infrastructure as Code)
- Unterstützung für mehrere isolierte Umgebungen
- Ressourceneffizienz auf Raspberry Pi 5 (8GB RAM)
- Wartbarkeit durch kleines Team (2-3 Entwickler)

### Entscheidung

**Docker + Docker Compose** als Container-Runtime und Orchestrierungslösung.

Begründung:
- Minimaler Overhead (~50MB vs. ~500-700MB für k3s)
- Einfache, deklarative Konfiguration via `docker-compose.yml`
- Ausreichend für Single-Node-Deployment
- Niedrige Lernkurve für das Team
- Gute Integration mit GitHub Actions

### Alternativen

| Alternative | Bewertung | Ablehnungsgrund |
|-------------|-----------|-----------------|
| **Kubernetes (k3s)** | Abgelehnt | ~500-700MB RAM-Overhead für Control Plane, Overkill für Single-Node ohne Cluster-Vorteile, steile Lernkurve |
| **Docker Swarm** | Abgelehnt | Designt für Multi-Node-Cluster, kaum Vorteile gegenüber Compose auf Single-Node |
| **Podman** | Abgelehnt | Weniger etabliert, geringere Tooling-Unterstützung |

### Konsequenzen

**Positiv:**
- Einfache Wartung und Verständlichkeit
- Minimaler Ressourcenverbrauch
- Schneller Einstieg für neue Teammitglieder

**Negativ:**
- Kein automatisches Failover (bei Single-Node ohnehin nicht möglich)
- Kein natives Auto-Scaling (nicht benötigt)
- Spätere Migration zu Kubernetes erfordert Anpassungen

**Neutral:**
- Container-Images sind kompatibel mit beiden Systemen
- Bei Bedarf kann später zu k3s migriert werden

---

## ADR-002: Deployment-Strategie

**Status:** Akzeptiert
**Datum:** 2025-12-09
**Beteiligte:** Torben Keller

### Kontext

Es wird eine automatisierte Deployment-Pipeline benötigt, die:
- Bei Merge auf `main` die Production-Umgebung aktualisiert
- Bei PR-Erstellung eine Preview-Umgebung erstellt
- Bei PR-Schließung die Preview-Umgebung aufräumt

Da der Raspberry Pi ARM64-Architektur verwendet, muss die Build-Strategie dies berücksichtigen.

### Entscheidung

**GitHub Self-Hosted Runner mit lokalem Build auf dem Raspberry Pi**

Die CI/CD-Pipeline ist zweigeteilt:
1. **GitHub Cloud-Runner**: Tests, Linting, Security-Checks (schnell, parallelisiert)
2. **Self-Hosted Runner auf Pi**: Build und Deployment (nativ ARM64)

```
GitHub Cloud → Tests OK → Self-Hosted Runner → Build → Deploy
```

### Alternativen

| Alternative | Bewertung | Ablehnungsgrund |
|-------------|-----------|-----------------|
| **Watchtower** | Abgelehnt | Automatisches Image-Pulling, aber keine PR-Preview-Unterstützung, keine komplexe Deployment-Logik möglich |
| **Cloud-Build mit QEMU** | Abgelehnt | ARM64-Emulation auf x86_64-Runnern ist 3-5x langsamer |
| **GitOps (ArgoCD/Flux)** | Abgelehnt | Benötigt Kubernetes, zusätzliche Komplexität |
| **Webhook + Script** | Abgelehnt | Erfordert eingehende Firewall-Regeln, Sicherheitsrisiko |

### Konsequenzen

**Positiv:**
- Volle Kontrolle über Deployment-Logik
- PR-Preview-Umgebungen möglich
- Native ARM64-Builds (keine Emulation)
- Keine eingehenden Netzwerkverbindungen nötig (Runner verbindet sich ausgehend)
- Kein Image-Transfer nötig (lokal gebaut = lokal verfügbar)

**Negativ:**
- Self-Hosted Runner verbraucht ~100-200MB RAM
- Runner muss als Systemdienst gepflegt werden
- Bei Pi-Ausfall keine Deployments möglich

**Neutral:**
- Build-Dauer ~5-8 Minuten für kompletten Stack
- Serialisierte Builds (ein Build gleichzeitig)

---

## ADR-003: Datenverschlüsselung für Gesundheitsdaten

**Status:** Akzeptiert
**Datum:** 2025-12-09
**Beteiligte:** Torben Keller

### Kontext

PhysioAI verarbeitet Gesundheitsdaten von Patienten, die nach DSGVO (Art. 9) als besonders schützenswerte Daten gelten. Eine Verschlüsselung der Daten "at rest" (auf der Festplatte) ist erforderlich, um bei physischem Diebstahl des Geräts die Daten zu schützen.

### Entscheidung

**LUKS (Linux Unified Key Setup) Verschlüsselung** für das Docker-Volume, das die PostgreSQL-Daten enthält.

Umsetzung:
```bash
# Verschlüsseltes Volume erstellen
cryptsetup luksFormat /data/encrypted-db.img
cryptsetup luksOpen /data/encrypted-db.img physio-encrypted
mount /dev/mapper/physio-encrypted /var/lib/physio-data
```

Alle PostgreSQL-Daten (Production + Previews) werden auf diesem verschlüsselten Volume gespeichert.

### Alternativen

| Alternative | Bewertung | Ablehnungsgrund |
|-------------|-----------|-----------------|
| **PostgreSQL TDE** | Abgelehnt | Nur Enterprise-Version oder Extensions, komplexere Konfiguration, schützt nicht alle Daten (z.B. WAL-Logs) |
| **Applikations-Verschlüsselung** | Abgelehnt | Hoher Implementierungsaufwand, Performance-Overhead bei Suche |
| **Full-Disk-Encryption** | Abgelehnt | Schützt alle Daten, aber komplexer bei Headless-Betrieb |

### Konsequenzen

**Positiv:**
- Vollständige Verschlüsselung aller Datenbankdaten
- Schutz bei physischem Diebstahl des Geräts
- Transparente Verschlüsselung (keine Anpassung der Anwendung nötig)
- Bewährte, auditierte Technologie

**Negativ:**
- Manuelles Entsperren nach Neustart erforderlich (Passwort-Eingabe)
- Geringer Performance-Overhead (~5-10%)
- Zusätzliche Komplexität im Betrieb

**Neutral:**
- Backup-Strategie muss Verschlüsselung berücksichtigen
- Dokumentation für Notfall-Recovery erforderlich

---

## ADR-004: SSL-Zertifikatsstrategie

**Status:** Akzeptiert
**Datum:** 2025-12-09
**Beteiligte:** Torben Keller

### Kontext

Alle Verbindungen zum PhysioAI-System müssen über HTTPS erfolgen. Dies gilt sowohl für die Production-Umgebung als auch für dynamisch erstellte PR-Preview-Umgebungen.

Subdomains:
- `physioai.torben-keller.de` - Production Frontend
- `api.physioai.torben-keller.de` - Production Backend
- `pr-{N}.physioai.torben-keller.de` - PR Preview Frontend
- `pr-{N}.api.physioai.torben-keller.de` - PR Preview Backend

### Entscheidung

**Wildcard-Zertifikat via Let's Encrypt mit AWS Route 53 DNS-Challenge**

Traefik führt die automatische Zertifikatsverwaltung durch:
```yaml
certificatesResolvers:
  letsencrypt:
    acme:
      dnsChallenge:
        provider: route53
```

Ein einziges Wildcard-Zertifikat (`*.physioai.torben-keller.de`) deckt alle Subdomains ab.

### Alternativen

| Alternative | Bewertung | Ablehnungsgrund |
|-------------|-----------|-----------------|
| **Einzelzertifikate pro Subdomain** | Abgelehnt | Let's Encrypt Rate-Limits (50/Woche), Verzögerung bei neuen PRs |
| **Self-Signed Certificates** | Abgelehnt | Browser-Warnungen, keine echte Sicherheit |
| **Gekaufte Wildcard-Zertifikate** | Abgelehnt | Unnötige Kosten, Let's Encrypt ist kostenlos |

### Konsequenzen

**Positiv:**
- Sofortige HTTPS-Verfügbarkeit für neue PR-Previews
- Keine Rate-Limit-Probleme
- Automatische Erneuerung durch Traefik/Let's Encrypt

**Negativ:**
- Abhängigkeit von AWS Route 53 für DNS-Challenge
- AWS IAM-Credentials müssen auf dem Pi gespeichert sein
- DNS-Propagation kann bei Zertifikatserneuerung verzögern

**Neutral:**
- Wildcard-Zertifikate erfordern DNS-Challenge (HTTP-Challenge nicht möglich)
- Route 53 wird bereits für DNS verwendet, daher keine zusätzliche Abhängigkeit
