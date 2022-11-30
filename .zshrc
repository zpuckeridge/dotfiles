# Path to oh-my-zsh installation
export ZSH="$HOME/.oh-my-zsh"

# Set desired theme
ZSH_THEME="fino"

# Enable oh-my-zsh
source $ZSH/oh-my-zsh.sh

# Enable zsh plugins
plugins=(git)

# Nodenv setup
export PATH="$HOME/.nodenv/bin:$PATH"
eval "$(nodenv init -)"
