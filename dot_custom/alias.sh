# factory functions
function alias_if_cmd_exists() {
    cmd=$1
    alias_name=$2
    if type $cmd >/dev/null 2>&1; then
        alias $alias_name=$cmd
    fi
}

alias_if_cmd_exists "chezmoi" "dot"
alias_if_cmd_exists "nvim" "vi"
alias_if_cmd_exists "nvim" "vim"
alias_if_cmd_exists "nvim" "view"
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
