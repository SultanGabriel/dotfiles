#!/bin/bash

# ===== CONFIGURABLE VARIABLES =====

SSH_DIR="$HOME/.ssh"

# Files to exclude in find
EXCLUDE_PATTERNS=(
  "*.pub"
  "config"
  "known_hosts"
  "environment"
  "known_hosts.old"
  "environment*"
)

# FZF options
FZF_OPTS=(
  --multi
  --prompt='Select SSH keys to add: '
  # --tmux-pane=up,50%
  --layout=reverse
  --info=inline
)

# Symbols
SYMBOL_ADDED="✅"
SYMBOL_NOT_ADDED="❌"

# ===== LOGIC STARTS =====

cd "$SSH_DIR" || exit

# Get currently loaded SSH key fingerprints
loaded_keys=$(ssh-add -l 2>/dev/null | awk '{print $2}')

# Function to check if key is already added
is_key_added() {
  key_file=$1
  fingerprint=$(ssh-keygen -lf "$key_file" | awk '{print $2}')
  if echo "$loaded_keys" | grep -q "$fingerprint"; then
    echo "$SYMBOL_ADDED"
  else
    echo "$SYMBOL_NOT_ADDED"
  fi
}

# Build find command dynamically
FIND_CMD=(find . -type f)
for pattern in "${EXCLUDE_PATTERNS[@]}"; do
  FIND_CMD+=(! -name "$pattern")
done

# Build key list with symbols
key_list=""
while IFS= read -r key; do
  status=$(is_key_added "$key")
  key_list+="$status $key"$'\n'
done < <("${FIND_CMD[@]}")

# Use fzf to select keys
selected=$(echo "$key_list" | fzf "${FZF_OPTS[@]}" | awk '{print $2}')

if [[ -z "$selected" ]]; then
  echo "No key selected."
  exit 1
fi

# Add selected keys
for key in $selected; do
  echo "Adding key: $key"
  ssh-add "$key"
done

echo "All selected keys processed!"

