#!/bin/bash
temp=$(curl -s --max-time 5 "wttr.in/Eindhoven?format=%t" 2>/dev/null | tr -d 'C+' | sed 's/[[:space:]]//g')
[ -n "$temp" ] && echo "$temp" > /tmp/weather.txt
