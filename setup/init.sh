#!/bin/sh

################################################################################
# About
#
# The initial setup script.
#
# - Installs `git` if not installed. On macOS, this is through XC CLT.
# - Clones 'github.com/nvzqz/dotfiles' to `~/.dotfiles` if it doesn't exist.
# - Runs 'post-init.sh' to continue setup.
################################################################################

# Prevent execution if this script was only partially downloaded.
{

set -euo pipefail

################################################################################
# Utility Functions
#
# Copied from `util.sh`.
################################################################################

# ANSI styling (https://en.wikipedia.org/wiki/ANSI_escape_code#Description).
ANSI_CSI=$'\033['
STYLE_GREEN="${ANSI_CSI}0;32;1m"
STYLE_MAGENTA="${ANSI_CSI}0;35;1m"
STYLE_CYAN="${ANSI_CSI}0;36;1m"
STYLE_OFF="${ANSI_CSI}0m"

log_fatal() {
    echo "  ${STYLE_RED}fatal:${STYLE_OFF} $@"
    exit 1
}

log_success() {
    echo "${STYLE_GREEN}success:${STYLE_OFF} $@"
}

log_status() {
    echo " ${STYLE_MAGENTA}status:${STYLE_OFF} $@"
}

log_skip() {
    echo "   ${STYLE_CYAN}skip:${STYLE_OFF} $@"
}

################################################################################
# OS Detection
################################################################################

OS_IS_MACOS='false'
OS_IS_LINUX='false'

OS="$(uname)"
if [[ "${OS}" == "Darwin" ]]; then
    OS_IS_MACOS='true'
else
    log_fatal "The operating system '$OS' is not supported"
fi

################################################################################
# macOS: Install Xcode Command Line Tools for `git`
################################################################################

if $OS_IS_MACOS; then
    XC_CLT_BIN='/Library/Developer/CommandLineTools/usr/bin'
    GIT_PATH="$XC_CLT_BIN/git"

    if ! [[ -x "$GIT_PATH" ]]; then
        log_status 'Installing Xcode CLT…'
        /usr/bin/xcode-select --install

        # Wait until `git` exists.
        until [[ -x "$GIT_PATH" ]]; do
            sleep 2
        done

        log_success 'Installed Xcode CLT'
    else
        log_skip "Installing Xcode CLT; found '$GIT_PATH'"
    fi

    # Make Xcode CLT be found before other tools.
    export PATH="$XC_CLT_BIN:$PATH"
fi

################################################################################
# Finish Bootstrap Phase
#
# Clone 'dotfiles' repo and continue setup.
################################################################################

DOTFILES_PATH="$HOME/.dotfiles"
POST_INIT_PATH="$DOTFILES_PATH/setup/post-init.sh"

if ! [[ -f "$POST_INIT_PATH" ]]; then
    log_status "Cloning 'nvzqz/dotfiles' repo into '$DOTFILES_PATH'…"

    # Clone with HTTPS for now because an SSH key pair has not yet been created.
    # After setting up SSH, the remote URL will be updated to use SSH.
    "$GIT_PATH" clone https://github.com/nvzqz/dotfiles.git "$DOTFILES_PATH"
else
    log_skip "Cloning 'nvzqz/dotfiles' repo; found '$POST_INIT_PATH'"
fi

log_status "Running 'post-init.sh'…"
bash "$POST_INIT_PATH"

# End of partial download wrapping.
}
