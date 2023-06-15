# 操作日志

## 创建vss
C:\Program Files (x86)\info2soft-i2node\bin>VSHADOW -p -nw C:

VSHADOW.EXE 2.2 - Volume Shadow Copy sample client
Copyright (C) 2005 Microsoft Corporation. All rights reserved.


(Option: Persistent shadow copy)
(Option: No-writers option detected)
(Option: Create shadow copy set)
- Setting the VSS context to: 0x00000019
Creating shadow set {b05c88e6-c5d1-49b4-bfce-c4b8eb5c4025} ...
- Adding volume \\?\Volume{39501e63-c16f-11ed-a068-806e6f6e6963}\ [C:\] to the shadow set...
Creating the shadow (DoSnapshotSet) ...
(Waiting for the asynchronous operation to finish...)
(Waiting for the asynchronous operation to finish...)
Shadow copy set succesfully created.

List of created shadow copies:


Querying all shadow copies with the SnapshotSetID {b05c88e6-c5d1-49b4-bfce-c4b8eb5c4025} ...

* SNAPSHOT ID = {1d7e4b6e-075f-4e75-a2c5-0c3ef66ec4ef} ...
   - Shadow copy Set: {b05c88e6-c5d1-49b4-bfce-c4b8eb5c4025}
   - Original count of shadow copies = 1
   - Original Volume name: \\?\Volume{39501e63-c16f-11ed-a068-806e6f6e6963}\ [C:\]
   - Creation Time: 2023/3/27 18:22:35
   - Shadow copy device name: \\?\GLOBALROOT\Device\HarddiskVolumeShadowCopy1
   - Originating machine: i-C299F62F
   - Service machine: i-C299F62F
   - Not Exposed
   - Provider id: {b5946137-7b9f-4925-af80-51abd60b20d5}
   - Attributes:  No_Auto_Release Persistent No_Writers Differential


Snapshot creation done.

## link_mount
C:\Program Files (x86)\info2soft-i2node\bin>mklink /D c:\temp \\?\GLOBALROOT\Device\HarddiskVolumeShadowCopy1
为 c:\temp <<===>> \\?\GLOBALROOT\Device\HarddiskVolumeShadowCopy1 创建的符号链接



C:\Program Files (x86)\info2soft-i2node\bin>vshadow.exe -el={1d7e4b6e-075f-4e75-a2c5-0c3ef66ec4ef},f:\backup\

VSHADOW.EXE 2.2 - Volume Shadow Copy sample client
Copyright (C) 2005 Microsoft Corporation. All rights reserved.


(Option: Expose a shadow copy)
- Setting the VSS context to: 0xffffffff
- Exposing shadow copy {1d7e4b6e-075f-4e75-a2c5-0c3ef66ec4ef} under the path 'f:\backup\'
- Checking if 'f:\backup\' is a valid empty directory ...
- Shadow copy exposed as 'f:\backup\'