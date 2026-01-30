# Main .zshrc - This file can be modified by applications
# Your personal configuration is in ~/.config/zsh/rc.zsh

# Debug logging function (needed before anything else)
debug_log() {
    [[ "$DEBUG_ZSHRC" == "1" ]] && echo "[$(date '+%H:%M:%S.%3N')] DEBUG: $1"
}

# Safe source helper (needed before anything else)
safe_source() {
    [[ -f "$1" ]] && source "$1"
}

debug_log "Starting .zshrc"

# Source main configuration
debug_log "Sourcing main config"
safe_source "$HOME/.config/zsh/rc.zsh"
debug_log "Main config loaded"

# Applications can add their modifications below this line
# -----------------------------------------------------

debug_log ".zshrc loading complete"
