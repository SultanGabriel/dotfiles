#!/bin/bash

xrandr --output DP-5 --mode 1920x1080 --auto --primary
xrandr --output DP-2 --mode 1920x1080 --auto --left-of DP-5 --noprimary
xrandr --output HDMI-0 --mode 1920x1080 --right-of DP-5 --noprimary


