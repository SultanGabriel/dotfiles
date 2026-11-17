#!/usr/bin/env bash
# -----------------------------------------------------------------------------
# sx-lib: files.sh
#
# Small filesystem helpers used by job/watcher scripts.
# -----------------------------------------------------------------------------

# sx-ensure-dir <directory>
# Creates a directory if it does not already exist.
sx-ensure-dir() {
    local dir="${1:-}"

    if [[ -z "$dir" ]]; then
        sx-log error "Usage: sx-ensure-dir <directory>"
        return 1
    fi

    mkdir -p "$dir"
}

# sx-file-wait <file> [seconds]
# Waits until one file exists.
sx-file-wait() {
    local file="${1:-}"
    local delay="${2:-5}"

    if [[ -z "$file" ]]; then
        sx-log error "Usage: sx-file-wait <file> [seconds]"
        return 1
    fi

    while [[ ! -f "$file" ]]; do
        sleep "$delay"
    done
}

# sx-files-wait <seconds> <file> [file...]
# Waits until every supplied file exists.
sx-files-wait() {
    local delay="${1:-5}"
    shift || true

    if (( $# == 0 )); then
        sx-log error "Usage: sx-files-wait <seconds> <file> [file...]"
        return 1
    fi

    while true; do
        local missing=0
        local file

        for file in "$@"; do
            if [[ ! -f "$file" ]]; then
                missing=1
                break
            fi
        done

        (( missing == 0 )) && return 0
        sleep "$delay"
    done
}
