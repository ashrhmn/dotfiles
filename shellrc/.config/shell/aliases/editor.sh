if command -v fzf >/dev/null 2>&1 && command -v nvim >/dev/null 2>&1; then
    alias inv='nvim $(fzf -m --preview="bat --color=always {}")'
fi
