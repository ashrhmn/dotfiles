# Zsh entry point
# Sources common shell config then zsh-specific layers

zmodload zsh/datetime 2>/dev/null || true
typeset -gF __zshrc_debug_start=0
typeset -gF __zshrc_debug_last=0

debug_log() {
    [[ "$DEBUG_ZSHRC" == "1" ]] || return 0
    local now=$EPOCHREALTIME
    if (( __zshrc_debug_start == 0 )); then
        __zshrc_debug_start=$now
        __zshrc_debug_last=$now
    fi
    local since_start=$(( (now - __zshrc_debug_start) * 1000.0 ))
    local since_last=$(( (now - __zshrc_debug_last) * 1000.0 ))
    printf '[%8.3f ms | +%8.3f ms] DEBUG: %s\n' "$since_start" "$since_last" "$1"
    __zshrc_debug_last=$now
}

debug_log "Loading user configuration"

setopt AUTO_CD
setopt INTERACTIVE_COMMENTS
setopt HIST_IGNORE_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_REDUCE_BLANKS
setopt SHARE_HISTORY
setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

# Common layers
debug_log "Loading functions"
source "$HOME/.config/shell/functions.sh"

debug_log "Loading environment"
source "$HOME/.config/shell/environment.sh"

debug_log "Loading paths"
source "$HOME/.config/shell/paths.sh"

debug_log "Loading aliases"
source "$HOME/.config/shell/aliases.sh"

# Zsh-specific: gtl uses noglob builtin
alias gtl='gtl(){ git tag --sort=-v:refname -n -l "${1}*" }; noglob gtl'

# Zsh-specific layers
debug_log "Loading plugins"
source "$HOME/.config/zsh/plugins.zsh"

debug_log "Loading tools"
source "$HOME/.config/zsh/tools.zsh"

debug_log "Loading prompt"
source "$HOME/.config/zsh/prompt.zsh"

# Open current command in $EDITOR via Ctrl-X Ctrl-E
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^X^E' edit-command-line
bindkey -M viins '^X^E' edit-command-line
bindkey -M vicmd '^X^E' edit-command-line

debug_log "User configuration complete"
