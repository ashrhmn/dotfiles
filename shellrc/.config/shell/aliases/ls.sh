if command -v eza >/dev/null 2>&1; then
    alias l="eza -l --group-directories-first --icons --color=always"
    alias ls="eza --group-directories-first --icons --color=always"
    alias ll="eza -l --group-directories-first --icons --color=always"
    alias la="eza -la --group-directories-first --icons --color=always"
    alias laa="eza -la --group-directories-first --icons --color=always --absolute"
    alias lag="eza -la --group-directories-first --icons --color=always --git --git-repos-no-status"
else
    alias l="ls -l"
    alias ll="ls -l"
    alias la="ls -la"
fi
