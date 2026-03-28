#!/bin/bash
BAR_OUTPUT="${I3_BAR_OUTPUT:-}"
EXTERNAL=$(xrandr --query | grep -c 'HDMI-A-0 connected')
get_bar() {
    local pct=$1
    local width=10
    local filled=$(( pct * width / 100 ))
    local empty=$(( width - filled ))
    local bar=""
    for ((i=0; i<filled; i++)); do bar+="▓"; done
    for ((i=0; i<empty; i++)); do bar+="░"; done
    echo "$bar"
}
get_battery_icon() {
    local pct=$1
    local status=$2
    if [[ $status == *"CHR"* ]]; then
        echo "[+]"
    elif (( pct > 80 )); then
        echo "█"
    elif (( pct > 60 )); then
        echo "▇"
    elif (( pct > 40 )); then
        echo "▅"
    elif (( pct > 20 )); then
        echo "▃"
    else
        echo "▁"
    fi
}
S=15
i3status -c ~/.config/i3status/config | while IFS= read -r line; do
    if [[ $line == '{"version":'* ]]; then
        echo "$line"
    elif [[ $line == '[' ]]; then
        echo "$line"
    else
        cpu_temp=$(($(cat /sys/class/thermal/thermal_zone0/temp) / 1000))
        vol=$(pactl get-sink-volume @DEFAULT_SINK@ 2>/dev/null | grep -oP '[0-9]+%' | head -1)
        mute=$(pactl get-sink-mute @DEFAULT_SINK@ 2>/dev/null)
        [[ $mute == *"yes"* ]] && vol="muted"
        # Update weather every 10 min
        if [[ ! -f /tmp/weather.txt ]] || [[ $(( $(date +%s) - $(stat -c %Y /tmp/weather.txt) )) -gt 600 ]]; then
            ~/.config/i3/weather.sh &
        fi
        weather=$(cat /tmp/weather.txt 2>/dev/null || echo "...")
        br_time=$(TZ="America/Sao_Paulo" date +"%H:%M")
        nl_time=$(TZ="Europe/Amsterdam" date +"%H:%M")
        full_date=$(date +"%d-%m-%Y")
        cpu_pct=$(echo "$line" | grep -oP '"name":"cpu_usage"[^}]*"full_text":"CPU: *-?\K[0-9]+')
        cpu_pct=${cpu_pct:-0}
        [[ $cpu_pct -gt 100 ]] && cpu_pct=100
        cpu_bar=$(get_bar "$cpu_pct")
        ram_available=$(awk '/MemAvailable/{print $2}' /proc/meminfo)
        ram_total_kb=$(awk '/MemTotal/{print $2}' /proc/meminfo)
        ram_used_kb=$(( ram_total_kb - ram_available ))
        ram_pct=$(( ram_used_kb * 100 / ram_total_kb ))
        ram_bar=$(get_bar "${ram_pct:-0}")
        bat_text=$(echo "$line" | grep -oP '"name":"battery"[^}]*"full_text":"\K[^"]+')
        bat_status=$(echo "$bat_text" | awk '{print $1}')
        bat_pct=$(echo "$bat_text" | grep -oP '[0-9.]+' | head -1 | cut -d. -f1)
        bat_icon=$(get_battery_icon "${bat_pct:-0}" "$bat_status")
        prefix=""
        if [[ $line == ',['* ]]; then
            prefix=","
        fi
        echo "${prefix}[{\"full_text\":\"<b>V</b> ${vol}\",\"markup\":\"pango\",\"separator_block_width\":${S}},{\"full_text\":\"<b>CPU</b> ${cpu_temp}°\",\"markup\":\"pango\",\"separator_block_width\":${S}},{\"full_text\":\"${cpu_bar}\",\"separator_block_width\":${S}},{\"full_text\":\"RAM ${ram_bar}\",\"separator_block_width\":${S}},{\"full_text\":\"${bat_icon} ${bat_pct}%\",\"color\":\"#FFFFFF\",\"separator_block_width\":${S}},{\"full_text\":\"<b>T</b> ${weather}\",\"markup\":\"pango\",\"separator_block_width\":${S}},{\"full_text\":\"${full_date}\",\"separator_block_width\":${S}},{\"full_text\":\"<b>BR</b> ${br_time}\",\"markup\":\"pango\",\"separator_block_width\":${S}},{\"full_text\":\"<b>NL</b> ${nl_time}\",\"markup\":\"pango\"}]"
    fi
done
