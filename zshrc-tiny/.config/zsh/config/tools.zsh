# Tool initializations and configurations

debug_log "Loading tool configurations"

# Bun completions
debug_log "Loading bun completions"
safe_source "$HOME/.bun/_bun"
debug_log "Bun completions loaded"

# Stripe completion
debug_log "Loading Stripe completion"
fpath=(~/.stripe $fpath)
autoload -Uz compinit && compinit -i
debug_log "Stripe completion loaded"

# Tabtab completion
debug_log "Loading tabtab"
safe_source ~/.config/tabtab/zsh/__tabtab.zsh
debug_log "Tabtab loaded"

# Zoxide (cd replacement)
debug_log "Initializing zoxide"
if command -v zoxide &> /dev/null; then
    eval "$(zoxide init --cmd cd zsh)"
    debug_log "Zoxide initialized"
fi

# fnm (Fast Node Manager)
debug_log "Initializing fnm"
if command -v fnm &> /dev/null; then
    eval "$(fnm env --use-on-cd --version-file-strategy=recursive)"
    debug_log "fnm initialized"
fi

# Tmuxifier
debug_log "Initializing tmuxifier"
if command -v tmuxifier &> /dev/null; then
    eval "$(tmuxifier init -)"
    debug_log "Tmuxifier initialized"
fi

# fzf (fuzzy finder)
debug_log "Loading fzf"
if command -v fzf &> /dev/null; then
    source <(fzf --zsh)
    debug_log "fzf loaded"
fi

# Load user secrets
debug_log "Loading secrets"
safe_source "$HOME/.secrets.sh"
safe_source "$HOME/.local.env.sh"
debug_log "Secrets loaded"

debug_log "Tool configurations complete"
