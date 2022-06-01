# Enable "flathub" remote.
if ! flatpak remotes --columns=name | grep -q flathub; then
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    flatpak remote-modify --enable flathub
fi

FLATPAK_FEDORA_PKGS=(
    # Apps
    com.transmissionbt.Transmission
    org.gnome.Extensions
    org.gnome.FileRoller
    org.gnome.Geary
)

FLATPAK_FLATHUB_PKGS=(
    # Essentials
    com.discordapp.Discord
    com.slack.Slack
    com.spotify.Client
    md.obsidian.Obsidian
    org.signal.Signal
    org.telegram.desktop

    # Utilities
    org.wireshark.Wireshark

    # Audio
    com.github.wwmm.easyeffects # EQ
    org.pulseaudio.pavucontrol  # Volume
    org.rncbc.qpwgraph          # Redirect

    com.github.tchx84.Flatseal
    org.gnome.Boxes
)

FLATPAK_EXT_PKGS=(
    # com.onepassword.OnePassword
    https://downloads.1password.com/linux/flatpak/1Password.flatpakref
)

flatpak install fedora  -y "${FLATPAK_FEDORA_PKGS[@]}"
flatpak install flathub -y "${FLATPAK_FLATHUB_PKGS[@]}"

# flatpak install -y "${FLATPAK_EXT_PKGS[@]}"
