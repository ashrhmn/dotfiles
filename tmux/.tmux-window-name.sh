#!/usr/bin/env bash

cmd="$1"
dir="$2"
pid="$3"

# check if the process exe is under target/debug or target/release (rust binary)
if [ -n "$pid" ]; then
  full_exe=$(readlink "/proc/$pid/exe" 2>/dev/null)
  if [[ "$full_exe" == */target/debug/* || "$full_exe" == */target/release/* ]]; then
    cmd="rust-binary"
  fi
fi

nvim_icon=$(printf '')
shell_icon=$(printf '')
ssh_icon=$(printf '\U000F08C0')
btop_icon=$(printf '\U000EBA2')
node_icon=$(printf '\U000ED0D')
claude_icon=$(printf '\U000EC10')
go_icon=$(printf '\U000F07D3')
rust_icon=$(printf '')
python_icon=$(printf '')
bun_icon=$(printf '')
deno_icon=$(printf '')

case "$cmd" in
  nvim|vim)
    printf '%s %s' "$dir" "$nvim_icon" ;;
  zsh|bash|fish|sh|dash)
    printf '%s %s' "$dir" "$shell_icon" ;;
  ssh|mosh)
    printf '%s %s' "$dir" "$ssh_icon" ;;
  btop|htop|top)
    printf '%s %s' "$dir" "$btop_icon" ;;
  node)
    printf '%s %s' "$dir" "$node_icon" ;;
  claude)
    printf '%s %s' "$dir" "$claude_icon" ;;
  go)
    printf '%s %s' "$dir" "$go_icon" ;;
  cargo|rustc|rust-binary)
    printf '%s %s' "$dir" "$rust_icon" ;;
  python|python3|python2)
    printf '%s %s' "$dir" "$python_icon" ;;
  bun)
    printf '%s %s' "$dir" "$bun_icon" ;;
  deno)
    printf '%s %s' "$dir" "$deno_icon" ;;
  *)
    printf '%s  %s' "$dir" "$cmd" ;;
esac
