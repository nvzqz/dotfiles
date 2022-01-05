readonly MACOS_SCRIPT_DIR="$(cd -- "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd -P)"

source "$MACOS_SCRIPT_DIR/homebrew.sh"
source "$MACOS_SCRIPT_DIR/prefs.sh"

################################################################################
# Set Shell to Fish
################################################################################

if $OS_IS_MACOS; then
    FISH_PATH='/opt/homebrew/bin/fish'
else
    log_todo "Get path to 'fish'"
fi

SHELLS_PATH='/etc/shells'

if $OS_IS_MACOS; then
    USER_SHELL="$(dscl . -read "$HOME"  UserShell | sed 's/UserShell: //')"
else
    log_todo 'Get user shell to skip setting shell'
fi

if [[ "$USER_SHELL" != "$FISH_PATH" ]]; then
    if [[ -f "$SHELLS_PATH" ]]; then
        log_status "Setting shell to '$FISH_PATH'"

        # Make shell usable if not already.
        if ! grep -Fq "$FISH_PATH" "$SHELLS_PATH"; then
            echo "$FISH_PATH" | sudo tee -a "$SHELLS_PATH"
        fi

        chsh -s "$FISH_PATH"
        log_success "Set shell to '$FISH_PATH'"
    else
        log_warning "Cannot set shell; missing '$SHELLS_PATH'"
    fi
else
    log_skip "Setting shell to '$FISH_PATH'"
fi
