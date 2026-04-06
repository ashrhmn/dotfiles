# Custom functions

# Safe source helper - only source if file exists
safe_source() {
    [[ -f "$1" ]] && source "$1"
}

# Fallback for standalone sourcing outside the main rc flow.
if ! typeset -f debug_log >/dev/null; then
    zmodload zsh/datetime 2>/dev/null || true
    typeset -gF __zshrc_debug_start=0
    typeset -gF __zshrc_debug_last=0

    debug_log() {
        [[ "$DEBUG_ZSHRC" == "1" ]] || return 0

        local now=$EPOCHREALTIME
        if (( __zshrc_debug_start == 0 )); then
            __zshrc_debug_start=$now
            __zshrc_debug_last=$now
        fi

        local since_start=$(( (now - __zshrc_debug_start) * 1000.0 ))
        local since_last=$(( (now - __zshrc_debug_last) * 1000.0 ))
        printf '[%8.3f ms | +%8.3f ms] DEBUG: %s\n' "$since_start" "$since_last" "$1"
        __zshrc_debug_last=$now
    }
fi

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
