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

# Function to shorten directory name with ellipsis
shorten_dir() {
  local dir_path="$1"
  local max_length=20

  # If path is shorter than or equal to max length, return as-is
  if [ ${#dir_path} -le $max_length ]; then
    echo "$dir_path"
    return
  fi

  # Extract the last component of the path (basename)
  local basename=$(basename "$dir_path")

  # If basename is longer than max length, just truncate it
  if [ ${#basename} -ge $max_length ]; then
    echo "${basename:0:$((max_length-3))}..."
    return
  fi

  # Calculate remaining space for the path part
  local remaining=$((max_length - 3 - ${#basename}))

  # If we don't have enough room, truncate the basename instead
  if [ $remaining -le 0 ]; then
    echo "${basename:0:$((max_length-3))}..."
    return
  fi

  # Extract parent directory components and build shortened path
  local dir_without_basename=$(dirname "$dir_path")

  # Start with just the basename, then add parts of the path from right to left until we reach max length
  local result="$basename"

  # If it's already short enough, return it
  if [ ${#result} -le $max_length ]; then
    echo "$result"
    return
  fi

  # Add path components backwards (right-to-left) with ellipsis
  IFS='/' read -ra PATH_PARTS <<< "$dir_without_basename"

  local i=${#PATH_PARTS[@]}
  while [ $i -gt 0 ] && [ $((${#result} + 3)) -lt $max_length ]; do
    i=$((i-1))
    if [ $i -ge 0 ]; then
      # Skip empty parts (from leading /) or root directory
      if [ -n "${PATH_PARTS[$i]}" ] && [ "${PATH_PARTS[$i]}" != "/" ]; then
        result="${PATH_PARTS[$i]}/$result"
      fi
    fi
  done

  # If we're still over the limit, truncate at max length (including ...), otherwise return result
  if [ ${#result} -gt $max_length ]; then
    echo "${result:0:$((max_length-3))}..."
  else
    echo "$result"
  fi
}

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

# Shorten the directory name for display
shortened_dir="$(shorten_dir "$dir")"

case "$cmd" in
  nvim|vim)
    printf '%s %s' "$shortened_dir" "$nvim_icon" ;;
  zsh|bash|fish|sh|dash)
    printf '%s %s' "$shortened_dir" "$shell_icon" ;;
  ssh|mosh)
    printf '%s %s' "$shortened_dir" "$ssh_icon" ;;
  btop|htop|top)
    printf '%s %s' "$shortened_dir" "$btop_icon" ;;
  node)
    printf '%s %s' "$shortened_dir" "$node_icon" ;;
  claude)
    printf '%s %s' "$shortened_dir" "$claude_icon" ;;
  go)
    printf '%s %s' "$shortened_dir" "$go_icon" ;;
  cargo|rustc|rust-binary|target/debug/*|target/release/*)
    printf '%s %s' "$shortened_dir" "$rust_icon" ;;
  python|python3|python2)
    printf '%s %s' "$shortened_dir" "$python_icon" ;;
  bun)
    printf '%s %s' "$shortened_dir" "$bun_icon" ;;
  deno)
    printf '%s %s' "$shortened_dir" "$deno_icon" ;;
  *)
    printf '%s  %s' "$shortened_dir" "$cmd" ;;
esac
