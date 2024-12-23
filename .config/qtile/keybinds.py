from libqtile.config import Key, Click, Drag
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal

from functions import powerMenu
from groups import groups
from pathlib import Path

from libqtile.lazy import lazy
from libqtile import qtile, widget
import subprocess

from libqtile.lazy import lazy
from libqtile import qtile
import subprocess

def show_command_output(qtile, command: str):
    """Run a shell command and display its output in a popup."""
    try:
        # Run the shell command
        result = subprocess.run(command, shell=True, capture_output=True, text=True)
        output = result.stdout.strip() or result.stderr.strip() or "No output"
    except Exception as e:
        output = f"Error: {e}"

    # Create the popup
    popup = Popup(
        qtile,
        width=500,
        height=300,
        x=(qtile.current_screen.width - 500) // 2,
        y=(qtile.current_screen.height - 300) // 2,
        border_width=2,
        border_color="ffffff",
        background="000000",
        opacity=0.9,
        text=output,
        fontsize=14,
        font="sans",
    )
    popup.timeout = 5  # Auto-close after 5 seconds
    popup.show()


#----------------------------------------------------------------------------
# Default apps and the mod key
#----------------------------------------------------------------------------

mod = "mod4"
defaultApps = {
    "terminal": guess_terminal(),
    "browser": "firefox",
    "fileMan": guess_terminal() + " ranger",
    "calendar": guess_terminal() + " --title Calendar calcurse",
    "sound": "pavucontrol",
    "network": "nm-connection-editor",
    "bluetooth": "blueman-manager",
}

terminal = "wezterm"        
browser=""
home = str(Path.home())

#----------------------------------------------------------------------------
# Keybinds for window management and opening apps 
#----------------------------------------------------------------------------
    
keys = [

    # Focus
    Key([mod], "h", lazy.layout.left(), desc="Move focus to left"),
    Key([mod], "l", lazy.layout.right(), desc="Move focus to right"),
    Key([mod], "j", lazy.layout.down(), desc="Move focus down"),
    Key([mod], "k", lazy.layout.up(), desc="Move focus up"),
    Key([mod], "space", lazy.layout.next(), desc="Move window focus to other window around"),
    Key([mod], "i", lazy.function(show_command_output, "ls -la"))  ,# Example with `ls -la`
    
    # Move
    Key([mod, "shift"], "h", lazy.layout.shuffle_left(), desc="Move window to the left"),
    Key([mod, "shift"], "l", lazy.layout.shuffle_right(), desc="Move window to the right"),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down(), desc="Move window down"),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up(), desc="Move window up"),

    # Swap
    # Key([mod, "shift"], "h", lazy.layout.swap_left()),
    # Key([mod, "shift"], "l", lazy.layout.swap_right()),

    # Key([mod], "Print", lazy.spawn(home + "/dotfiles/scripts/scrot.sh")),

    # Size
    # Key([mod], "h", lazy.layout.shrink(), lazy.layout.decrease_nmaster(), desc='Shrink window (MonadTall)'),
    # Key([mod], "l", lazy.layout.grow(), lazy.layout.increase_nmaster(), desc='Expand window (MonadTall)'),
    Key([mod, "control"], "k", lazy.layout.shrink(), desc="Grow window to the left"),
    Key([mod, "control"], "l", lazy.layout.grow(), desc="Grow window to the right"),
    # Key([mod, "control"], "Down", lazy.layout.grow_down(), desc="Grow window down"),
    # Key([mod, "control"], "Up", lazy.layout.grow_up(), desc="Grow window up"),
    Key([mod], "n", lazy.layout.normalize(), desc="Reset all window sizes"),

    # Floating
    Key([mod], "t", lazy.window.toggle_floating(), desc="Toggle floating"),
    
    # Split
    Key([mod, "shift"], "Return", lazy.layout.toggle_split(), desc="Toggle between split and unsplit sides of stack"),

    # Toggle Layouts
    Key([mod], "Tab", lazy.next_layout(), desc="Toggle between layouts"),

    # Fullscreen
    Key([mod], "f", lazy.window.toggle_fullscreen()),

    #System
    Key([mod], "q", lazy.window.kill(), desc="Kill focused window"),
    Key([mod, "control"], "r", lazy.reload_config(), desc="Reload the config"),
    Key([mod, "control"], "q", lazy.spawn(home + "/dotfiles/.config/scripts/power_menu.sh"), desc="Open Powermenu"),
    Key([mod, "control"], "p", lazy.spawn("maim -i $(xdotool getactivewindow) ~/mypicture.jpg"), desc="take screenshot of active window"),
    
    # Apps
    Key([mod], "Return", lazy.spawn(terminal), desc="Launch terminal"),
    Key([mod], "p", lazy.spawn("flameshot gui"), desc="screenshot"),
    # Key([mod, "control"], "Return", lazy.spawn(home + "/dotfiles/scripts/applauncher.sh"), desc="Launch Rofi"),
    Key([mod], "d", lazy.spawn("rofi -show drun -show-icons"), desc="Launch Rofi"),
    Key([mod], "b", lazy.spawn(browser), desc="Launch Browser"),
    # Key([mod, "control"], "b", lazy.spawn(home + "/dotfiles/scripts/bravebookmarks.sh"), desc="Rofi Brave Bookmarks"),
    # Key([mod], "v", lazy.spawn(home + "/dotfiles/scripts/looking-glass.sh"), desc="Start Looking Glass Client"),
    Key([mod, "shift"], "w", lazy.spawn(home + "~/.config/scripts/updatewal.sh"), desc="Update Theme and Wallpaper"),
    Key([mod, "control"], "w", lazy.spawn(home + "/dotfiles/.config/scripts/wallpaper.sh"), desc="Select Theme and Wallpaper"),
    Key([mod, "control"], "t", lazy.spawn("flatpak run com.github.IsmaelMartinez.teams_for_linux --user"), desc="Select Tempate and copy to clipboard"),
    Key([mod, "control"], "s", lazy.spawn("maim -o -s | xclip -selection clipboard -t \"image/png\""), desc="Select Tempate and copy to clipboard"),
#    Key([], 'F10', lazy.spawn("brave --app=https://chat.openai.com"), desc="Open ChatGPT")
]


#----------------------------------------------------------------------------
# Keybinds for groups
#----------------------------------------------------------------------------

for i in groups:  
    keys.extend([
        Key([mod], i.name, lazy.group[i.name].toscreen(toggle=True), desc="Switch to group {}".format(i.name)),
        Key([mod, "shift"], i.name, lazy.window.togroup(i.name, switch_group=True), desc="Switch to & move focused window to group {}".format(i.name)),
        Key([mod, "control"], i.name, lazy.window.togroup(i.name), desc="Move focused window to group {}".format(i.name)),
    ])



#----------------------------------------------------------------------------
# Drag floating layouts
#----------------------------------------------------------------------------

mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(), start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]
