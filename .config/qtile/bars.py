#==========================================================================
# EPIC QTILE STATUS BAR
# The most beautiful and functional status bar ever created
#==========================================================================

from libqtile import bar
from libqtile.lazy import lazy
from qtile_extras import widget
from qtile_extras.widget.decorations import RectDecoration, PowerLineDecoration
from qtile_extras.widget import modify

from colors import colors
from keybinds import defaultApps
from functions import powerMenu, brightnessControl

#==========================================================================
# MODERN WIDGET STYLING
#==========================================================================

widget_defaults = {
    "font": "JetBrainsMono Nerd Font",
    "fontsize": 11,
    "padding": 8,
    "background": colors[-1],  # transparent
    "foreground": colors[1],
}

# Powerline decorations for modern look
powerline_left = {
    "decorations": [
        PowerLineDecoration(path="arrow_left")
    ]
}

powerline_right = {
    "decorations": [
        PowerLineDecoration(path="arrow_right")
    ]
}

# Rounded rect decorations
rounded_decoration = {
    "decorations": [
        RectDecoration(
            use_widget_background=True,
            radius=8,
            filled=True,
            padding_y=2,
            group=True
        )
    ]
}

# Special styling for different widget types
primary_widget = {
    "background": colors[2],  # Primary blue
    "foreground": colors[0],  # Dark background for contrast
    "padding": 12,
    **rounded_decoration
}

accent_widget = {
    "background": colors[4],  # Accent red
    "foreground": colors[1],  # Light foreground
    "padding": 10,
    **rounded_decoration
}

success_widget = {
    "background": colors[5],  # Success green
    "foreground": colors[0],  # Dark background for contrast
    "padding": 10,
    **rounded_decoration
}

warning_widget = {
    "background": colors[6],  # Warning yellow
    "foreground": colors[0],  # Dark background for contrast
    "padding": 10,
    **rounded_decoration
}

secondary_widget = {
    "background": colors[7],  # Secondary purple
    "foreground": colors[1],  # Light foreground
    "padding": 10,
    **rounded_decoration
}

tertiary_widget = {
    "background": colors[8],  # Tertiary cyan
    "foreground": colors[0],  # Dark background for contrast
    "padding": 10,
    **rounded_decoration
}

glass_widget = {
    "background": colors[0] + "66",  # Semi-transparent background
    "foreground": colors[1],
    "padding": 10,
    **rounded_decoration
}

#==========================================================================
# BAR CONFIGURATION
#==========================================================================

bar_config = {
    "size": 28,
    "margin": [6, 8, 2, 8],
    "border_width": [0, 0, 0, 0],
    "border_color": colors[-1],
    "background": colors[-1],  # Fully transparent
    "opacity": 1.0,
}

#==========================================================================
# AMAZING WIDGET SECTIONS
#==========================================================================

# Left section - System controls and info
left_widgets = [
    # Power menu button
    widget.TextBox(
        text="",
        font="Font Awesome 6 Free Solid",
        fontsize=16,
        mouse_callbacks={"Button1": lazy.function(powerMenu)},
        **accent_widget,
    ),
    
    widget.Spacer(length=8),
    
    # Current layout indicator
    widget.CurrentLayoutIcon(
        scale=0.7,
        **glass_widget,
    ),
    
    widget.Spacer(length=8),
    
    # Date widget with calendar icon
    modify(
        widget.TextBox,
        text="",
        font="Font Awesome 6 Free Solid",
        fontsize=14,
        mouse_callbacks={"Button1": lazy.spawn(defaultApps["calendar"])},
        **tertiary_widget,
    ),
    
    widget.Clock(
        format="%a %b %d",
        font="JetBrainsMono Nerd Font Medium",
        mouse_callbacks={"Button1": lazy.spawn(defaultApps["calendar"])},
        **tertiary_widget,
    ),
    
    widget.Spacer(length=8),
    
    # System monitoring section
    modify(
        widget.TextBox,
        text="",
        font="Font Awesome 6 Free Solid",
        fontsize=14,
        **warning_widget,
    ),
    
    widget.CPU(
        format='{load_percent}%',
        update_interval=2.0,
        mouse_callbacks={"Button1": lazy.spawn("htop")},
        **warning_widget,
    ),
    
    widget.Spacer(length=4),
    
    modify(
        widget.TextBox,
        text="",
        font="Font Awesome 6 Free Solid",
        fontsize=14,
        **secondary_widget,
    ),
    
    widget.Memory(
        format='{MemPercent}%',
        update_interval=2.0,
        measure_mem='G',
        mouse_callbacks={"Button1": lazy.spawn("htop")},
        **secondary_widget,
    ),
    
    widget.Spacer(length=8),
    
    # Disk usage
    modify(
        widget.TextBox,
        text="",
        font="Font Awesome 6 Free Solid",
        fontsize=14,
        **success_widget,
    ),
    
    widget.DF(
        update_interval=60,
        mouse_callbacks={"Button1": lazy.spawn("thunar")},
        visible_on_warn=False,
        format='{uf}{m}B',
        **success_widget,
    ),
    
    widget.Spacer(length=8),
]

# Center section widgets for main screen
main_center_widgets = [
    # Updates checker
    widget.CheckUpdates(
        font='Font Awesome 6 Free Solid',
        distro='Arch_checkupdates',
        display_format=' {updates}',
        no_update_string='',
        colour_have_updates=colors[4],
        colour_no_updates=colors[5],
        update_interval=300,
        mouse_callbacks={"Button1": lazy.spawn(defaultApps["terminal"] + ' --hold --title "Available updates" checkupdates')},
        **glass_widget,
    ),
    
    widget.Spacer(length=8),
    
    # Window name with truncation
    widget.WindowName(
        format="{name}",
        max_chars=50,
        scroll=True,
        scroll_repeat=True,
        scroll_interval=0.1,
        scroll_step=1,
        width=300,
        **glass_widget,
    ),
    
    widget.Spacer(length=bar.STRETCH),
    
    # Stunning group box
    widget.GroupBox(
        font="JetBrainsMono Nerd Font Bold",
        fontsize=14,
        spacing=8,
        padding_x=8,
        padding_y=6,
        margin_x=4,
        margin_y=2,
        borderwidth=2,
        disable_drag=True,
        
        # Colors for different states
        inactive=colors[3],
        active=colors[1],
        other_current_screen_border=colors[7],
        other_screen_border=colors[3],
        this_current_screen_border=colors[2],
        this_screen_border=colors[2],
        block_highlight_text_color=colors[0],
        
        # Styling
        highlight_method='block',
        rounded=True,
        use_mouse_wheel=True,
        visible_groups=["1", "2", "3", "4", "5", "6", "7", "8", "9"],
        
        **{
            "background": colors[2] + "33",
            "decorations": [
                RectDecoration(
                    use_widget_background=True,
                    radius=12,
                    filled=True,
                    padding_y=4,
                    padding_x=4,
                )
            ]
        }
    ),
    
    widget.Spacer(length=bar.STRETCH),
    
    # System tray
    widget.Systray(
        icon_size=18,
        background=colors[0] + "66",
        decorations=[
            RectDecoration(
                use_widget_background=True,
                radius=8,
                filled=True,
                padding_y=2,
                group=True
            )
        ]
    ),
    
    widget.Spacer(length=8),
]

# Center section for secondary screen
secondary_center_widgets = [
    widget.CheckUpdates(
        font='Font Awesome 6 Free Solid',
        distro='Arch_checkupdates',
        display_format=' {updates}',
        no_update_string='',
        colour_have_updates=colors[4],
        colour_no_updates=colors[5],
        update_interval=300,
        mouse_callbacks={"Button1": lazy.spawn(defaultApps["terminal"] + ' --hold --title "Available updates" checkupdates')},
        **glass_widget,
    ),
    
    widget.Spacer(length=8),
    
    widget.WindowName(
        format="{name}",
        max_chars=50,
        scroll=True,
        **glass_widget,
    ),
    
    widget.Spacer(length=bar.STRETCH),
    
    widget.GroupBox(
        font="JetBrainsMono Nerd Font Bold",
        fontsize=14,
        spacing=8,
        padding_x=8,
        padding_y=6,
        margin_x=4,
        margin_y=2,
        borderwidth=2,
        disable_drag=True,
        
        inactive=colors[3],
        active=colors[1],
        other_current_screen_border=colors[7],
        other_screen_border=colors[3],
        this_current_screen_border=colors[2],
        this_screen_border=colors[2],
        block_highlight_text_color=colors[0],
        
        highlight_method='block',
        rounded=True,
        use_mouse_wheel=True,
        visible_groups=["6", "7", "8", "9", "0"],
        
        **{
            "background": colors[2] + "33",
            "decorations": [
                RectDecoration(
                    use_widget_background=True,
                    radius=12,
                    filled=True,
                    padding_y=4,
                    padding_x=4,
                )
            ]
        }
    ),
    
    widget.Spacer(length=bar.STRETCH),
]

# Right section - Audio, network, battery, time
right_widgets = [
    # Volume control
    modify(
        widget.TextBox,
        text="",
        font="Font Awesome 6 Free Solid",
        fontsize=14,
        mouse_callbacks={"Button1": lazy.spawn(defaultApps["sound"])},
        **primary_widget,
    ),
    
    widget.Volume(
        update_interval=0.2,
        volume_app=defaultApps["sound"],
        mouse_callbacks={"Button3": lazy.spawn(defaultApps["sound"])},
        **primary_widget,
    ),
    
    widget.Spacer(length=4),
    
    # Bluetooth with enhanced styling
    widget.Bluetooth(
        font="Font Awesome 6 Free Solid",
        mouse_callbacks={"Button1": lazy.spawn(defaultApps["bluetooth"])},
        default_text="",
        default_show_battery=True,
        device_format='{name} {battery_level}%',
        **secondary_widget,
    ),
    
    widget.Spacer(length=4),
    
    # Network status
    widget.Wlan(
        interface='wlan0',
        format=' {essid} {percent:2.0%}',
        disconnected_message=' Disconnected',
        ethernet_message_format=' Wired',
        use_ethernet=True,
        mouse_callbacks={"Button1": lazy.spawn(defaultApps["network"])},
        **tertiary_widget,
    ),
    
    widget.Spacer(length=4),
    
    # Battery with multiple states
    widget.Battery(
        charge_char='',
        discharge_char='',
        empty_char='',
        full_char='',
        unknown_char='',
        format='{char} {percent:2.0%}',
        font="Font Awesome 6 Free Solid",
        fontsize=14,
        show_short_text=False,
        mouse_callbacks={"Button1": lazy.function(brightnessControl)},
        low_percentage=0.2,
        low_foreground=colors[4],
        **success_widget,
    ),
    
    widget.Spacer(length=8),
    
    # Time with icon
    modify(
        widget.TextBox,
        text="",
        font="Font Awesome 6 Free Solid",
        fontsize=14,
        **accent_widget,
    ),
    
    widget.Clock(
        format="%H:%M",
        font="JetBrainsMono Nerd Font Bold",
        fontsize=13,
        **accent_widget,
    ),
]

#==========================================================================
# BAR ASSEMBLY
#==========================================================================

# Main bar for primary screen
mainBar = bar.Bar(
    left_widgets + main_center_widgets + right_widgets,
    **bar_config
)

# Secondary bar for additional screens
secondBar = bar.Bar(
    left_widgets + secondary_center_widgets + right_widgets,
    **bar_config
)