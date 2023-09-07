
sudo apt install libncurses-dev flex bison openssl libssl-dev \
    dkms libelf-dev libudev-dev libpci-dev libiberty-dev autoconf
sudo apt install llvm lld libclang-dev

git clone https://github.com/torvalds/linux.git

cd linux
$ rustup override set $(scripts/min-tool-version.sh rustc)
$ rustup component add rust-src # Rust standard library source
$ cargo install --locked --version $(scripts/min-tool-version.sh bindgen) bindgen-cli

check again and make sure the toolchain is correct:
$ make LLVM=1 rustavailable

cp .github/workflows/kernel-x86_64-debug.config .config

make LLVM=1 -j$(nproc)

rustup component add rustfmt
rustup component add clippy