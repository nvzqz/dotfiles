function sizeof --wraps='du' --description 'get size of files or directories'
    du -h -s $argv
end
