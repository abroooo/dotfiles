sudo apt-get update && sudo apt-get install zsh exa ripgrep stow fzf

cd $HOME && wget https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage && stow .

# use zsh as default shell
sudo chsh -s $(which zsh) $USER

# install neovim plugins
#nvim --headless +PlugInstall +qall

echo "Installing vimplug"
if ! test -f "${XDG_DATA_HOME:-$HOME/.local/share}/nvim/site/autoload/plug.vim"; then
    echo "$FILE exists."
    sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
           https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
else
    echo "Vim Plug already installed"
fi
