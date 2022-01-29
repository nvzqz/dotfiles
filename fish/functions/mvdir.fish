function mvdir --description 'move files into directories with the same names'
    for file in $argv
        set filename (basename $file)

        mv "$file" "$file.bak"
        mkdir -p "$file"

        mv "$file.bak" "$file/$filename"
    end
end
