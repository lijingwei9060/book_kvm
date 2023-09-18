# buildroot 

download url：https://buildroot.org/download.html

make gcc libncurses-dev  g++ unzip bc bzip2


配置wget代理
vim ~/.wgetrc
https_proxy = http://172.20.48.1:51000
http_proxy = http://172.20.48.1:51000
use_proxy = on

配置git代理
vim ~/.gitconfig
[http]
        proxy = http://172.20.48.1:51000


export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/usr/lib/wsl/lib

tar -xvzf buildroot-2023.02.2.tar.gz
~/buildroot-2023.02.2$ 
make qemu_x86_64_defconfig
make menuconfig
make linux-menuconfig

make


qemu-system-x86_64 -kernel bzImage -hda rootfs.ext2 -append "root=/dev/sda rw console=ttyS0" --enable-kvm --nographic 


./scripts/clang-tools/gen_compile_commands.py -d .

vscode: 
1. add clangd plugin
2. config 

在已安装的Extension组件页选中clangd，点击图标旁边的齿轮打开设置页，User和Remote标签页中的Clangd Arguments都按照下面设置（点击Add Item，一个item输入下面的一行）

--compile-commands-dir=${workspaceFolder}
--background-index
--completion-style=detailed
--header-insertion=never
-log=info
--enable-config

添加.clangd在${workspaceFolder} //过滤clangd的告警


.clangd
CompileFlags:
  Remove: [-fconserve-stack, -fno-allow-store-data-races, -mfunction-return=thunk-extern, -mindirect-branch-cs-prefix, -mindirect-branch-register, -mindirect-branch=thunk-extern, -mskip-rax-setup, -mpreferred-stack-boundary=3, -mno-fp-ret-in-387]


.vscode/settings.json
{
    "files.exclude": {
        "**/*.cmd": true,
        "**/*.d": true,
        "**/*.S": true,
        "**/*.o": true,
        "**/*.a": true,
        "arch/[a-u]*": true,
        "arch/xtensa": true,
    },
    "[c]": {
        "editor.detectIndentation": false,
        "editor.tabSize": 8,
        "editor.insertSpaces": false,
        "editor.rulers": [80,100]
    },
    "files.associations": {
        "*.h": "c"
    }
}