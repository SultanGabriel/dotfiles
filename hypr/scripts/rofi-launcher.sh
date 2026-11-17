#!/usr/bin/env bash

TYPE="${1:-1}"
STYLE="${2:-1}"
MODE="${3:-drun}"

ROFI_DIR="$HOME/.config/rofi/launchers/type-${TYPE}"
THEME="$ROFI_DIR/style-${STYLE}.rasi"

if [[ ! -f "$THEME" ]]; then
    notify-send "Rofi" "Theme not found: type-${TYPE}/style-${STYLE}"
    exit 1
fi

exec rofi \
    -show "$MODE" \
    -theme "$THEME"