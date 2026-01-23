#!/bin/bash
# sync-claude-plugins.sh - Sync Claude Code plugins from upstream repos
# Usage: ./sync-claude-plugins.sh <wshobson-dir> <superpowers-dir>
#
# This script:
# 1. Reads enabledPlugins from .chezmoidata/claude.yaml
# 2. Syncs plugin content to dot_claude/{agents,commands,skills}/
# 3. Removes plugins no longer in enabledPlugins
# 4. Updates .plugin-manifest.yaml with sync metadata
#
# Protected: Local directories listed in manifest are never touched

set -euo pipefail

WSHOBSON_DIR="${1:?Usage: $0 <wshobson-dir> <superpowers-dir>}"
SUPERPOWERS_DIR="${2:?Usage: $0 <wshobson-dir> <superpowers-dir>}"

REPO_ROOT="$(git rev-parse --show-toplevel)"
DOT_CLAUDE="$REPO_ROOT/dot_claude"
CLAUDE_YAML="$REPO_ROOT/.chezmoidata/claude.yaml"
MANIFEST="$DOT_CLAUDE/.plugin-manifest.yaml"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

log_info() { echo -e "${BLUE}[INFO]${NC} $*"; }
log_success() { echo -e "${GREEN}[OK]${NC} $*"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $*"; }
log_error() { echo -e "${RED}[ERROR]${NC} $*" >&2; }

# Read enabled plugins from claude.yaml
get_enabled_plugins() {
    yq -r '.claude.enabledPlugins[]' "$CLAUDE_YAML" 2>/dev/null || true
}

# Read local directories from manifest (protected from deletion)
get_local_dirs() {
    local type=$1
    yq -r ".local.${type}[]" "$MANIFEST" 2>/dev/null || true
}

# Read currently managed plugins from manifest
get_managed_plugins() {
    local type=$1
    yq -r ".managed.${type}[]" "$MANIFEST" 2>/dev/null || true
}

# Check if directory is local (protected)
is_local_dir() {
    local type=$1
    local name=$2
    get_local_dirs "$type" | grep -qx "$name"
}

# Sync a single plugin from wshobson-agents
sync_wshobson_plugin() {
    local plugin_name=$1
    local plugin_src="$WSHOBSON_DIR/plugins/$plugin_name"

    if [[ ! -d "$plugin_src" ]]; then
        log_warn "Plugin not found in wshobson-agents: $plugin_name"
        return 1
    fi

    local synced=0

    # Sync agents
    if [[ -d "$plugin_src/agents" ]]; then
        mkdir -p "$DOT_CLAUDE/agents/$plugin_name"
        rm -rf "$DOT_CLAUDE/agents/$plugin_name"/*
        cp -r "$plugin_src/agents"/* "$DOT_CLAUDE/agents/$plugin_name/" 2>/dev/null || true
        ((synced++)) || true
    fi

    # Sync commands
    if [[ -d "$plugin_src/commands" ]]; then
        mkdir -p "$DOT_CLAUDE/commands/$plugin_name"
        rm -rf "$DOT_CLAUDE/commands/$plugin_name"/*
        cp -r "$plugin_src/commands"/* "$DOT_CLAUDE/commands/$plugin_name/" 2>/dev/null || true
        ((synced++)) || true
    fi

    # Sync skills
    if [[ -d "$plugin_src/skills" ]]; then
        mkdir -p "$DOT_CLAUDE/skills/$plugin_name"
        rm -rf "$DOT_CLAUDE/skills/$plugin_name"/*
        cp -r "$plugin_src/skills"/* "$DOT_CLAUDE/skills/$plugin_name/" 2>/dev/null || true
        ((synced++)) || true
    fi

    if [[ $synced -gt 0 ]]; then
        log_success "Synced: $plugin_name"
        return 0
    else
        log_warn "Empty plugin (no agents/commands/skills): $plugin_name"
        return 1
    fi
}

# Sync superpowers (flat structure -> superpowers/ namespace)
sync_superpowers() {
    local synced=0

    # Sync agents
    if [[ -d "$SUPERPOWERS_DIR/agents" ]]; then
        mkdir -p "$DOT_CLAUDE/agents/superpowers"
        rm -rf "$DOT_CLAUDE/agents/superpowers"/*
        cp -r "$SUPERPOWERS_DIR/agents"/* "$DOT_CLAUDE/agents/superpowers/" 2>/dev/null || true
        ((synced++)) || true
    fi

    # Sync commands
    if [[ -d "$SUPERPOWERS_DIR/commands" ]]; then
        mkdir -p "$DOT_CLAUDE/commands/superpowers"
        rm -rf "$DOT_CLAUDE/commands/superpowers"/*
        cp -r "$SUPERPOWERS_DIR/commands"/* "$DOT_CLAUDE/commands/superpowers/" 2>/dev/null || true
        ((synced++)) || true
    fi

    # Sync skills
    if [[ -d "$SUPERPOWERS_DIR/skills" ]]; then
        mkdir -p "$DOT_CLAUDE/skills/superpowers"
        rm -rf "$DOT_CLAUDE/skills/superpowers"/*
        for skill_dir in "$SUPERPOWERS_DIR/skills"/*/; do
            [[ -d "$skill_dir" ]] || continue
            skill_name=$(basename "$skill_dir")
            cp -r "$skill_dir" "$DOT_CLAUDE/skills/superpowers/$skill_name"
        done
        ((synced++)) || true
    fi

    if [[ $synced -gt 0 ]]; then
        log_success "Synced: superpowers"
    fi
}

# Remove orphan plugin directories
cleanup_orphans() {
    local type=$1
    shift
    local enabled_plugins=("$@")
    local removed=0

    [[ -d "$DOT_CLAUDE/$type" ]] || return 0

    for dir in "$DOT_CLAUDE/$type"/*/; do
        [[ -d "$dir" ]] || continue
        local name
        name=$(basename "$dir")

        # Skip local directories
        if is_local_dir "$type" "$name"; then
            continue
        fi

        # Skip superpowers (always synced)
        if [[ "$name" == "superpowers" ]]; then
            continue
        fi

        # Check if plugin is still enabled
        local found=false
        for p in "${enabled_plugins[@]}"; do
            if [[ "$p" == "$name" ]]; then
                found=true
                break
            fi
        done

        if [[ "$found" == "false" ]]; then
            rm -rf "$dir"
            log_warn "Removed orphan: $type/$name"
            ((removed++)) || true
        fi
    done

    return $removed
}

# Update manifest with sync results
update_manifest() {
    local wshobson_sha=$1
    local superpowers_sha=$2
    local timestamp
    timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

    # Update sync metadata
    yq -i ".sync.timestamp = \"$timestamp\"" "$MANIFEST"
    yq -i ".sync.wshobson_agents_sha = \"$wshobson_sha\"" "$MANIFEST"
    yq -i ".sync.superpowers_sha = \"$superpowers_sha\"" "$MANIFEST"

    # Update managed lists
    local managed_agents=()
    local managed_commands=()
    local managed_skills=()

    # Collect managed directories (non-local)
    for dir in "$DOT_CLAUDE/agents"/*/; do
        [[ -d "$dir" ]] || continue
        local name
        name=$(basename "$dir")
        if ! is_local_dir "agents" "$name"; then
            managed_agents+=("$name")
        fi
    done

    for dir in "$DOT_CLAUDE/commands"/*/; do
        [[ -d "$dir" ]] || continue
        local name
        name=$(basename "$dir")
        if ! is_local_dir "commands" "$name"; then
            managed_commands+=("$name")
        fi
    done

    for dir in "$DOT_CLAUDE/skills"/*/; do
        [[ -d "$dir" ]] || continue
        local name
        name=$(basename "$dir")
        if ! is_local_dir "skills" "$name"; then
            managed_skills+=("$name")
        fi
    done

    # Write managed lists
    yq -i '.managed.agents = []' "$MANIFEST"
    for name in "${managed_agents[@]}"; do
        yq -i ".managed.agents += [\"$name\"]" "$MANIFEST"
    done

    yq -i '.managed.commands = []' "$MANIFEST"
    for name in "${managed_commands[@]}"; do
        yq -i ".managed.commands += [\"$name\"]" "$MANIFEST"
    done

    yq -i '.managed.skills = []' "$MANIFEST"
    for name in "${managed_skills[@]}"; do
        yq -i ".managed.skills += [\"$name\"]" "$MANIFEST"
    done

    log_success "Updated manifest"
}

# Get git SHA from extracted directory (look for .git or use directory hash)
get_source_sha() {
    local dir=$1
    if [[ -f "$dir/.git/HEAD" ]]; then
        cat "$dir/.git/HEAD" | head -c 7
    else
        # Use content hash as fallback
        find "$dir" -type f -name "*.md" -exec sha256sum {} \; 2>/dev/null | sha256sum | head -c 7
    fi
}

# Main execution
main() {
    log_info "Starting Claude plugins sync..."

    # Validate inputs
    if [[ ! -d "$WSHOBSON_DIR" ]]; then
        log_error "wshobson-agents directory not found: $WSHOBSON_DIR"
        exit 1
    fi

    if [[ ! -d "$SUPERPOWERS_DIR" ]]; then
        log_error "superpowers directory not found: $SUPERPOWERS_DIR"
        exit 1
    fi

    if [[ ! -f "$CLAUDE_YAML" ]]; then
        log_error "claude.yaml not found: $CLAUDE_YAML"
        exit 1
    fi

    # Read enabled plugins (portable alternative to mapfile)
    enabled_plugins=()
    while IFS= read -r plugin; do
        [[ -n "$plugin" ]] && enabled_plugins+=("$plugin")
    done < <(get_enabled_plugins)
    log_info "Enabled plugins: ${#enabled_plugins[@]}"

    # Sync wshobson plugins
    log_info "Syncing wshobson-agents plugins..."
    local synced_count=0
    for plugin in "${enabled_plugins[@]}"; do
        if sync_wshobson_plugin "$plugin"; then
            ((synced_count++)) || true
        fi
    done

    # Sync superpowers
    log_info "Syncing superpowers..."
    sync_superpowers

    # Cleanup orphans
    log_info "Cleaning up orphan directories..."
    local orphan_count=0
    for type in agents commands skills; do
        cleanup_orphans "$type" "${enabled_plugins[@]}" || orphan_count=$((orphan_count + $?))
    done

    # Update manifest
    local wshobson_sha superpowers_sha
    wshobson_sha=$(get_source_sha "$WSHOBSON_DIR")
    superpowers_sha=$(get_source_sha "$SUPERPOWERS_DIR")
    update_manifest "$wshobson_sha" "$superpowers_sha"

    # Summary
    echo ""
    log_info "=== Sync Summary ==="
    log_info "Plugins synced: $synced_count"
    log_info "Orphans removed: $orphan_count"
    log_info "wshobson SHA: $wshobson_sha"
    log_info "superpowers SHA: $superpowers_sha"
}

main "$@"
