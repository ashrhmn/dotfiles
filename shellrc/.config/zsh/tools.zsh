autoload -Uz compinit && compinit -C

if command -v zoxide >/dev/null 2>&1; then
    eval "$(zoxide init --cmd z zsh)"
fi

if command -v fzf >/dev/null 2>&1; then
    source <(fzf --zsh)
fi

if command -v fnm >/dev/null 2>&1; then
    eval "$(fnm env --use-on-cd --shell zsh)"
fi

safe_source "$HOME/.secrets.sh"
safe_source "$HOME/.local.env.sh"
