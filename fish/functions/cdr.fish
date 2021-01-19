function cdr --wraps='cd' --description 'cd Change to realpath of directory'
    set -l destination $argv[1]
    if set -q $destination
        set destination '.'
    end

    cd (realpath "$destination")
end
