# `code` is slow to run, so mimic it through `open`.
if test "$EDITOR" = 'code' && test (uname -s) = Darwin
    function e
        open -a 'Visual Studio Code' -- $argv
    end
    return
end

function e --wraps='$EDITOR' --description 'open with "$EDITOR"'
    "$EDITOR" $argv
end
