# factory functions
function eval_if_cmd_exists() {
    cmd=$1
    eval_tgt=$2
    if type $cmd >/dev/null 2>&1; then
        eval "$(eval $eval_tgt)"
    fi
}

eval_if_cmd_exists "starship" "starship init zsh"
eval_if_cmd_exists "sheldon" "sheldon source"
eval_if_cmd_exists "fzf" "fzf --zsh"
eval_if_cmd_exists "navi" "navi widget zsh"
eval_if_cmd_exists "zoxide" "zoxide init zsh"