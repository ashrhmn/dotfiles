#!/bin/bash
# Status line derived from ~/.config/zsh/prompt.zsh
# Original PROMPT: '%F{cyan}%~%f%F{red}${vcs_info_msg_0_}%f %F{green}%f '

input=$(cat)
cwd=$(echo "$input" | jq -r '.workspace.current_dir')

# Mirror zsh's %~ : show path relative to $HOME using ~
if [ "$cwd" = "$HOME" ]; then
  display_path="~"
elif [ "${cwd#"$HOME"/}" != "$cwd" ]; then
  display_path="~${cwd#"$HOME"}"
else
  display_path="$cwd"
fi

branch=""
if git -C "$cwd" --no-optional-locks rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  branch=$(git -C "$cwd" --no-optional-locks branch --show-current 2>/dev/null)
fi

CYAN='\033[36m'
RED='\033[31m'
GREEN='\033[32m'
DIM='\033[2m'
RESET='\033[0m'

IFS='|' read -r model effort ctx_used five_hour seven_day <<EOF
$(echo "$input" | jq -r '[
  (.model.display_name // ""),
  (.effort.level // ""),
  (.context_window.used_percentage // ""),
  (.rate_limits.five_hour.used_percentage // ""),
  (.rate_limits.seven_day.used_percentage // "")
] | join("|")')
EOF

model_segment="$model"
[ -n "$model" ] && [ -n "$effort" ] && model_segment="$model:$effort"

segments=()
[ -n "$model_segment" ] && segments+=("$model_segment")
[ -n "$ctx_used" ] && segments+=("ctx $(printf '%.0f' "$ctx_used")%")
[ -n "$five_hour" ] && segments+=("5h $(printf '%.0f' "$five_hour")%")
[ -n "$seven_day" ] && segments+=("7d $(printf '%.0f' "$seven_day")%")

extra=""
for seg in "${segments[@]}"; do
  if [ -z "$extra" ]; then
    extra="$seg"
  else
    extra="$extra · $seg"
  fi
done

if [ -n "$branch" ]; then
  printf "${CYAN}%s${RESET}${RED} (%s)${RESET} ${GREEN}\xe2\x9e\x9c${RESET} " "$display_path" "$branch"
else
  printf "${CYAN}%s${RESET} ${GREEN}\xe2\x9e\x9c${RESET} " "$display_path"
fi

if [ -n "$extra" ]; then
  printf "${DIM}%s${RESET}" "$extra"
fi
