# Prepend system dirs to PATH.
set -gp fish_user_paths \
    '/usr/local/bin' \
    '/usr/bin' \
    '/bin' \
    '/usr/sbin' \
    '/sbin' \

# Prepend Homebrew to PATH.
set -gp fish_user_paths /opt/homebrew/bin

# Prepend home-relative dirs to PATH. These have priority over the system dirs.
set -gp fish_user_paths \
    "$HOME/bin" \
    "$HOME/.bin" \
    "$HOME/dotfiles/bin" \
    "$HOME/.dotfiles/bin" \
    "$HOME/.cargo/bin" \
    "$HOME/.rbenv/shims" \
    "$HOME/go/bin"

set -l DEV_TOOLS_DIR "$HOME/dev/tools"

set -gx ASDF_DATA_DIR "$DEV_TOOLS_DIR/asdf"

# https://starship.rs
if exists starship
    starship init fish | source
end

# https://the.exa.website
if exists exa
    alias ls 'exa'
end

# https://github.com/Schniz/fnm
if exists fnm
    fnm env | source
end

if exists brew
    # asdf
    condsource (brew --prefix asdf)/asdf.fish
end
