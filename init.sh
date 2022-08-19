# install zsh
echo "Installing zsh..."
sudo apt install zsh

# clone dotfiles
echo "Cloning dotfiles..."
git clone git@github.com:zpuckeridge/dotfiles.git $HOME

echo "Setup done, run 'zsh' to start or if already running, restart it."
echo "Tip: Use 'chsh -s /bin/zsh' to set zsh as your default shell."
