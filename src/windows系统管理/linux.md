例如在Linux 系统中，通过可堆叠文件系统(Stackable Filesystem) 的VFS(Virtual File System) 架构的支持，对inode 操作( 例如create、link、unlink、mkdir、rmdir、rename、setattr 等操作)、file 操作( 例如open、flush、llseek、write、aio_write、release 等操作)，以及address_space 操作( 例如writepage、prepare_write、commit_write 等操作) 进行截获；


