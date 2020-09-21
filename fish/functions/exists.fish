function exists --description 'determine if commands are defined'
    for arg in $argv
        if not type -q "$arg"
            return 1
        end
    end
end
