#!/usr/bin/env bash

set -euo pipefail

source "$HOME/scripts/sx_lib/init.sh"

APP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BIN_DIR="$APP_DIR/bin"

INSTALL_DIR="$HOME/.local/bin"

COMMANDS=(
    sx-dir-add
    sx-dir-list
    sx-dir-remove
    sx-dir-rename
    sx-dir-pick
)

sx-banner
sx-header "Installing sx-dir"

sx-ensure-dir "$INSTALL_DIR"

for command_name in "${COMMANDS[@]}"; do
    source_file="$BIN_DIR/$command_name"
    target_file="$INSTALL_DIR/$command_name"

    if [[ ! -f "$source_file" ]]; then
        sx-die "Missing command: $source_file"
    fi

    chmod +x "$source_file"
    ln -sfn "$source_file" "$target_file"

    sx-log ok "$command_name -> $target_file"
done

sx-log ok "sx-dir installed"
