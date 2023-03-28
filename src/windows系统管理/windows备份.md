Changed Block Tracking
Resilient Change Tracking (RCT) 

# CBT for Volume-Level Backup
 In case of the volume-level backup, Veeam Agent for Microsoft Windows performs changed block tracking in the following way:

- During the full backup job session, Veeam Agent reads the Master File Table (MFT) of the backed-up volume. Veeam Agent uses MFT records to create digests with file system metadata, transfers the created digests to the target location and stores them to the resulting backup file.
- During subsequent incremental job sessions, Veeam Agent performs the following operations:
- - Reads the Master File Table (MFT) of the backed-up volume and creates the new digests with file system metadata.
- - Interacts with the target backup location to obtain digests from the backup file that was created during the previous job session.
- - Compares new and previous digests to detect files whose data blocks have changed on the volume since the previous job session. During incremental backup, Veeam Agent for Microsoft Windows reads from the VSS snapshot only data blocks pertaining to files that have changed since the previous job session. If Veeam Agent cannot calculate information about the changed files, for example, if it fails to retrieve digests from the backup file, Veeam Agent will need to read all data blocks from the VSS snapshot. As a result, the backup may take significantly more time.

# CBT for File-Level Backup

In case of the file-level backup, Veeam Agent for Microsoft Windows performs changed block tracking in the following way:

- During the full backup job session, Veeam Agent creates a new NTFS partition in the backup file. Veeam Agent uses this partition to store all backed-up files and folders.
- During subsequent incremental job sessions, Veeam Agent performs the following operations:
- - Compares the last modification time attribute of files on the Veeam Agent computer and files in the backup. This operation allows Veeam Agent to detect files that have changed since the previous job session.
- - Transfers data blocks that contain metadata related to each changed file and its parent folders from the target backup location to the Veeam Agent computer.
- - If the backed-up file system has a complex folder structure with many hierarchy levels, and you back up data to a remote location, during incremental backup, the inbound network traffic on the Veeam Agent computer may exceed by far the outbound traffic. Significant amount of data can be transferred to the Veeam Agent computer even if few files are changed since the previous job session.

Replaces file system metadata in the downloaded data blocks with the current file system metadata.
Transfers data blocks with current metadata from the Veeam Agent computer to the target backup location along with changed files. In the target backup location, Veeam Agent stores data and metadata in the newly created backup file.


[url](https://helpcenter.veeam.com/docs/agentforwindows/userguide/backup_cbt_driver.html?ver=50)

优选地，对于Windows系统，所述磁盘快照模块使用系统的vss机制追踪磁盘数据块的变化。
优选地，对于Linux系统，所述磁盘快照模块通过内核模块追踪磁盘数据块的变化。
基于RDC(RemoteDifferential Compression，远程差分压缩)不定长分块策略的数据同步方法及装置


mklink /d e:\vss \\?\GLOBALROOT\Device\HarddiskVolumeShadowCopy1\
fastcopy /cmd=sync /no_ui /acl /stream /verify /error_stop=FALSE /skip_empty_dir=FALSE /speed=full /bufsize=500 /exclude='\`$RECYCLE.BIN\;\System Volume Information\' /filelog='e:\logFile.txt' 'e:\vss\' /to='e:\dst\'"










