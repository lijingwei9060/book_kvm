
git clone https://github.com/torvalds/linux.git

cd linux
$ rustup override set $(scripts/min-tool-version.sh rustc)
$ rustup component add rust-src # Rust standard library source
$ cargo install --locked --version $(scripts/min-tool-version.sh bindgen) bindgen-cli --force

check again and make sure the toolchain is correct:
$ make LLVM=1 rustavailable

make LLVM=1 menuconfig

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



./scripts/clang-tools/gen_compile_commands.py -d .

## 安装驱动
sudo make modules_install INSTALL_MOD_PATH=/home/casoul/buildroot-2023.08.1/output/images/mnt