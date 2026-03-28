#!/bin/bash

HDMI="HDMI-A-0"
DP="DisplayPort-0"
EDP="eDP"

hdmi=$(xrandr | grep "^$HDMI connected")
dp=$(xrandr | grep "^$DP connected")

if [[ -n "$hdmi" && -n "$dp" ]]; then
    # All three monitors
    xrandr --output $EDP --auto --pos 0x0 \
           --output $HDMI --mode 2560x1440 --rate 143.99 --right-of $EDP --primary \
           --output $DP --mode 1920x1080 --rate 100 --right-of $HDMI

elif [[ -n "$hdmi" ]]; then
    # Laptop + HDMI only
    xrandr --output $EDP --auto \
           --output $HDMI --mode 2560x1440 --rate 143.99 --right-of $EDP --primary \
           --output $DP --off

elif [[ -n "$dp" ]]; then
    # Laptop + DP only
    xrandr --output $EDP --auto \
           --output $DP --mode 1920x1080 --rate 100 --right-of $EDP --primary \
           --output $HDMI --off

else
    # Laptop only
    xrandr --output $EDP --auto --primary \
           --output $HDMI --off \
           --output $DP --off
fi
