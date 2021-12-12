# Setup Scripts

To initiate setup, run:

```sh
bash -c "$(curl -fsSL https://raw.githubusercontent.com/nvzqz/dotfiles/HEAD/setup/init.sh)"
```

This will run the following:
1. [`init.sh`](https://github.com/nvzqz/dotfiles/blob/HEAD/setup/init.sh)
  - On macOS, installs Xcode Command Line Tools in order to use `git`.
  - Once `git` is available, runs `git clone` on this repo into `~/.dotfiles`.
2. [`post-init.sh`](https://github.com/nvzqz/dotfiles/blob/HEAD/setup/post-init.sh)
    1. `source`s [`util.sh`](https://github.com/nvzqz/dotfiles/blob/HEAD/setup/util.sh)
    for utility functions.
    2. Configures SSH by generating a key pair and adding it to the SSH agent.
    3. Configures Git with
    4. On macOS, runs [`macos/init.sh`](https://github.com/nvzqz/dotfiles/blob/HEAD/setup/macos/init.sh).
      1. Runs [`macos/homebrew.sh`](https://github.com/nvzqz/dotfiles/blob/HEAD/setup/macos/homebrew.sh)
      to install various packages.
      2. Configures the system (TODO)
