#!/usr/bin/env bash

set -euo pipefail

# Temporary directory used for decoded image previews.
TMP_DIR="${XDG_RUNTIME_DIR:-/tmp}/cliphist-rofi"

mkdir -p "$TMP_DIR"


# -------------------------------------------------------------------
# Restore selected clipboard entry
# -------------------------------------------------------------------
#
# In Rofi script mode, the selected row is passed back to this script
# as the first argument. cliphist only needs the leading history ID.

if [[ -n "${1:-}" ]]; then
    cliphist decode <<< "$1" | wl-copy
    exit 0
fi


# -------------------------------------------------------------------
# Generate clipboard entries
# -------------------------------------------------------------------
#
# Fields returned by cliphist:
#   $1 = history ID
#   $2 = format / extension
#   $3 = human-readable preview
#
# Image entries are decoded into temporary files. Rofi receives those
# files through its per-row icon metadata so it can display thumbnails.

cliphist list -fields id,format,preview |
    gawk -F '\t' -v tmp_dir="$TMP_DIR" '
        $3 ~ /^<meta http-equiv=/ {
            next
        }

        $2 != "" {
            path = tmp_dir "/" $1 "." $2

            system("cliphist decode " $1 " > \"" path "\"")

            print $1 "\t" $3 "\0icon\x1f" path
            next
        }

        {
            print $1 "\t" $3
        }
    '