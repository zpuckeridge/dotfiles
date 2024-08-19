#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Install zsh
if ! command_exists zsh; then
    echo "Installing zsh..."
    sudo apt update && sudo apt install -y zsh
else
    echo "zsh is already installed."
fi

# Install oh-my-zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Installing oh-my-zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
    echo "oh-my-zsh is already installed."
fi

# Install nodenv
if [ ! -d "$HOME/.nodenv" ]; then
    echo "Installing nodenv..."
    git clone https://github.com/nodenv/nodenv.git ~/.nodenv
    cd ~/.nodenv && src/configure && make -C src
    # Initialize nodenv
    echo 'export PATH="$HOME/.nodenv/bin:$PATH"' >> ~/.zshrc
    echo 'eval "$(nodenv init -)"' >> ~/.zshrc
else
    echo "nodenv is already installed."
fi

# Setup node-build
if [ ! -d "$(nodenv root)/plugins/node-build" ]; then
    echo "Setting up node-build..."
    mkdir -p "$(nodenv root)/plugins"
    git clone https://github.com/nodenv/node-build.git "$(nodenv root)/plugins/node-build"
else
    echo "node-build is already set up."
fi

# Clone dotfiles
DOTFILES_DIR="$HOME/dotfiles"
if [ ! -d "$DOTFILES_DIR" ]; then
    echo "Cloning dotfiles..."
    git clone git@github.com:zpuckeridge/dotfiles.git $DOTFILES_DIR
else
    echo "Dotfiles are already cloned."
fi

echo "Setup done. Run 'zsh' to start or if already running, restart it."
echo "Tip: Use 'chsh -s $(which zsh)' to set zsh as your default shell."
