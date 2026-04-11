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

# Doppler environment loader
d() {
    set -a
    . <(doppler secrets download --no-file --format env)
    set +a
}
