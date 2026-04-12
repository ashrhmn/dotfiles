_DPS_FMT='table {{truncate .Names 22}}\t{{truncate .Image 35}}\t{{truncate .Status 20}}\t{{truncate .Ports 28}}'
_DPS_FULL_FMT='table {{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}'
_DPS_VERBOSE_FMT='table {{.ID}}\t{{.Names}}\t{{.Image}}\t{{.Command}}\t{{.Status}}\t{{.Ports}}'

alias dps="docker ps --format \"$_DPS_FMT\""
alias dpsa="docker ps -a --format \"$_DPS_FMT\""
alias dpsv="docker ps --format \"$_DPS_FULL_FMT\""
alias dpsvv="docker ps --format \"$_DPS_VERBOSE_FMT\""
alias dpsva="docker ps -a --format \"$_DPS_FULL_FMT\""
alias dpsvva="docker ps -a --format \"$_DPS_VERBOSE_FMT\""
