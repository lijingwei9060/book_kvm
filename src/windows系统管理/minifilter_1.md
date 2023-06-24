# 加载

在Windows系统中使用SC或net start命令加载MiniFilter驱动程序。例如，在命令提示符中输入：sc create minifilter binPath= "C:\MyDriver.sys" type= kernel。

在注册表中添加MiniFilter驱动程序信息，以使得Windows系统能够自动加载驱动程序。具体操作为在注册表中添加以下键值：HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\驱动程序名称。

在系统启动时自动加载MiniFilter驱动程序，可以使用Windows服务的方式实现。具体操作为在Windows服务管理器中创建一个Windows服务，并将MiniFilter驱动程序作为服务的启动项，使得Windows系统在启动时自动加载驱动程序。

需要注意的是，加载MiniFilter驱动程序需要管理员权限，否则无法成功加载驱动程序。

(fltmc load, FltLoadFilter, or FilterLoad).

##  DriverEntry
驱动入口可作为初始化的地点

1. `FltRegisterFilter` to register callback routines with the filter manager
2. `FltStartFiltering` to notify the filter manager that the minifilter driver is ready to start attaching to volumes and filtering I/O requests.
3. `InstanceSetupCallback` volume可用，可能在  `FltStartFiltering` 之前(系统启动加载filter driver)也可能在运行中 (fltmc attach, FltAttachVolume, or FilterAttach)。
4. `InstanceTeardownStartCallback` ：开始下线，包括umount 磁盘，volume，通过 (fltmc detach, FltDetachVolume, or FilterDetach)
5. `InstanceTeardownCompleteCallback`
6. 卸载驱动 (fltmc unload, FltUnloadFilter, or FilterUnload)，收到`FilterUnloadCallback`调用，关闭通讯端口，调用` FltUnregisterFilter`



## IRP

IRP（I/O请求数据包）是Windows操作系统中用于进行I/O（输入/输出）操作的一种数据结构。它是I/O请求的核心，其中包含了操作的详细信息和请求的状态。IRP最初由驱动程序发送给系统内核，然后内核将其传递给适当的设备驱动程序进行处理。

IRP主要包括以下几个部分：

主体：主要用于描述I/O请求的基本信息，包括请求的类型（例如，读、写、发送和接收等）、请求的长度、缓冲区指针和处理程序等。
呈现缓冲区：用于存储数据，其中包括要读入或写出的数据。
命令缓冲区：当执行命令时，用于在驱动程序之间传递数据的缓冲区。


用minifilter备份数据需要注册一些I/O请求数据包（IRP）。其中比较重要的IRP包括：

IRP_MJ_CREATE：当文件被创建时处理IRP请求。
IRP_MJ_WRITE：当文件被写入时处理IRP请求。
IRP_MJ_CLOSE：当文件关闭时处理IRP请求。
IRP_MJ_CLEANUP：当一个进程被终结时清除IRP请求。


## communication

The filter manager provides the following support routines for kernel-mode minifilter drivers to communicate with user-mode applications:

FltCloseClientPort

FltCloseCommunicationPort

FltCreateCommunicationPort

FltSendMessage

The following support routines are provided for user-mode applications to communicate with minifilter drivers:

FilterConnectCommunicationPort

FilterGetMessage

FilterReplyMessage

FilterSendMessage