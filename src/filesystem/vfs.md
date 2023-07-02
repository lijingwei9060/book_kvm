# Intro

vfs Inode cache/ Directory cache/ superblocks

Minix/Ext2

Buffer cache

## data structure

vfs superblock:
- device:
- inode: the mounted inode pointer points at he first inode. covered inode.
- blocksize:
- operation:
- file system type
- file system specific:

vfs inode: 
- device:
- inode number:
- mode
- user ids
- times
- block size
- inode operations
- count
- lock
- dirty
- speific information


struct file_system_type * fs

## tools

int register_filesystem (	struct file_system_type * fs);
int unregister_filesystem (	struct file_system_type * fs);

