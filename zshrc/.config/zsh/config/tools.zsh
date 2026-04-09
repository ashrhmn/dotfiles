# Tool initializations and configurations

debug_log "Loading tool configurations"

# Initialize zsh completion once and prefer the cached dump.
debug_log "Initializing completion system"
autoload -Uz compinit && compinit -C
debug_log "Completion system initialized"

# Zoxide (cd replacement)
debug_log "Initializing zoxide"
if command -v zoxide &> /dev/null; then
    eval "$(zoxide init --cmd z zsh)"
    debug_log "Zoxide initialized"
fi

# fzf (fuzzy finder)
debug_log "Loading fzf"
if command -v fzf &> /dev/null; then
    source <(fzf --zsh)
    debug_log "fzf loaded"
fi

# fnm (Node version manager)
debug_log "Initializing fnm"
if command -v fnm &> /dev/null; then
    eval "$(fnm env --use-on-cd --shell zsh)"
    debug_log "fnm initialized"
fi

# Load user secrets
debug_log "Loading secrets"
safe_source "$HOME/.secrets.sh"
safe_source "$HOME/.local.env.sh"
debug_log "Secrets loaded"

debug_log "Tool configurations complete"
