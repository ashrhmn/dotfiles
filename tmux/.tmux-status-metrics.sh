#!/usr/bin/env bash

set -u

state_dir="${XDG_RUNTIME_DIR:-/tmp}"
state_file="$state_dir/tmux-status-cpu-${UID:-$(id -u)}.state"

read -r _ user nice system idle iowait irq softirq steal guest guest_nice < /proc/stat

idle_all=$((idle + iowait))
non_idle=$((user + nice + system + irq + softirq + steal))
total=$((idle_all + non_idle))

cpu_usage=0
if [ -r "$state_file" ]; then
  read -r prev_total prev_idle < "$state_file" || {
    prev_total=0
    prev_idle=0
  }

  total_delta=$((total - prev_total))
  idle_delta=$((idle_all - prev_idle))

  if [ "$total_delta" -gt 0 ]; then
    cpu_usage=$((((total_delta - idle_delta) * 100 + total_delta / 2) / total_delta))
  fi
fi

printf '%s %s\n' "$total" "$idle_all" > "$state_file"

mem_total=0
mem_available=0
while read -r key value _; do
  case "$key" in
    MemTotal:)
      mem_total="$value"
      ;;
    MemAvailable:)
      mem_available="$value"
      ;;
  esac
done < /proc/meminfo

mem_usage=0
if [ "$mem_total" -gt 0 ]; then
  mem_used=$((mem_total - mem_available))
  mem_usage=$(((mem_used * 100 + mem_total / 2) / mem_total))
fi

printf 'CPU %s%% RAM %s%%' "$cpu_usage" "$mem_usage"
