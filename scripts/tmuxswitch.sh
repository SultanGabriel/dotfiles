#!/bin/bash

########################################
# Very nice script doing nice things   #
# with tmux fzf, and tmuxinator.       #
# Very Cool.                           #
#                                      #
# - Sultan                             #
########################################


export PATH="$HOME/.fzf/bin:$PATH"

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

# Get list of all tmux sessions
all_sessions=$(tmux list-sessions -F "#{session_name}" 2>/dev/null)

# Detect if inside tmux
if [ -n "$TMUX" ]; then
  current_session=$(tmux display-message -p '#S' 2>/dev/null)
else
  current_session=""
fi

# Get list of tmuxinator projects
mux_projects=$(tmuxinator list -n | awk '{print $1}' | grep -v '^-' )

current_list=""
running_list=""
inactive_list=""
already_listed=""

# Process tmuxinator projects
for proj in $mux_projects; do
  if echo "$all_sessions" | grep -qw "$proj"; then
    if [[ "$proj" == "$current_session" ]]; then
      current_list+="${BOLD}${CURRENT_ICON}      ${proj}${RESET}\n"
    else
      running_list+="${GREEN}${RUNNING_EMOJI}      ${proj}${RESET}\n"
    fi
  else
    inactive_list+="${DIM}${INACTIVE_ICON}      ${proj}${RESET}\n"
  fi
  already_listed+="$proj "
done

# Process other tmux sessions not listed in tmuxinator
for session in $all_sessions; do
  if ! echo "$already_listed" | grep -qw "$session"; then
    if [[ "$session" == "$current_session" ]]; then
      current_list+="${BOLD}${CURRENT_ICON}      ${session}${RESET}\n"
    else
      running_list+="${YELLOW}${RUNNING_EMOJI}      ${session}${RESET}\n"
    fi
  fi
done

# Combine lists: current -> running -> inactive
choices="${current_list}${running_list}${inactive_list}"

# FZF options
FZF_OPTS=(
  --tmux 60%
  --border
  --margin=1%,1%
  --padding=2%
  --layout=reverse
  --info=inline
)

# Use fzf to pick
selected=$(echo -e "$choices" | fzf --ansi "${FZF_OPTS[@]}" | awk '{print $2}')

# Exit if nothing selected
if [[ -z "$selected" ]]; then
  exit 0
fi


# Determine if selected session is running
if echo "$all_sessions" | grep -qw "$selected"; then
  if [ -n "$TMUX" ]; then
    tmux switch-client -t "$selected"
  else
    tmux attach -t "$selected"
  fi
else
  tmuxinator start "$selected"
fi
