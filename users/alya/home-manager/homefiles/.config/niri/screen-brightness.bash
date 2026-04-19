#!/usr/bin/env bash

ACTION="$*"
cd /home/alya/.config/niri || exit 1

CURRENT=$(brightnessctl g)
MAX=$(brightnessctl m)

# 5% steps → 20 steps total
STEPS=()
for i in {0..20}; do
    STEPS+=( $(( MAX * i / 20 )) )
done

# Find closest step
closest_index=0
smallest_diff=$MAX

for i in "${!STEPS[@]}"; do
    diff=$(( CURRENT - STEPS[i] ))
    diff=${diff#-}
    if (( diff < smallest_diff )); then
        smallest_diff=$diff
        closest_index=$i
    fi
done

# Adjust index
if [[ "$ACTION" == "increase" ]]; then
    ((closest_index++))
else
    ((closest_index--))
fi

# Clamp
(( closest_index < 0 )) && closest_index=0
(( closest_index >= ${#STEPS[@]} )) && closest_index=$((${#STEPS[@]} - 1))

# Set brightness (RAW!)
brightnessctl s "${STEPS[closest_index]}" -r

# Notify
CURRENT=$(brightnessctl g)
MAX=$(brightnessctl m)
CURRENT_PCT=$(echo "scale=0; ($CURRENT*100 + $MAX/2)/$MAX" | bc)

ICON=""
./qs-notification.bash "$ICON Brightness set to ${CURRENT_PCT}%"

