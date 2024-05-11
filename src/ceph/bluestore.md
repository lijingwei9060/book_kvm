# intro

## 结构

1. onode： 代表对象
   1. lextent（逻辑extent），
   2. blob映射pextent（物理extent）
2. Bnode
3. BlueFS： 小的文件系统，解决元数据、文件空间及磁盘空间的分配和管理，并实现了rocksdb::Env 接口(存储RocksDB日志和sst文件)。因为rocksdb常规来说是运行在文件系统的顶层，下面是BlueFS。 它是数据存储后端层，RocksDB的数据和BlueStore中的真正数据被存储在同一个块物理设备。所有的元数据的修改都记录在BlueFS的日志中，也就是对于BlueFS，元数据的持久化保存在日志中。在系统启动mount这个文件系统时，只需回放日志，就可将所有的元数据都加载到内存中。BluesFS的数据和日志文件都通过块设备保存到裸设备上（BlueFS和BlueStore可以共享裸设备，也可以分别指定不同的设备）。
4. RocksDB： 存储预写式日志、数据对象元数据、Ceph的omap数据信息、以及分配器的元数据（分配器负责决定真正的数据应在什么地方存储）
5. BlueRocksEnv： 与RocksDB交互的接口
6. Disk : bluestore不使用本地文件系统，直接接管裸设备，并且只使用一个原始分区，HDD/SSD所在的物理块设备实现在用户态下使用linux aio直接对裸设备进行I/O操作。由于操作系统支持的aio操作只支持directIO，所以对BlockDevice的写操作直接写入磁盘，并且需要按照page对齐。其内部有一个aio_thread 线程，用来检查aio是否完成。其完成后，通过回调函数aio_callback 通知调用方。
7. Allocator 模块: 用来委派具体哪个实际存储块用来存储当前的object数据；同样采用bitmap的方式来实现allocator，同时采用层级索引来存储多种状态，这种方式对内存的消耗相对较小，平均1TB磁盘需要大概35M左右的ram空间。

BlueStore 把元数据和对象数据分开写，对象数据直接写入硬盘，而元数据则先写入超级高速的内存数据库，后续再写入稳定的硬盘设备，这个写入过程由 BlueFS 来控制。
 


### 写路径

1. BlueStore 的写策略综合运用直接写、COW 和 RMW 策略。
   1. BlockSize：磁盘IO操作的最小单元(原子操作)。HDD为512B，SSD为4K。即读写的数据就算少于 BlockSize，磁盘I/O的大小也是 BlockSize，是原子操作，要么写入成功，要么写入失败，即使掉电不会存在部分写入的情况。
   2. RWM(Read-Modify-Write)：指当覆盖写发生时，如果本次改写的内容不足一个BlockSize，那么需要先将对应的块读上来，然后再内存中将原内容和待修改内容合并Merge，最后将新的块写到原来的位置。但是RMW也带来了两个问题：一是需要额外的读开销；二是RMW不是原子操作，如果磁盘中途掉电，会有数据损坏的风险。为此我们需要引入Journal，先将待更新数据写入Journal，然后再更新数据，最后再删除Journal对应的空间。
   3. COW(Copy-On-Write)：指当覆盖写发生时，不是更新磁盘对应位置已有的内容，而是新分配一块空间，写入本次更新的内容，然后更新对应的地址指针，最后释放原有数据对应的磁盘空间。理论上COW可以解决RMW的两个问题，但是也带来了其他的问题：一是COW机制破坏了数据在磁盘分布的物理连续性。经过多次COW后，读数据的顺序读将会便会随机读。二是针对小于块大小的覆盖写采用COW会得不偿失。是因为：一是将新的内容写入新的块后，原有的块仍然保留部分有效内容，不能释放无效空间，而且再次读的时候需要将两个块读出来Merge操作，才能返回最终需要的数据，将大大影响读性能。二是存储系统一般元数据越多，功能越丰富，元数据越少，功能越简单。而且任何操作必然涉及元数据，所以元数据是系统中的热点数据。COW涉及空间重分配和地址重定向，将会引入更多的元数据，进而导致系统元数据无法全部缓存在内存里面，性能会大打折扣。
   4. 非覆盖写直接分配空间写入即可；非覆盖写直接通过 Allocater 分配空间后写入硬盘设备
   5. 块大小对齐的覆盖写采用 COW 策略, 也是直接通过 Allocater 分配空间后写入硬盘设备。
   6. 小于块大小的覆盖写采用 RMW 策略,先把数据写入 Journal，在 BlueStore 中就是 RocksDB，再后续通过 BlueFS 控制，刷新写入硬盘设备。
2. BlueStore 把数据分成两条路径。
   1. 一条是 data 直接通过 Allocator（磁盘空间分配器）分配磁盘空间，然后写入 BlockDevice。
   2. 另一条是 metadata 先写入 RocksDB（内存数据库），通过 BlueFs（BlueStore 专用文件系统）来管理 RocksDB 数据，经过 Allocator 分配磁盘空间后落入 BlockDevice。
3. BlueStore 把元数据和对象数据分开写，对象数据直接写入硬盘，而元数据则先写入超级高速的内存数据库，后续再写入稳定的硬盘设备，这个写入过程由 BlueFS 来控制。

在 ceph 配置中，有 bluestore_prefer_deferred_size 可以设定：当对象大小小于该值时，该对象总是使用延迟写（即先写入 Rocks DB，再落入 BlockDevice）。

Ceph的事务只工作于单个OSD内，能够保证多个对象操作被ACID地执行，主要是用于实现自身的高级功能。每个PG（Placement Group，类似Dynamo的vnode，将hash映射到同一个组内的对象组到一起）内有一个OpSequencer，通过它保证PG内的操作按序执行。事务需要处理的写分三种：

1. 写到新分配的区域。考虑ACID，因为此写不覆盖已有数据，即使中途断电，因为RocksDB中的元数据没有更新，不用担心ACID语义被破坏。后文可见RocksDB的元数据更新是在数据写之后做的。因而，日志是不需要的。在数据写完之后，元数据更新写入RocksDB；RocksDB本身支持事务，元数据更新作为RocksDB的事务提交即可。
2. 写到Blob中的新位置。同理，日志是不需要的。
3. Deferred Writes（延迟写），只用于覆写（Overwrite）情况。从上面也可以看到，只有覆写需要考虑日志问题。如果新写比块大小（min_alloc_size）更小，那么会将其数据与元数据合并写入到RocksDB中，之后异步地把数据搬到实际落盘位置；这就是日志了。如果新写比块大小更大，那么分割它，整块的部分写入新分配块中，即按（1）处理，；不足的部分按（3）中上种情况处理。
上述基本概述了BlueStore的写处理。可以看到其是如何解决FileStore的日志双写问题的。
首先，没有Linux文件系统了，也就没有了多余的Journaling of Journal问题。然后，大部分写是写到新位置的，而不是覆写，因此不需要对它们使用日志；写仍然发生了两次，第一次是数据落盘，然后是RocksDB事务提交，但不再需要在日志中包含数据了。最后，小的覆写合并到日志中提交，一次写完即可返回用户，之后异步地把数据搬到实际位置（小数据合并到日志是个常用技巧）；大的覆写被分割，整块部分用Append-only方式处理，也绕开了日志的需要。至此，成为一个自然而正常的处理方式。

 
### 存储管理 
BlueStore可以管理最多3个设备：
1. main 设备（块系统链接）存储目标队形以及元数据
2. db 设备是可选的，存储metadata(RocksDB)
3. WAL 设备可选只用于内部日志（RocksDB预写日志

## 特性
1. 内存使用：BlueStore的底线是 bluestore_cache_size 配置选贤，控制每个OSD所使用的BlueStore缓存消耗的内存。默认是每个HDD后端OSD使用1GB内存，而SSD后端OSD则使用3GB内存。
2. 校验： BlueStore计算、存储和验证校验所有存储的数据和元数据。任何时候从磁盘读取数据，数据在输出给系统其他部分（或用户）使用之前都会使用校验来验证数据正确性。默认使用 crc32c checksum，也提供其他校验选项（ xxhash32 ， xxhash64 ），甚至支持使用降级的 crc32c （例如，使用标准校验32位数据中的8位或者16位）来降低元数据跟踪（牺牲了数据可靠性）。也支持完全关闭数据校验（但不推荐此方式）。
3. 压缩：BlueStore可以使用zlib, snappy 或者 lz4 实现透明压缩。默认BlueStore关闭了压缩功能，但是可以全局激活或者针对特定存储池激活，也提供了当RADOS客户端访问数据时选择性激活


## superblock

bluestore_bdev_label_t    
- uuid_d osd_uuid;   ///< osd uuid
- uint64_t size;    ///< device size
- utime_t btime;    ///< birth time
- string description; ///< device description
