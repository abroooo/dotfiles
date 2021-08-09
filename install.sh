#!/bin/bash


echo "Installing vimplug"
if ! test -f "${XDG_DATA_HOME:-$HOME/.local/share}/nvim/site/autoload/plug.vim"; then
    echo "$FILE exists."
    sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
           https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
else
    echo "Vim Plug already installed"
fi

echo "Installing ripgrep"
if ! rg -v COMMAND &> /dev/null
then
    sudo apt update
    sudo apt-get install ripgrep
else
    echo "ripgrep found."
fi
