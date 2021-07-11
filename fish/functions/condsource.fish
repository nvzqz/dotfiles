function condsource --wraps='source' --description 'conditionally source a file if it exists'
    for arg in $argv
        if test -e $arg
            source $arg
        end
    end
end
