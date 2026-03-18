#!/usr/bin/env bash
# Bootstrap a new machine: zsh, oh-my-zsh, nodenv, symlinked dotfiles.
# Supports macOS (Homebrew) and Debian/Ubuntu (apt).

set -euo pipefail

command_exists() { command -v "$1" >/dev/null 2>&1; }

die() { echo "Error: $*" >&2; exit 1; }

detect_os() {
  case "$(uname -s)" in
    Darwin) echo "macos" ;;
    Linux)  echo "linux" ;;
    *)      echo "unknown" ;;
  esac
}

OS="$(detect_os)"
[[ "$OS" == "unknown" ]] && die "Unsupported OS. Install zsh, oh-my-zsh, and nodenv manually, then symlink from this repo."

install_zsh() {
  if command_exists zsh; then
    echo "zsh: already installed."
    return 0
  fi
  echo "Installing zsh..."
  if [[ "$OS" == "macos" ]]; then
    command_exists brew || die "Install Homebrew first: https://brew.sh"
    brew install zsh
  else
    sudo apt-get update -qq
    sudo apt-get install -y zsh
  fi
}

install_oh_my_zsh() {
  if [[ -d "$HOME/.oh-my-zsh" ]]; then
    echo "oh-my-zsh: already installed."
    return 0
  fi
  echo "Installing oh-my-zsh (non-interactive)..."
  RUNZSH=no CHSH=no KEEP_ZSHRC=yes \
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
}

install_nodenv() {
  local root="$HOME/.nodenv"
  if [[ -d "$root" ]]; then
    echo "nodenv: already installed."
  else
    echo "Installing nodenv..."
    git clone --depth 1 https://github.com/nodenv/nodenv.git "$root"
    (cd "$root" && src/configure && make -C src)
  fi
  export PATH="$root/bin:$PATH"
  command_exists nodenv || die "nodenv binary missing after install"

  local plugdir="$root/plugins"
  if [[ ! -d "$plugdir/node-build" ]]; then
    echo "Installing node-build..."
    mkdir -p "$plugdir"
    git clone --depth 1 https://github.com/nodenv/node-build.git "$plugdir/node-build"
  else
    echo "node-build: already present."
  fi
}

install_bun() {
  if command -v bun >/dev/null 2>&1; then
    echo "bun: already installed."
  else
    echo "Installing bun..."
    curl -fsSL https://bun.sh/install | bash
  fi
  export PATH="$HOME/.bun/bin:$PATH"
  if [[ ! -s "$HOME/.bun/_bun" ]] && command -v bun >/dev/null 2>&1; then
    echo "Generating bun zsh completions..."
    mkdir -p "$HOME/.bun"
    bun completions zsh >"$HOME/.bun/_bun"
  fi
}

backup_and_link() {
  local src="$1" dest="$2"
  [[ -f "$src" ]] || die "Missing file in repo: $src"
  if [[ -e "$dest" ]] && [[ ! -L "$dest" ]]; then
    echo "Backing up $dest -> ${dest}.bak"
    mv "$dest" "${dest}.bak"
  fi
  ln -sfn "$src" "$dest"
  echo "Linked $dest -> $src"
}

# Default: clone next to this script's intended location, or use env DOTFILES_DIR
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [[ "${DOTFILES_DIR:-}" ]]; then
  :
elif [[ -d "$SCRIPT_DIR/.git" ]] || [[ -f "$SCRIPT_DIR/.zshrc" ]]; then
  DOTFILES_DIR="$SCRIPT_DIR"
else
  DOTFILES_DIR="${DOTFILES_DIR:-$HOME/dotfiles}"
  if [[ ! -d "$DOTFILES_DIR" ]]; then
    echo "Cloning dotfiles into $DOTFILES_DIR ..."
    git clone https://github.com/zpuckeridge/dotfiles.git "$DOTFILES_DIR"
  else
    echo "Dotfiles dir exists: $DOTFILES_DIR"
  fi
fi

install_zsh
install_oh_my_zsh
install_nodenv
install_bun

backup_and_link "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"
if [[ -f "$DOTFILES_DIR/.gitconfig" ]]; then
  backup_and_link "$DOTFILES_DIR/.gitconfig" "$HOME/.gitconfig"
fi

echo ""
echo "Done."
echo "  Default shell: run  chsh -s \"\$(command -v zsh)\"  (may require logout)"
echo "  Node:           nodenv install <version> && nodenv global <version>"
echo "  Bun:            bun --version"
echo "  Machine-only:   ~/.zshrc.local (optional; e.g. mysql-client, mole, opencode)"
