# Safe source helper
safe_source() {
    [ -f "$1" ] && . "$1"
}

# Git helper functions used by git aliases
git_current_branch() {
    git symbolic-ref --quiet --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null
}

git_main_branch() {
    git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's@^refs/remotes/origin/@@' || echo main
}

git_develop_branch() {
    git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's@^refs/remotes/origin/@@' || echo develop
}

# PM2 ecosystem config generator
pmgen() {
    echo "module.exports = { apps: [{ name: '$1', script: '${@:2}', time: true, log_file: './app.log' }] };" > ecosystem.config.cjs
}

# Yazi wrapper for Blink/tmux:
# - Force Yazi onto the iTerm2 inline-image path Blink understands better.
# - Disable tmux mouse while Yazi runs to avoid repaint-triggered stray events.
yazi() {
    local tmux_mouse=""
    local exit_code=0

    if [ -n "$TMUX" ]; then
        tmux_mouse="$(tmux show -gv mouse 2>/dev/null || true)"
        tmux set -g mouse off >/dev/null 2>&1 || true
    fi

    if [ -z "$TERM_PROGRAM" ] || [ "$TERM_PROGRAM" = "tmux" ]; then
        TERM_PROGRAM="iTerm.app" command yazi "$@"
        exit_code=$?
    else
        command yazi "$@"
        exit_code=$?
    fi

    if [ -n "$TMUX" ] && [ -n "$tmux_mouse" ]; then
        tmux set -g mouse "$tmux_mouse" >/dev/null 2>&1 || true
    fi

    return "$exit_code"
}

# Doppler environment loader
d() {
    set -a
    . <(doppler secrets download --no-file --format env)
    set +a
}
