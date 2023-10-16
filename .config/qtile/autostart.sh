#!/bin/sh
#   ___ _____ ___ _     _____   ____  _             _    
#  / _ \_   _|_ _| |   | ____| / ___|| |_ __ _ _ __| |_  
# | | | || |  | || |   |  _|   \___ \| __/ _` | '__| __| 
# | |_| || |  | || |___| |___   ___) | || (_| | |  | |_  
#  \__\_\|_| |___|_____|_____| |____/ \__\__,_|_|   \__| 
#                                                        
#  
# by Stephan Raabe (2023) 
# ----------------------------------------------------- 

# My screen resolution
# xrandr --rate 120
~/.config/scripts/xrandr_setup.sh &

# For Virtual Machine 
# xrandr --outout Virtual-1 --mode 1920x1080

# Set keyboard mapping
setxkbmap eu
# setxkbmap en

# Load picom
# picom &
picom --backend glx &

# Load power manager
xfce4-power-manager &

# Load notification service
dunst &

# Launch polybar
~/.config/polybar/launch.sh &

# Setup Wallpaper and update colors
~/.config/scripts/updatewal.sh &

# Load Windows 11 VM
# virsh --connect qemu:///system start win11
