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
    "border_width": 3,
    "margin": 15,
    # "border_focus": "FFFFFF",
    "border_focus": "FF00FF",
    "border_normal": colors[0],
    "single_border_width": 3
}

# --------------------------------------------------------
# Layouts
# --------------------------------------------------------

layouts = [
    # layout.Columns(),
    layout.Max(**layout_theme),
    # Try more layouts by unleashing below layouts.
    # layout.Stack(num_stacks=2),
    # layout.Bsp(),
    # layout.Matrix(),
    layout.MonadTall(**layout_theme),
    layout.MonadWide(**layout_theme),
    layout.RatioTile(**layout_theme),
    # layout.Tile(),
    # layout.TreeTab(),
    # layout.VerticalTile(),
    # layout.Zoomy(),
    layout.Floating()
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
# Miscelanous settings
#----------------------------------------------------------------------------

dgroups_key_binder = None
dgroups_app_rules = []  # type: list
follow_mouse_focus = True
bring_front_click = False
floats_kept_above = True
cursor_warp = False
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True
auto_minimize = False

# If something Java related is not working, set this to "LG3D"
wmname = "Qtile"

# HOOK startup
@hook.subscribe.startup_once
def autostart():
    home = os.path.expanduser('~/.config/qtile/autostart.sh')
    subprocess.Popen([home])
