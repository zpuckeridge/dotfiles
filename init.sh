# install zsh
echo "Installing zsh..."
sudo apt install zsh

# install oh-my-zsh
echo "Installing oh-my-zsh..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" | sh install.sh

# install nodenv
git clone https://github.com/nodenv/nodenv.git ~/.nodenv
cd ~/.nodenv && src/configure && make -C src
~/.nodenv/bin/nodenv init
# setup node-build
mkdir -p "$(nodenv root)"/plugins
git clone https://github.com/nodenv/node-build.git "$(nodenv root)"/plugins/node-build

# clone dotfiles
echo "Cloning dotfiles..."
git clone git@github.com:zpuckeridge/dotfiles.git $HOME

echo "Setup done, run 'zsh' to start or if already running, restart it."
echo "Tip: Use 'chsh -s /bin/zsh' to set zsh as your default shell."
