################################################################################
# Theme: Adwaita
#
# https://github.com/lassekongo83/adw-gtk3/releases/latest/
################################################################################

mkdir -p "$HOME/.themes"

if ! [[ -d "$HOME/.themes/adw-gtk3" ]]; then
    log_status 'Installing Adwaita GTK theme'

    ADW_TMP=$(mktemp -d)
    ADW_TAR='adw-gtk3v2-0.tar.xz'
    wget -P "$ADW_TMP" "https://github.com/lassekongo83/adw-gtk3/releases/download/v2.0/$ADW_TAR"
    tar -C "$HOME/.themes" -xvf "$ADW_TMP/$ADW_TAR" adw-gtk3 adw-gtk3-dark

    log_success 'Installed Adwaita GTK theme'
else
    log_skip "Installing Adwaita GTK theme: '$HOME/.themes/adw-gtk3' exists"
fi

gsettings set org.gnome.desktop.interface gtk-theme    adw-gtk3-dark
gsettings set org.gnome.desktop.interface icon-theme   Adwaita
gsettings set org.gnome.desktop.interface icon-theme   Adwaita
gsettings set org.gnome.desktop.interface cursor-theme Adwaita

# Flatpak isn't perfect at detecting our theme so we're exposing our local
# themes and then forcing a theme for GTK3 flatpak apps.
if exists flatpak; then
    flatpak override --user --filesystem=$HOME/.themes
    flatpak override --user --env=GTK_THEME=adw-gtk3-dark

    # Fix certain flatpak apps not using dark theme
    flatpak override --user org.gnome.TextEditor --unset-env=GTK_THEME
    flatpak override --user com.github.wwmm.easyeffects --unset-env=GTK_THEME
    flatpak override --user org.gnome.baobab --unset-env=GTK_THEME
fi

################################################################################
# Theme: Settings
################################################################################

gsettings set org.gnome.desktop.interface color-scheme prefer-dark

gsettings set org.gnome.desktop.interface font-name           'Noto Sans 11'
gsettings set org.gnome.desktop.interface document-font-name  'Noto Sans 11'
gsettings set org.gnome.desktop.interface monospace-font-name 'Fira Code 11'
gsettings set org.gnome.desktop.wm.preferences titlebar-font  'Noto Sans, Medium 11'

# Disable ambient light sensor.
gsettings set org.gnome.settings-daemon.plugins.power ambient-enabled false

# Disable middle click paste.
gsettings set org.gnome.desktop.interface gtk-enable-primary-paste false

# Touch to click.
gsettings set org.gnome.desktop.peripherals.touchpad click-method fingers

gsettings set org.gnome.desktop.interface            show-battery-percentage  true
gsettings set org.gnome.desktop.peripherals.touchpad disable-while-typing     false
gsettings set org.gnome.desktop.peripherals.touchpad natural-scroll           true
gsettings set org.gnome.desktop.wm.preferences       focus-mode               click
gsettings set org.gnome.desktop.wm.preferences       resize-with-right-button true

################################################################################
# Desktop Extensions
################################################################################

# Enable extentions.
gsettings set org.gnome.shell disable-user-extensions false

# Enable system tray.
# gnome-extensions enable appindicatorsupport@rgcjonas.gmail.com

################################################################################
# Custom Key Bindings
################################################################################

keybind_id=0
keybind_paths=()

# Comma-separated values for path, name, binding, and command.
keybind_settings=()

# keybind() {
#     local name=$1
#     local binding=$2
#     local command=$3

#     local path="org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom${keybind_id}/"
#     keybind_paths+=("$path")

#     keybind_settings+=("${path},${name},${binding},${command}")

#     ((keybind_id = keybind_id + 1))
# }

# register_keybind() {
#     local settings
#     IFS=',' read -r -a settings <<< "$1"

#     local path="${arr[0]}"
#     local name="${arr[1]}"
#     local binding="${arr[2]}"
#     local command="${arr[3]}"

#     gsettings set "$path" name "$name"
#     gsettings set "$path" binding "$binding"
#     gsettings set "$path" command "$command"
# }

# keybind 'Open Terminal' '<Super>Return' 'tilix'

# # Convert `keybind_paths` to comma-separated list.
# printf -v keybind_paths '%s, ' "${keybind_paths[@]}"
# keybind_paths="\"[$(echo "${keybind_paths%, }")]\""

# gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "$keybind_paths"

# for settings in "${keybind_settings[@]}"; do
#     register_keybind "$settings"
# done
