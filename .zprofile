# Homebrew location on Apple M1
if [[ `uname -m` == 'arm64' ]]; then
  eval $(/opt/homebrew/bin/brew shellenv)
fi

# Homebrew shell completion - https://docs.brew.sh/Shell-Completion
FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"

# Homebrew app install folder
export HOMEBREW_CASK_OPTS="--appdir=~/Applications"

# GCP
source "$(brew --prefix)/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc"
source "$(brew --prefix)/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc"
