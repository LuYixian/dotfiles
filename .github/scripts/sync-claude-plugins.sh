#!/bin/bash
# sync-claude-plugins.sh - Sync Claude Code plugins from upstream repos
# Usage: ./sync-claude-plugins.sh <wshobson-dir> <superpowers-dir>
#
# Syncs enabled plugins to dot_claude/{agents,commands,skills}/
# Detects local directories automatically (no manifest needed)
# Removes orphan plugin directories

set -euo pipefail

WSHOBSON_DIR="${1:?Usage: $0 <wshobson-dir> <superpowers-dir>}"
SUPERPOWERS_DIR="${2:?Usage: $0 <wshobson-dir> <superpowers-dir>}"

REPO_ROOT="$(git rev-parse --show-toplevel)"
DOT_CLAUDE="$REPO_ROOT/dot_claude"
CLAUDE_YAML="$REPO_ROOT/.chezmoidata/claude.yaml"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info() { echo -e "${BLUE}[INFO]${NC} $*"; }
log_ok() { echo -e "${GREEN}[OK]${NC} $*"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $*"; }
log_error() { echo -e "${RED}[ERROR]${NC} $*" >&2; }

# Get enabled wshobson plugins from claude.yaml
get_enabled_plugins() {
    yq -r '.claude.wshobson.enabled[]' "$CLAUDE_YAML" 2>/dev/null || true
}

# Get local directories from claude.yaml
get_local_dirs() {
    local type=$1
    yq -r ".claude.localDirectories.${type}[]" "$CLAUDE_YAML" 2>/dev/null || true
}

# Check if directory is local (defined in claude.yaml)
is_local_dir() {
    local type=$1 name=$2
    get_local_dirs "$type" | grep -qx "$name"
}

# Sync single wshobson plugin
sync_plugin() {
    local name=$1
    local src="$WSHOBSON_DIR/plugins/$name"
    [[ -d "$src" ]] || {
        log_warn "Not found: $name"
        return 1
    }

    local synced=0
    for type in agents commands skills; do
        if [[ -d "$src/$type" ]]; then
            mkdir -p "$DOT_CLAUDE/$type/$name"
            rm -rf "$DOT_CLAUDE/$type/$name"/*
            cp -r "$src/$type"/* "$DOT_CLAUDE/$type/$name/" 2>/dev/null || true
            ((synced++)) || true
        fi
    done

    [[ $synced -gt 0 ]] && log_ok "$name" || log_warn "$name (empty)"
    return 0
}

# Sync superpowers
sync_superpowers() {
    for type in agents commands; do
        if [[ -d "$SUPERPOWERS_DIR/$type" ]]; then
            mkdir -p "$DOT_CLAUDE/$type/superpowers"
            rm -rf "$DOT_CLAUDE/$type/superpowers"/*
            cp -r "$SUPERPOWERS_DIR/$type"/* "$DOT_CLAUDE/$type/superpowers/" 2>/dev/null || true
        fi
    done

    if [[ -d "$SUPERPOWERS_DIR/skills" ]]; then
        mkdir -p "$DOT_CLAUDE/skills/superpowers"
        rm -rf "$DOT_CLAUDE/skills/superpowers"/*
        cp -r "$SUPERPOWERS_DIR/skills"/* "$DOT_CLAUDE/skills/superpowers/"
    fi
    log_ok "superpowers"
}

# Remove orphan directories
cleanup_orphans() {
    local type=$1
    shift
    local -a enabled=("$@")
    local removed=0

    [[ -d "$DOT_CLAUDE/$type" ]] || return 0

    for dir in "$DOT_CLAUDE/$type"/*/; do
        [[ -d "$dir" ]] || continue
        local name
        name=$(basename "$dir")

        # Skip superpowers
        [[ "$name" == "superpowers" ]] && continue

        # Skip local directories
        is_local_dir "$type" "$name" && continue

        # Skip enabled plugins
        local found=false
        for p in "${enabled[@]}"; do
            [[ "$p" == "$name" ]] && {
                found=true
                break
            }
        done
        [[ "$found" == "true" ]] && continue

        # Orphan - remove
        rm -rf "$dir"
        log_warn "Removed: $type/$name"
        ((removed++)) || true
    done
}

# Main
main() {
    log_info "Syncing Claude plugins..."

    # Validate
    [[ -d "$WSHOBSON_DIR" ]] || {
        log_error "Not found: $WSHOBSON_DIR"
        exit 1
    }
    [[ -d "$SUPERPOWERS_DIR" ]] || {
        log_error "Not found: $SUPERPOWERS_DIR"
        exit 1
    }
    [[ -f "$CLAUDE_YAML" ]] || {
        log_error "Not found: $CLAUDE_YAML"
        exit 1
    }

    # Read enabled plugins
    local -a enabled=()
    while IFS= read -r p; do
        [[ -n "$p" ]] && enabled+=("$p")
    done < <(get_enabled_plugins)
    log_info "Enabled: ${#enabled[@]} plugins"

    # Sync
    log_info "Syncing wshobson plugins..."
    for plugin in "${enabled[@]}"; do
        sync_plugin "$plugin" || true
    done

    log_info "Syncing superpowers..."
    sync_superpowers

    # Cleanup
    log_info "Cleaning orphans..."
    for type in agents commands skills; do
        cleanup_orphans "$type" "${enabled[@]}"
    done

    log_info "Done"
}

main "$@"
