readonly LINUX_SCRIPT_DIR="$(cd -- "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd -P)"

OS_IS_FEDORA='false'
OS_IS_SILVERBLUE='false'

LINUX_RELEASE_INFO=$(cat /etc/*-release)

# Checks if `LINUX_RELEASE_INFO` contains a key/value-glob pair.
release_contains() {
    local key="$1"
    local value="$2"

    [[ "$(echo "$LINUX_RELEASE_INFO" | grep "${key}=" | head -n 1)" == *"$value"* ]]
}

if release_contains NAME Fedora; then
    OS_IS_FEDORA='true'
fi

if release_contains VARIANT Silverblue; then
    OS_IS_SILVERBLUE='true'
fi

if exists flatpak; then
    log_status 'Setting up Flatpak packages'
    source "$LINUX_SCRIPT_DIR/flatpak.sh"
    log_success 'Set up Flatpak packages'
fi

if $OS_IS_SILVERBLUE; then
    log_status 'Setting up Fedora Silverblue installation'
    source "$LINUX_SCRIPT_DIR/silverblue.sh"
    log_success 'Set up Fedora Silverblue installation'
elif $OS_IS_FEDORA; then
    log_status 'Setting up Fedora installation'
    source "$LINUX_SCRIPT_DIR/fedora.sh"
    log_success 'Set up Fedora installation'
fi

if [[ "${DESKTOP_SESSION:-}" == 'gnome' ]]; then
    log_status 'Setting up GNOME desktop environment'
    source "$LINUX_SCRIPT_DIR/gnome.sh"
    log_success 'Set up GNOME desktop environment'
fi
