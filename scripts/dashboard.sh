#!/bin/bash

# Colors
BOLD="\e[1m"
RESET="\e[0m"
GREEN="\e[32m"
YELLOW="\e[33m"
DIM="\e[2m"

# Emojis and symbols
RUNNING_EMOJI="🌕"  
INACTIVE_ICON="🌑"
CURRENT_ICON="🌍"    


# --- System Info ---
# echo ""
# if command -v neofetch >/dev/null 2>&1; then
# neofetch
# else
# echo "🖥️  Host: $(hostname) | IP: $(hostname -I | awk '{print $1}')"
# fi

# # --- System Summary ---
# echo ""
# echo "🕒 Uptime: $(uptime -p)"
# echo "📊 CPU: $(top -bn1 | grep 'Cpu(s)' | awk '{print $2 + $4}')%"
#
# # Memory
# mem_used=$(free -h | awk '/Mem:/ {print $3}')
# mem_total=$(free -h | awk '/Mem:/ {print $2}')
# echo "💾 Memory: ${mem_used} / ${mem_total}"
#
# # Disk
# disk_used=$(df -h / | awk 'END{print $3}')
# disk_total=$(df -h / | awk 'END{print $2}')
# echo "🗄️  Disk: ${disk_used} / ${disk_total}"

# --- TMUX Sessions Overview ---
echo ""
echo "🌐 TMUX Sessions:"
echo ""
current_session=$(tmux display-message -p '#S' 2>/dev/null)
all_sessions=$(tmux list-sessions -F "#{session_name}" 2>/dev/null)
mux_projects=$(tmuxinator list -n | awk '{print $1}' | grep -v '^-')

already_listed=()

for proj in $mux_projects; do
  if echo "$all_sessions" | grep -qw "$proj"; then
    if [[ "$proj" == "$current_session" ]]; then
      echo "${CURRENT_ICON}  $proj (current)"
    else
      echo "${CURRENT_ICON}  $proj (running)"
    fi
  else
    echo "${INACTIVE_ICON}  $proj (inactive)"
  fi
  already_listed+=("$proj")
done

for session in $all_sessions; do
  skip=0
  for listed in "${already_listed[@]}"; do
    if [[ "$session" == "$listed" ]]; then
      skip=1
      break
    fi
  done
  if [[ $skip -eq 0 ]]; then
    if [[ "$session" == "$current_session" ]]; then
      echo "⭐  $session (current)"
    else
      echo "✅  $session (running)"
    fi
  fi
done

# --- Optional Reminders ---
if [ -f ~/.tasks ]; then
  echo ""
  echo "📝 Reminders:"
  head -n 5 ~/.tasks
fi

# --- Random Tip ---
echo ""
echo "💡 Tip: Use 'muxgo' to switch sessions!"


