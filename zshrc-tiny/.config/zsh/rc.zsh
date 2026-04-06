# Main zsh configuration
# This is your personal config that won't be modified by random applications

# In-process debug timing avoids forking `date` for every log line.
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

# Basic zsh configuration
setopt AUTO_CD              # Auto cd when typing just a path
setopt INTERACTIVE_COMMENTS # Allow comments in interactive shells
setopt HIST_IGNORE_DUPS     # Don't record duplicate entries
setopt HIST_FIND_NO_DUPS    # Don't display duplicates when searching
setopt HIST_REDUCE_BLANKS   # Remove superfluous blanks
setopt SHARE_HISTORY        # Share history between sessions
setopt APPEND_HISTORY       # Append to history file
setopt INC_APPEND_HISTORY   # Add commands to history immediately

# History configuration
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

# Load modular configuration
debug_log "Loading functions"
source "$HOME/.config/zsh/config/functions.zsh"

debug_log "Loading environment"
source "$HOME/.config/zsh/config/environment.zsh"

debug_log "Loading paths"
source "$HOME/.config/zsh/config/paths.zsh"

debug_log "Loading aliases"
source "$HOME/.config/zsh/config/aliases.zsh"

debug_log "Loading plugins"
source "$HOME/.config/zsh/config/plugins.zsh"

debug_log "Loading tools"
source "$HOME/.config/zsh/config/tools.zsh"

debug_log "Loading prompt"
source "$HOME/.config/zsh/config/prompt.zsh"

# edit-command-line: open current command in $EDITOR via Ctrl-X Ctrl-E
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^X^E' edit-command-line
bindkey -M viins '^X^E' edit-command-line
bindkey -M vicmd '^X^E' edit-command-line

debug_log "User configuration complete"
