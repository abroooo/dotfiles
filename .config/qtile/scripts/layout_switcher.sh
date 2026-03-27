#!/bin/bash

# Qtile Layout Switcher with Rofi
# Beautiful layout selection with descriptions

# Define layouts with descriptions
declare -A layouts=(
    ["max"]="🖥️  Max - Fullscreen single window"
    ["monadtall"]="📱 MonadTall - Master and stack vertical"
    ["monadwide"]="📺 MonadWide - Master and stack horizontal" 
    ["ratiotile"]="🔲 RatioTile - Automatic tiling with ratios"
    ["stack"]="📚 Stack - Multiple stacks side by side"
    ["bsp"]="🌳 BSP - Binary space partitioning"
    ["columns"]="📊 Columns - Dynamic columns layout"
    ["matrix"]="⬜ Matrix - Grid-based window arrangement"
    ["floating"]="🎈 Floating - Free-form window placement"
)

# Create the rofi menu
layout_list=""
for layout in "${!layouts[@]}"; do
    layout_list+="${layouts[$layout]}\n"
done

# Show rofi menu and get selection
selected=$(echo -e "$layout_list" | rofi \
    -dmenu \
    -i \
    -p "🏗️ Select Layout" \
    -theme-str 'window {width: 500px;}' \
    -theme-str 'listview {lines: 9;}' \
    -theme-str 'element-text {horizontal-align: 0;}' \
    -no-custom)

# Exit if nothing selected
if [ -z "$selected" ]; then
    exit 0
fi

# Extract layout name from selection
layout_name=""
for layout in "${!layouts[@]}"; do
    if [[ "$selected" == "${layouts[$layout]}" ]]; then
        layout_name="$layout"
        break
    fi
done

# Switch to the selected layout using qtile command
if [ -n "$layout_name" ]; then
    qtile cmd-obj -o cmd -f to_layout_index -a $(python3 -c "
import sys
sys.path.append('/home/alex/dotfiles/.config/qtile')
import config
layouts = [str(l).split('.')[-1].split('(')[0].lower() for l in config.layouts]
try:
    print(layouts.index('$layout_name'))
except ValueError:
    print(0)
")
    
    # Show notification of layout change
    notify-send "🏗️ Layout Changed" "Switched to: $selected" -t 2000 -i preferences-desktop
fi