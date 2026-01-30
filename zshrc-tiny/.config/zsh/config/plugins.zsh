# Plugin loading

debug_log "Loading plugins"

# Syntax highlighting
safe_source "$HOME/.config/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

# Auto suggestions
safe_source "$HOME/.config/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"

debug_log "Plugins loaded"
