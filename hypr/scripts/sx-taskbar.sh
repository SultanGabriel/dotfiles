#!/usr/bin/env bash

set -u

STATE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/sx-hyprland"

MODE_FILE="$STATE_DIR/taskbar-mode"
MONITOR_FILE="$STATE_DIR/taskbar-monitors"

mkdir -p "$STATE_DIR"

DEFAULT_MODE="autohide"
DEFAULT_MONITORS="current"

get_mode() {
    if [[ -f "$MODE_FILE" ]]; then
        cat "$MODE_FILE"
    else
        printf '%s\n' "$DEFAULT_MODE"
    fi
}

get_monitors() {
    if [[ -f "$MONITOR_FILE" ]]; then
        cat "$MONITOR_FILE"
    else
        printf '%s\n' "$DEFAULT_MONITORS"
    fi
}

stop_dock() {
    pkill -f '(^|/)nwg-dock-hyprland([[:space:]]|$)' 2>/dev/null || true
    sleep 0.15
}

build_mode_args() {
    case "$(get_mode)" in
        fixed)
            printf '%s\n' "-r" "-x"
            ;;

        autohide|*)
            printf '%s\n' "-d"
            ;;
    esac
}

start_one() {
    local output="$1"
    shift

    setsid -f nwg-dock-hyprland \
        "$@" \
        -f \
        -p bottom \
        -a start \
        -lp start \
        -i 28 \
        -mb 0 \
        -o "$output" \
        -c "$HOME/.config/hypr/scripts/rofi-launcher.sh 1 15" \
        >/dev/null 2>&1
}

start_dock() {
    stop_dock

    mapfile -t mode_args < <(build_mode_args)

    case "$(get_monitors)" in
        all)
            # -m allows several nwg-dock-hyprland instances.
            start_one "DP-3" -m "${mode_args[@]}"
            start_one "DP-1" -m "${mode_args[@]}"
            start_one "HDMI-A-1" -m "${mode_args[@]}"
            ;;

        current|*)
            # Your normal/main taskbar monitor.
            start_one "DP-1" "${mode_args[@]}"
            ;;
    esac
}

set_mode() {
    printf '%s\n' "$1" > "$MODE_FILE"
    start_dock
}

set_monitors() {
    printf '%s\n' "$1" > "$MONITOR_FILE"
    start_dock
}

case "${1:-start}" in
    start|restart)
        start_dock
        ;;

    fixed)
        set_mode fixed
        ;;

    autohide)
        set_mode autohide
        ;;

    toggle)
        if [[ "$(get_mode)" == "fixed" ]]; then
            set_mode autohide
        else
            set_mode fixed
        fi
        ;;

    monitors-current)
        set_monitors current
        ;;

    monitors-all)
        set_monitors all
        ;;

    toggle-monitors)
        if [[ "$(get_monitors)" == "all" ]]; then
            set_monitors current
        else
            set_monitors all
        fi
        ;;

    status)
        get_mode
        ;;

    monitor-status)
        get_monitors
        ;;

    stop)
        stop_dock
        ;;

    *)
        echo "Usage: $0 {start|restart|fixed|autohide|toggle|monitors-current|monitors-all|toggle-monitors|status|monitor-status}"
        exit 1
        ;;
esac