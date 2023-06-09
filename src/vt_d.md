现有的IO过程是通过PIO或者MMIO方式进行读写，有vmx non-root模式陷入到KVM或者qemu，然后再模拟IO操作，将结果返回给guest。这个过程存在内存多次移动或者IO的模拟过程，最理想的情况是Guest可以直接和对应的设备打交道，同时满足安全性要求，比如不能越界或者逃逸等。virtio是另外一种IO过程，本质和前面的过程一样。

vt-d的引入新的硬件IOMMU以及IRQ remapping、DMA remapping，实现对不同Guest IO地址空间的隔离以及Guest可以直接和物理设备通信。VT-d技术通过在北桥（MCH）引入DMA重映射硬件（IOMMU），以提供设备重映射和设备直接分配的功能。在启用VT-d的平台上，设备所有的DMA传输都会被DMA重映射硬件截获。根据设备对应的I/O页表，硬件可以对DMA中的地址进行转换，使设备只能访问到规定的内存。