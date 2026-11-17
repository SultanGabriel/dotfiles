#!/usr/bin/env bash

# -----------------------------------------------------------------------------
# notify
#
# Small reusable wrapper for sending notifications through ntfy.
#
# Usage:
#   notify "Title" "Body" [priority] [tags]
#
# Example:
#   notify \
#       "Backup failed" \
#       "PostgreSQL backup on srv01 returned exit code 1." \
#       high \
#       warning
#
# Configuration is loaded from:
#   /etc/ntfy-notify.env
#
# Required:
#   NTFY_URL
#   NTFY_TOPIC
#
# Optional:
#   NTFY_TOKEN
# -----------------------------------------------------------------------------

set -euo pipefail

ENV_FILE="${NTFY_ENV_FILE:-/etc/ntfy-notify.env}"

if [[ ! -f "$ENV_FILE" ]]; then
    echo "notify: config file not found: $ENV_FILE" >&2
    exit 1
fi

# Load ntfy configuration.
set -a
source "$ENV_FILE"
set +a

TITLE="${1:-Notification}"
BODY="${2:-No body provided}"
PRIORITY="${3:-default}"
TAGS="${4:-}"

if [[ -z "${NTFY_URL:-}" ]]; then
    echo "notify: NTFY_URL is required" >&2
    exit 1
fi

if [[ -z "${NTFY_TOPIC:-}" ]]; then
    echo "notify: NTFY_TOPIC is required" >&2
    exit 1
fi

args=(
    -fsS
    -X POST
    -H "Title: $TITLE"
    -H "Priority: $PRIORITY"
)

if [[ -n "$TAGS" ]]; then
    args+=(
        -H "Tags: $TAGS"
    )
fi

if [[ -n "${NTFY_TOKEN:-}" ]]; then
    args+=(
        -H "Authorization: Bearer $NTFY_TOKEN"
    )
fi

curl "${args[@]}" \
    --data-binary "$BODY" \
    "${NTFY_URL%/}/${NTFY_TOPIC}"
