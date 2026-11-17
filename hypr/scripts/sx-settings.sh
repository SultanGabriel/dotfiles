#!/usr/bin/env bash

set -u

SCRIPT_DIR="$HOME/.config/hypr/scripts"

TASKBAR="$SCRIPT_DIR/sx-taskbar.sh"
WAYBAR_RELOAD="$SCRIPT_DIR/sx-waybar-reload.sh"
WEBCAM="$HOME/scripts/eos-webcam.sh"

# -------------------------------------------------------------------
# UI symbols
# -------------------------------------------------------------------

ICON_SELECTED="■"
ICON_UNSELECTED="□"

ICON_RESTART="↻"
ICON_STOP="✕"

ICON_SECTION="─"


# -------------------------------------------------------------------
# Helpers
# -------------------------------------------------------------------

is_selected() {
    local current="$1"
    local expected="$2"

    if [[ "$current" == "$expected" ]]; then
        printf '%s' "$ICON_SELECTED"
    else
        printf '%s' "$ICON_UNSELECTED"
    fi
}

section_line() {
    printf '%s\n' \
        "separator	────────────────────────────"
}

section_title() {
    printf '%s\n' \
        "title-$1	──────── $1 ────────" 
}

# -------------------------------------------------------------------
# Main UI
# -------------------------------------------------------------------

while true; do
    taskbar_mode="$("$TASKBAR" status)"
    monitor_mode="$("$TASKBAR" monitor-status)"

    autohide_icon="$(is_selected "$taskbar_mode" "autohide")"
    fixed_icon="$(is_selected "$taskbar_mode" "fixed")"

    all_monitors_icon="$(is_selected "$monitor_mode" "all")"
    main_monitor_icon="$(is_selected "$monitor_mode" "current")"

    webcam_mode="$("$WEBCAM" status)"
    webcam_icon="$(is_selected "$webcam_mode" "on")"

    choice="$(
        {
            section_title "Taskbar"

            printf '%s\n' \
                "title-taskbar-mode	── Visibility ──" \
                "taskbar-autohide	$autohide_icon  Auto-hide" \
                "taskbar-fixed	$fixed_icon  Always visible"

            printf '%s\n' \
                "title-taskbar-monitors	── Monitor Visibility ──" \
                "taskbar-all	$all_monitors_icon  All monitors" \
                "taskbar-current	$main_monitor_icon  Main monitor only"

            printf '%s\n' \
                "title-taskbar-tools	── Tools ──" \
                "taskbar-restart	$ICON_RESTART  Restart taskbar" \
                "taskbar-stop	$ICON_STOP  Stop taskbar"

            section_title "Waybar"

            printf '%s\n' \
                "waybar-reload	$ICON_RESTART  Reload Waybar"
            section_title "Camera"

            printf '%s\n' \
                "webcam-toggle	$webcam_icon  Canon EOS 200D"
        } |
        fzf \
            --delimiter=$'\t' \
            --with-nth=2 \
            --prompt='  SX  ›  ' \
            --pointer='›' \
            --marker='✓' \
            --height=100% \
            --layout=reverse \
            --border=rounded \
            --no-multi \
            --no-info \
            --bind='q:abort' \
            --bind='esc:abort' \
            --header='Desktop controls' \
            --color='fg:#d7dae0,fg+:#ffffff,bg:-1,bg+:#333844' \
            --color='hl:#8cd2ff,hl+:#8cd2ff' \
            --color='pointer:#8cd2ff,marker:#8cd2ff,prompt:#8cd2ff' \
            --footer='↑/↓ Navigate   Enter Select   q/Esc Close'
    )" || exit 0

    action="${choice%%$'\t'*}"

    case "$action" in
        taskbar-autohide)
            "$TASKBAR" autohide
            ;;

        taskbar-fixed)
            "$TASKBAR" fixed
            ;;

        taskbar-all)
            "$TASKBAR" monitors-all
            ;;

        taskbar-current)
            "$TASKBAR" monitors-current
            ;;

        taskbar-restart)
            "$TASKBAR" restart
            ;;

        taskbar-stop)
            "$TASKBAR" stop
            ;;

        waybar-reload)
            "$WAYBAR_RELOAD"
            ;;
        webcam-toggle)
          "$WEBCAM" toggle
          ;;

        separator|title-*)
            ;;
    esac
done
