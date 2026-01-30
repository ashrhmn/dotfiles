# Environment variables

# Editor
export EDITOR='nvim'

# Locale
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# PostgreSQL pager
export PSQL_PAGER='pspg -X -s 16'

# Dotnet
export DOTNET_WATCH_RESTART_ON_RUDE_EDIT=1

# Database path (user specific)
export DBS_PATH="/Users/ash/Library/CloudStorage/GoogleDrive-ashrhmn@outlook.com/My Drive/Backup/secrets/databases.csv"

# Deno completions
if [[ ":$FPATH:" != *":$HOME/.zsh/completions:"* ]]; then
    export FPATH="$HOME/.zsh/completions:$FPATH"
fi
