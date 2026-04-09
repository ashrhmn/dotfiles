# Simple prompt configuration (robbyrussell-style)

# Load version control info
autoload -Uz vcs_info
precmd() { vcs_info }

# Format the vcs_info_msg_0_ variable
zstyle ':vcs_info:git:*' formats ' (%b)'

# Enable parameter expansion in prompt
setopt PROMPT_SUBST

# Set the prompt
PROMPT='%F{cyan}%~%f%F{red}${vcs_info_msg_0_}%f %F{green}➜%f '
