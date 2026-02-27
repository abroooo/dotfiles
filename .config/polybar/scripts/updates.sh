#!/bin/bash

# Updates checker script for polybar

if ! command -v checkupdates &> /dev/null; then
    echo "0"
    exit
fi

updates=$(checkupdates 2> /dev/null | wc -l)

if [ "$updates" -gt 0 ]; then
    echo "$updates updates"
else
    echo "Up to date"
fi