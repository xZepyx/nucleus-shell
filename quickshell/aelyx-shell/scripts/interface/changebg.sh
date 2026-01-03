#!/bin/bash

# Wallpaper selector (no color generation)

START_DIR="$HOME/Pictures/Wallpapers"

FILE=$(zenity --file-selection \
    --title="Select Wallpaper" \
    --filename="$START_DIR/" \
    --file-filter="Images/Videos | *.png *.jpg *.jpeg *.webp *.bmp *.svg *.mp4 *.mkv *.webm *.mov *.avi *.m4v"  2>/dev/null)

if [ $? -eq 0 ]; then
    echo "file://$FILE"
else
    echo "null"
fi
