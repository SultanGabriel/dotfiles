#!/usr/bin/env bash

PID="/tmp/eos-webcam-$UID.pid"
LOG="/tmp/eos-webcam-$UID.log"

start() {
    if [[ -f "$PID" ]] && kill -0 "$(cat "$PID")" 2>/dev/null; then
        echo "Camera already running"
        return
    fi

    [[ -e /dev/video42 ]] || sudo modprobe v4l2loopback \
        video_nr=42 card_label="Canon EOS 200D" exclusive_caps=1

    setsid bash -c '
        gphoto2 --set-config-index /main/settings/output=2 \
            --stdout --capture-movie |
        ffmpeg -loglevel error -f mjpeg -i - \
            -vf "scale=1280:720" \
            -pix_fmt yuv420p -f v4l2 /dev/video42
    ' >"$LOG" 2>&1 </dev/null &

    echo $! > "$PID"
    echo "Camera starting"
}

stop() {
    if [[ -f "$PID" ]]; then
        kill -TERM -- "-$(cat "$PID")" 2>/dev/null
        rm -f "$PID"
    fi
    echo "Camera stopped"
}

case "${1:-toggle}" in
    start) start ;;
    stop) stop ;;
    status)
    if [[ -f "$PID" ]] && kill -0 "$(cat "$PID")" 2>/dev/null; then
        echo "on"
    else
        echo "off"
    fi
    ;;
    toggle)
        if [[ -f "$PID" ]] && kill -0 "$(cat "$PID")" 2>/dev/null; then
            stop
        else
            start
        fi
        ;;
    *) echo "Usage: eos-webcam [start|stop|toggle]" ;;
esac
