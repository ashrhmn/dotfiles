# Tool initializations and configurations

debug_log "Loading tool configurations"

# Initialize zsh completion once and prefer the cached dump.
debug_log "Initializing completion system"
autoload -Uz compinit && compinit -C
debug_log "Completion system initialized"

# Bun completions
debug_log "Loading bun completions"
safe_source "$HOME/.bun/_bun"
debug_log "Bun completions loaded"

# Stripe completion
# debug_log "Loading Stripe completion"
# fpath=(~/.stripe $fpath)
# autoload -Uz compinit && compinit -i
# debug_log "Stripe completion loaded"

# Tabtab completion
debug_log "Loading tabtab"
safe_source ~/.config/tabtab/zsh/__tabtab.zsh
debug_log "Tabtab loaded"

# Zoxide (cd replacement)
debug_log "Initializing zoxide"
if command -v zoxide &> /dev/null; then
    eval "$(zoxide init --cmd z zsh)"
    debug_log "Zoxide initialized"
fi

# fnm (Fast Node Manager)
maybe_init_fnm() {
    [[ -n ${__FNM_INIT_DONE:-} ]] && return 0
    command -v fnm &> /dev/null || return 0

    local dir=$PWD
    while [[ "$dir" != "/" ]]; do
        if [[ -f "$dir/.nvmrc" || -f "$dir/.node-version" ]]; then
            debug_log "Initializing fnm"
            eval "$(fnm env --use-on-cd --version-file-strategy=recursive)"
            __FNM_INIT_DONE=1
            debug_log "fnm initialized"
            return 0
        fi
        dir=${dir:h}
    done
}

autoload -Uz add-zsh-hook
add-zsh-hook chpwd maybe_init_fnm
maybe_init_fnm

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
