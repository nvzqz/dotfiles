function codeman --wraps 'man' --description 'opens a manpage in vscode'
    catman $argv | code -
end
