#!/bin/bash

# Weather script for polybar
# You'll need to get an API key from openweathermap.org

API_KEY=""  # Add your API key here
CITY="Tokyo"  # Change to your city
UNITS="metric"  # metric for Celsius, imperial for Fahrenheit

if [ -z "$API_KEY" ]; then
    echo "No API key"
    exit
fi

# weather=$(curl -sf "http://api.openweathermap.org/data/2.5/weather?q=$CITY&appid=$API_KEY&units=$UNITS")

if [ -z "$weather" ]; then
    echo "No connection"
    exit
fi

temp=$(echo "$weather" | jq -r ".main.temp" | cut -d "." -f 1)
desc=$(echo "$weather" | jq -r ".weather[0].description" | sed 's/.*/\L&/; s/[a-z]*/\u&/g')

echo "$temp°C $desc"
