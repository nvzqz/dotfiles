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
SCREENSHOTS_PATH_SIM="$SCREENSHOTS_PATH/Simulator"

mkdir -p "$SCREENSHOTS_PATH_SIM"

# Set host screenshot path.
defaults write com.apple.screencapture location -string "$SCREENSHOTS_PATH"

# Set simulator screenshot path.
defaults write com.apple.iphonesimulator ScreenShotSaveLocation -string "$SCREENSHOTS_PATH_SIM"

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

# Use hidden "suck" effect when minimizing items. This is slightly different
# from the default "genie" effect.
defaults write com.apple.dock mineffect -string suck

# Enable app expose swipe gesture.
defaults write com.apple.dock showAppExposeGestureEnabled -bool true

# Disable recent apps section.
defaults write com.apple.dock show-recents -bool false

# Set size to something reasonable.
defaults write com.apple.dock tilesize -int 48

# Enable magnification with specific size.
defaults write com.apple.dock magnification -bool true
defaults write com.apple.dock largesize -int 64

# Make icons for hidden apps translucent.
defaults write com.apple.dock showhidden -bool true

################################################################################
# Finder
################################################################################

# Show full path and status bars in bottom.
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowStatusBar -bool true

# Make path bar relative to home folder.
defaults write com.apple.finder PathBarRootAtHome -bool true

# Show extensions and hidden files.
defaults write -g AppleShowAllExtensions -bool true
defaults write com.apple.Finder AppleShowAllFiles -bool true

# Disable extension change warning.
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Show folders first when sorting.
defaults write com.apple.finder _FXSortFoldersFirst -bool false

# Prefer column view.
defaults write com.apple.finder FXPreferredViewStyle -string clmv

# Open new windows in home folder.
defaults write com.apple.finder NewWindowTarget     -string PfHm
defaults write com.apple.finder NewWindowTargetPath -string "file://$HOME"

# Show all items on desktop.
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowMountedServersOnDesktop -bool true
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true

function set_finder_desktop_icon_setting() {
    "$PLIST_BUDDY" -c \
        "Set ':DesktopViewSettings:IconViewSettings:$1' '$2'" \
        "$HOME/Library/Preferences/com.apple.finder.plist"
}

# Show desktop icon item info.
set_finder_desktop_icon_setting showItemInfo true

# Arrange desktop icons by kind.
set_finder_desktop_icon_setting arrangeBy kind

# Set desktop icon grid spacing and icon size.
set_finder_desktop_icon_setting gridSpacing 100 # max
set_finder_desktop_icon_setting iconSize 48

# Set desktop labels on right.
set_finder_desktop_icon_setting labelOnBottom false

# Set desktop text size.
set_finder_desktop_icon_setting textSize 11

################################################################################
# User Interface
################################################################################

# Disable toolbar title delay on 11 (Big Sur) and later.
defaults write -g NSToolbarTitleViewRolloverDelay -float 0

# Make sidebar use small icons.
defaults write -g NSTableViewDefaultSizeMode -int 1

# Set system theme to red.
defaults write -g AppleAquaColorVariant -int 0
defaults write -g AppleAccentColor -int 0
defaults write -g AppleHighlightColor '1.000000 0.733333 0.721569 Red'

################################################################################
# Hardware
################################################################################

# Make trackpad tracking slightly faster.
defaults write -g com.apple.trackpad.scaling -float 1.5

################################################################################
# General
################################################################################

# Disable restoring last file state for Xcode and Preview.
for app in 'com.apple.dt.Xcode' 'com.apple.Preview'; do
    defaults write "$app" ApplePersistenceIgnoreState -bool true
done

# Expand save and print panels by default.
defaults write -g NSNavPanelExpandedStateForSaveMode  -bool true
defaults write -g NSNavPanelExpandedStateForSaveMode2 -bool true
defaults write -g PMPrintingExpandedStateForPrint     -bool true
defaults write -g PMPrintingExpandedStateForPrint2    -bool true

# Save new documents to local drive by default.
defaults write -g NSDocumentSaveNewDocumentsToCloud -bool false

# Disable system-wide resume.
defaults write -g NSQuitAlwaysKeepsWindows -bool false

# Disable '.DS_Store' on network and USB drives.
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# Disable time machine using new drives for backup.
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true

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
