
sudo apt install libncurses-dev flex bison openssl libssl-dev \
    dkms libelf-dev libudev-dev libpci-dev libiberty-dev autoconf
sudo apt install llvm lld libclang-dev clang
sudo apt install make gcc libncurses-dev  g++ unzip bc bzip2

根据https://rsproxy.cn/#getStarted 安装rust

git clone https://github.com/torvalds/linux.git

cd linux
$ rustup override set $(scripts/min-tool-version.sh rustc)
$ rustup component add rust-src # Rust standard library source
$ cargo install --locked --version $(scripts/min-tool-version.sh bindgen) bindgen-cli

check again and make sure the toolchain is correct:
$ make LLVM=1 rustavailable

make menuconfig

```shell
General setup 
    -> enable rust

Kernel hacking
    -> Sample kernel code
        -> Rust samples
```



make LLVM=1 -j$(nproc)

rustup component add rustfmt
rustup component add clippy

make LLVM=1 rust-analyzer


