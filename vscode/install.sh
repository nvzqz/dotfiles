#!/usr/bin/env bash

DIR="$(dirname "${BASH_SOURCE[0]}")"

if hash code > /dev/null; then
    if [[ "$(uname)" == "Darwin" ]]; then
        VSCODE_HOME="$HOME/Library/Application Support/Code"
    else
        VSCODE_HOME="$HOME/.config/Code"
    fi

    cp "$DIR/settings.json" "$VSCODE_HOME/settings.json"

    # Created with `code --list-extensions > extensions.txt`
    while read extension; do
        code --install-extension "$extension"
    done < "$DIR/extensions.txt"
fi
