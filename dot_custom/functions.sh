# ─────────────────────────────────────────────────────────────
# Alt+Up/Down Directory Navigation
# ─────────────────────────────────────────────────────────────
_cd_up() {
    cd .. || return 1
    zle reset-prompt
}

_cd_back() {
    cd - >/dev/null 2>&1
    zle reset-prompt
}

zle -N _cd_up
zle -N _cd_back

# Alt+Up = cd .., Alt+Down = cd -
bindkey '^[[1;3A' _cd_up
bindkey '^[[1;3B' _cd_back

# Also support Option key on macOS Terminal.app
bindkey '^[^[[A' _cd_up
bindkey '^[^[[B' _cd_back

# FZF-powered shell functions

# ─────────────────────────────────────────────────────────────
# dev - Interactive repository selector with ghq
# Usage: dev
# ─────────────────────────────────────────────────────────────
dev() {
    local repo
    repo=$(ghq list | fzf --preview 'eza --tree --level=2 --color=always --icons $(ghq root)/{}' --preview-window=right:50%)
    if [[ -n "$repo" ]]; then
        cd "$(ghq root)/$repo" || return 1
        # Rename tmux session if inside tmux
        if [[ -n "$TMUX" ]]; then
            tmux rename-session "${repo##*/}"
        fi
    fi
}

# ─────────────────────────────────────────────────────────────
# fgc - Fuzzy git checkout (branches)
# Usage: fgc
# ─────────────────────────────────────────────────────────────
fgc() {
    local branch
    branch=$(git branch -a --color=always | \
        grep -v '/HEAD' | \
        fzf --ansi --preview 'git log --oneline --graph --color=always {1}' | \
        sed 's/^[* ]*//' | \
        sed 's/remotes\/origin\///')
    if [[ -n "$branch" ]]; then
        git checkout "$branch"
    fi
}

# ─────────────────────────────────────────────────────────────
# fgl - Fuzzy git log (show commits)
# Usage: fgl
# ─────────────────────────────────────────────────────────────
fgl() {
    git log --oneline --color=always | \
        fzf --ansi --preview 'git show --color=always {1}' | \
        awk '{print $1}' | \
        xargs -I {} git show {}
}

# ─────────────────────────────────────────────────────────────
# fga - Fuzzy git add (select files to stage)
# Usage: fga
# ─────────────────────────────────────────────────────────────
fga() {
    local files
    files=$(git status -s | fzf -m --preview 'git diff --color=always {2}' | awk '{print $2}')
    if [[ -n "$files" ]]; then
        echo "$files" | tr '\n' '\0' | xargs -0 git add
        git status -s
    fi
}

# ─────────────────────────────────────────────────────────────
# fkill - Fuzzy process kill (with confirmation)
# Usage: fkill [-9] (use -9 for SIGKILL, default is SIGTERM)
# ─────────────────────────────────────────────────────────────
fkill() {
    local signal="-15"  # SIGTERM by default (graceful)
    [[ "$1" == "-9" ]] && signal="-9"

    local selection
    selection=$(ps aux | tail -n +2 | fzf -m --header="Select process(es) to kill (SIGTERM)")

    if [[ -z "$selection" ]]; then
        return 0
    fi

    local pids
    pids=$(echo "$selection" | awk '{print $2}')

    echo "Will kill the following PIDs with signal $signal:"
    echo "$pids"
    echo -n "Confirm? [y/N] "
    read -r confirm

    if [[ "$confirm" =~ ^[Yy]$ ]]; then
        echo "$pids" | tr '\n' '\0' | xargs -0 kill "$signal"
        echo "Done."
    else
        echo "Cancelled."
    fi
}

# ─────────────────────────────────────────────────────────────
# fenv - Fuzzy environment variable viewer
# Usage: fenv
# ─────────────────────────────────────────────────────────────
fenv() {
    printenv | fzf
}

# ─────────────────────────────────────────────────────────────
# chezmoi-cd - Quick jump to chezmoi source
# Usage: chezmoi-cd
# ─────────────────────────────────────────────────────────────
chezmoi-cd() {
    cd "$(chezmoi source-path)" || return 1
}
alias dotcd="chezmoi-cd"

# ─────────────────────────────────────────────────────────────
# mkcd - Make directory and cd into it
# Usage: mkcd <dirname>
# ─────────────────────────────────────────────────────────────
mkcd() {
    mkdir -p "$1" && cd "$1" || return 1
}

# ─────────────────────────────────────────────────────────────
# aicommit - Generate commit message with AI CLI (claude, codex, gemini)
# Usage: aicommit [--dry-run]
# ─────────────────────────────────────────────────────────────
aicommit() {
    local dry_run=false
    [[ "$1" == "--dry-run" ]] && dry_run=true

    # Get staged diff
    local diff
    diff=$(git diff --cached --stat --patch)

    if [[ -z "$diff" ]]; then
        echo "No staged changes. Use 'git add' first."
        return 1
    fi

    local prompt="Generate a concise git commit message following conventional commits format.
Rules:
- Use format: type(scope): description
- Types: feat, fix, docs, style, refactor, perf, test, chore
- Keep the first line under 72 characters
- Focus on WHY, not WHAT
- No period at the end
- Be specific but concise

Diff:
$diff

Return ONLY the commit message, nothing else."

    local message=""

    # Try Claude CLI first
    if [[ -z "$message" ]] && command -v claude &>/dev/null; then
        message=$(echo "$prompt" | claude --print 2>/dev/null | head -1)
    fi

    # Try Codex CLI
    if [[ -z "$message" ]] && command -v codex &>/dev/null; then
        message=$(echo "$prompt" | codex --print 2>/dev/null | head -1)
    fi

    # Try Gemini CLI
    if [[ -z "$message" ]] && command -v gemini &>/dev/null; then
        message=$(echo "$prompt" | gemini 2>/dev/null | head -1)
    fi

    if [[ -z "$message" ]]; then
        echo "Failed to generate commit message. No AI CLI available."
        echo "Install one of: claude, codex, gemini"
        return 1
    fi

    # Clean up the message
    message=$(echo "$message" | sed 's/^[[:space:]]*//;s/^[`'"'"'"]//;s/[`'"'"'"]$//')

    if $dry_run; then
        echo "Generated commit message:"
        echo "$message"
    else
        echo "Committing with message: $message"
        git commit -m "$message"
    fi
}

# ─────────────────────────────────────────────────────────────
# Direnv Helper Functions
# ─────────────────────────────────────────────────────────────

# create_direnv_venv - Create Python venv with direnv
# Usage: create_direnv_venv
create_direnv_venv() {
    echo 'layout python' > .envrc
    direnv allow
}

# create_direnv_nix - Create Nix flake environment with direnv
# Usage: create_direnv_nix
create_direnv_nix() {
    echo 'use flake' > .envrc
    direnv allow
}

# create_direnv_mise - Create mise environment with direnv
# Usage: create_direnv_mise
create_direnv_mise() {
    echo 'use mise' > .envrc
    direnv allow
}

# ─────────────────────────────────────────────────────────────
# Project Creation
# ─────────────────────────────────────────────────────────────

# create_py_project - Quick Python project setup with uv
# Usage: create_py_project [name]
create_py_project() {
    local name="${1:-.}"
    if [[ "$name" != "." ]]; then
        mkdir -p "$name" && cd "$name" || return 1
    fi
    uv init
    create_direnv_venv
    echo "Python project created!"
}

# ─────────────────────────────────────────────────────────────
# System Utilities
# ─────────────────────────────────────────────────────────────

# o - Open in Finder (or default file manager)
# Usage: o [path]
o() {
    open "${1:-.}"
}

# port - Show process using a specific port
# Usage: port <port_number>
port() {
    if [[ -z "$1" ]]; then
        echo "Usage: port <port_number>"
        return 1
    fi
    lsof -i ":$1"
}

# clip - Copy stdin to clipboard (cross-platform)
# Usage: echo "text" | clip
clip() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        pbcopy
    else
        xclip -selection clipboard
    fi
}

# ─────────────────────────────────────────────────────────────
# GitHub Utilities
# ─────────────────────────────────────────────────────────────

# gh_latest - Get latest release version of a GitHub repo
# Usage: gh_latest <owner/repo>
gh_latest() {
    local repo="$1"
    if [[ -z "$repo" ]]; then
        echo "Usage: gh_latest <owner/repo>"
        return 1
    fi
    gh api "repos/${repo}/releases/latest" --jq '.tag_name'
}

# gh_clone - Clone a GitHub repo to ghq root
# Usage: gh_clone <owner/repo>
gh_clone() {
    local repo="$1"
    if [[ -z "$repo" ]]; then
        echo "Usage: gh_clone <owner/repo>"
        return 1
    fi
    ghq get "https://github.com/${repo}"
}

# ─────────────────────────────────────────────────────────────
# Quick Edit
# ─────────────────────────────────────────────────────────────

# dotfiles - Open dotfiles in editor
# Usage: dotfiles
dotfiles() {
    ${EDITOR:-nvim} "$(chezmoi source-path)"
}

# zshconfig - Edit zsh config
# Usage: zshconfig
zshconfig() {
    ${EDITOR:-nvim} "$(chezmoi source-path)/dot_zshrc"
}

# ─────────────────────────────────────────────────────────────
# Development Environment Backup
# ─────────────────────────────────────────────────────────────

# backup_dev_env - Backup development environment configs
# Usage: backup_dev_env
backup_dev_env() {
    local backup_dir="${1:-$(chezmoi source-path)/backups}"
    local date_str=$(date +%Y%m%d)

    mkdir -p "$backup_dir"

    echo "Backing up development environment..."

    # Brewfile
    if command -v brew &>/dev/null; then
        echo "  - Generating Brewfile..."
        brew bundle dump --force --file="$backup_dir/Brewfile.$date_str"
    fi

    # mise tools
    if command -v mise &>/dev/null; then
        echo "  - Backing up mise config..."
        mise list --json > "$backup_dir/mise-tools.$date_str.json" 2>/dev/null || true
    fi

    # VS Code extensions
    if command -v code &>/dev/null; then
        echo "  - Backing up VS Code extensions..."
        code --list-extensions > "$backup_dir/vscode-extensions.$date_str.txt"
    fi

    # npm global packages
    if command -v npm &>/dev/null; then
        echo "  - Backing up npm global packages..."
        npm list -g --depth=0 --json > "$backup_dir/npm-global.$date_str.json" 2>/dev/null || true
    fi

    echo "Backup completed: $backup_dir"
}

# restore_vscode_ext - Restore VS Code extensions from backup
# Usage: restore_vscode_ext [backup_file]
restore_vscode_ext() {
    local backup_file="${1:-$(chezmoi source-path)/backups/vscode-extensions.txt}"
    if [[ -f "$backup_file" ]]; then
        echo "Restoring VS Code extensions from $backup_file..."
        cat "$backup_file" | xargs -L 1 code --install-extension
    else
        echo "Backup file not found: $backup_file"
        return 1
    fi
}
