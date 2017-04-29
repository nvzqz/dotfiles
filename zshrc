#!/usr/bin/env zsh
# Zsh runcom file

# oh-my-zsh (https://github.com/robbyrussell/oh-my-zsh)
if [ -d "$HOME/.oh-my-zsh" ]; then
    # Path to oh-my-zsh installation
    fpath+=~/.zfunc
    export ZSH=$HOME/.oh-my-zsh

    # Theme
    ZSH_THEME="agnoster"

    # Other favorites:
    # "gianu"
    # "minimal"
    # "dst"
    # "lambda"
    # "bureau"

    # How often to auto-update (in days)
    export UPDATE_ZSH_DAYS=7

    # Enable command auto-correction
    ENABLE_CORRECTION="true"

    source $ZSH/oh-my-zsh.sh
fi

export PATH=/usr/local/bin:$PATH
export LANG=en_US.UTF-8

# Man syntax highlighting
man() {
    env \
        LESS_TERMCAP_mb=$'\e[1;31m' \
        LESS_TERMCAP_md=$'\e[1;31m' \
        LESS_TERMCAP_me=$'\e[0m' \
        LESS_TERMCAP_se=$'\e[0m' \
        LESS_TERMCAP_so=$'\e[1;44;33m' \
        LESS_TERMCAP_ue=$'\e[0m' \
        LESS_TERMCAP_us=$'\e[1;32m' \
            man "$@"
}

exists() {
    type "$1" > /dev/null ;
}

#Aliases
alias ls='ls --color=always'
alias a='ls -A'
alias e='$EDITOR'
alias please='sudo $(fc -ln -1)'
alias netup='sudo ifconfig en0 up'
alias netdown='sudo ifconfig en0 down'

# Rust
export PATH="$PATH:$HOME/.cargo/bin"
if exists rustc; then
    export RUST_SRC_PATH="$(rustc --print sysroot)/lib/rustlib/src/rust/src"
fi

# Go
export GOPATH="$HOME/go"
export PATH="$PATH:$GOPATH/bin:/usr/local/opt/go/libexec/bin"

# Haskell
export PATH="$HOME/Library/Haskell/bin:$PATH"

# Swift
if which swiftenv > /dev/null; then eval "$(swiftenv init -)"; fi

# OS-specific settings:
UNAME=`uname`

if [[ "$UNAME" == "Darwin" ]]; then
    #---------------------------------------------------------------------------
    # ~~~~~ macOS ~~~~~
    #---------------------------------------------------------------------------

    # ZSH syntax highlighting
    source '/usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh'

    # Add coreutils to PATH
    export PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"

    # Set editor to Visual Studio Code
    export EDITOR='code'

    # brew cask options
    export HOMEBREW_CASK_OPTS="--appdir=/Applications"

    # Android Studio
    export ANDROID_HOME=/usr/local/opt/android-sdk
    export STUDIO_JDK=/Library/Java/JavaVirtualMachines/jdk1.8.0_25.jdk

    # Hide/show desktop
    alias hidedesktop='defaults write com.apple.finder CreateDesktop false; killall Finder'
    alias showdesktop='defaults write com.apple.finder CreateDesktop true; killall Finder'

    # Remove all '.DS_Store' files in the current directory
    alias rmds='find . -name ".DS_Store" -delete'

    # App shortcuts
    alias chrome='open -a "Google Chrome"'
    alias safari='open -a "Safari"'
    alias xcode='open -a "Xcode"'
    alias preview='open -a "Preview"'

    # Current date for sparkle appcast
    alias appcastdate='date --rfc-2822'

elif [[ "$UNAME" == "Linux" ]]; then
    #---------------------------------------------------------------------------
    # ~~~~~ Linux ~~~~~
    #---------------------------------------------------------------------------

    if [[ "$(cat /proc/sys/kernel/osrelease)" =~ .*Microsoft.* ]]; then
        #-----------------------------------------------------------------------
        # ~~~~~ Linux on Windows ~~~~~
        #-----------------------------------------------------------------------

        # Run windows command using cmd.exe
        alias wcmd='/mnt/c/Windows/System32/cmd.exe /C'

        # VS Code
        alias code='wcmd code'

    else
        alias screenfetch='screenfetch -st'
    fi

    # ZSH syntax highlighting
    source "$HOME/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

fi
