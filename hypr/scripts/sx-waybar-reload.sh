#!/usr/bin/env bash

set -u

pkill waybar 2>/dev/null || true
sleep 0.15

nohup waybar >/dev/null 2>&1 &
disown