# Custom functions

# Safe source helper - only source if file exists
safe_source() {
    [[ -f "$1" ]] && source "$1"
}

# Debug logging function
debug_log() {
    [[ "$DEBUG_ZSHRC" == "1" ]] && echo "[$(date '+%H:%M:%S.%3N')] DEBUG: $1"
}

# PM2 ecosystem config generator
pmgen() {
    echo "module.exports = { apps: [{ name: '$1', script: '${@:2}', time: true, log_file: './app.log' }] };" > ecosystem.config.cjs
}

# Doppler environment loader
d() {
    set -a
    source <(doppler secrets download --no-file --format env)
    set +a
}
