#!/usr/bin/env bash
# -----------------------------------------------------------------------------
# sx-lib: notify.sh
#
# Send a notification through ntfy.
#
# Required environment variables:
#   NTFY_URL
#   NTFY_TOPIC
#
# Optional:
#   NTFY_TOKEN
#
# Usage:
#   sx-notify "Title" "Body" [priority] [tags]
# -----------------------------------------------------------------------------

sx-notify() {
    local title="${1:-Notification}"
    local body="${2:-No body provided}"
    local priority="${3:-default}"
    local tags="${4:-}"

    sx-require curl || return 1
    sx-require-var NTFY_URL || return 1
    sx-require-var NTFY_TOPIC || return 1

    local args=(
        -fsS
        -X POST
        -H "Title: $title"
        -H "Priority: $priority"
    )

    if [[ -n "$tags" ]]; then
        args+=(-H "Tags: $tags")
    fi

    # Token is optional. Public ntfy topics do not need one.
    if [[ -n "${NTFY_TOKEN:-}" ]]; then
        args+=(-H "Authorization: Bearer $NTFY_TOKEN")
    fi

    curl "${args[@]}" \
        --data-binary "$body" \
        "${NTFY_URL%/}/${NTFY_TOPIC}"
}
