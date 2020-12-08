# Prepend home-relative dirs to PATH
set -gp fish_user_paths \
    "$HOME/bin" \
    "$HOME/.bin" \
    "$HOME/dotfiles/bin" \
    "$HOME/.dotfiles/bin" \
    "$HOME/.cargo/bin" \
    "$HOME/.rbenv/shims" \
    "$HOME/go/bin"

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
