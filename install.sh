#!/bin/bash

# install nix
curl -L https://nixos.org/nix/install | sh

# source nix
. ~/.nix-profile/etc/profile.d/nix.sh

# install packages
nix-env -iA \
	nixpkgs.zsh \
	nixpkgs.git \
	nixpkgs.neovim \
	nixpkgs.tmux \
	nixpkgs.stow \
	nixpkgs.fzf \
	nixpkgs.ripgrep \
	nixpkgs.bat \
	nixpkgs.tldr \
	nixpkgs.python3Full \
	nixpkgs.lazygit \
    nixpkgs.exa

# stow dotfiles
stow -S .

# add zsh as a login shell
#command -v zsh | sudo tee -a /etc/shells

# use zsh as default shell
sudo chsh -s $(which zsh) $USER

# install neovim plugins
nvim --headless +PlugInstall +qall

echo "Installing vimplug"
if ! test -f "${XDG_DATA_HOME:-$HOME/.local/share}/nvim/site/autoload/plug.vim"; then
    echo "$FILE exists."
    sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
           https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
else
    echo "Vim Plug already installed"
fi

exec zsh
