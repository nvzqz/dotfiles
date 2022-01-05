#!/usr/bin/env bash

################################################################################
# About
#
# The setup script run after `init.sh` has `git clone` the dotfiles repo.
################################################################################

set -euo pipefail

realpath() {
    cd -- "$1" &>/dev/null && pwd -P
}

readonly SCRIPT_DIR="$(realpath "$(dirname "${BASH_SOURCE[0]}")")"

cd "$SCRIPT_DIR/.."

source "$SCRIPT_DIR/util.sh"

################################################################################
# OS Detection
#
# This is run again so that this script can be run standalone for debugging.
################################################################################

OS_IS_MACOS='false'
OS_IS_LINUX='false'

OS="$(uname)"
if [[ "${OS}" == 'Darwin' ]]; then
    OS_IS_MACOS='true'
else
    log_fatal "The operating system '$OS' is not supported"
fi

################################################################################
# Config Variables
################################################################################

USER_NAME='Nikolai Vazquez'
USER_EMAIL='hello@nikolaivazquez.com'

################################################################################
# SSH Config
################################################################################

SSH_ALGO='ed25519'
SSH_KEY_PATH="$HOME/.ssh/id_$SSH_ALGO"
SSH_CONFIG_PATH="$HOME/.ssh/config"

if ! [[ -f "$SSH_KEY_PATH" ]]; then
    echo "$SSH_KEY_PATH"

    log_status $'Generating SSH key…\a'
    ssh-keygen -f "$SSH_KEY_PATH" -t "$SSH_ALGO" -C "$USER_EMAIL"

    eval "$(ssh-agent -s)"

    if $OS_IS_MACOS; then
        APPLE_SSH_ADD_BEHAVIOR='macos' /usr/bin/ssh-add -K "$SSH_KEY_PATH"
    else
        ssh-add "$SSH_KEY_PATH"
    fi

    log_success 'Generated SSH key and added it to `ssh-agent`'
else
    log_skip "SSH setup; found '$SSH_KEY_PATH'"
fi

# `ssh-add -K` does not persist unless the config enables the keychain.
SSH_CONFIG_MACOS=$(cat <<EOF
Host *
  UseKeychain yes
EOF
)

if $OS_IS_MACOS; then
    if ! [[ -f "$SSH_CONFIG_PATH" ]]; then
        log_status 'Enabling keychain for SSH…'
        echo "$SSH_CONFIG_MACOS" > "$SSH_CONFIG_PATH"
        log_success 'Enabled keychain for SSH'
    else
        log_skip "Enabling keychain for SSH; found '$SSH_CONFIG_PATH'"
    fi
fi

################################################################################
# Git Config
################################################################################

log_status 'Configuring `git`…'

git config --global user.name  "$USER_NAME"
git config --global user.email "$USER_EMAIL"

git config --global core.editor 'code --wait'
git config --global init.defaultbranch main

# Use SSH for dotfiles repo.
git remote set-url origin 'git@github.com:nvzqz/dotfiles.git'

log_success 'Configured `git`'

################################################################################
# Platform-Specific Init
################################################################################

if $OS_IS_MACOS; then
    source "$SCRIPT_DIR/specific/macos/init.sh"
fi

# TODO:
# - Run macOS setup
#   - User defaults
#   - App associations for file extensions
# - Run VSCode setup
# - Sync configs from dotfiles
# - Log message to add Git private key

if $OS_IS_MACOS; then
    # cat "$SSH_KEY_PATH.pub" | pbcopy
    log_todo "Add public key '$SSH_KEY_PATH.pub' to GitHub: https://github.com/settings/ssh/new"
fi

################################################################################
# Dev Config
################################################################################

source "$SCRIPT_DIR/specific/rust.sh"
