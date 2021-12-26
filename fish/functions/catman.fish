function catman --wraps 'man' --description 'cats a manpage'
    man $argv | col -bx
end
