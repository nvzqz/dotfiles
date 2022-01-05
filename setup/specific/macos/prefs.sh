PLIST_BUDDY='/usr/libexec/PlistBuddy'

plist_set_or_add() {
    local FILE="$1"
    local KEY="$2"
    local TYPE="$3"
    local VALUE="$4"

    "$PLIST_BUDDY" -c "Set $KEY $VALUE" "$FILE" || \
    "$PLIST_BUDDY" -c "Add $KEY $TYPE $VALUE" "$FILE"
}

# TODO: Check out https://github.com/kristovatlas/osx-config-check

################################################################################
# Screenshots
################################################################################

SCREENSHOTS_PATH="$HOME/Pictures/Screenshots"

mkdir -p "$SCREENSHOTS_PATH"
defaults write com.apple.screencapture location "$SCREENSHOTS_PATH"

# Disable screenshot preview and shadows.
defaults write com.apple.screencapture show-thumbnail -bool false
defaults write com.apple.screencapture disable-shadow -bool true

################################################################################
# Clock
################################################################################

# Use 24 hour time with seconds.
#
# TODO: Set this in such a way that it'll trigger in System Preferences.
defaults write com.apple.menuextra.clock IsAnalog    -bool false
defaults write com.apple.menuextra.clock ShowSeconds -bool true
defaults write com.apple.menuextra.clock DateFormat  -string 'EEE MMM d  H:mm:ss'

################################################################################
# Safari
#
# TODO: Set Safari preferences within its sandbox. This requires giving access
# to all files.
#
# TODO: Show full website address.
# TODO: Show developer menu.
################################################################################

# TODO: Set default search engine to DuckDuckGo.
#
# SAFARI_PREFS="$HOME/Library/Containers/com.apple.Safari/Data/Library/Preferences/com.apple.Safari"
#
# defaults write -g NSPreferredWebServices \
#     '{
#         NSWebServicesProviderWebSearch = {
#             NSDefaultDisplayName = DuckDuckGo;
#             NSProviderIdentifier = "com.duckduckgo";
#         };
#     }'
#
# defaults write "$SAFARI_PREFS" SearchProviderShortName  -string DuckDuckGo
# defaults write "$SAFARI_PREFS" SearchProviderIdentifier -string com.duckduckgo

################################################################################
# Dock
#
# TODO: Add 'SCREENSHOTS_PATH' dir to dock.
# TODO: Set apps in wanted order with spacers.
################################################################################

# Enable autohide, with no show/hide delay.
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock autohide-time-modifier -float 0.25

# Enable app expose swipe gesture.
defaults write com.apple.dock showAppExposeGestureEnabled -bool true

# Disable recent apps section.
defaults write com.apple.dock show-recents -bool false

# Set size to something reasonable.
defaults write com.apple.dock tilesize -int 48

# Enable magnification with specific size.
defaults write com.apple.dock magnification -bool true
defaults write com.apple.dock largesize -int 64

################################################################################
# Finder
################################################################################

# Show full path in bottom bar.
defaults write com.apple.finder ShowPathbar -bool true

# Show extensions and hidden files.
defaults write -g AppleShowAllExtensions -bool true
defaults write com.apple.Finder AppleShowAllFiles -bool true

# Disable extension change warning.
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Disable toolbar title delay on 11 (Big Sur) and later.
defaults write -g NSToolbarTitleViewRolloverDelay -float 0

# Make sidebar use small icons.
defaults write NSGlobalDomain NSTableViewDefaultSizeMode -int 1

################################################################################
# General
################################################################################

# Disable '.DS_Store' on network and USB drives.
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# Make key repeat very quick.
#
# `KeyRepeat` float values between 0 and 1 are not processed well by the system.
defaults write -g KeyRepeat -int 1
defaults write -g InitialKeyRepeat -int 12
defaults write -g ApplePressAndHoldEnabled -bool false

################################################################################
# Shortcuts
################################################################################

# ZOOM_PREFS=(
#     ':AppleSymbolicHotKeys:15:enabled'
#     ':AppleSymbolicHotKeys:17:enabled'
#     ':AppleSymbolicHotKeys:179:enabled'
#     ':AppleSymbolicHotKeys:19:enabled'
#     ':AppleSymbolicHotKeys:23:enabled'
# )
#
# for zoom_pref in "${ZOOM_PREFS[@]}"; do
#     "$PLIST_BUDDY" -c \
#         "Set $zoom_pref true" \
#         "$HOME/Library/Preferences/com.apple.symbolichotkeys.plist"
# done

UNIVERSAL_ACCESS_PREFS="$HOME/Library/Preferences/com.apple.universalaccess"
UNIVERSAL_ACCESS_PREFS_FILE="$UNIVERSAL_ACCESS_PREFS.plist"

if [[ -f "$UNIVERSAL_ACCESS_PREFS_FILE" ]]; then
    true
    # TODO: Enable scroll wheel zoom.
    #
    # defaults write "$UNIVERSAL_ACCESS_PREFS" closeViewScrollWheelToggle -bool true

    # defaults write "$UNIVERSAL_ACCESS_PREFS" closeViewScrollWheelToggle -bool true
    # defaults write "$UNIVERSAL_ACCESS_PREFS" HIDScrollZoomModifierMask -int 262144
    # defaults write "$UNIVERSAL_ACCESS_PREFS" closeViewZoomFollowsFocus -bool true
else
    log_warning "Cannot set 'com.apple.universalaccess'; missing '$UNIVERSAL_ACCESS_PREFS_FILE'"
fi

################################################################################
# Cleanup
################################################################################

AFFECTED_PROCS=(
    # General
    Dock
    Finder

    # Screenshots & Clock
    SystemUIServer

    cfprefsd
    'System Preferences'
)

killall "${AFFECTED_PROCS[@]}" || true
