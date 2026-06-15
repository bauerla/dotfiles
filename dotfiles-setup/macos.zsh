#!/bin/zsh

####################################
# This script automates tweaking many of the Os X system settings.
# All changes are for my personal preference so feel free to adjust any to your liking before running the script.
#
# Settings changed by the script are grouped by their context and/or app in question with a comment.
# Not every setting is explained as most of them are self explanatory so have added comment to only where needed IMO.
#
#
# Parameters
#   --hostname <name> : change computer name including network names
#   --skip-hardening : when provided some hardening settings are skipped (see below in the script)
#
# Notes
#   '−g' used system settings is equivalent to '−globalDomain' and 'NSGlobalDomain'
#
####################################

zmodload zsh/zutil
# Parse passed arguments
zparseopts -D -E -F -hostname:=n -skip-hardening=h || exit 1

# hostname from as first argument or env variable
#COMPUTER_NAME=${$COMPUTER_NAME:-""}
#HARDENING=${$HARDENING:-true}

# close any system preference windows first
osascript -e 'tell application "System Settings" to quit'

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing 'sudo' time stamp until script has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &


####################################
# Security (Hardening)

# Skip hardenings settings if --skip-hardening provided
if [[ -z $h ]]; then
  # Enable Firewall
  print -P "%F{blue}Enabling FireWall...%f"
  sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setglobalstate on

  # Enable FileVault
  if ! fdesetup isactive >/dev/null 2>&1; then
    print -P "%F{blue}Enabling FileVault...%f"
    sudo fdesetup enable
  fi
  sudo fdesetup status

  # Other hardening
  sudo defaults write /Library/Preferences/.GlobalPreferences MultipleSessionEnabled -bool false # disable fast user switch
  sudo pmset destroyfvkeyonstandby 1 # remove FileVault keys in memory when standby mode
else
  print -P "%F{blue}Skipping hardening settings..."
fi

####################################
# Hostname

# - 'ComputerName', 'HostName' & 'LocalHostName' (System Settings -> General -> Sharing)
# - 'NetBIOSName' (System Settings -> Network -> interface -> Advanced...)

if [[ -n $n[2] ]]; then
  sudo scutil --set ComputerName $n[2]
  sudo scutil --set HostName $n[2]
  sudo scutil --set LocalHostName $n[2]
  sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string $n[2]

  # Flush DNS cache
  dscacheutil -flushcache

  # Print out the names after changed
  print -P "%F{blue}Network names set:%f"
  print -P "\tComputerName:\t%B$(sudo scutil --get ComputerName)%b"
  print -P "\tHostName:\t%B$(sudo scutil --get HostName)%b"
  print -P "\tLocalHostName:\t%b$(sudo scutil --get LocalHostName)%b"
  print -P "\tNetBIOSName:\t%B$(sudo defaults read /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName)\n%b"
  print -P "%F{red}--> Remember to restart computer after the script%f\n"
fi


####################################
# Media

# Increase Bluetooth audio quality
defaults write com.apple.BluetoothAudioAgent "Apple Bitpool Min (editable)" -int 40
# Disable the sound effects on boot
# Note: nvram modifications may be silently ignored on macOS 12+ (Tahoe) due to SIP/security restrictions
sudo nvram SystemAudioVolume=" "


####################################
# Trackpad, keyboard

# Trackpad: enable tap to click for this user and for the login screen
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write -g com.apple.mouse.tapBehavior -int 1
defaults write -g com.apple.mouse.tapBehavior -int 1

# Trackpad: map bottom right corner to right-click
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadCornerSecondaryClick -int 2
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRightClick -bool true
defaults -currentHost write -g com.apple.trackpad.trackpadCornerClickBehavior -int 1
defaults -currentHost write -g com.apple.trackpad.enableSecondaryClick -bool true

# Keyboard: repeat and autocorrection settings
defaults write -g InitialKeyRepeat -int 10 # normal minimum is 15 (225 ms)
defaults write -g KeyRepeat -int 2 # normal minimum (30 ms)
defaults write -g NSAutomaticSpellingCorrectionEnabled -bool false
defaults write -g NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write -g NSAutomaticDashSubstitutionEnabled -bool false

# Use keyboard navigation to move focus between controls (tab-tab for everything): System & Safari
defaults write -g AppleKeyboardUIMode -int 3
defaults write com.apple.Safari WebKitTabToLinksPreferenceKey -bool false

# Non-breaking spaces: https://superuser.com/questions/78245/how-to-disable-the-option-space-key-combination-for-non-breaking-spaces
mkdir -p ~/Library/KeyBindings
cat > ~/Library/KeyBindings/DefaultKeyBinding.dict <<EOF
{
"~ " = ("insertText:", " ");
}
EOF


####################################
# Screen

# Require password immediately after sleep or screen saver begins
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0

# Disable some animations
defaults write -g NSAutomaticWindowAnimationsEnabled -bool false
defaults write -g QLPanelAnimationDuration -float 0
defaults write com.apple.finder DisableAllAnimations -bool true
defaults write com.apple.dock launchanim -bool false
defaults write com.apple.dock expose-animation-duration -float 0.1
defaults write com.apple.dock expose-group-by-app -bool true
defaults write com.apple.mail DisableReplyAnimations -bool true
defaults write com.apple.mail DisableSendAnimations -bool false

# Enable font subpixel anti-aliasing (revert if any problems occurs)
# Deprecated in macOS 14+ (Sonoma/Tahoe) - may have no effect on modern displays
defaults write -g CGFontRenderingFontSmoothingDisabled -bool false

# Disable font smoothing. Values 0-3
# Deprecated in macOS 14+ (Sonoma/Tahoe) - may have no effect on modern displays
defaults -currentHost write -g AppleFontSmoothing -int 0


####################################
# Dock & Menu bar

# Spaces automatic reordering
defaults write com.apple.dock mru-spaces -bool false

# Menu
defaults write com.apple.menuextra.battery ShowPercent -string "YES"
defaults write com.apple.menuextra.battery ShowTime -bool false

# Dock
defaults write com.apple.dock persistent-apps -array # remove stock apps
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock autohide-time-modifier -float 0.2
defaults write com.apple.dock magnification -bool false
defaults write com.apple.dock show-recents -bool false
defaults write com.apple.dock tilesize -int 40
defaults write com.apple.dock dashboard-in-overlay -bool true
defaults write -g AppleEnableMenuBarTransparency -bool false
defaults write -g FXEnableSlowAnimation -bool false
defaults write -g InitialKeyRepeat -int 12
defaults write -g NSWindowResizeTime -float 0.001
defaults write -g NSDisableAutomaticTermination -bool true

# Clock
## Thu 18 Aug 23:46:10
## System Settings > General > Date & Time > Display time with seconds - Checked [:ss]
## System Settings > General > Date & Time > Use a 24-hour clock - Checked [HH:mm]
## System Settings > General > Date & Time > Show AM/PM - Unchecked
## System Settings > General > Date & Time > Show the day of the week - Checked [EEE]
## System Settings > General > Date & Time > Show date - Checked [d MMM]
sudo defaults write com.apple.menuextra.clock DateFormat -string 'EEE d MMM HH:mm:ss'


####################################
# Locations

# Screenshot location
test -d "${HOME}/Documents/screenshots" || mkdir -p "${HOME}/Documents/screenshots"
defaults write com.apple.screencapture location -string "${HOME}/Documents/screenshots"
defaults write com.apple.screencapture type png

# Show the ~/Library folder
chflags nohidden ~/Library

# Show the /Volumes folder
sudo chflags nohidden /Volumes


####################################
# System Apps

# Terminal: UTF8 encoding
defaults write com.apple.terminal StringEncodings -array 4

# Activity Monitor
defaults write com.apple.ActivityMonitor OpenMainWindow -bool true
defaults write com.apple.ActivityMonitor SortColumn -string "CPUUsage"
defaults write com.apple.ActivityMonitor SortDirection -int 0
defaults write com.apple.ActivityMonitor ShowCategory -int 0

# Finder
defaults write -g AppleShowAllExtensions -bool true
defaults write -g NSDocumentSaveNewDocumentsToCloud -bool false
defaults write -g NSScrollViewRubberbanding -bool false
defaults write -g NSTableViewDefaultSizeMode -int 2
defaults write -g AppleShowScrollBars -string "Always"
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true
defaults write com.apple.finder AppleShowAllFiles true
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowStatusBar -bool true
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true
defaults write com.apple.finder _FXSortFoldersFirst -bool true
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
defaults write com.apple.finder QuitMenuItem -bool true
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"
defaults write com.apple.finder NewWindowTarget -string "PfLo"
defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}"
defaults write com.apple.finder QLEnableTextSelection -bool true;
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowMountedServersOnDesktop -bool true
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true
defaults write com.apple.screencapture disable-shadow -bool true
defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1

# Safari
defaults write -g WebKitDeveloperExtras -bool true
defaults write com.apple.Safari IncludeInternalDebugMenu -bool true
defaults write com.apple.Safari AutoOpenSafeDownloads -bool false
defaults write com.apple.Safari SendDoNotTrackHTTPHeader -bool true
defaults write com.apple.Safari ProxiesInBookmarksBar "()"
defaults write com.apple.Safari HomePage -string "https://duckduckgo.com/"
defaults write com.apple.Safari IncludeDevelopMenu -bool true
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2StandardFontFamily Georgia
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DefaultFontSize 16
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2FixedFontFamily Menlo
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DefaultFixedFontSize 14

# Print: expand save and print panels by default, also quit automatically
defaults write -g NSNavPanelExpandedStateForSaveMode -bool true
defaults write -g NSNavPanelExpandedStateForSaveMode2 -bool true
defaults write -g PMPrintingExpandedStateForPrint -bool true
defaults write -g PMPrintingExpandedStateForPrint2 -bool true
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

# Scan: prevent ImageCapture taking over the control
defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool true

# App Store
defaults write com.apple.appstore ShowDebugMenu -bool true

# TextEdit
defaults write com.apple.TextEdit PlainTextEncoding -int 4
defaults write com.apple.TextEdit PlainTextEncodingForWrite -int 4

# Disk Utility
defaults write com.apple.DiskUtility DUDebugMenuEnabled -bool true
defaults write com.apple.DiskUtility advanced-image-options -bool true


defaults write com.apple.loginwindow PowerButtonSleepsSystem -bool false
defaults write -g ApplePressAndHoldEnabled -bool false

# Disable crash report dialog and Bonjour adds
defaults write com.apple.CrashReporter DialogType none
# note: set to "false" if Airdrop not working between iOS & macOS
/usr/bin/sudo /usr/bin/defaults write /Library/Preferences/com.apple.mDNSResponder.plist NoMulticastAdvertisements -bool false

####################################
# App specific configurations

# Iterm2
# don’t display the annoying prompt when quitting iTerm
defaults write com.googlecode.iterm2 PromptOnQuit -bool false
# specify the preferences directory
defaults write com.googlecode.iterm2.plist PrefsCustomFolder -string "~/iterm2"
# use the custom preferences in the directory
defaults write com.googlecode.iterm2.plist LoadPrefsFromCustomFolder -bool true

# Chrome: disable two finger back/forward in Chrome
defaults write com.google.Chrome AppleEnableSwipeNavigateWithScrolls -bool false

# Visual Studio Code: enable subpixel anti-aliasing
defaults write com.microsoft.VSCode CGFontRenderingFontSmoothingDisabled -bool false
defaults write com.microsoft.VSCode.helper CGFontRenderingFontSmoothingDisabled -bool false
defaults write com.microsoft.VSCode.helper.EH CGFontRenderingFontSmoothingDisabled -bool false
defaults write com.microsoft.VSCode.helper.NP CGFontRenderingFontSmoothingDisabled -bool false


####################################
# Restart all affected apps
echo "Closing all system apps affected by the changes (Safari Finder Dock SystemUIServer)..."
for app in Safari Finder Dock SystemUIServer; do killall "$app" >/dev/null 2>&1; done

osascript <<'END'
if application "iTerm" is running then
  log "Closing iTerm2 to apply changes..."
  tell application "iTerm" to quit
  return
end if
END

print -P "%F{green}Done!%f"
