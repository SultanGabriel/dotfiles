#!/usr/bin/env bash
# -----------------------------------------------------------------------------
# sx-lib: init.sh
#
# Main entry point for sx-lib.
# Source this file once and it loads the rest of the library.
#
# Example:
#   source "./lib/init.sh"
# -----------------------------------------------------------------------------

# Simple library version. Keep this in sync with the VERSION file in the repo.
SX_LIB_VERSION="0.1.0"

# Find this library directory, no matter where the calling script is run from.
SX_LIB_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Load modules explicitly so the order is obvious and predictable.
source "$SX_LIB_DIR/log.sh"
source "$SX_LIB_DIR/env.sh"
source "$SX_LIB_DIR/notify.sh"
source "$SX_LIB_DIR/files.sh"
