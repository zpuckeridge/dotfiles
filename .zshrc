# Dotfiles: https://github.com/zpuckeridge/dotfiles
# zsh >= 5.8 recommended

# --- History ---
HISTFILE="${HISTFILE:-$HOME/.zsh_history}"
HISTSIZE=50000
SAVEHIST=$HISTSIZE
setopt EXTENDED_HISTORY       # timestamps in history
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE      # don't save commands starting with space
setopt HIST_VERIFY            # show expanded command before running
setopt SHARE_HISTORY          # share history across sessions

# --- Navigation & completion ---
setopt AUTO_CD                 # cd by typing directory name
setopt CORRECT                # offer spelling correction for commands
setopt INTERACTIVE_COMMENTS   # allow # comments in interactive shell

# --- oh-my-zsh (plugins MUST be set before sourcing) ---
export ZSH="${ZSH:-$HOME/.oh-my-zsh}"
ZSH_THEME="${ZSH_THEME:-fino}"
plugins=(git)

if [[ -r "$ZSH/oh-my-zsh.sh" ]]; then
  source "$ZSH/oh-my-zsh.sh"
fi

# --- nodenv ---
export PATH="$HOME/.nodenv/bin:$PATH"
if command -v nodenv >/dev/null 2>&1; then
  eval "$(nodenv init - zsh)"
fi

# --- bun ---
export PATH="$HOME/.bun/bin:$PATH"
[[ -s "$HOME/.bun/_bun" ]] && source "$HOME/.bun/_bun"

# --- QoL (bun scripts) ---
alias dev='bun run dev'
alias build='bun run build'
alias update='bun run update'
alias deploy='bun run deploy'
alias emails='bun run emails'
alias ship='bun run ship'

# --- Git: stage all, prompt for message, commit, push ---
alias gcm='git add . && read "?Commit message: " msg && git commit -m "$msg" && git push'

# --- Optional: local overrides (not in git) ---
[[ -f "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"
