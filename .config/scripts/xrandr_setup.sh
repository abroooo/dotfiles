#!/bin/bash

# just setup my monitor
# Fix overscan issue with:
# --set "underscan hborder" 70 --set "underscan vborder" 50

xrandr --fb 7280x1440 \
    --output DVI-D-1 --pos 0x0 --mode 1920x1200 \
    --output HDMI-2 --pos 1920x0 --auto --primary \
    --output HDMI-1 --pos 5360x0 --mode 1920x1080 --set underscan on
