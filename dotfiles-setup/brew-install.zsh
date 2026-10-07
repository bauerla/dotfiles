#!/bin/zsh

# Detect architecture (Apple Silicon installs to /opt/homebrew, Intel to /usr/local)
if [[ $(uname -m) == "arm64" ]]; then
  BREW_PREFIX="/opt/homebrew"
  print -P "%F{cyan}Detected Apple Silicon — Homebrew will install to $BREW_PREFIX%f"
else
  BREW_PREFIX="/usr/local"
  print -P "%F{cyan}Detected Intel — Homebrew will install to $BREW_PREFIX%f"
fi

# Check if Homebrew installed already
if [[ $(command -v brew) == "" ]]; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  # The installer doesn't put brew on PATH for this already-running shell, so
  # brew calls below (and in later scripts run in this same session) would
  # fail with "command not found" without evaluating shellenv now.
  eval "$("$BREW_PREFIX/bin/brew" shellenv zsh)"

  # disable analytics
  brew analytics off # disable analytics

  print -P "%F{yellow}Homebrew installed and added to PATH for this session.%f"
else
  print -P "%F{cyan}Yay! You have Homebrew installed already!\nRunning update and upgrade... %f"
  # do update and upgrade
  brew update && brew upgrade
fi

# Check for any issues
brew doctor

print -P "%F{cyan}Done!%f"
