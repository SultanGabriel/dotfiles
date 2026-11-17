#!/bin/sh
# Deschide OpenClaw in Chromium cu profil persistent separat.
set -eu

source "$HOME/scripts/sx_lib/init.sh"

URL="https://oc.sxltxn.de"
PROFILE_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/openclaw-chromium-profile"

sx-ensure-dir "$HOME/.local/share/openclaw-chromium-profile"

# Poți suprascrie binarul, de exemplu: BROWSER=chromium openclaw-web.sh
BROWSER="${BROWSER:-chromium}"
exec "$BROWSER" \
  --user-data-dir="$PROFILE_DIR" \
  --new-window \
  "$URL"

