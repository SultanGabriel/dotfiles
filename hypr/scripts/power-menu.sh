#!/usr/bin/env bash
set -euo pipefail

choice="$(
    printf '%s\n' \
        "Lock" \
        "Logout" \
        "Suspend" \
        "Reboot" \
        "Shutdown" |
    rofi -dmenu \
         -i \
         -p "Power"
)"

case "$choice" in
    "Lock")
        hyprlock
        ;;

    "Logout")
        hyprshutdown
        ;;

    "Suspend")
        systemctl suspend
        ;;

    "Reboot")
        systemctl reboot
        ;;

    "Shutdown")
        systemctl poweroff
        ;;
esac