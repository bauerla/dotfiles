# Homebrew shell completion - https://docs.brew.sh/Shell-Completion
FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"

# Homebrew app install folder
export HOMEBREW_CASK_OPTS="--appdir=~/Applications"
