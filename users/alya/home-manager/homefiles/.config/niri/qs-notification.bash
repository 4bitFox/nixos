#!/usr/bin/env bash

TITLE="$1"
MESSAGE="$2"



IDFILE="/tmp/niri_qs-notification_id"
id=$(cat "$IDFILE")
if [[  $id == "" ]]; then
    id=0
fi


NEWID=$(notify-send -p -t 3000 --replace-id "$id" "$TITLE" "$MESSAGE")
echo "$NEWID" > "$IDFILE"
