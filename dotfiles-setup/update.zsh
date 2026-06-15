#!/bin/zsh
#  Update components:
#    Update existing components that needs to be updated manually in some way

# Source user shell env
source "$HOME/.zshrc"

################################
# Oh My Zsh
print -P "%F{cyan}\nUpdating Oh-My-Zsh (OMZ) and its plugins...\n%f"
# Uses autoupdate plugin https://github.com/TamCore/autoupdate-oh-my-zsh-plugins#usage
# Updates:
#   - OMZ version
#   - Custom plugins (all git-repositories under $ZSH_CUSTOM folder)
if typeset -f upgrade_oh_my_zsh_all > /dev/null; then
  upgrade_oh_my_zsh_all
else
  print -P "%F{yellow}autoupdate plugin not found, pulling OMZ manually%f"
  git -C "$ZSH" pull --quiet
fi

# Powerlevel10k
print -P "%F{cyan}\nUpdating Powerlevel10k...%f"
p10k_path="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
if [[ -d "$p10k_path" ]]; then
  git -C "$p10k_path" pull
else
  print -P "%F{yellow}Powerlevel10k not found, skipping%f"
fi

################################
# Homebrew
print -P "%F{cyan}\nRunning brew update & brew upgrade...%f"
if ! brew update --quiet; then
  print -P "%F{red}brew update failed, skipping upgrade%f"
else
  brew upgrade
fi
print -P "\n%F{cyan}Doing some homebrew housekeeping...%f"
brew cleanup && brew doctor

print -P "%F{cyan}\n...Done! To restart shell run%f %F{magenta}exec zsh%f"
