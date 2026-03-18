# dotfiles

Personal shell and Git defaults for macOS and Linux.

## What’s included

| File        | Purpose                                      |
|------------|-----------------------------------------------|
| `.zshrc`   | History, oh-my-zsh, nodenv, Bun + completions, QoL aliases, `gcm` |
| `.gitconfig` | Sensible Git defaults + your name/email   |
| `init.sh`  | One-shot bootstrap on a new machine           |

## Quick install (new machine)

From anywhere (downloads and runs the script):

```bash
curl -fsSL https://raw.githubusercontent.com/zpuckeridge/dotfiles/main/init.sh -o /tmp/dotfiles-init.sh
bash /tmp/dotfiles-init.sh
```

From a clone of this repo:

```bash
cd /path/to/dotfiles
bash init.sh
```

The script will:

1. Install **zsh** (Homebrew on macOS, `apt` on Debian/Ubuntu).
2. Install **oh-my-zsh** (non-interactive; won’t force a new shell mid-run).
3. Install **nodenv** + **node-build**.
4. Install **[Bun](https://bun.sh)** and generate zsh completions under `~/.bun/_bun`.
5. **Symlink** `~/.zshrc` and `~/.gitconfig` to the repo (existing real files are moved to `*.bak`).

Set zsh as login shell when ready:

```bash
chsh -s "$(command -v zsh)"
```

Install a Node version:

```bash
nodenv install 22
nodenv global 22
```

## Shell shortcuts

- **`dev` / `build` / `update` / `deploy` / `emails` / `ship`** — `bun run …` in the current project.
- **`gcm`** — `git add .`, prompts for a commit message (zsh), then `git commit` + `git push`.

Regenerate Bun completions after a major upgrade:

```bash
bun completions zsh > ~/.bun/_bun
```

## Local overrides

- **`~/.zshrc.local`** — sourced at the end of `.zshrc` (not tracked). See **`.zshrc.local.example`** for mysql-client, mole, and opencode snippets.

## Updating dotfiles

After `git pull` in the repo, symlinks already point at the updated files—no copy step.

## Requirements

- **macOS:** [Homebrew](https://brew.sh) (for installing zsh if missing).
- **Linux:** `sudo` and Debian/Ubuntu-style `apt-get`.
