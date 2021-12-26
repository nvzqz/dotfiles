function pidpath --description 'paths for process IDs'
    for pid in $argv
        which (ps -ww -o comm= -p $pid)
    end
end
