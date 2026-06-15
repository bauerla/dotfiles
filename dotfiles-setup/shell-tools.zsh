#!/bin/zsh

################################
# Iterm2 shell integration
# Note: verify URL is current for your macOS version at https://iterm2.com/documentation-shell-integration.html
print -P "%F{magenta}Install iTerm2 shell integration...%f"
curl -L https://iterm2.com/shell_integration/zsh -o $HOME/.iterm2_shell_integration.zsh


################################
# Oh-My-Zsh & plugins
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended --keep-zshrc

print -P "%F{magenta}Clone Oh-My-ZSH plugins...%f"
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

clone_plugin() {
  if ! git clone "$@"; then
    print -P "%F{red}Failed to clone ${@[-1]}%f"
  fi
}

# Zsh plugins (plugins section in .zshrc)
clone_plugin https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
clone_plugin https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
clone_plugin https://github.com/TamCore/autoupdate-oh-my-zsh-plugins "$ZSH_CUSTOM/plugins/autoupdate"
clone_plugin https://github.com/mroth/evalcache "$ZSH_CUSTOM/plugins/evalcache"

################################
# Powerlevel10k
print -P "%F{magenta}Install Powerlevel10k...%f"
clone_plugin --depth=1 https://github.com/romkatv/powerlevel10k.git "$ZSH_CUSTOM/themes/powerlevel10k"

# download Powerlevel10k optimized fonts so no need to run 'p10k configure'
# https://github.com/romkatv/powerlevel10k#fonts
fonts='https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf
https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf
https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf
https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf'

print -P "%F{magenta}Getting Powerlevel10k fonts...%f"
mkdir -p "$HOME/Library/Fonts"
while IFS= read -r url; do
  [[ -z "$url" ]] && continue
  if ! wget --no-verbose --show-progress --directory-prefix="$HOME/Library/Fonts/" "$url"; then
    print -P "%F{yellow}Warning: Failed to download $url%f"
  fi
done <<< "$fonts"

print -P "%F{magenta}Installing SDKMAN...%f"
sdkman_installer=$(mktemp)
if curl -fsSL "https://get.sdkman.io" -o "$sdkman_installer"; then
  bash "$sdkman_installer"
  rm -f "$sdkman_installer"
  # source is a no-op for the parent shell; user must restart shell to activate sdk command
  [[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
  print -P "%F{yellow}SDKMAN installed. Run: exec zsh to activate in current shell%f"
else
  print -P "%F{red}Failed to download SDKMAN installer%f"
  rm -f "$sdkman_installer"
fi

print -P "%F{magenta}Done!%f"
