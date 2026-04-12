_DPS_FMT='table {{truncate .Names 22}}\t{{truncate .Image 35}}\t{{truncate .Status 20}}\t{{truncate .Ports 28}}'
_DPS_FULL_FMT='table {{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}'
_DPS_VERBOSE_FMT='table {{.ID}}\t{{.Names}}\t{{.Image}}\t{{.Command}}\t{{.Status}}\t{{.Ports}}'

alias dps="docker ps --format \"$_DPS_FMT\""
alias dpsa="docker ps -a --format \"$_DPS_FMT\""
alias dpsv="docker ps --format \"$_DPS_FULL_FMT\""
alias dpsvv="docker ps --format \"$_DPS_VERBOSE_FMT\""
alias dpsva="docker ps -a --format \"$_DPS_FULL_FMT\""
alias dpsvva="docker ps -a --format \"$_DPS_VERBOSE_FMT\""

alias dex="docker exec -it"
alias dlogs="docker logs -f"
alias dstop="docker stop"
alias drm="docker rm"
alias drestart="docker restart"

alias di="docker images"
alias drmi="docker rmi"
alias dpull="docker pull"
alias dbuild="docker build"

alias dcu="docker compose up -d"
alias dcuf="docker compose up -d --force-recreate --remove-orphans"
alias dcd="docker compose down"
alias dcl="docker compose logs -f"
alias dcb="docker compose build"
alias dcr="docker compose restart"

alias dprune="docker system prune -f"
alias dprune-all="docker system prune -af --volumes"

alias dstats="docker stats --no-trunc"
alias dins="docker inspect"
