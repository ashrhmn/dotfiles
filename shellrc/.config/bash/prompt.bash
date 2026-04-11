_bash_git_branch() {
    git symbolic-ref --quiet --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null
}

_bash_prompt() {
    local branch
    branch=$(_bash_git_branch)
    local git_part=""
    [ -n "$branch" ] && git_part=" ($branch)"
    PS1="\[\033[36m\]\w\[\033[0m\]\[\033[31m\]${git_part}\[\033[0m\] \[\033[32m\]➜\[\033[0m\] "
}

PROMPT_COMMAND="_bash_prompt"
