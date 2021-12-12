SCRIPT_DIR="$(cd -- "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd -P)"

source "$SCRIPT_DIR/homebrew.sh"
source "$SCRIPT_DIR/prefs.sh"

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

################################################################################
# Rust
################################################################################

# Install Rust with the given targets.

if $OS_IS_MACOS; then
    RUST_MACOS_TARGETS=(
        aarch64-apple-darwin
        aarch64-apple-ios
        aarch64-apple-ios-sim
        x86_64-apple-ios
    )
fi

RUST_TARGETS=(
    x86_64-apple-darwin
    x86_64-pc-windows-msvc
    x86_64-unknown-linux-gnu

    ${RUST_MACOS_TARGETS[@]:-}
)

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- \
    -y \
    -t "${RUST_TARGETS[@]}"

# Install Rust crates with optimizations for the current CPU.

RUST_CRATES=(
    bat
    exa
    fcp
    fd-find # fd
    ripgrep # rg
    starship
    tokei
)

RUSTFLAGS='-C target-cpu=native' "$HOME/.cargo/bin/cargo" install "${RUST_CRATES[@]}"
