#!/bin/sh

set -eu

MODE="${1:-area}"

SCREENSHOT_DIR="${XDG_PICTURES_DIR:-$HOME/Pictures}/Screenshots"
mkdir -p "$SCREENSHOT_DIR"

FILE="$SCREENSHOT_DIR/$(date '+%Y%m%d_%H%M%S_%3N').png"

case "$MODE" in
    area)
        GEOMETRY="$(slurp)" || exit 0
        [ -n "$GEOMETRY" ] || exit 0

        grim -g "$GEOMETRY" "$FILE"
        ;;

    window)
        GEOMETRY="$(
            hyprctl activewindow -j |
                jq -r '"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"'
        )"

        [ -n "$GEOMETRY" ] || exit 1

        grim -g "$GEOMETRY" "$FILE"
        ;;

    monitor)
        OUTPUT="$(
            hyprctl monitors -j |
                jq -r '.[] | select(.focused == true).name'
        )"

        [ -n "$OUTPUT" ] || exit 1

        grim -o "$OUTPUT" "$FILE"
        ;;

    all)
        grim "$FILE"
        ;;

    *)
        printf 'Unknown screenshot mode: %s\n' "$MODE" >&2
        exit 2
        ;;
esac

# Immediately place the screenshot on the Wayland clipboard.
wl-copy --type image/png < "$FILE"

# Show a clickable notification. Left-clicking invokes the default
# action in mako and returns "default" from notify-send.
ACTION="$(
    notify-send \
        --app-name="Screenshot" \
        --icon="$FILE" \
        --urgency=normal \
        --expire-time=8000 \
        --action=default="Edit in Satty" \
        "Screenshot captured" \
        "Saved and copied to clipboard"
)" || true

# Only launch Satty if the notification was activated.
if [ "$ACTION" = "default" ]; then
    satty \
        --filename "$FILE" \
        --output-filename "$FILE"
fi