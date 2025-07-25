# Set to 1 to enable debug timing logs for .zshrc loading
# export DEBUG_ZSHRC=1

export CATPPUCCIN_FLAVOUR="mocha"

# Debug logging function
debug_log() {
    [[ "$DEBUG_ZSHRC" == "1" ]] && echo "[$(date '+%H:%M:%S.%3N')] DEBUG: $1"
}

# Add deno completions to search path
if [[ ":$FPATH:" != *":/home/ash/.zsh/completions:"* ]]; then export FPATH="/home/ash/.zsh/completions:$FPATH"; fi
debug_log "Deno completions setup complete"
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
# if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
#   source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
# fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
debug_log "Starting oh-my-zsh setup"
export ZSH="$HOME/.oh-my-zsh"
debug_log "ZSH variable set"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
# ZSH_THEME="powerlevel10k/powerlevel10k"
ZSH_THEME="robbyrussell"
# ZSH_THEME="af-magic"
# ZSH_THEME=""

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
debug_log "Loading plugins"
plugins=(
	git
	zsh-autosuggestions
	zsh-syntax-highlighting
)
debug_log "Plugins loaded"

# Disable oh-my-zsh auto-update to prevent slow startup
DISABLE_AUTO_UPDATE=true

debug_log "Starting oh-my-zsh source"
source $ZSH/oh-my-zsh.sh
debug_log "oh-my-zsh sourced"

safe_source() {
    [[ -f "$1" ]] && source "$1"
}

debug_log "Loading secrets"
safe_source "$HOME/.secrets.sh"
debug_log "Secrets loaded"

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi
export EDITOR='nvim'

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Setup NVM
# export NVM_DIR="$HOME/.nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# auto switch node version to .nvmrc
# place this after nvm initialization!
# autoload -U add-zsh-hook
# load-nvmrc() {
#   local node_version="$(nvm version)"
#   local nvmrc_path="$(nvm_find_nvmrc)"
#
#   if [ -n "$nvmrc_path" ]; then
#     local nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")
#
#     if [ "$nvmrc_node_version" = "N/A" ]; then
#       nvm install
#     elif [ "$nvmrc_node_version" != "$node_version" ]; then
#       nvm use > /dev/null
#     fi
#   elif [ "$node_version" != "$(nvm version default)" ]; then
#     # echo "Reverting to nvm default version"
#     nvm use default > /dev/null
#   fi
# }
# add-zsh-hook chpwd load-nvmrc
# load-nvmrc

alias cln="cd ~/clones"
alias dl="cd ~/Downloads"
alias dt="cd ~/Desktop"
alias p="pnpm"
alias dp="doppler run -- pnpm"
alias dy="doppler run -- yarn"
alias dop="doppler run --"
alias dopen="doppler open"
alias dget="doppler secrets get"
alias dset="doppler secrets set"
alias denv="doppler secrets download --no-file --format=env-no-quotes"
alias dcp="denv | pbcopy"
alias mp="multipass"
alias c="clear"
alias e="exit"
alias t="tmux"
alias ta="tmux attach || tmux"
alias cat="bat"
alias l="eza -l --group-directories-first --icons --color=always"
alias ls="eza --group-directories-first --icons --color=always"
alias ll="eza -l --group-directories-first --icons --color=always"
alias la="eza -la --group-directories-first --icons --color=always"
alias laa="eza -la --group-directories-first --icons --color=always --absolute"
alias lag="eza -la --group-directories-first --icons --color=always --git --git-repos-no-status"

function pmgen(){
  echo "module.exports = { apps: [{ name: '$1', script: '${@:2}', time: true, email: './app.log' }] };">ecosystem.config.cjs;
}

export PATH="$HOME/Library/Python/3.8/bin/:$PATH"
export PATH="/opt/homebrew/opt/libpq/bin:$PATH"
export PGHOST="localhost"
export JAVA_HOME="/Applications/Android Studio.app/Contents/jbr/Contents/Home"

# [ -s "$HOME/.web3j/source.sh" ] && source "$HOME/.web3j/source.sh"

# bun completions
debug_log "Loading bun completions"
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"
debug_log "Bun completions loaded"

# Bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
# export PATH="$HOME/go/bin/:$PATH"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
# [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# pnpm
export PNPM_HOME="$HOME/Library/pnpm"
export PATH="$PNPM_HOME:$PATH"
# pnpm end

# tabtab source for packages
# uninstall by removing these lines
debug_log "Loading tabtab"
[[ -f ~/.config/tabtab/zsh/__tabtab.zsh ]] && . ~/.config/tabtab/zsh/__tabtab.zsh || true
debug_log "Tabtab loaded"
export DOTNET_WATCH_RESTART_ON_RUDE_EDIT=1
# export DOCKER_HOST=ssh://ash@debian
# export DOCKER_HOST=ssh://ubuntu@homeserver
# export PGDATA="/opt/homebrew/var/postgresql@15"
export PATH="/opt/homebrew/opt/openjdk@17/bin:$PATH"
# export PATH="$HOME/flutter-sdk/flutter:$PATH"
# export PATH="$HOME/flutter-sdk/flutter/bin:$PATH"
export PATH="$PATH":"$HOME/.pub-cache/bin"
export PATH="$PATH":"$HOME/go/bin"
export PATH="/opt/homebrew/opt/mysql-client/bin:$PATH"
export PATH="/Users/ash/.local/share/solana/install/active_release/bin:$PATH"
# export PATH="/Users/Shared/DBngin/mysql/8.0.33/bin:$PATH"
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

export DBS_PATH="/Users/ash/Library/CloudStorage/GoogleDrive-ashrhmn@outlook.com/My Drive/Backup/secrets/databases.csv"

debug_log "Initializing zoxide"
eval "$(zoxide init --cmd cd zsh)"
debug_log "Zoxide initialized"
# export PYENV_ROOT="$HOME/.pyenv"
# [[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
# eval "$(pyenv init -)"

debug_log "Initializing fnm"
eval "$(fnm env --use-on-cd --version-file-strategy=recursive)"
debug_log "fnm initialized"


debug_log "Initializing tmuxifier"
export PATH="$HOME/.tmux/plugins/tmuxifier/bin:$PATH"
eval "$(tmuxifier init -)"
debug_log "Tmuxifier initialized"

# Set up fzf key bindings and fuzzy completion
debug_log "Loading fzf"
source <(fzf --zsh)
debug_log "fzf loaded"

alias inv='nvim $(fzf -m --preview="bat --color=always {}")'

export PATH="/opt/homebrew/opt/libpq/bin:$PATH"
export LDFLAGS="-L/opt/homebrew/opt/libpq/lib"
export CPPFLAGS="-I/opt/homebrew/opt/libpq/include"

export PATH="/Users/ash/.dotnet:$PATH"

# Stripe Auto Completion
debug_log "Loading Stripe completion"
fpath=(~/.stripe $fpath)
autoload -Uz compinit && compinit -i
debug_log "Stripe completion loaded"

[[ ":$PATH:" != *":$HOME/.bin:"* ]] && PATH="$HOME/.bin:$PATH"


# Created by `pipx` on 2025-06-27 20:35:05
export PATH="$PATH:/Users/ash/.local/bin"

# alias claude="/Users/ash/.claude/local/claude"
# . "/home/ash/.deno/env"

debug_log ".zshrc loading complete"


alias claude="/home/ash/.claude/local/claude"
