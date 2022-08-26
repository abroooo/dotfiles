sudo apt-get update && sudo apt-get install zsh exa ripgrep stow fzf bat dwarfdump
sudo apt-get install ninja-build git gettext libtool libtool-bin autoconf automake cmake g++ pkg-config unzip curl doxygen -y

cd /tmp && wget https://github.com/sharkdp/bat/releases/download/v0.21.0/bat_0.21.0_amd64.deb && sudo dpkg -i bat_0.21.0_amd64.deb 
git clone https://github.com/neovim/neovim /tmp/neovim
cd /tmp/neovim && make && sudo make install
mkdir $HOME/.cache/
cd $HOME/dotfiles && stow .


# install neovim plugins
pip install pyright
nvim --headless +PlugInstall +qall

echo "Installing vimplug"
if ! test -f "${XDG_DATA_HOME:-$HOME/.local/share}/nvim/site/autoload/plug.vim"; then
    echo "$FILE exists."
    sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
           https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
else
    echo "Vim Plug already installed"
fi

# use zsh as default shell
sudo chsh -s $(which zsh) $USER
