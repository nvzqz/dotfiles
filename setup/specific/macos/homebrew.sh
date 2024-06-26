# Packages from https://github.com/Homebrew/homebrew-core.
HOMEBREW_FORMULAE=(
    coreutils
    exiftool
    ffmpeg
    fish
    fossil
    gnutls
    jq
    mas
    nmap
    openjdk
    pngquant
    subversion
    wget
    woff2
    youtube-dl
    zig
    zopfli
    zstd
)

# Packages from https://github.com/Homebrew/homebrew-cask.
HOMEBREW_CASKS=(
    1password
    dash
    discord
    dotnet
    firefox
    glyphs
    google-chrome
    iina
    istat-menus
    iterm2
    keepingyouawake
    mactex
    notion
    obsidian
    plex
    postman
    scroll-reverser
    signal
    sketch
    slack
    soundsource
    spotify
    the-unarchiver
    transmission
    unicodechecker
    visual-studio-code
    wwdc
    zoom
    zulip
)

# Fonts from https://github.com/Homebrew/homebrew-cask.
HOMEBREW_CASK_FONTS=(
    bree-serif
    carter-one
    fira-code
    fira-mono
    flow-block
    flow-circular
    flow-rounded
    gabriela
    kiwi-maru
    kurale
    lora
    marko-one
    merriweather
    merriweather-sans
    new-tegomin
    poiret-one
    roboto
    roboto-flex
    roboto-mono
    roboto-slab
    zilla-slab
)

# All packages concatenated, giving casks the appropriate prefixes.
HOMEBREW_PKGS=(
    "${HOMEBREW_FORMULAE[@]}"
    "${HOMEBREW_CASKS[@]/#/homebrew/cask/}"
    "${HOMEBREW_CASK_FONTS[@]/#/homebrew/cask/font-}"
)

HOMEBREW_PKG_COUNT="${#HOMEBREW_PKGS[@]}"

HOMEBREW_PATH="$(which brew || echo '/opt/homebrew/bin/brew')"

if ! [[ -x "$HOMEBREW_PATH" ]]; then
    log_status "Installing Homebrew…"
    bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    log_success 'Installed Homebrew'
else
    log_skip "Installing Homebrew; found at '$HOMEBREW_PATH'"
fi

eval "$("$HOMEBREW_PATH" shellenv)"

log_status "Installing $HOMEBREW_PKG_COUNT Homebrew packages…"

"$HOMEBREW_PATH" install "${HOMEBREW_PKGS[@]}"

log_success "Installed $HOMEBREW_PKG_COUNT Homebrew packages"
