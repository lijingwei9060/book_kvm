# NTFS结构
NTFS文件系统大致可以分为引导区(16扇区)，用户数据，MFT区，用户数据，MFT备份区，数据区和DBR备份区(1个扇区)。NTFS是用Unicode编码，FAT32是用ASCII编码

- 引导扇区和FAT32的引导区类似，是文件系统的保留区，第一扇区为DBR。一般包括文件系统的引导代码和数据。
- MFT区一般占文件系统大小的12.5%，一般当其它数据区写满后才会暂时使用这个空间。
- MFT备份区，说是备份区，其实只是备份了MFT区的部分数所在，只是MFT区的前几个项的备份。
- 引导扇区备份区在卷的最后一个扇区，其备份了一份DBR扇区的内容。

# 16个元文件

- $MFT: 主文件表，每个文件都在这里有记录
- $MFTMirr： 前4个表项的备份
- $LogFile: 日志文件
- $Volume: 记录卷标信息
- $AttrDef: 属性定义表
- $Root: 根目录
- $Bitmap: 记录文件系统中簇的分配情况
- $Boot: 引导文件
- $BadClus: 坏簇列表文件
- $Secure: 控制文件和目录的访问控制
- $UpCase: 大小写转换
- $Extend: 扩展元数据目录
- $Quota: 配额管理文件
- $ObjId: 对象ID解析文件
- $Reoarse: 重解析点文件
- $RmMetadata: 事务元数据

# MFT表
- 以明文“FILE”开头
- 每个MFT项都占用1024字节，即两个扇区
- NTFS文件系统中的所有文件，都有一个MFT项记录相应的数据
- 每个MFT项占用的两个扇区，最后两个字节是一个修正值，这个修正值和MFT项中的更新序列号相同，如果系统发现不同，就会认为这个MFT项错误，会把开头标志明文“FILE”改成“BAAD”
- 一个MFT表一般有3个更新序列号，分别位于30、第一个扇区末尾，第二个扇区末尾

pub struct MFT{
	magic u32, //"FILE"
	offset_update_sn u16, //0x0030
	cnt_update_sn u16,
	log_sn u64,
	sn u16,
	cn_hard_link u16,
	offset_attr_1 u16,
	flag u16,
	logical_length u32, //（有效长度 字节
	physical_length u32, // （占用长度）
	index_base u64,
	id_next u16,
	reserve u16,
	index_mft_entry  u32,
	update_sn u16,
	update_array_1 u16,
	update_array_2 u16
}