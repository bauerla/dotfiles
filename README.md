# dotfiles

Personal macOS dotfiles, managed as a bare git repo checked out directly into `$HOME`.

## Setup

On a fresh Mac, requires Xcode Command Line Tools (`xcode-select --install`) — the bootstrap script checks for this and exits with instructions if missing.

```zsh
sh -c "$(curl -fsSL <gist-url>)"
```

(Replace `<gist-url>` with the raw URL of the bootstrap gist.)

What it does:

1. Clones this repo as a bare repo into `~/.dotfiles` (does not touch `$HOME` directly at this step).
2. Sets `status.showUntrackedFiles no` on the repo so `git status` doesn't list every unrelated file in `$HOME` as untracked.
3. Configures a sparse-checkout that excludes this `README.md` from the work-tree — it stays tracked and pushed (so it still renders on this repo's GitHub page) but is never written into `$HOME`.
4. Checks which tracked paths already exist in `$HOME` (e.g. a pre-existing `.zshrc`) and moves only those to `~/.dotfiles-backup-MM-DD-YY/`, preserving their relative path, before touching anything.
5. Checks out the repo with `$HOME` as the work-tree. If checkout still fails after the backup step, the script stops and exits non-zero rather than leaving things half-done silently — check `dotfiles status` and the backup directory if that happens.

Day to day, use this shell function to operate on the repo (it's not defined in your shell until you add it yourself, e.g. to `.zshrc`, or you just inline the `--git-dir`/`--work-tree` flags):

```zsh
dotfiles() { /usr/bin/git --git-dir=$HOME/.dotfiles --work-tree=$HOME "$@"; }
```

Then: `dotfiles status`, `dotfiles add .zshrc`, `dotfiles commit`, `dotfiles push`.

## Updating

Re-running the bootstrap script on a machine that already has `~/.dotfiles` exits immediately with a message pointing here, without touching anything. To actually pull new changes:

```zsh
dotfiles pull
```

equivalently:

```zsh
git --git-dir=$HOME/.dotfiles --work-tree=$HOME pull
```

The bootstrap script is only for first-time setup on a new machine, not for updating an existing checkout.

## What's in here

```
.gitconfig                       git config
.zshrc                           main zsh config
.zprofile                        zsh login shell config
.p10k.zsh                        Powerlevel10k prompt config
.oh-my-zsh-custom/                files meant to live under $ZSH_CUSTOM
  aliases.zsh                     shell aliases
  functions.zsh                   shell functions
  iterm.zsh                       iTerm-specific shell config
  nvm.zsh                         nvm setup
  pyenv.zsh                       pyenv setup
  zsh-autosuggestion.zsh          zsh-autosuggestions config
iterm2/
  com.googlecode.iterm2.plist     exported iTerm2 preferences profile
dotfiles-setup/                   optional post-setup scripts, see below
```

## Post-setup: dotfiles-setup/ scripts

These are not run by the bootstrap script. Run manually, after the dotfiles above are checked out. Suggested order:

1. **`brew-install.zsh`** — installs Homebrew (handles both Apple Silicon and Intel install paths) if not present; otherwise runs `brew update && brew upgrade`.
2. **`brew-packages.zsh`** — installs core CLI tools (git, wget, curl, GNU coreutils/sed/tar/indent/which) and iTerm2, then interactively prompts to install packages from a Brewfile — your own `~/Brewfile` if present, otherwise `dotfiles-setup/Brewfile`, or skip entirely.
3. **`shell-tools.zsh`** — installs iTerm2 shell integration, Oh My Zsh plus plugins (zsh-autosuggestions, zsh-syntax-highlighting, autoupdate-oh-my-zsh-plugins, evalcache), Powerlevel10k and its recommended Nerd Font, and SDKMAN.
4. **`macos.zsh`** — applies personal macOS system preference tweaks (trackpad, keyboard, Finder, Safari, etc.). These are the repo owner's own preferences — adjust to taste before running.

**`Brewfile`** is the package list used by step 2 (dev tools, GUI apps, fonts, CLI utilities — mongodb, docker, pyenv, yarn, android-studio, vscode, google-cloud-sdk, postman, ffmpeg, imagemagick, chrome, firefox, spotify, etc.).

**`update.zsh`** is for later maintenance, not initial setup — run it whenever to update Oh My Zsh and its custom plugins, Powerlevel10k, and run `brew update && brew upgrade` plus `brew cleanup && brew doctor`.

## Notes

- Conflict detection compares the repo's tracked paths against what's already in `$HOME` directly (via `git ls-tree`), rather than parsing checkout error output — so filenames with spaces or other odd characters are handled correctly, and an unrelated file/directory can't get caught up in the backup by mistake.
- If a conflicting file can't be backed up (e.g. it's immutable or otherwise un-renameable), the script stops before running checkout and exits non-zero, rather than continuing with a partial checkout. Run `dotfiles status` if setup reports a failure.
- This `README.md` is intentionally excluded from the work-tree via sparse-checkout, so it won't show up under `$HOME` after setup — `dotfiles status` will correctly report the tree as clean despite that. Read it on GitHub instead.
