# https://github.com/thomcc/fish-cargo-completions

# Tab completion for cargo (https://github.com/rust-lang/cargo).
complete -e -c cargo

function __cargo_packages
    set -l manifest_path_arg
    if set -l manifest (__tcsc_command_opt_value manifest-path)
        set manifest_path_arg --manifest-path "$manifest"
    end
    cargo metadata --no-deps --format-version 1 $manifest_path_arg | jq -r ".packages[] | .name"
end

function __cargo_use_subcommand -d "like __fish_use_subcommand, but handles things like `cargo +nightly`"
    set -l cmd (commandline -poc)
    set -e cmd[1]
    for i in $cmd
        switch $i
            case '+*'
                continue
            case '-*'
                continue
        end
        return 1
    end
    return 0
end
# note: we avoid this intentionally for `cargo test`/`cargo bench` when completing past the --
function __cargo_seen_subcommand_from -d "like __fish_seen_subcommand_from but stops at `--`"
    set -l cmd (commandline -poc)
    set -e cmd[1]
    for i in $cmd
        if test "$i" = '--'
            return 1
        end
        if contains -- $i $argv
            return 0
        end
    end
    return 1
end

function __cargo_manifest_paths
    set -l input
    if test (count $argv) -gt 0
        set input $argv[1]
    else
        set input (commandline -ct)
    end
    set -l found
    set -l rx (string escape --style=regex "$PWD")
    if test -z "$input" || string match -vqr '^(~|\.\.|/)' -- "$input"
        set -l jqprog '.workspace_members[] | sub("^(?<name>[^ ]+) .*file://(?<path>.*?)\\\\)"; "\(.path)/Cargo.toml\t\(.name)")'
        if set -l metadata (cargo metadata  --no-deps --format-version 1 2> /dev/null)
            set -l pkgs (echo "$metadata" | jq -r $jqprog | string replace -r "^$rx/" "")
            set -a found $pkgs
        end
    end
    set -l dirs
    set -l paths $input*Cargo.toml $input*/Cargo.toml $input*/*/Cargo.toml
    for p in $input*
        if string match -qr 'Cargo.toml$' -- $p
            set -p paths $p
        end
    end
    set -l searched 0
    for f in $paths
        set searched (math $searched + 1)
        set -a found $f
    end
    if test "$searched" -eq 0
        set paths $input*/*/*/Cargo.toml
        for p in $paths
            set searched (math $searched + 1)
            set -a found $p
        end
    end
    if string match -qr '^\./' -- "$input"
        string join \n $found | sort -fs -k 1,1 -u -t \t
    else
        string replace -r '^\./' '' -- $found | string join \n | sort -fs -k 1,1 -u -t \t
    end
end

function __cargo_find_features
    set -l manifest_path_args
    if set -l manifest (__tcsc_command_opt_value manifest-path)
        set manifest_path_args --manifest-path "$manifest"
    end
    set -l mani (cargo locate-project $manifest_path_args | jq -r '.root' 2> /dev/null)
    if test "$mani" != ""
        set -l meta (cargo metadata --no-deps --format-version=1 $manifest_path_args 2>/dev/null)
        set -l query '.packages[] | select(.manifest_path == $mani) | .features | to_entries[] | .key | select(. != "default")'
        cargo metadata --no-deps --format-version=1 $manifest_path_args 2>/dev/null | jq --arg mani "$mani" -r $query
    end
end

function __cargo_toolchains
    set -l short
    set -l long
    for tc in (rustup toolchain list)
        set -l toolchain (string replace -r '\s+.*' '' -- $tc)
        if set -l parts (string match -r '(nightly|beta|stable|\d\.\d{1,2}\.\d)(-(\d{4}-\d{2}-\d{2}))?(-.*)' -- "$toolchain")
            if test -z "$parts[4]"
                set -a short "+$parts[2]"
            else
                set -a short "+$parts[2]-$parts[4]"
            end
        end
        set -a long "+$toolchain"
    end
    for tc in $short $long
        echo "$tc"
    end
end

function __cargo_need_toolchain
    if test (count (commandline -poc)) -gt 1
        return 1
    else
        return 0
    end
end

set __fish_cargo_subcommands (cargo --list | tail -n +2 | string trim | string replace -r '\s+' '\t')

complete -f -c cargo
complete -c cargo -s h -l help
complete -c cargo -n '__cargo_use_subcommand' -s V -l version -d 'Print version info and exit'
complete -c cargo -s v -l verbose -d 'Use verbose output'
complete -c cargo -s q -l quiet -d 'No output printed to stdout'

complete -c cargo -x -n '__cargo_seen_subcommand_from help' -a '$__fish_cargo_subcommands' -k
complete -c cargo -n '__cargo_use_subcommand' -l list -d 'List installed commands'

complete -c cargo -r -k -n '__cargo_need_toolchain' -a '(__cargo_toolchains)' -d 'choose toolchain'

complete -c cargo -f -n '__cargo_use_subcommand' -a '$__fish_cargo_subcommands' -k
complete -c cargo -x -n '__cargo_seen_subcommand_from help' -a '$__fish_cargo_subcommands' -k

set -l manifest_subcommands bench build check clippy clean doc fetch fix fmt generate_lockfile \
    help init install locate_project login metadata new owner package pkgid publish \
    read_manifest run rustc rustdoc search test tree uninstall update vendor \
    verify_project version yank

complete -c cargo -x -n "__cargo_seen_subcommand_from $manifest_subcommands" -l manifest-path -d 'manifest' -a '(__cargo_manifest_paths)'

# There's only one metadata format and no plans to change.
complete -c cargo -x -n "__cargo_seen_subcommand_from metadata" -l 'format-version=1' -d 'Use version 1 of metadata format'
complete -c cargo -f -n "__cargo_seen_subcommand_from metadata" -l 'no-deps' -d 'Use version 1 of metadata format'

complete -c cargo -x -n "__cargo_seen_subcommand_from bench build clean check doc fix test tree run rustc rustdoc clippy" -s p -l package -d 'Package to build' -a '(__cargo_packages)'
complete -c cargo -f -n "__cargo_seen_subcommand_from bench build clean check doc fix test tree run rustc rustdoc clippy fmt" -l all -d 'Operate on all packages in the workspace'
complete -c cargo -f -n "__cargo_seen_subcommand_from bench build clean check doc fix test tree run rustc rustdoc clippy" -l workspace -d 'Operate on all packages in the workspace'
complete -c cargo -x -n "__cargo_seen_subcommand_from bench build check clippy clean doc fix install package publish run rustc rustdoc test" -l target -d 'Build for the target triple' -a '(rustup target list --installed)'

complete -c cargo -x -n "__cargo_seen_subcommand_from run bench build rustc test check clippy fix" -l bin -d 'Only the specified binary' -a '(__cargo_find_output bin bin)'
complete -c cargo -x -n "__cargo_seen_subcommand_from run bench build rustc test check clippy fix" -l example -d 'Only the specified example' -a '(__cargo_find_output example examples)'
# cargo run {--test/--bench} isn't a thing
complete -c cargo -x -n "__cargo_seen_subcommand_from bench build rustc test check clippy fix" -l test -d 'Only the specified test target' -a '(__cargo_find_output test tests)'
complete -c cargo -x -n "__cargo_seen_subcommand_from bench build rustc test check clippy fix" -l bench -d 'Only the specified benchmark' -a '(__cargo_find_output bench benches)'

complete -c cargo -f -n "__cargo_seen_subcommand_from test build check clippy bench rustc fix" -l lib -d 'Only the package\'s library'
complete -c cargo -f -n "__cargo_seen_subcommand_from test build check clippy bench rustc fix" -l examples -d 'All examples'
complete -c cargo -f -n "__cargo_seen_subcommand_from test build check clippy bench rustc fix" -l bins -d 'All binaries'
complete -c cargo -f -n "__cargo_seen_subcommand_from test build check clippy bench rustc fix" -l tests -d 'All tests'
complete -c cargo -f -n "__cargo_seen_subcommand_from test build check clippy bench rustc fix" -l benches -d 'All benchmarks'
complete -c cargo -f -n "__cargo_seen_subcommand_from test build check clippy bench rustc fix" -l all-targets -d 'All build targets'
complete -c cargo -f -n "__cargo_seen_subcommand_from test" -l doc -d 'Test only the library\'s documentation'

# complete parameters passed right to libtest's runner. (In theory we could do
# this for cargo bench too, but it would be wrong for harness=false benches
# which are the common case, as they're all that can be used on stable rust
complete -c cargo -f -n "__cargo_seen_subcommand_from test && __fish_seen_subcommand_from '--'" -s h -l help -d 'Display help message (longer with --help)'
complete -c cargo -f -n "__cargo_seen_subcommand_from test && __fish_seen_subcommand_from '--'" -s q -l quiet -d 'Display only one character per test'
complete -c cargo -f -n "__cargo_seen_subcommand_from test && __fish_seen_subcommand_from '--'" -l 'test-threads=1' -d 'Use only one test thread'
complete -c cargo -rF -n "__cargo_seen_subcommand_from test && __fish_seen_subcommand_from '--'" -l logfile -d 'Specify path to log file'
complete -c cargo -x -n "__cargo_seen_subcommand_from test && __fish_seen_subcommand_from '--'" -l skip -d 'Skip tests whose names contains a filter'
complete -c cargo -f -n "__cargo_seen_subcommand_from test && __fish_seen_subcommand_from '--'" -l exact -d 'Exactly match filter'
complete -c cargo -f -n "__cargo_seen_subcommand_from test && __fish_seen_subcommand_from '--'" -l nocapture -d 'Don\'t capture stdout/stderr of each task'
complete -c cargo -x -n "__cargo_seen_subcommand_from test && __fish_seen_subcommand_from '--'" -l color -d 'Configure output coloring' -a "auto always never"
complete -c cargo -x -n "__cargo_seen_subcommand_from test && __fish_seen_subcommand_from '--'" -l format -d 'Configure output format' -a "pretty terse json"
complete -c cargo -f -n "__cargo_seen_subcommand_from test && __fish_seen_subcommand_from '--'" -l show-output -d 'Show captured stdout of successful tests'
# complete -c cargo -f -n "__cargo_seen_subcommand_from test bench && not __fish_seen_subcommand_from '--'" -a "--" -d 'Pass args to test runner'

complete -c cargo -n '__cargo_seen_subcommand_from bench build check clippy clean doc fix package publish run rustc rustdoc test' -l target-dir -d 'Target directory'
complete -c cargo -f -n "__cargo_seen_subcommand_from build check clippy clean doc fix run rustc rustdoc test" -l release -d 'Build artifacts in release mode, with optimizations'

complete -c cargo -f -n "__cargo_seen_subcommand_from bench test" -l no-run -d 'Compile but do not run'
complete -c cargo -f -n "__cargo_seen_subcommand_from bench test" -l no-fail-fast -d 'Run all regardless of failure'

complete -c cargo -x -n "__cargo_seen_subcommand_from bench build check clippy doc fix install package publish run rustc rustdoc test" -s j -l jobs -d 'Number of jobs to run in parallel'

complete -c cargo -x -n "__cargo_seen_subcommand_from bench build check clippy doc fix install metadata package publish run rustc rustdoc test tree" -l features -d 'Space-separated list of features to also build' -a '(__cargo_find_features)'
complete -c cargo -f -n "__cargo_seen_subcommand_from bench build check doc clippy fix install metadata package publish run rustc rustdoc test tree" -l no-default-features -d 'Do not build the `default` feature'
complete -c cargo -f -n "__cargo_seen_subcommand_from bench build check doc clippy fix install metadata package publish run rustc rustdoc test tree" -l all-features -d 'Build with all features'

complete -c cargo -x -n '__cargo_seen_subcommand_from new init' -l vcs -a 'none hg git fossil pijul' -d 'Specify a vcs to use'
complete -c cargo -f -n '__cargo_seen_subcommand_from new init' -l name -d "Package name"
complete -c cargo -f -n '__cargo_seen_subcommand_from new init' -l lib -d "Use a library template"
complete -c cargo -f -n '__cargo_seen_subcommand_from new init' -l bin -d "Use a binary (application) template"
complete -c cargo -x -n '__cargo_seen_subcommand_from new init' -l edition -d "Rust edition to use" -a "2018 2015"
# todo: completion for registries, i guess.
complete -c cargo -x -n '__cargo_seen_subcommand_from init install login new owner publish search yank' -l registry -d "Registry to use"

complete -c cargo -f -n '__cargo_seen_subcommand_from doc' -l no-deps -d 'Don\'t build documentation for dependencies'
complete -c cargo -f -n '__cargo_seen_subcommand_from doc' -l open -d 'Opens the docs in a browser after the operation'
complete -c cargo -f -n '__cargo_seen_subcommand_from doc' -l document-private-items -d 'Document private items'

complete -c cargo -r -n '__cargo_seen_subcommand_from owner' -s a -l add -d 'Login of a user to add as an owner'
complete -c cargo -r -n '__cargo_seen_subcommand_from owner' -s r -l remove -d 'Login of a user to remove as an owner'

complete -c cargo -r -n "__cargo_seen_subcommand_from owner publish search yank" -l index -d 'Registry index to use'
complete -c cargo -x -n "__cargo_seen_subcommand_from owner publish yank" -l token -d 'API token to use when authenticating'

complete -c cargo -n '__cargo_seen_subcommand_from package' -l no-verify -d 'Don\'t verify the contents by building them'
complete -c cargo -n '__cargo_seen_subcommand_from package' -l no-metadata -d 'Ignore warnings about a lack of human-usable metadata'

complete -c cargo -n '__cargo_seen_subcommand_from update' -l aggressive -d 'Force updating all dependencies of <name> as well'
complete -c cargo -x -n '__cargo_seen_subcommand_from update' -l precise -d 'Update a single dependency to exactly PRECISE'

complete -c cargo -x -n '__cargo_seen_subcommand_from yank' -l vers -d 'The version to yank or un-yank'
complete -c cargo -n '__cargo_seen_subcommand_from yank' -l undo -d 'Undo a yank, putting a version back into the index'

# todo: tired of trawling docs for updates here, didn't finish though
