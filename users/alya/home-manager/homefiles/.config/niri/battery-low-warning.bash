#!/usr/bin/env bash

ICON_BATTERY=🪫
ICON_CHARGER=🔌

while true; do
    BAT=$(upower -e | grep BAT)
    battery=$(upower -i "$BAT" | awk '/percentage/ {gsub("%",""); print $2 -1}')
    state=$(upower -i "$BAT" | awk '/state/ {print $2}')
    if [ "$state" = "discharging" ] && [ "$battery" -le 20 ]; then
        notify-send -u critical -t 3000 "$ICON_BATTERY Battery low!" "$battery% remaining"
        sleep 4
    else
        sleep 60
    fi
done
