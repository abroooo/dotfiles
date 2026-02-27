#!/bin/bash

# Spotify status script for polybar

player_status=$(playerctl --player=spotify status 2> /dev/null)

if [ "$player_status" = "Playing" ]; then
    artist=$(playerctl --player=spotify metadata artist)
    title=$(playerctl --player=spotify metadata title)
    
    # Truncate long titles
    if [ ${#title} -gt 30 ]; then
        title="${title:0:27}..."
    fi
    
    echo "$artist - $title"
elif [ "$player_status" = "Paused" ]; then
    echo " Paused"
else
    echo ""
fi