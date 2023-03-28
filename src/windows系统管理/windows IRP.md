
本发明的一致点捕获时机可根据用户策略定义。一致点捕获驱动捕获所有文件 层的IRP，通过IRP中操作类型来决定一致点插入时机和一致点内容。IRP是Windows内 核中的一种非常重要的数据结构。上层应用程序与底层驱动程序通信时，应用程序会发出 I/O请求，操作系统将相应的I/O请求转换成相应的IRP，不同的IRP会根据类型被分派到 不同的派遣例程中进行处理。文件I/O的相关函数，例如创建文件（CreateFile)、读文件 (ReadFile)、写文件（WriteFile)、（关闭文件句柄CloseHandle)等分别会引发操作系统产 生创建文件型 IRP(IRP_MJ_CREATE)、读文件型 IRP (IRP_MJ_READ)、写文件型 IRP(IRP_MJ_ WRITE)、关闭文件型IRP(IRP_MJ_CLOSE)等不同类型的IRP，这些IRP会被传送到驱动程序 的相应派遣例程中进行处理。

1、弱一致检查点IRP (Checkpoint IRP)。在单个文件`关闭`、`删除`和`重命名`等操作时写入，一致性的支持粒度为文件。弱一致Checkpoint IRP通过分析`IRP_MJ_CL0SE`和设为文件信息型IRP(`IRP_SET_INFORMATION`)两种类型的IRP产生。上层应用在关闭文件句柄时调用系统调用CloseHandle方法，CloseHandle向文件系统发送`IRP_MJ_CL0SE`类型的IRP。 一致点插入驱动通过分析`IRP_MJ_CL0SE`类型IRP中关联的文件信息判断是用户感兴趣的 文件类型或文件保护目录，如果是则插入一个封装弱一致IRP后随同上层`IRP_MJ_CL0SE`类型的IRP发往文件系统。对`IRP_SET_INF0RMATI0N`类的IRP，一致点捕获驱动只对次功能类型为删除、重命名和修改属性的IRP产生弱一致Checkpoint IRP,而对次功能类型为`剪切`和`修改文件指针`的操作不产生弱一致Checkpoint IRP。操作来源上层调用捕获`IRP—MJ—CREATE` 创建、打开文件 CreateFile 一致点捕获驱动处 理`IRP—MJ—CLEANUP` 在关闭句柄时取消悬挂的 IRP CloseHandle 不处理`IRP—MJ—CLOSE` 关闭文件句柄 CloseHandle 一致点捕获驱动处 理`IRP—SET—INFORMATION` 删除、重命名、修改属性、剪切、 修改文件指针。 SetFileLength 一致点捕获驱动部 分处理`IRP—MI—WRITE` 写入数据 WriteFile 镜像驱动处理`IRP—MJ—FLUSH—BUFFERS` 写输出缓冲区或丢弃输入缓冲 区 FlushFileBuffers 不处理

2、强一致Checkpoint IRP。在被保护的目录所有打开的文件都关闭时写入，一致性支持粒度为目录。弱一致Checkpoint IRP指示了文件的一致点，而强一致Checkpoint IRP则指示了目录的一致点。强一致CheckpointIRP通过`计数器`实现。对用户指定的被保护目录，上层应用打开目录下的文件时会往文件系统发送`IRP_MJ_CREATE`类型的IRP。与该目录关联的计数器加1，在关闭某个文件时计数器减1。如果计数器为零，则表明该目录下 所有打开的文件全部关闭。此时，一致点捕获驱动插入一个封装强一致信息的Checkpoint IRP。

3、强制一致Checkpoint IRP。按用户定义的策略强制性写入，一致性支持粒度为逻辑卷。强制一致Checkpoint IRP则根据用户预先定义的策略生成。例如，用户要求 1小时生成一个强制一致视图，则系统每1小时插入一个强制一致Checkpoint IRP。系统插入强制一致Checkpoint IRP时调用操作系统的`Flush`命令强制将文件系统中的缓存数据刷新到磁盘上。通过插入强制一致Checkpoint IRP，系统只能提供崩溃一致性 (Crash-consistency)级别的数据一致性保证，而不能提供类似于Windows卷影复制服务提供的应用级一致性（Application-level consistency)的快照视图。


1. IRP_MJ_CREATE： 
2. IRP_MJ_CLEANUP: 关闭句柄时取消悬挂的IRP， CloseHandle，不用处理
3. IRP_MJ_CLOSE: 关闭文件句柄，CloseHandle，一直点捕获驱动处理
4. IRP_SET_INFORMATION: 删除、重命名、修改属性、剪切、修改文件指针，SetFileLength，一致点捕获驱动部分处理
5. IRP_MJ_FILE_SYSTEM_CONTROL： 
6. IRP_MJ_WRITE: 写入数据，WriteFile，镜像驱动处理
7. IRP_MJ_FLUSH_BUFFERS: 写输出缓冲区或丢弃输入缓冲区，FlushFileBuffers，不处理



windows IFS对IRP 捕获： 时间，进程，文件，文件的具体位置，操作的内容  => 序列化成队列
CSAC(Classification on Self-Adaptive Cache)

在linux 下的netlink 和windows 下的CommunicationPort 从内核态拷贝到用户态，然后再将这些操作日志缓存在内存或磁盘中等待网络传输到远端的灾备机

在本发明中的本地缓存模块将一个独立的缓存队列分成四个部分：
- sended——已发送但未确认的数据( 数据即指队列中的序列化I/O 操作日志)，在网络传输出错时用来重新发送的，通过先进先出(FIFO) 调度策略转换到ready 中，
- ready——等待发送的数据，马上能用来网络发送的数据
- save——保存在磁盘中的数据，在内存紧张时由new 转存到磁盘上
- new——新加入的数据，即刚从内核态收上来的数据


- 挂接点超块处理：
- VFS拦截处理： 
  - 对inode 操作( 例如create、link、unlink、mkdir、rmdir、rename、setattr 等操作)
  - file 操作( 例如open、flush、llseek、write、aio_write、release 等操作)
  - address_space 操作( 例如writepage、prepare_write、commit_write 等操作) 
- IFS接获处理：
  - File System Filter 架构的支持，对IRP_MJ_SET_INFORMATION、IRP_MJ_SET_SECURITY、IRP_MJ_CREATE、IRP_MJ_WRITE、IRP_MJ_CLOSE 等IRP 操作进行截获


# fast I/O dispatch table

1. 没fast io表会导致crash，表`FAST_IO_DISPATCH`
2. fast io比irp快，而且是同步。如果fast io返回false，就是用IRP


- IoRegisterFsRegistrationChange: 文件变更callback
- IoSkipCurrentIrpStackLocation(Irp): 跳过处理，passthrough
- IoGetCurrentIrpStackLocation(Irp)->FileObject
- IoCallDriver(pDevExt->AttachedToDeviceObject, Irp);
- IoEnumerateDeviceObjectList
- FsFilterDetachFromDevice
- ObDereferenceObject
- KeDelayExecutionThread

# 文件IO的结构

文件IO -> volume IO(instance 上下文) -> driver IO

iopb->MajorFunction
## Instance
VolumeDeviceType == FILE_DEVICE_NETWORK_FILE_SYSTEM // 是网络盘
VolumeFilesystemType == FLT_FSTYPE_NTFS // ntfs卷
CSV volume： cluster share volume
a file state cache table for each NTFS volume instance： FS_SUPPORTS_FILE_STATE_CACHE( VolumeFilesystemType )

# FLT_REGISTRATION 结构体

在我们的注册函数中有次结构体. 此结构体如下:

```C
typedef struct _FLT_REGISTRATION {
  USHORT  Size;                    // @1 指向自身的大小sizeof(FLT_REGISTRATION). 
  USHORT  Version;                 // 版本 必须设置为FLT_REGISTRATION_VERSION
  FLT_REGISTRATION_FLAGS  Flags;   // 标志   @1
  CONST FLT_CONTEXT_REGISTRATION  *ContextRegistration; //上下文@2
  CONST FLT_OPERATION_REGISTRATION  *OperationRegistration; // 注册的回调函数FLT_OPERATION_REGISTRATION 
  PFLT_FILTER_UNLOAD_CALLBACK  FilterUnloadCallback;    // 卸载回调函数
  PFLT_INSTANCE_SETUP_CALLBACK  InstanceSetupCallback;  //InstanceSetup
  PFLT_INSTANCE_QUERY_TEARDOWN_CALLBACK  InstanceQueryTeardownCallback; // InstanceQueryTeardown
  PFLT_INSTANCE_TEARDOWN_CALLBACK  InstanceTeardownStartCallback;       // InstanceTeardownStart
  PFLT_INSTANCE_TEARDOWN_CALLBACK  InstanceTeardownCompleteCallback;    // InstanceTeardownComplete
  PFLT_GENERATE_FILE_NAME  GenerateFileNameCallback;                    //  GenerateFileName
  PFLT_NORMALIZE_NAME_COMPONENT  NormalizeNameComponentCallback;        //  NormalizeNameComponentCallback
  PFLT_NORMALIZE_CONTEXT_CLEANUP  NormalizeContextCleanupCallback;      //  NormalizeContextCleanupCallback
#if FLT_MGR_LONGHORN
  PFLT_TRANSACTION_NOTIFICATION_CALLBACK TransactionNotificationCallback;  //  TransactionNotificationCallback
  PFLT_NORMALIZE_NAME_COMPONENT_EX  NormalizeNameComponentExCallback;    //  NormalizeNameComponentExCallback
#endif // FLT_MGR_LONGHORN
} FLT_REGISTRATION, *PFLT_REGISTRATION;                                 //  ？SectionNotificationCallback
```

含义如下:

- Size：	大小，指向自身的大小，sizeof(FLT_REGISTRATION)
- Version：	版本，必须设置为 FLT_REGISTRATION_VERSION
- Flags：标志	两种设置,设置为NULL或者 FLTFL_REGISTRATION_DO_NOT_SUPPORT_SERVICE_STOP 设置为STOP的时候 MinniFilter停止服务的时候不会进行卸载不管你的卸载函数是否设置
- ContextRegistration：上下文	注册处理上下文的函数 如果注册了则结构体数组的最后一项必须设置为 FLT_CONTEXT_END
- OperationRegistration	回调函数集	重点中的重点,主要学习的就是这个域怎么设置. 是一个结构体数组可以设置我们感兴趣的回调. 最后一项设置为 IRP_MJ_OPERATION_END
- FilterUnloadCallback	卸载函数	卸载MiniFilter回调.如果flags = xx_STOP 那么不管你是否设置都不会卸载
- InstanceSetupCallback	卷实例加载回调	当一个卷加载的时候MiniFilter会为其生成一个实例并且绑定,比如移动硬盘接入的时候就会生成一个实例. 可以设置为NULL.
- InstanceQueryTeardownCallback	控制实例销毁函数	这个实例只会在手工解除绑定的时候会来.
- InstanceTeardownStartCallback	实例销毁函数	当调用的时候代表已经解除绑定,可以设置为NULL
- InstanceTeardownCompleteCallback	实例解绑定完成函数	当确定时调用解除绑定后的完成函数,可以设置为NULL.
- GenerateFileNameCallback	文件名字回调	生成文件名可以设置回调,可以设置为NULL.	
- NormalizeNameComponentCallback	
- NormalizeContextCleanupCallback	
- TransactionNotificationCallback： 事务是个什么鬼
- NormalizeNameComponentExCallback:

回调函数集的结构：

```C
typedef struct _FLT_OPERATION_REGISTRATION {
  UCHAR  MajorFunction;
  FLT_OPERATION_REGISTRATION_FLAGS  Flags;
  PFLT_PRE_OPERATION_CALLBACK  PreOperation;
  PFLT_POST_OPERATION_CALLBACK  PostOperation;
  PVOID  Reserved1;
} FLT_OPERATION_REGISTRATION, *PFLT_OPERATION_REGISTRATION;
```

- 参数1 指明的你想监控的IRP操作
- 参数2 是个标志
- 参数3 是你执行的监控回调 pre代表的意思是先前回调. 比如文件创建 还未创建之前调用你
- 参数4 监控后回调. 文件创建完会调用的回调
- 参数五 保留参数 给NULL即可.

IRP可以监控很多 这个查询WDK文档即可.

这里说一下 标志

标志如下:

- FLTFL_OPERATION_REGISTRATION_SKIP_CACHED_IO	使用此标志代表了不对缓存的IO处理进行 pre和post函数操作 适用于快速IO 因为所有快速IO已经缓存
- FLTFL_OPERATION_REGISTRATION_SKIP_PAGING_IO	指定不应该为分页操作的IO进行回调操作.对于不是基于IRP的io操作都会跳过.不会调用我们的函数
看着比较蒙对吧. 那我说一下. 其实在我们写一个文件的时候并不是直接写入到磁盘中.

而是先写到缓存中的. 缓存在写到内存中的.

调用链大概如下:

- APP->IO->FSD->Cache->MM->IO->FSD->DISk  第一种
- APP->IO->FSD->DISk                      第二种
- 第一种就是先写到缓存中,当满足1024个字节的时候再由MM发起IO请求.然后在通知文件系统最好写道磁盘中.
- 第二种就是直接通过IO到文件系统,然后写入到磁盘中.

如果频繁读写是影响效率的.所以对于第一种不是IRP发起的请求我们都可以忽略掉.

所以这两个标志的意思就是差不多这个意思.


文件带缓存IO:
1. 预先读入文件和延迟写入文件。在读/写文件的时候，为了提高效率，文件带缓冲进行IO操作，读的时候提前读入目标旁边的数据，写的时候会延迟写(集中起来一次性写入)，因为磁盘是低速设备，减少IO次数是能提高效率的。
2. 当ReadFile时，会调用NtReadFile()系统调用，它会构造一个IRP下发到FSD，FSD会检查这个IRP看是不是可以缓存的，是的话，如果还没有为此文件建立缓存的话，就会调用CclnitializeCacheMap()函数建立缓存，它里面会调用内存管理器(VMM）函数建立一个节对象。
3. 当用到时，会把这个节对象(和文件关联)映射到内核空间。如果IRP是可缓存的，则调用CcCopyRead函数进行从缓存中读入文件。
4. 如果此文件还没有在内存中，则会产生页面错误，交给MmAccessFault()函教处理,它会调用loPageRead iO分配一个不缓存的IRP(IRP_PAGING_lO)，但是它会走FSD，不会调用缓存的函数,而是最终调用磁盘驱动进行真实的磁盘读写读入到内存。
5. 之后CcCopyRead()再不会产生错误了，会从缓存复制到用户Buffer中

IRP_PAGING_IO:
1. IRP_NOCACHE && 非IRP_XXX_ PAGING _IO,也就是用户程序设置FILE_NO_INTERMEDIATE_BUFFERING,流程是App->IO->FSD->DISK
2. IRP_CACHE&& 非IRP_XXX_PAGING_IO,也就是用户程序默认设置, 流程是APP->IO->FSD-CC(Cache Manger)->MM(->FSD-DISK)
3. IRP_PAGING_IO:在情况2中:MM会发起一个IRP并标记为IRP_XXX_PAGING_IO,流程是MM->FSD->DISK(on behalt of vm),所以IRP_PAGING_IO不是由用户程序发起的，而是由内存管理器发起的，所以不需要监控。
4. 如果设置了IRP_XXX_PAGING_IO,那就是MM内部用的IRP,CACHE标记此时没有意义(on behalft of vmn)

发给磁盘的机会:
1. FILE_NO_INTERMEDIATE_BUFFERING&&非IRR_XXX_PAGING_IO的时候会发给DISK，即App->IO->FSD->DISK
2. IRP_XXX_PAGING_IO时候会发给DISK，即MM->FSD->DISK

HOOK_PreNtCreatelFile/HOOK_PostNtCreateFile定义: 

```C
/// create执行之前调用
FLT_PREOP_CALLBACK_STATUS HOOK_PreNtCreateFile(
 PFLTCALLBACK_DATA Data, ///Filter Manager Frame将IRP重新组装成`FLT_CALLBACK_DATA`结构体
 PCFLT_RELATED_OBJECTS FltObjects, ///与Minifilter相关的对象
 PVOID *CompletionContext ///分配的一个context资源,可以传给Post函数处理，然后在Post函数释放掉context资源
)
 //sandbox
 //主防
 //杀毒引擎
 //加解密
 return xxx; ///这个返回值是返回给Minifilter管理器的，拿到返回值之后再决定要不要把操作继续往下发给Mnifilter驱动或者Sfilter驱动
 /// Data->IoStatus.Status = STATUS_ACCESS_DENIED; 这个才是返回给IO管理器的，即应用层
 /// PRE-OP的返回值:(和sfilter比较)
 /// FLT_PREOP_SUCCESS_WITH_CALLBACK // 告诉Minifilte管理器要把操作往下发，结束之后要调用Post,类似Sfilter中`IoCopyxxX+完成例程`将IRP下发
 /// FLTPREOP_SUCCESS_NO_CALLBACK // 告诉Minifilte管理器要把操作往下发，结束之后但不需要调用Post,类似Sfilter中`IoSkip+IoCall`直接下发
 /// FLT_PREOP_PENDING  // 挂起
 /// FLT PREOP DISALLOW_FASTIO // 禁用fastio
 /// FLT_PREOP_COMPLETE // 告诉Minifilte管理器要把操作完成之后不下发了，当前为止，不下发有拒绝(STATUS_ACCESS_DENIED),成功完成(STATUS_ACCESS)
 /// FLT_PREOP_SYNCHRONIZE // 同步
}

/// create完成之后创建 
FLT_POSTOP_CALLBACK_STATUS HOOK_PostNtCreateFile(
 PFLT_CALLBACK_DATA Data,
 PCFLT RELATED_OBJECTS FltObjects,
 PVOID completionContext， //在PRE-OP里返回FLT_PREOPsuCcEss_wITH_CALLBACK 时获取里面的上下文,并最后释放Context资源
 FLT_POST_OPERATION_FLAGS Flags
)
{
 return xxx;
 // POST-OP的返回值:
 // FLT_POSTOP_FINISHED_PROCESSING // 最终完成处理
 // FLT_POSTOP_MORE_PROCESSING_REQUIRED // post处理完之后，还需要更多处理，一般发生在Post里面，如果Irql比较高，比如处于DISPATCH_LEVEL，这样需要做一些操作的时候，是需要开一个工作者线程去做，这时候就需要返回一个FLT_POSTOP_MORE_PROCESSING_REQUIRED

}
FltObjects->volume,FltObjects->Instance,FltObjects->FileObject,
FltObjects->FileObject->DeviceObject
```

判断Data是什么操作的宏: 
```C
FLT_IS_IRP_OPERATION  ///应用下发的IRP
FLT_IS_FASTIO_OPERATION ///走缓存
FLJ IS_FS_FILTER_OPERATION ///其他Minifilter或者Sfilter下发的
 
// eg：禁用fastio
if(FLT_IS_FASTIO_OPERATION(Data)) ///为真则是Fasdtio操作
{
 ntStatus STATUS_FLT DISALLOW_FAST_I0;
 Data->loStatus.status = ntStatus;
 Data->loStatus.Information = 0;
 return FLT_PREOR_DISALLOW_FASTIO;
}
```

# context类型

## Files (Windows Vista and later)
## Instances context
```C
typedef struct _CTX_FILE_CONTEXT {
    UNICODE_STRING FileName; //  Name of the file associated with this context.
} CTX_FILE_CONTEXT, *PCTX_FILE_CONTEXT;

typedef struct _CTX_INSTANCE_CONTEXT {
    PFLT_INSTANCE Instance; //  Instance for this context.
    PFLT_VOLUME Volume; //  Volume associated with this instance.
    UNICODE_STRING VolumeName; //  Name of the volume associated with this instance.
} CTX_INSTANCE_CONTEXT, *PCTX_INSTANCE_CONTEXT;
```

(实例上下文),也就是过滤驱动在文件系统的设备堆栈上创建的一个过滤器实例;
FltGetlnstanceContext // 获取对象上的上下文
FltSetInstanceContext // 将缓存重新设置到对象上，比如修改了上下文的数据，使用这个函数把上下文



status = FltAllocateContext( FltObjects->Filter, FLT_INSTANCE_CONTEXT, CTX_INSTANCE_CONTEXT_SIZE, NonPagedPool, &instanceContext ); //?这个大小可以变动吗
status = FltGetVolumeName( FltObjects->Volume, NULL, &volumeNameLength ); // get the nt volume length
instanceContext->VolumeName.MaximumLength = (USHORT) volumeNameLength;
status = CtxAllocateUnicodeString( &instanceContext->VolumeName ); //  Allocate a string big enough to take the volume name
status = FltGetVolumeName( FltObjects->Volume, &instanceContext->VolumeName, &volumeNameLength ); //  Get the NT volume name
status = FltSetInstanceContext( FltObjects->Instance, FLT_SET_CONTEXT_KEEP_IF_EXISTS, instanceContext, NULL ); //  Set the instance context.

instanceContext->Instance = FltObjects->Instance; // ?
instanceContext->Volume = FltObjects->Volume; // ?

## Streams

```C
typedef struct _CTX_STREAM_CONTEXT {
    UNICODE_STRING FileName; //  Name of the file associated with this context.
    ULONG CreateCount; //  Number of times we saw a create on this stream
    ULONG CleanupCount; //  Number of times we saw a cleanup on this stream
    ULONG CloseCount; //  Number of times we saw a close on this stream
    PERESOURCE Resource; //  Lock used to protect this context.
} CTX_STREAM_CONTEXT, *PCTX_STREAM_CONTEXT;
```

(流上下文),绑定到FCB (File control Block，文件控制块)的上下文， 文件和FCB是一对一的关系。

- FltGetStreamContext // 获取对象上的上下文， volume，fileobject
- FltSetStreamContext // 将缓存重新设置到对象上，比如修改了上下文的数据，使用这个函数把上下文更新到对象上

## Stream handles (file objects)

```C
typedef struct _CTX_STREAMHANDLE_CONTEXT {
    UNICODE_STRING FileName; //  Name of the file associated with this context.
    PERESOURCE Resource; //  Lock used to protect this context.
} CTX_STREAMHANDLE_CONTEXT, *PCTX_STREAMHANDLE_CONTEXT;
```

(流句柄上下文),就是常见FO(FileObjec),文件和FileObjec是多对一的关系。
写关闭
FltGetStreamHandleContext
FltSetStreamHandleContext

- Transactions (Windows Vista and later)
## Volumes

(卷上下文),卷就是通常看到的C,D盘以及网络重定向器，一般情况下一个券对一个对滤器实例对象，在实际应用上经常用Instance Context来代替volume Context。(在启动Minifilter的时候有多少卷设备对象就生成多少个Minigilter实例，安装到卷设备上，安装的那一刻可以把卷设备的信息查询出来(卷的名字，卷的文件系统信息，文件系统类型，卷的扇区大小等))放到Instance Context，以后要想知道卷的信息，直接从Instance Context获取即可。

# instance 上下文

# volume上下文

status = FltGetVolumeProperties( FltObjects->Volume, volProp, sizeof(volPropBuffer), &retLen );
 status = FltSetVolumeContext( FltObjects->Volume, FLT_SET_CONTEXT_KEEP_IF_EXISTS, ctx, NULL );

status = FltGetDiskDeviceObject( FltObjects->Volume, &devObj );
status = IoVolumeDeviceToDosName( devObj, &ctx->Name );


# 内存

FltFreePoolAlignedWithTag( FltObjects->Instance, newBuf, BUFFER_SWAP_TAG );

ExInitializeNPagedLookasideList( &Pre2PostContextList,  NULL, NULL, 0, sizeof(PRE_2_POST_CONTEXT), PRE_2_POST_TAG, 0 );
ExDeleteNPagedLookasideList( &Pre2PostContextList );

p2pCtx = ExAllocateFromNPagedLookasideList( &Pre2PostContextList );
newMdl = IoAllocateMdl( newBuf, readLen, FALSE, FALSE, NULL );
IoFreeMdl( newMdl );
MmBuildMdlForNonPagedPool( newMdl ); //  setup the MDL for the non-paged pool we just allocated
MmGetSystemAddressForMdlSafe( iopb->Parameters.Read.MdlAddress, NormalPagePriority | MdlMappingNoExecute );


FltSetCallbackDataDirty( Data ); // mark we have changed something.

# IRP_MJ_CREATE

FLT_PREOP_CALLBACK_STATUS CtxPreCreate ( _Inout_ PFLT_CALLBACK_DATA Cbd, _In_ PCFLT_RELATED_OBJECTS FltObjects, _Flt_CompletionContext_Outptr_ PVOID *CompletionContext )
FLT_POSTOP_CALLBACK_STATUS CtxPostCreate ( _Inout_ PFLT_CALLBACK_DATA Cbd,  _In_ PCFLT_RELATED_OBJECTS FltObjects, _Inout_opt_ PVOID CbdContext, _In_ LT_POST_OPERATION_FLAGS Flags )

Cbd->IoStatus.Status // 创建文件或者文件夹成功吗？
status = FltGetFileNameInformation( Cbd, FLT_FILE_NAME_NORMALIZED | FLT_FILE_NAME_QUERY_DEFAULT,  &nameInfo );  // get file name

在post中可以创建streamContext、streamHandlerContext、fileContext

# IRP_MJ_CLEANUP: 关闭句柄时取消悬挂的IRP， CloseHandle，不用处理
# IRP_MJ_CLOSE: 关闭文件句柄，CloseHandle，一直点捕获驱动处理
# IRP_SET_INFORMATION: 删除、重命名、修改属性、剪切、修改文件指针，SetFileLength，一致点捕获驱动部分处理

Cbd->Iopb->Parameters.SetFileInformation.FileInformationClass FileRenameInformation/FileRenameInformationEx
# IRP_MJ_FILE_SYSTEM_CONTROL： 
# IRP_MJ_WRITE: 写入数据，WriteFile，镜像驱动处理
# IRP_MJ_FLUSH_BUFFERS: 写输出缓冲区或丢弃输入缓冲区，FlushFileBuffers，不处理