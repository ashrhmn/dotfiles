if command -v zoxide >/dev/null 2>&1; then
    eval "$(zoxide init --cmd z bash)"
fi

if command -v fzf >/dev/null 2>&1; then
    eval "$(fzf --bash)"
fi

if command -v fnm >/dev/null 2>&1; then
    eval "$(fnm env --use-on-cd --shell bash)"
fi

safe_source "$HOME/.secrets.sh"
safe_source "$HOME/.local.env.sh"
