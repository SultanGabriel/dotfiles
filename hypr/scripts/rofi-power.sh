#!/usr/bin/env bash

TYPE="${1:-1}"
STYLE="${2:-1}"

DIR="$HOME/.config/rofi/powermenu/type-${TYPE}"
SCRIPT="$DIR/powermenu.sh"
THEME="$DIR/style-${STYLE}.rasi"

if [[ ! -x "$SCRIPT" ]]; then
    notify-send "Rofi" "Power menu not found: type-${TYPE}"
    exit 1
fi

if [[ ! -f "$THEME" ]]; then
    notify-send "Rofi" "Power theme not found: type-${TYPE}/style-${STYLE}"
    exit 1
fi

exec "$SCRIPT" "$STYLE"