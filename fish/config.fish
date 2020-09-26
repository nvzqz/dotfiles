# Prepend home-relative dirs to PATH
set -gp fish_user_paths \
    "$HOME/bin" \
    "$HOME/.bin" \
    "$HOME/dotfiles/bin" \
    "$HOME/.dotfiles/bin" \
    "$HOME/.cargo/bin" \
    "$HOME/.rbenv/shims" \
    "$HOME/go/bin"

if exists starship
    starship init fish | source
end

if exists exa
    alias ls 'exa'
end

if exists fnm
    fnm env --fish --multi | source
end
