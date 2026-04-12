_ALIASES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-${(%):-%x}}")" && pwd)"

source "$_ALIASES_DIR/navigation.sh"
source "$_ALIASES_DIR/misc.sh"
source "$_ALIASES_DIR/package-managers.sh"
source "$_ALIASES_DIR/doppler.sh"
source "$_ALIASES_DIR/ls.sh"
source "$_ALIASES_DIR/cat.sh"
source "$_ALIASES_DIR/editor.sh"
source "$_ALIASES_DIR/docker.sh"
source "$_ALIASES_DIR/git.sh"

unset _ALIASES_DIR
