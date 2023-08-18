# vga

QEMU+KVM的虚拟化环境中，系统启动执行SeaBIOS对系统设备进行初始化，包括VGA设备。为了能够让VGA能够显示处图像（显卡在系统中一般是以PCI设备的形式出现在系统中，然后显示器通过VGA线连接到显卡上）。SeaBIOS会在较早的时候，即枚举完系统的PCI设备后，就去将显卡的PCI Option ROM读取出来，然后执行，显卡的PCI Option ROM会对显卡进行初始化，并且会注册中断0x10相应的中断处理函数，0x10中断用于处理跟显卡相关的事件，如切换显卡的工作模式，显示图像等等。当注册了中断0x10处理函数后，SeaBIOS就可以通过该中断调用显示图像了，并且在OS启动的早期阶段（显卡驱动未加载的时候），OS也可以通过该方法进行图像显示，直到OS加载完显卡驱动。这种方法相对于OS下的显卡驱动，工作效率应该会比较慢，但是简单直接，而且看样子有统一的接口。

# vnc server

1. 显卡，即VNC Server提供的图像所对应的显卡，可以是qxl显卡，也可以是cirrus等，这是VNC Server图像的来源。
2. VncDisplay，即QEMU中定义的代表一个VNC Server的结构体，即一个VncDisplay代表一个VNC Server。全局变量vnc_displays保存所有vnc display。
3. VncState，即VNC Server中针对每个VNC Client保存的一个状态信息。包含socket接口，编码格式，vnc客户端属性，事件通知函数。
4. VncClient，即对应到VNC客户端
5. VNCJobQueue，即VNC Server中用于存放更新VNC客户端的工作队列，用于显卡设备提供数据给VNCServer的队列(VNCJob)。VNCJob包含一个VncState指针和一个VncRectEntry的列表，表示选哟更新的矩形块。
