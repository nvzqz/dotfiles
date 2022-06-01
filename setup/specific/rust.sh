# Install Rust with the given targets.

if $OS_IS_MACOS; then
    RUST_MACOS_TARGETS=(
        aarch64-apple-darwin
        aarch64-apple-ios
        aarch64-apple-ios-sim
        x86_64-apple-ios
    )
fi

RUST_TARGETS=(
    x86_64-apple-darwin
    x86_64-pc-windows-msvc
    x86_64-unknown-linux-gnu

    ${RUST_MACOS_TARGETS[@]:-}
)

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- \
    -y \
    -t "${RUST_TARGETS[@]}"

# Install Rust crates with optimizations for the current CPU.

RUST_CRATES=(
    bat
    exa
    fcp
    fd-find # fd
    ripgrep # rg
    starship
    tokei

    cargo-bloat
    cargo-expand
)

# Run the installation either in the Silverblue 'dev' toolbox or on the host.
CARGO_INSTALL_CMD=(
    "$HOME/.cargo/bin/cargo" install "${RUST_CRATES[@]}"
)

if "${OS_IS_SILVERBLUE:-false}"; then
    # FIXME: Pass `RUSTFLAGS` env var.
    tb_run "${CARGO_INSTALL_CMD[@]}"
else
    RUSTFLAGS='-C target-cpu=native' "${CARGO_INSTALL_CMD[@]}"
fi
