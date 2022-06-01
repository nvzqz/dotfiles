# Increase DNF speeds
sudo bash -c "echo -e '[main]\nmax_parallel_downloads=20\nfastestmirror=True' > /etc/dnf/dnf.conf"

DNF_PKGS=(
    # Essentials
    fish
    zsh
    openssl
    podman-compose
    wl-clipboard

    # Desktop Environment
    tilix
    gnome-shell-extension-appindicator

    # Utilities
    bpytop

    # Fonts
    fira-code-fonts
    roboto-fontface-fonts
)

sudo dnf groupinstall -y 'Development Tools'
sudo dnf install -y "${DNF_PKGS[@]}"

log_status "Setting shell to '/bin/fish'"
sudo usermod --shell '/bin/fish' "$USER"

log_status 'Symlinking fish config'
ln -sf "$HOME/.dotfiles/fish" "$HOME/.config/fish"

log_success "Set shell to '/bin/fish'"
