export ZDOTDIR=$HOME/.config/zsh

if [ -e /home/dottest/.nix-profile/etc/profile.d/nix.sh ]; then . /home/dottest/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer
. "$HOME/.cargo/env"
