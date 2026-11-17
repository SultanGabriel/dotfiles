#!/usr/bin/env bash
# -----------------------------------------------------------------------------
# sx-lib: env.sh
#
# Helpers for loading .env files and checking required configuration.
# -----------------------------------------------------------------------------

# sx-env [file]
# Loads variables from a .env-style shell file and exports them to child commands.
# Defaults to ./.env.
sx-env() {
    local file="${1:-.env}"

    if [[ ! -f "$file" ]]; then
        sx-log error "Environment file not found: $file"
        return 1
    fi

    set -a
    # shellcheck disable=SC1090
    source "$file"
    set +a
}

# sx-require <command>
# Checks that a command exists in PATH.
sx-require() {
    local command_name="${1:-}"

    if [[ -z "$command_name" ]]; then
        sx-log error "sx-require needs a command name"
        return 1
    fi

    if ! command -v "$command_name" >/dev/null 2>&1; then
        sx-log error "Required command not found: $command_name"
        return 1
    fi
}

# sx-require-var <variable-name>
# Checks that an environment variable exists and is not empty.
sx-require-var() {
    local name="${1:-}"

    if [[ -z "$name" ]]; then
        sx-log error "sx-require-var needs a variable name"
        return 1
    fi

    if [[ -z "${!name:-}" ]]; then
        sx-log error "Required variable is not set: $name"
        return 1
    fi
}
