function gi --description 'download from gitignore.io to stdout'
    curl -fL "https://www.gitignore.io/api/"(string join ',' $argv)
end
