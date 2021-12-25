function pidpath --description 'paths for process IDs'
    for pid in $argv
        ps -ww -o comm= -p $pid
    end
end
