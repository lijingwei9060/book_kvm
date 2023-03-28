
# inf文件


```txt
;;;
;;; PassThrough
;;;
;;;
;;; Copyright (c) 1999 - 2001, Microsoft Corporation
;;;
 
[Version]
Signature   = "$Windows NT$"     
Class       = "ActivityMonitor"  ;指明了驱动的分组,必须指定.
ClassGuid   = {b86dff51-a31e-4bac-b3cf-e8cfe75c9fc2}  ;GUID 每个分组都有固定的GUID
Provider    = %Msft% ;变量值 从STRING节中可以看到驱动提供者的名称 
DriverVer   = 06/16/2007,1.0.0.1 ;版本号
CatalogFile = passthrough.cat    ;inf对应的cat 文件 可以不需要
 
 
[DestinationDirs]
DefaultDestDir          = 12    ;告诉我们驱动拷贝到哪里 13代表拷贝到%windir%
MiniFilter.DriverFiles  = 12            ;%windir%\system32\drivers
 
;;
;; Default install sections
;;
 
[DefaultInstall]
OptionDesc          = %ServiceDescription%
CopyFiles           = MiniFilter.DriverFiles
 
[DefaultInstall.Services]
AddService          = %ServiceName%,,MiniFilter.Service
 
;;
;; Default uninstall sections
;;
 
[DefaultUninstall]
DelFiles   = MiniFilter.DriverFiles
 
[DefaultUninstall.Services]
DelService = %ServiceName%,0x200      ;Ensure service is stopped before deleting
 
;
; Services Section
;
 
[MiniFilter.Service]                 ;服务的一些信息
DisplayName      = %ServiceName%
Description      = %ServiceDescription%
ServiceBinary    = %12%\%DriverName%.sys        ;%windir%\system32\drivers\
Dependencies     = "FltMgr"                     ;服务的依赖
ServiceType      = 2                            ;SERVICE_FILE_SYSTEM_DRIVER
StartType        = 3                            ;SERVICE_DEMAND_START
ErrorControl     = 1                            ;SERVICE_ERROR_NORMAL
LoadOrderGroup   = "FSFilter Activity Monitor"  ;文件过滤分组
AddReg           = MiniFilter.AddRegistry       ;文件过滤注册表需要添加的高度值等信息
 
;
; Registry Modifications
;
 
[MiniFilter.AddRegistry]
HKR,,"DebugFlags",0x00010001 ,0x0
HKR,"Instances","DefaultInstance",0x00000000,%DefaultInstance%
HKR,"Instances\"%Instance1.Name%,"Altitude",0x00000000,%Instance1.Altitude%
HKR,"Instances\"%Instance1.Name%,"Flags",0x00010001,%Instance1.Flags%
 
;
; Copy Files
;
 
[MiniFilter.DriverFiles]
%DriverName%.sys
 
[SourceDisksFiles]
passthrough.sys = 1,,
 
[SourceDisksNames]
1 = %DiskId1%,,,
 
;;
;; String Section
;;
 
[Strings]
Msft                    = "Microsoft Corporation"
ServiceDescription      = "PassThrough Mini-Filter Driver"
ServiceName             = "PassThrough"
DriverName              = "PassThrough"
DiskId1                 = "PassThrough Device Installation Disk"
 
;Instances specific information.
DefaultInstance         = "PassThrough Instance"
Instance1.Name          = "PassThrough Instance"
Instance1.Altitude      = "370030"
Instance1.Flags         = 0x0              ; Allow all attachments
```

# dbgview

注册表需要增加下面的键值，重启。

```txt
Windows Registry Editor Version 5.00
[HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Debug Print Filter] 
"DEFAULT"=dword:0000000f
```