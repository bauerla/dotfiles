# The following lines were added by Docker Desktop to add commands to your PATH.
export PATH="$PATH:/Users/401366/.docker/bin"
# End of Docker Desktop section.

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

# Created by `pipx` on 2026-02-23 10:27:34
export PATH="$PATH:/Users/401366/.local/bin"

# GNU tools — override BSD tools with GNU versions (brew-packages.zsh installs with g-prefix by default)
export PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
export PATH="/usr/local/opt/gnu-sed/libexec/gnubin:$PATH"
export PATH="/usr/local/opt/gnu-tar/libexec/gnubin:$PATH"
export PATH="/opt/homebrew/opt/gnu-tar/libexec/gnubin:$PATH"
export PATH="/usr/local/opt/gnu-indent/libexec/gnubin:$PATH"
export PATH="/usr/local/opt/gnu-which/libexec/gnubin:$PATH"

# Homebrew sbin and man
export PATH="/usr/local/sbin:$PATH"
export MANPATH="/usr/local/man:$MANPATH"

# curl (Homebrew over system)
export PATH="/usr/local/opt/curl/bin:$PATH"

# JDK
export PATH="/usr/local/opt/openjdk/bin:$PATH"

# Lang
export LANG=en_US.UTF-8

# Android SDK
export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/tools/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools

# Chromium depot_tools
export PATH="$PATH:$HOME/devtools/depot_tools"

# pyenv
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"


export PATH="/Users/401366/.local/bin:$PATH"
