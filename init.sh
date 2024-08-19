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

# Update .zshrc from dotfiles
ZSHRC_SOURCE="$DOTFILES_DIR/.zshrc"
if [ -f "$ZSHRC_SOURCE" ]; then
    echo "Updating .zshrc from dotfiles..."
    [ -f "$HOME/.zshrc" ] && rm "$HOME/.zshrc"
    cp "$ZSHRC_SOURCE" "$HOME/.zshrc"
else
    echo "No .zshrc found in dotfiles."
fi

# Remove init.sh
INIT_SH="$HOME/init.sh"
if [ -f "$INIT_SH" ]; then
    echo "Removing init.sh..."
    rm "$INIT_SH"
else
    echo "init.sh does not exist."
fi

echo "Setup done. Run 'zsh' to start or if already running, restart it."
echo "Tip: Use 'chsh -s $(which zsh)' to set zsh as your default shell."
