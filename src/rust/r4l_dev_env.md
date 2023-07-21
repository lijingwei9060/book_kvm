sudo apt-get -y install \
        binutils build-essential libtool texinfo \
        gzip zip unzip patchutils curl git \
        make cmake ninja-build automake bison flex gperf \
        grep sed gawk bc \
        zlib1g-dev libexpat1-dev libmpc-dev \
        libglib2.0-dev libfdt-dev libpixman-1-dev \
        libelf-dev libssl-dev \
        clang-format clang-tidy clang-tools clang \
        clangd libc++-dev libc++1 libc++abi-dev libc++abi1 \
        libclang-dev libclang1 liblldb-dev libllvm-ocaml-dev \
        libomp-dev libomp5 lld lldb llvm-dev llvm-runtime llvm \
        python3-clang \
        qemu-system-x86 cpio 


git clone --depth=1 -b rust-e1000 https://github.com/fujita/linux.git fujita_linux
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --default-toolchain none 

rustup override set $(scripts/min-tool-version.sh rustc)
rustup component add rust-src
cargo install --locked --version $(scripts/min-tool-version.sh bindgen) bindgen
rustup component add rustfmt
rustup component add clippy

make LLVM=1 rustavailable


make LLVM=1 O=build x86_64_defconfig
# make LLVM=1 O=build kernel_config_patch.config
make LLVM=1 O=build -j4