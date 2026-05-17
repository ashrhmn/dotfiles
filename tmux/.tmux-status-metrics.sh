#!/usr/bin/env bash

set -u

state_dir="${XDG_RUNTIME_DIR:-/tmp}"
state_file="$state_dir/tmux-status-cpu-${UID:-$(id -u)}.state"

linux_metrics() {
  read -r _ user nice system idle iowait irq softirq steal guest guest_nice < /proc/stat

  idle_all=$((idle + iowait))
  non_idle=$((user + nice + system + irq + softirq + steal))
  total=$((idle_all + non_idle))

  cpu_tenths=0
  if [ -r "$state_file" ]; then
    read -r prev_total prev_idle < "$state_file" || {
      prev_total=0
      prev_idle=0
    }

    total_delta=$((total - prev_total))
    idle_delta=$((idle_all - prev_idle))

    if [ "$total_delta" -gt 0 ]; then
      cpu_count=$(getconf _NPROCESSORS_ONLN 2>/dev/null || printf '1')
      cpu_tenths=$((((total_delta - idle_delta) * cpu_count * 10 + total_delta / 2) / total_delta))
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
    mem_usage=$(((mem_used + 524288) / 1048576))
  fi

  printf '%s.%sC %sG' "$((cpu_tenths / 10))" "$((cpu_tenths % 10))" "$mem_usage"
}

macos_metrics() {
  cpu_tenths=$(ps -A -o %cpu= | awk '{sum += $1} END {printf "%d\n", (sum / 10) + 0.5}')
  mem_usage=$(vm_stat | awk -v page_size="$(pagesize)" '
    function value() {
      page_count = $NF
      gsub(/\./, "", page_count)
      return page_count
    }
    /^Pages active:/ { active = value() }
    /^Pages wired down:/ { wired = value() }
    /^Pages occupied by compressor:/ { compressed = value() }
    END {
      used = (active + wired + compressed) * page_size
      printf "%d\n", (used + 536870912) / 1073741824
    }
  ')

  printf '%s.%sC %sG' "$((cpu_tenths / 10))" "$((cpu_tenths % 10))" "$mem_usage"
}

case "$(uname -s)" in
  Darwin)
    macos_metrics
    ;;
  Linux)
    linux_metrics
    ;;
  *)
    printf '0.0C 0G'
    ;;
esac
