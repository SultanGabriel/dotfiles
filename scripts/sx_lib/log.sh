#!/usr/bin/env bash
# -----------------------------------------------------------------------------
# sx-lib: log.sh
#
# Small colored logging helpers.
# Colors are used only when stdout is a terminal. Set NO_COLOR=1 to disable.
# -----------------------------------------------------------------------------

if [[ -t 1 && -z "${NO_COLOR:-}" ]]; then
    SX_RESET=$'\033[0m'
    SX_BOLD=$'\033[1m'
    SX_RED=$'\033[31m'
    SX_GREEN=$'\033[32m'
    SX_YELLOW=$'\033[33m'
    SX_BLUE=$'\033[34m'
    SX_CYAN=$'\033[36m'
else
    SX_RESET=""
    SX_BOLD=""
    SX_RED=""
    SX_GREEN=""
    SX_YELLOW=""
    SX_BLUE=""
    SX_CYAN=""
fi

# sx-log <level> <message...>
# Levels: info, ok, warn, error
sx-log() {
    local level="${1:-info}"
    shift || true

    local color label
    case "$level" in
        info)
            color="$SX_BLUE"
            label="INFO"
            ;;
        ok|success)
            color="$SX_GREEN"
            label=" OK "
            ;;
        warn|warning)
            color="$SX_YELLOW"
            label="WARN"
            ;;
        error|err)
            color="$SX_RED"
            label="ERR "
            ;;
        *)
            color="$SX_CYAN"
            label="$level"
            ;;
    esac

    printf '%s[%s]%s %s\n' \
        "${color}${SX_BOLD}" "$label" "$SX_RESET" "$*"
}

# A normal section header.
sx-header() {
    printf '\n%s%s== %s ==%s\n\n' \
        "$SX_BOLD" "$SX_CYAN" "$*" "$SX_RESET"
}

# A smaller subsection header.
sx-section() {
    printf '\n%s-- %s --%s\n' \
        "${SX_BOLD}${SX_BLUE}" "$*" "$SX_RESET"
}

# Large SXLTXN banner for the start of a script.
sx-banner() {
    printf '%s%s' "$SX_BOLD" "$SX_BLUE"
    cat <<'BANNER'
 ███████╗██╗  ██╗██╗  ████████╗██╗  ██╗███╗   ██╗
 ██╔════╝╚██╗██╔╝██║  ╚══██╔══╝╚██╗██╔╝████╗  ██║
 ███████╗ ╚███╔╝ ██║     ██║    ╚███╔╝ ██╔██╗ ██║
 ╚════██║ ██╔██╗ ██║     ██║    ██╔██╗ ██║╚██╗██║
 ███████║██╔╝ ██╗███████╗██║   ██╔╝ ██╗██║ ╚████║
 ╚══════╝╚═╝  ╚═╝╚══════╝╚═╝   ╚═╝  ╚═╝╚═╝  ╚═══╝
BANNER
    printf '%s\n' "$SX_RESET"
}

# Log an error and stop the current script.
sx-die() {
    sx-log error "$*"
    exit 1
}
