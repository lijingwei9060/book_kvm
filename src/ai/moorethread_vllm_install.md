# support

1. MT:S80 / S3000 / S4000
2. OS: ubuntu 22.04 with intel cpu, because of iommu module
3. mudnn: [musa sdk rc3.1.0](https://docs.mthreads.com/musa-sdk/musa-sdk-doc-online/install_guide) 
4. torch_musa: [v1.3](https://github.com/MooreThreads/torch_musa/releases), download from release page
5. vllm_musa:[4.2](https://github.com/MooreThreads/vllm_musa)

## Setting for Hardware

1. setting resize bar to  ON
2. turn on " IOMMU（VT-d）" if memory size above 256G


## install

1. install driver
2. install musa toolkit
3. install mudnn

check device:
lspci -nn | grep 1ed5
sudo apt install lightdm (安装时，default display manager 选择 lightdm)
sudo apt install dkms (如果为非 dkms deb 包，可忽略该步骤)
sudo apt install libgbm1 libglapi-mesa


remove old driver: 
sudo dpkg -P musa
sudo rmmod mtgpu
lsmdo|grep mtgpu --check 

### install driver:
sudo dpkg -i musa_verison.deb
sudo reboot  // sudo modprobe -rv mtgpu && sudo modprobe mtgpu

add user: (logout is needed)
sudo usermod -aG render ${USER}
sudo usermod -aG video  ${USER}

check driver：
clinfo |grep "Platform Name" // Moore Threads OpenCL  will be returned
mthreads-gmi // run well

casoul@casoul-mt:~/MUSA+SDK-MUSA+SDK+rc3.1.0+/MT_Linux_Driver_2.7.0$ mthreads-gmi 
Mon Nov 11 16:07:07 2024
---------------------------------------------------------------
    mthreads-gmi:1.14.0          Driver Version:2.7.0
---------------------------------------------------------------
ID   Name           |PCIe                |%GPU  Mem            
     Device Type    |Pcie Lane Width     |Temp  MPC Capable    
                                         |      ECC Mode       
+-------------------------------------------------------------+
0    MTT S80        |00000000:04:00.0    |0%    2MiB(16384MiB)
     Physical       |4x(16x)             |49C   YES            
                                         |      N/A            
---------------------------------------------------------------

---------------------------------------------------------------
Processes:
ID   PID       Process name                         GPU Memory
                                                         Usage
+-------------------------------------------------------------+
   No running processes found
---------------------------------------------------------------


### install  MUSA Toolkit:
cd musa_toolkits_install
sudo ./install.sh -u # 先卸载环境已安装的musa
sudo ./install.sh # 以上两条命令非root用户需要sudo提权执行

export MUSA_INSTALL_PATH=/usr/local/musa
export PATH=$MUSA_INSTALL_PATH/bin:$PATH
export LD_LIBRARY_PATH=$MUSA_INSTALL_PATH/lib:$LD_LIBRARY_PATH

check musa:
$ musa_version_query
$ musaInfo

### muDNN install
tar -zxvf mudnn_rc2.7.0.tar.gz
cd mudnn
sudo ./install_mudnn.sh -i

export LD_LIBRARY_PATH=/usr/local/musa/lib:${LD_LIBRARY_PATH}

### MCCL install
原始的安装文有错误，这个是正确的

```shell
cd ./mccl
sudo ./install.sh -id /usr/local/musa

export LD_LIBRARY_PATH
```



## install torch/vllm


### install torch/ torch_musa

sudo apt install python-is-python3 python3-pip

setting pip source
```shell
vim ~/.pip/pip.conf

[global]
index-url = http://mirrors.aliyun.com/pypi/simple/

[install]
trusted-host=mirrors.aliyun.com
```

get [S80_S3000_torch_musa-1.3.0-cp310-cp310-linux_x86_64.whl](https://github.com/MooreThreads/torch_musa/releases/download/v1.3.0/S80_S3000_torch_musa-1.3.0-cp310-cp310-linux_x86_64.whl)
rename to torch_musa-1.3.0-cp310-cp310-linux_x86_64.whl (important)
pip install torch_musa-1.3.0-cp310-cp310-linux_x86_64.whl

get torch/torch_musa/torchvision/torchaudio from [torch_musa release](https://github.com/MooreThreads/torch_musa/releases)
```shell
pip install torch
pip install torch_musa
pip install torchvision
pip install torchaudio
```
use patched torch whl got from this repository, very important!!!!

check:
```python
import torch
import torch_musa

torch.musa.is_available()
torch.musa.device_count()
```
### build vllm

git clone https://github.com/MooreThreads/vllm_musa.git

vim requirements-common.txt 
change numpy to numpy < 2.0 // have no idea

remove torch =2.2.0 from requirement-build.txt requirement-musa.txt

sudo apt install libstdc++-12-dev

pip install -r requirements-build.txt
pip install -r requirements-musa.txt