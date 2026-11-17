#!/usr/bin/env bash
# Ultra-simple helper for ONE specific SMB share.
# Edit these variables and forget the long mount command.

SERVER="u493707.your-storagebox.de"      # Host or IP
SHARE="backup"               # Share name ONLY (no leading slashes)
USER="u493707"               # SMB username
PASS="SkatingBananas?1011"     # Plaintext password (optional: export SMB_PASS instead)
MOUNT_POINT="/mnt/htz" # Where to mount locally
VERS="3.1.1"               # SMB protocol version to try (fallbacks: 3.0, 2.1)
EXTRA_OPTS="iocharset=utf8"  # Add more comma-separated opts if needed

# If you prefer not to hardcode PASS, comment PASS above and: export SMB_PASS='...'; ./smb.sh mount

set -e

cmd="${1:-mount}"

mount_share() {
  [[ -d "$MOUNT_POINT" ]] || sudo mkdir -p "$MOUNT_POINT"

  if mountpoint -q "$MOUNT_POINT"; then
    echo "[INFO] Already mounted at $MOUNT_POINT"
    return 0
  fi

  # Use env var if set
  local pw="${SMB_PASS:-$PASS}"

  if [[ -z "$pw" ]]; then
    echo "Password not set. Set PASS in script or export SMB_PASS." >&2
    exit 1
  fi

  echo "[INFO] Mounting //$SERVER/$SHARE -> $MOUNT_POINT"
  sudo mount -t cifs "//$SERVER/$SHARE" "$MOUNT_POINT" \
    -o "username=${SMB_USER:-$USER},password=$pw,vers=${VERS:-3.0},${EXTRA_OPTS},uid=0,gid=0,file_mode=0666,dir_mode=0777,noperm,nounix" || {
      echo "[ERROR] Mount failed."
      exit 1
    }

  # echo "[INFO] Mounting //$SERVER/$SHARE -> $MOUNT_POINT"
  # sudo mount -t cifs "//$SERVER/$SHARE" "$MOUNT_POINT" \
  #   -o "username=$USER,password=$pw,vers=$VERS,$EXTRA_OPTS,uid=$(id -u),gid=$(id -g)" || {
  #     echo "[ERROR] Mount failed."
  #     exit 1
  #   }
  echo "[OK] Mounted."
}

umount_share() {
  if ! mountpoint -q "$MOUNT_POINT"; then
    echo "[INFO] $MOUNT_POINT is not mounted."
    return 0
  fi
  echo "[INFO] Unmounting $MOUNT_POINT"
  sudo umount "$MOUNT_POINT" && echo "[OK] Unmounted."
}

status() {
  if mountpoint -q "$MOUNT_POINT"; then
    echo "[STATUS] Mounted: //$SERVER/$SHARE -> $MOUNT_POINT"
  else
    echo "[STATUS] Not mounted."
  fi
}

case "$cmd" in
  mount)  mount_share ;;
  umount|unmount) umount_share ;;
  status) status ;;
  *) echo "Usage: $0 [mount|umount|status] (default: mount)"; exit 1 ;;
esac
