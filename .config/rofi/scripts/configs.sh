#!/usr/bin/env bash
#
# Script name: dmconf
# Description: Choose from a list of configuration files to edit.
# Dependencies: dmenu
# GitLab: https://www.gitlab.com/dwt1/dmscripts
# Contributors: Derek Taylor

# Defining the text editor to use.
# DMENUEDITOR="vim"
# DMENUEDITOR="nvim"
# DMEDITOR="st -e nvim"
MYEDITOR="kitty -e nvim"

# An array of options to choose.
# You can edit this list to add/remove config files.
declare -A options
options[ Alacritty]="$HOME/.config/alacritty/alacritty.yml"
options[ Bashrc]="$HOME/.bashrc"
options[ Bookmarks File]="$HOME/Documents/bookmarks.txt"
options[ Bookmark Script]="$HOME/scripts/bookmarkthis.sh"
options[ Config Script]="$HOME/.config/rofi/scripts/configs.sh"
options[ Custom_autocommands.vim]="$HOME/.config/nvim/plugin/custom_autocommands.vim"
options[ Fish]="$HOME/.config/fish/config.fish"
options[ i3]="$HOME/.config/i3/config"
options[ Init.vim]="$HOME/.config/nvim/init.vim"
options[ Kitty]="$HOME/.config/kitty/kitty.conf"
options[ Legendary]="$HOME/.config/nvim/lua/plugins/legendary.lua"
options[ LSP]="$HOME/.config/nvim/lua/plugins/lsp.lua"
options[ Nvim-Colorscheme]="$HOME/.config/nvim/lua/plugins/colorscheme.lua"
options[ Nerdtree.vim]="$HOME/.config/nvim/plugin/nerdtree.vim"
options[ My-Config-Files README]="$HOME/my-config-files/README.md"
options[ Packer]="$HOME/.config/nvim/lua/plugins/plugins.lua"
options[ Pacman]="/etc/pacman.conf"
options[ Picom]="$HOME/.config/picom/picom.conf"
options[ Pmenu.vim]="$HOME/.config/nvim/plugin/pmenu.vim"
options[ Polybar-Config]="$HOME/.config/polybar/config.ini"
options[ Polybar-Theme-Alt-Arrows]="$HOME/.config/polybar/themes/alt-arrows.ini"
options[ Polybar-Theme-Alt-Slashes]="$HOME/.config/polybar/themes/alt-slashes.ini"
options[ Polybar-Theme-Classic-Polybar]="$HOME/.config/polybar/themes/classic-polybar.ini"
options[ Polybar-Theme-Flames]="$HOME/.config/polybar/themes/flames.ini"
options[ Polybar-Theme-Rainbow-Arrows]="$HOME/.config/polybar/themes/rainbow-arrows.ini"
options[ Polybar-Theme-Rainbow-Slashes]="$HOME/.config/polybar/themes/rainbow-slashes.ini"
options[ Qutebrowser]="$HOME/.config/qutebrowser/config.py"
options[ Ranger]="$HOME/.config/ranger/rc.conf"
options[ Rifle]="$HOME/.config/ranger/rifle.conf"
options[ Rofi-Config]="$HOME/.config/rofi/config"
options[ Rofi-Config.rasi]="$HOME/.config/rofi/config.rasi"
options[ Rofi-Theme-Fullscreen]="$HOME/.config/rofi/themes/fullscreen.rasi"
options[ Rofi-Theme-Pretty_Alt]="$HOME/.config/rofi/themes/pretty_alt.rasi"
options[ Rofi-Theme-Pretty_Big]="$HOME/.config/rofi/themes/pretty_big.rasi"
options[ Rofi-Theme-Pretty_Small]="$HOME/.config/rofi/themes/pretty_small.rasi"
options[ Rofi-Theme-Simple]="$HOME/.config/rofi/themes/simple.rasi"
options[ Starship-Prompt]="$HOME/.config/starship.toml"
options[ StartUp-Dashboard_Theme]="$HOME/.config/nvim/lua/startup/themes/fossvim_dashboard.lua"
options[ StartUp-Doom_Theme]="$HOME/.config/nvim/lua/startup/themes/fossvim_doom.lua"
options[ Telescope]="$HOME/.config/nvim/lua/plugins/Telescopes.lua"
options[ Topgrade]="$HOME/.config/topgrade.toml"
options[ Treesitter]="$HOME/.config/nvim/lua/plugins/treesitter.lua"
options[ Which-Key]="$HOME/.config/nvim/lua/plugins/whichkey.lua"
options[ Zathura]="$HOME/.config/zathura/zathurarc"
options[ Zsh-Aliases]="$HOME/.config/zsh/zsh-aliases"
options[ Zsh]="$HOME/.config/zsh/zshrc"

# Piping the above array into dmenu.
# We use "printf '%s\n'" to format the array one item to a line.
choice=$(printf '%s\n' "${!options[@]}" | rofi -dmenu -i  20 -p 'Edit config:')

# What to do when/if we choose a file to edit.
if [ "$choice" ]; then
	conf=$(printf '%s\n' "${options["${choice}"]}")
	$MYEDITOR "$conf"
# What to do if we just escape without choosing anything.
else
    echo "Program terminated." && exit 0
fi

