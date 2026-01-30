# PATH modifications

# User bin
[[ ":$PATH:" != *":$HOME/.bin:"* ]] && PATH="$HOME/.bin:$PATH"

# Python
export PATH="$HOME/Library/Python/3.8/bin/:$PATH"

# PostgreSQL
export PATH="/opt/homebrew/opt/libpq/bin:$PATH"
export LDFLAGS="-L/opt/homebrew/opt/libpq/lib"
export CPPFLAGS="-I/opt/homebrew/opt/libpq/include"
export PGHOST="localhost"

# Java
export JAVA_HOME="/Applications/Android Studio.app/Contents/jbr/Contents/Home"

# Bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# pnpm
export PNPM_HOME="$HOME/Library/pnpm"
export PATH="$PNPM_HOME:$PATH"

# Go
export PATH="$PATH:$HOME/go/bin"

# OpenJDK
export PATH="/opt/homebrew/opt/openjdk@17/bin:$PATH"

# Dart/Flutter pub cache
export PATH="$PATH:$HOME/.pub-cache/bin"

# MySQL client
export PATH="/opt/homebrew/opt/mysql-client/bin:$PATH"

# Solana
export PATH="/Users/ash/.local/share/solana/install/active_release/bin:$PATH"

# .NET
export PATH="/Users/ash/.dotnet:$PATH"

# pipx
export PATH="$PATH:/Users/ash/.local/bin"

# Cargo (Rust)
export PATH="/home/ash/.cargo/bin:$PATH"

# Tmuxifier
export PATH="$HOME/.tmux/plugins/tmuxifier/bin:$PATH"

# OpenCode
export PATH=/home/ash/.opencode/bin:$PATH
