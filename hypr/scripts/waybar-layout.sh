#!/usr/bin/env bash

set -euo pipefail

# Waybar supplies the monitor on which this instance of the custom
# module is running.
OUTPUT="${WAYBAR_OUTPUT_NAME:-}"

if [[ -z "$OUTPUT" ]]; then
    printf 'UNKNOWN\n'
    exit 0
fi

# Resolve the workspace currently displayed on this monitor.
WORKSPACE="$(
    hyprctl monitors -j |
        jq -r --arg output "$OUTPUT" '
            .[]
            | select(.name == $output)
            | .activeWorkspace.id
        '
)"

if [[ -z "$WORKSPACE" || "$WORKSPACE" == "null" ]]; then
    printf 'UNKNOWN\n'
    exit 0
fi

# Read the tiling engine assigned to that workspace.
LAYOUT="$(
    hyprctl workspaces -j |
        jq -r --argjson workspace "$WORKSPACE" '
            .[]
            | select(.id == $workspace)
            | .tiledLayout
        '
)"

if [[ -z "$LAYOUT" || "$LAYOUT" == "null" ]]; then
    printf 'UNKNOWN\n'
    exit 0
fi

printf '%s\n' "${LAYOUT^^}"