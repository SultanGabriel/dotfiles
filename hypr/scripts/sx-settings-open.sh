#!/usr/bin/env bash

set -u

CLASS="sx-settings"
SCRIPT="$HOME/.config/hypr/scripts/sx-settings.sh"

# If a visible SX window already exists, focus it.
if hyprctl clients -j | grep -q "\"class\": \"$CLASS\""; then
    hyprctl dispatch focuswindow "class:^${CLASS}$" >/dev/null
    exit 0
fi

# Clean up a stale Alacritty/SX process if one exists without a window.
pkill -f "alacritty.*--class ${CLASS}" 2>/dev/null || true
pkill -f "$SCRIPT" 2>/dev/null || true

sleep 0.1

# Start a fresh disposable SX window.
exec alacritty \
    --class "$CLASS" \
    --title "SX Settings" \
    -e bash \
        --noprofile \
        --norc \
        "$SCRIPT"