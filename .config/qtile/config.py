from libqtile import layout
from libqtile.config import Match, Screen

from bars import widget_defaults, mainBar, secondBar
from colors import colors
from keybinds import *
from functions import *
from libqtile import qtile
from typing import List  
from libqtile import bar, layout, widget
from libqtile.config import Click, Drag, Group, Key, Match, Screen, ScratchPad, DropDown, KeyChord
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal
from libqtile.widget import Spacer, Backlight
from libqtile.widget.image import Image
from libqtile.dgroups import simple_key_binder
from pathlib import Path


#----------------------------------------------------------------------------
# Layout settings
#----------------------------------------------------------------------------
    
# layoutTheme = {
#     "border_focus": colors[2], 
#     "border_normal": colors[0], 
#     "border_width": 3, 
#     "margin": 3
# }

layout_theme = { 
    "border_width": 2,
    "margin": 12,
    "border_focus": colors[2],  # Primary blue from color scheme
    "border_normal": colors[3],  # Muted gray from color scheme
    "single_border_width": 2,
    "border_focus_stack": colors[4],  # Accent color for stack focus
    "border_normal_stack": colors[3],
}

# --------------------------------------------------------
# Layouts
# --------------------------------------------------------

layouts = [
    layout.Max(**layout_theme),
    layout.MonadTall(
        ratio=0.6,
        max_ratio=0.85,
        min_ratio=0.15,
        change_ratio=0.05,
        **layout_theme
    ),
    layout.MonadWide(
        ratio=0.65,
        max_ratio=0.85,
        min_ratio=0.15,
        change_ratio=0.05,
        **layout_theme
    ),
    layout.RatioTile(**layout_theme),
    layout.Stack(
        num_stacks=2,
        **layout_theme
    ),
    layout.Bsp(
        fair=False,
        grow_amount=10,
        **layout_theme
    ),
    layout.Columns(
        border_on_single=True,
        split=False,
        **{k: v for k, v in layout_theme.items() if not k.startswith('border_focus_stack') and not k.startswith('border_normal_stack')}
    ),
    layout.Matrix(
        columns=2,
        **layout_theme
    ),
    layout.Floating(
        float_rules=[
            *layout.Floating.default_float_rules,
            Match(wm_class="confirmreset"),
            Match(wm_class="makebranch"),
            Match(wm_class="maketag"),
            Match(wm_class="ssh-askpass"),
            Match(title="branchdialog"),
            Match(title="pinentry"),
            Match(wm_class="pavucontrol"),
            Match(wm_class="nm-connection-editor"),
            Match(wm_class="blueman-manager"),
            Match(wm_class="gnome-disks"),
            Match(wm_class="qalculate-gtk"),
            Match(wm_class="rofi"),
            Match(wm_class="flameshot"),
        ],
        **layout_theme
    )
]

group_layouts = ["monadtall", "monadtall", "monadtall", "monadtall", "monadtall", "monadtall", "monadtall", "monadtall", "monadtall"]
# layouts = [
#     layout.Columns(**layoutTheme),
# ]


# floating_layout = layout.Floating(
#     float_rules=[
#         *layout.Floating.default_float_rules,
#         Match(wm_class = "confirmreset"),  # gitk
#         Match(wm_class = "makebranch"),  # gitk
#         Match(wm_class = "maketag"),  # gitk
#         Match(wm_class = "ssh-askpass"),  # ssh-askpass
#         Match(title = "branchdialog"),  # gitk
#         Match(title = "pinentry"),  # GPG key password entry
#
#         # System control
#         Match(wm_class = "pavucontrol"),
#         Match(wm_class = "nm-connection-editor"),
#         # Match(wm_class = "blueman-manager"),
#         Match(wm_class = "gnome-disks"),
#
#         # Games
#         Match(wm_class = "amazon games ui.exe"),
#         Match(wm_class = "steam"),
#         Match(wm_class = "lutris"),
#         Match(wm_class = "epicgameslauncher.exe"),
#         Match(wm_class = "prismlauncher"),
#         Match(wm_class = "leagueclientux.exe"),
#         
#         # Communication
#         Match(wm_class = "telegram-desktop"),
#         Match(wm_class = "whatsdesk"),
#         Match(wm_class = "caprine"),
#         Match(wm_class = "discord"),
#
#         # Others
#         Match(wm_class = "qalculate-gtk"),
#     ],
#     **layout_theme
# )



#----------------------------------------------------------------------------
# Screens settings
#----------------------------------------------------------------------------

wallpaperSettings = {
    "wallpaper": "~/.config/wallpapers/wall.png",
    "wallpaper_mode": "fill",
}

# Enhanced screen configuration
def get_num_monitors():
    import subprocess
    try:
        output = subprocess.check_output(['xrandr', '--query'], universal_newlines=True)
        return len([line for line in output.splitlines() if ' connected' in line])
    except:
        return 1


screens = [
    Screen(
        top = mainBar,
        **wallpaperSettings,
    ),
    Screen(
        top = secondBar,
        **wallpaperSettings,
    ),
]



#----------------------------------------------------------------------------
# Enhanced Qtile Settings
#----------------------------------------------------------------------------

dgroups_key_binder = None
dgroups_app_rules = []  # type: list

# Mouse and focus behavior
follow_mouse_focus = True
bring_front_click = False
floats_kept_above = True
cursor_warp = False

# Window behavior
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True
auto_minimize = True

# Performance optimizations
respect_minimize_requests = True
window_close_animation = True

# If something Java related is not working, set this to "LG3D"
wmname = "Qtile"

# HOOK startup
@hook.subscribe.startup_once
def autostart():
    home = os.path.expanduser('~/.config/qtile/autostart.sh')
    subprocess.Popen([home])
