# shellcheck shell=bash
# Shell aliases
# Conditionally create aliases only if the tool exists

alias_if_cmd_exists() {
    local cmd="$1"
    local alias_name="$2"
    if command -v "$cmd" >/dev/null 2>&1; then
        # shellcheck disable=SC2139
        alias "$alias_name"="$cmd"
    fi
}

# Editor aliases
alias_if_cmd_exists "chezmoi" "dot"
alias_if_cmd_exists "nvim" "vi"
alias_if_cmd_exists "nvim" "vim"
alias_if_cmd_exists "nvim" "view"

# Modern CLI replacements
alias_if_cmd_exists "eza" "ls"
alias ll="ls -l --git"
alias la="ls -a"
alias lla="ls -la --git"
alias lt="ls --tree"

alias_if_cmd_exists "bat" "cat"
alias_if_cmd_exists "dust" "du"
alias_if_cmd_exists "duf" "df"
alias_if_cmd_exists "tldr" "man"
alias_if_cmd_exists "hyperfine" "hf"
alias_if_cmd_exists "lazygit" "lg"
