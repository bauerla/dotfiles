#!/bin/zsh

################################
# Iterm2 shell integration
print -P "%F{magenta}Install iTerm2 shell integration...%f"
curl -L https://iterm2.com/shell_integration/zsh -o $HOME/.iterm2_shell_integration.zsh


################################
# Oh-My-Zsh & plugins
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended --keep-zshrc

print -P "%F{magenta}Clone Oh-My-ZSH plugins...%f"
# Zsh plugins (plugins section in .zshrc)
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-$HOME/.oh-my-zsh-custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh-custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/lukechilds/zsh-nvm ${ZSH_CUSTOM:-$HOME/.oh-my-zsh-custom}/plugins/zsh-nvm
git clone https://github.com/TamCore/autoupdate-oh-my-zsh-plugins ${ZSH_CUSTOM:-$HOME/.oh-my-zsh-custom}/plugins/autoupdate

################################
# Powerlevel10k
print -P "%F{magenta}Install Powerlevel10k...%f"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh-custom}/themes/powerlevel10k

# download Powerlevel10k optimized fonts so no need to run 'p10k configure'
# https://github.com/romkatv/powerlevel10k#fonts
fonts='https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf
https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf
https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf
https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf'

print -P "%F{magenta}Getting Powerlevel10k fonts...%f"
wget --no-verbose --show-progress --directory-prefix=$HOME/Library/Fonts/ -i - <<< $fonts

print -P "%F{magenta}Done!%f"

