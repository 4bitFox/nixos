#!/usr/bin/env bash

ACTION="$*"

cd /home/alya/.config/niri

if [[ "$ACTION" == "raise" ]]; then
    wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.05+
else
    wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.05-
fi


volume=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print $2}')
volume_pct=$(echo "$volume * 100" | bc | cut -d'.' -f1)%

if [[ "$volume" == "0.00" ]]; then
    ICON="×"
elif (( $(echo "$volume <= 0.3" | bc -l) )); then
    ICON=" "
elif (( $(echo "$volume <= 0.65" | bc -l) )); then
    ICON=" "
else
   ICON=" "
fi

./qs-notification.bash "$ICON Volume set to $volume_pct"

