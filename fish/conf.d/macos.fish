if not test (uname -s) = Darwin
    exit
end

function pbsort --description 'sort lines in pasteboard'
    pbpaste $argv | sort | pbcopy
end

function pbuniq --description 'sort and deduplicate lines in pasteboard'
    pbpaste $argv | sort | uniq | pbcopy
end

function finderdefaults --description 'set value for Finder\'s user defaults'
    defaults write com.apple.finder $argv[1] $argv[2] && killall Finder
end

function hidedesktop --wraps 'finderdefaults' --description 'hide items in desktop'
    finderdefaults CreateDesktop false
end

function showdesktop --wraps 'finderdefaults' --description 'reveal items in desktop'
    finderdefaults CreateDesktop true
end

function showfiles --wraps 'finderdefaults' --description 'show hidden files in Finder'
    finderdefaults AppleShowAllFiles true
end

function hidefiles --wraps 'finderdefaults' --description 'hide hidden files in Finder'
    finderdefaults AppleShowAllFiles false
end

function joinpdf --description 'join PDFs together'
    '/System/Library/Automator/Combine PDF Pages.action/Contents/Resources/join.py' $argv
end

function rmds --description 'remove all .DS_Store files in current directory'
    find . -name .DS_Store -delete
end

function netup --description 'enable network connectivity on en0'
    networksetup -setairportpower en0 on
end

function netdown --description 'disable network connectivity on en0'
    networksetup -setairportpower en0 off
end

function chscreen
    defaults write com.apple.screencapture location (realpath $argv[1]) && killall SystemUIServer
end

# 1st party apps
alias safari 'open -a Safari'
alias terminal 'open -a Terminal'
alias xcode 'open -a Xcode'
alias fontbook 'open -a \'Font Book\''
alias pages 'open -a Pages'
alias quicktime 'open -a \'QuickTime Player\''
alias textedit 'open -a TextEdit'

# 3rd party apps
alias iterm 'open -a iTerm'
alias dash 'open -a Dash'
alias hopper 'open -a \'Hopper Disassembler v4\''
alias paintcode 'open -a PaintCode'
alias iina 'open -a IINA'
alias spotify 'open -a Spotify'
alias slack 'open -a Slack'
alias discord 'open -a Discord'
alias notion 'open -a Notion'
alias steam 'open -a Steam'
alias telegram 'open -a Telegram'
alias firefox 'open -a Firefox'
alias chrome 'open -a \'Google Chrome\''
alias glyphs 'open -a Glyphs'
alias sketch 'open -a Sketch'
alias zulip 'open -a Zulip'
