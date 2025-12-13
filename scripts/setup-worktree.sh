#!/bin/bash
#
# setup-worktree.sh - Git Worktree mit automatischer Port-Konfiguration
#
# Erstellt einen Git Worktree für einen Branch mit automatisch berechneten Ports.
# Ports werden deterministisch aus dem Branch-Namen berechnet (10000-19999).
#
# Usage: ./scripts/setup-worktree.sh [OPTIONS] <branch-name>
#
# Options:
#   -h, --help     Zeigt diese Hilfe
#   -f, --force    Überschreibt existierenden Worktree
#   --dry-run      Zeigt was passieren würde
#

set -e

# ============================================================
# KONFIGURATION
# ============================================================
readonly PORT_BASE=10000
readonly PORT_RANGE=10000
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly ROOT_DIR="$(dirname "$SCRIPT_DIR")"
readonly PARENT_DIR="$(dirname "$ROOT_DIR")"

# Farben
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly NC='\033[0m'

# Globale Variablen
BRANCH_NAME=""
WORKTREE_PATH=""
FORCE=false
DRY_RUN=false
CREATE_NEW_BRANCH=false
FRONTEND_PORT=0
BACKEND_PORT=0
DB_PORT=0

# ============================================================
# HILFSFUNKTIONEN
# ============================================================

print_usage() {
    cat << EOF
Usage: $(basename "$0") [OPTIONS] <branch-name>

Erstellt einen Git Worktree mit automatisch berechneten Ports.

Options:
  -h, --help     Zeigt diese Hilfe
  -f, --force    Überschreibt existierenden Worktree
  --dry-run      Zeigt was passieren würde ohne Änderungen

Beispiele:
  $(basename "$0") feature-patient-form
  $(basename "$0") --force feature/login
  $(basename "$0") --dry-run bugfix-123
EOF
}

log_step() {
    echo -e "${BLUE}[$1]${NC} $2"
}

log_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

log_warning() {
    echo -e "${YELLOW}Warning: $1${NC}"
}

log_error() {
    echo -e "${RED}Error: $1${NC}" >&2
}

sanitize_branch_name() {
    local name="$1"
    echo "$name" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9_-]/-/g' | sed 's/-\{2,\}/-/g' | sed 's/^-//' | sed 's/-$//'
}

calculate_ports() {
    local branch_name="$1"
    local hash
    hash=$(echo -n "$branch_name" | md5)

    local part1="${hash:0:8}"
    local part2="${hash:8:8}"
    local part3="${hash:16:8}"

    local num1 num2 num3
    num1=$(printf '%d' "0x$part1")
    num2=$(printf '%d' "0x$part2")
    num3=$(printf '%d' "0x$part3")

    FRONTEND_PORT=$((num1 % PORT_RANGE + PORT_BASE))
    BACKEND_PORT=$((num2 % PORT_RANGE + PORT_BASE))
    DB_PORT=$((num3 % PORT_RANGE + PORT_BASE))
}

check_port_available() {
    local port=$1
    if lsof -i ":$port" >/dev/null 2>&1; then
        return 1
    fi
    return 0
}

copy_claude_settings() {
    local target_dir="$1"
    local source_settings="$ROOT_DIR/.claude/settings.local.json"

    if [[ -f "$source_settings" ]]; then
        mkdir -p "$target_dir/.claude"
        cp "$source_settings" "$target_dir/.claude/settings.local.json"
        return 0
    fi
    return 1
}

generate_env_file() {
    local target_dir="$1"
    local branch="$2"
    local compose_name="physio_$(sanitize_branch_name "$branch")"

    cat > "$target_dir/.env" << EOF
# Generiert von setup-worktree.sh für Branch: $branch
# Ports deterministisch berechnet aus Branch-Name
# Erstellt am: $(date '+%Y-%m-%d %H:%M:%S')

# Docker Compose Projekt-Name (pro Worktree eindeutig)
COMPOSE_PROJECT_NAME=$compose_name

# Backend (Spring Boot)
PHYSIO_BACKEND_PORT=$BACKEND_PORT

# Frontend (Vite)
PHYSIO_FRONTEND_PORT=$FRONTEND_PORT

# PostgreSQL Database
PHYSIO_DB_HOST=localhost
PHYSIO_DB_PORT=$DB_PORT
PHYSIO_DB_NAME=physio_ai
PHYSIO_DB_USER=postgres
PHYSIO_DB_PASSWORD=postgres
EOF
}

cleanup() {
    if [[ -n "$WORKTREE_PATH" && -d "$WORKTREE_PATH" && "$DRY_RUN" == false ]]; then
        log_warning "Räume partiellen Worktree auf..."
        git worktree remove --force "$WORKTREE_PATH" 2>/dev/null || true
    fi
}

# ============================================================
# HAUPTLOGIK
# ============================================================

parse_args() {
    while [[ $# -gt 0 ]]; do
        case "$1" in
            -h|--help)
                print_usage
                exit 0
                ;;
            -f|--force)
                FORCE=true
                shift
                ;;
            --dry-run)
                DRY_RUN=true
                shift
                ;;
            -*)
                log_error "Unbekannte Option: $1"
                print_usage
                exit 1
                ;;
            *)
                if [[ -z "$BRANCH_NAME" ]]; then
                    BRANCH_NAME="$1"
                else
                    log_error "Mehrere Branch-Namen angegeben"
                    exit 1
                fi
                shift
                ;;
        esac
    done
}

validate_environment() {
    # Prüfe ob in Git-Repository
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        log_error "Nicht in einem Git-Repository"
        exit 1
    fi

    # Prüfe ob Branch-Name angegeben
    if [[ -z "$BRANCH_NAME" ]]; then
        log_error "Branch-Name erforderlich"
        print_usage
        exit 1
    fi

    # Prüfe ob Branch existiert (lokal oder remote)
    if ! git show-ref --verify --quiet "refs/heads/$BRANCH_NAME" && \
       ! git show-ref --verify --quiet "refs/remotes/origin/$BRANCH_NAME"; then
        # Branch existiert nicht -> wird neu erstellt
        CREATE_NEW_BRANCH=true
    fi
}

main() {
    parse_args "$@"
    validate_environment

    # Sonderfall: main Branch
    if [[ "$BRANCH_NAME" == "main" ]]; then
        echo ""
        log_warning "Branch 'main' verwendet Default-Ports (8080, 5173, 5432)"
        log_warning "Keine .env Datei wird für main generiert"
        echo ""
        echo "Für main einfach im Hauptverzeichnis arbeiten:"
        echo "  cd $ROOT_DIR"
        exit 0
    fi

    # Worktree-Pfad berechnen
    local sanitized
    sanitized=$(sanitize_branch_name "$BRANCH_NAME")
    WORKTREE_PATH="$PARENT_DIR/$sanitized"

    echo ""
    echo "Setting up worktree for branch: $BRANCH_NAME"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""

    if [[ "$DRY_RUN" == true ]]; then
        echo -e "${YELLOW}[DRY-RUN] Keine Änderungen werden vorgenommen${NC}"
        echo ""
    fi

    # Prüfe ob Worktree existiert
    if [[ -d "$WORKTREE_PATH" ]]; then
        if [[ "$FORCE" == true ]]; then
            log_warning "Entferne existierenden Worktree: $WORKTREE_PATH"
            if [[ "$DRY_RUN" == false ]]; then
                git worktree remove --force "$WORKTREE_PATH"
            fi
        else
            log_error "Worktree existiert bereits: $WORKTREE_PATH"
            log_error "Verwende --force zum Überschreiben"
            exit 1
        fi
    fi

    # Error-Cleanup-Trap setzen
    trap cleanup ERR

    # Schritt 1: Ports berechnen
    log_step "1/6" "Berechne Ports aus Branch-Name..."
    calculate_ports "$BRANCH_NAME"
    echo "      Frontend: $FRONTEND_PORT"
    echo "      Backend:  $BACKEND_PORT"
    echo "      Database: $DB_PORT"
    echo ""

    # Port-Verfügbarkeit prüfen (nur Warnung)
    for port in $FRONTEND_PORT $BACKEND_PORT $DB_PORT; do
        if ! check_port_available "$port"; then
            log_warning "Port $port scheint bereits belegt zu sein"
        fi
    done

    # Schritt 2: Worktree erstellen
    log_step "2/6" "Erstelle Worktree..."
    echo "      Pfad: $WORKTREE_PATH"
    if [[ "$CREATE_NEW_BRANCH" == true ]]; then
        echo "      Neuer Branch: $BRANCH_NAME (basiert auf main)"
    fi
    if [[ "$DRY_RUN" == false ]]; then
        if [[ "$CREATE_NEW_BRANCH" == true ]]; then
            git worktree add -b "$BRANCH_NAME" "$WORKTREE_PATH" main
        else
            git worktree add "$WORKTREE_PATH" "$BRANCH_NAME"
        fi
    fi
    echo ""

    # Schritt 3: .env generieren
    log_step "3/6" "Generiere .env Datei..."
    echo "      COMPOSE_PROJECT_NAME: physio_$sanitized"
    if [[ "$DRY_RUN" == false ]]; then
        generate_env_file "$WORKTREE_PATH" "$BRANCH_NAME"
    fi
    echo ""

    # Schritt 4: Symlink für Backend erstellen
    log_step "4/6" "Erstelle .env Symlink für Backend..."
    if [[ "$DRY_RUN" == false ]]; then
        ln -sf ../.env "$WORKTREE_PATH/backend/.env"
        echo "      backend/.env -> ../.env"
    else
        echo "      backend/.env würde auf ../.env verlinkt"
    fi
    echo ""

    # Schritt 5: Claude Code Settings kopieren
    log_step "5/6" "Kopiere Claude Code Settings..."
    if [[ "$DRY_RUN" == false ]]; then
        if copy_claude_settings "$WORKTREE_PATH"; then
            echo "      .claude/settings.local.json kopiert"
        else
            echo "      (keine settings.local.json gefunden, übersprungen)"
        fi
    else
        if [[ -f "$ROOT_DIR/.claude/settings.local.json" ]]; then
            echo "      .claude/settings.local.json würde kopiert"
        else
            echo "      (keine settings.local.json gefunden)"
        fi
    fi
    echo ""

    # Schritt 6: Fertig!
    log_step "6/6" "Fertig!"
    echo ""

    # Zusammenfassung
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    if [[ "$DRY_RUN" == true ]]; then
        echo -e "${YELLOW}[DRY-RUN] Worktree würde erstellt werden: $WORKTREE_PATH${NC}"
    else
        log_success "Worktree bereit: $WORKTREE_PATH"
    fi
    echo ""
    echo "Nächste Schritte:"
    echo "  cd $WORKTREE_PATH"
    echo "  cd backend && docker compose up -d  # Datenbank starten"
    echo "  cd frontend && npm run dev          # Frontend starten"
    echo "  cd backend && ./mvnw spring-boot:run  # Backend starten"
    echo ""
    echo "URLs:"
    echo "  Frontend: http://localhost:$FRONTEND_PORT"
    echo "  Backend:  http://localhost:$BACKEND_PORT"
    echo "  Database: localhost:$DB_PORT"

    # Error-Trap deaktivieren bei Erfolg
    trap - ERR
}

main "$@"
