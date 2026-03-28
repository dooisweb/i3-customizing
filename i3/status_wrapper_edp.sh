#!/bin/bash
EXTERNAL=$(xrandr --query | grep -c 'HDMI-A-0 connected')
if [[ $EXTERNAL -gt 0 ]]; then
    # External connected: eDP shows no status, just empty JSON
    echo '{"version":1}'
    echo '['
    echo '[]'
    while true; do echo ',[]'; sleep 5; done
else
    exec ~/.config/i3/status_wrapper.sh
fi
