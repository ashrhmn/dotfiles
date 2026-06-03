#!/usr/bin/env bash

cmd="$1"
dir="$2"
pid="$3"

resolve_make_command() {
  local root_pid="$1"
  local root_cmd=""
  local root_under_make=0
  local current_pid current_depth current_under_make child child_cmd child_under_make
  local resolved_cmd=""
  local resolved_pid=""
  local resolved_depth=999999
  local -a pids=("$root_pid")
  local -a depths=(0)
  local -a children=()
  local index=0

  { read -r root_cmd < "/proc/$root_pid/comm"; } 2>/dev/null || true
  if [[ "$root_cmd" == "make" || "$root_cmd" == "gmake" ]]; then
    root_under_make=1
  fi
  local -a under_make=("$root_under_make")

  while [ "$index" -lt "${#pids[@]}" ]; do
    current_pid="${pids[$index]}"
    current_depth="${depths[$index]}"
    current_under_make="${under_make[$index]}"
    index=$((index + 1))

    children=()
    { read -r -a children < "/proc/$current_pid/task/$current_pid/children"; } 2>/dev/null || true

    for child in "${children[@]}"; do
      { read -r child_cmd < "/proc/$child/comm"; } 2>/dev/null || continue
      child_under_make="$current_under_make"

      if [[ "$child_cmd" == "make" || "$child_cmd" == "gmake" ]]; then
        child_under_make=1
      fi

      pids+=("$child")
      depths+=("$((current_depth + 1))")
      under_make+=("$child_under_make")

      if [ "$child_under_make" -eq 1 ] &&
         [[ "$child_cmd" != "make" && "$child_cmd" != "gmake" ]] &&
         [[ "$child_cmd" != "sh" && "$child_cmd" != "bash" && "$child_cmd" != "dash" &&
            "$child_cmd" != "zsh" && "$child_cmd" != "fish" && "$child_cmd" != "env" ]] &&
         [ "$current_depth" -lt "$resolved_depth" ]; then
        resolved_cmd="$child_cmd"
        resolved_pid="$child"
        resolved_depth="$current_depth"
      fi
    done
  done

  if [ -n "$resolved_cmd" ]; then
    cmd="$resolved_cmd"
    pid="$resolved_pid"
  fi
}

if [[ "$cmd" == "make" || "$cmd" == "gmake" ]] && [ -n "$pid" ]; then
  resolve_make_command "$pid"
fi

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
