# Bash entry point
# Sources common shell config then bash-specific layers

shopt -s autocd 2>/dev/null
shopt -s histappend
shopt -s checkwinsize

HISTFILE=~/.bash_history
HISTSIZE=10000
HISTFILESIZE=10000
HISTCONTROL=ignoredups:erasedups

SHELL_DIR="$HOME/.config/shell"

source "$SHELL_DIR/functions.sh"
source "$SHELL_DIR/environment.sh"
source "$SHELL_DIR/paths.sh"
source "$SHELL_DIR/aliases/index.sh"

# Bash-specific: gtl as a plain function (no noglob)
gtl() { git tag --sort=-v:refname -n -l "${1}*"; }

source "$HOME/.config/bash/tools.bash"
source "$HOME/.config/bash/prompt.bash"
