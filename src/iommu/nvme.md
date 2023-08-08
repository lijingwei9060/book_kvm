# passthrough

```xml
<hostdev mode="subsystem" type="pci" managed="yes">
  <source>
    <address domain="0x0000" bus="0x6f" slot="0x00" function="0x0"/>
  </source>
  <boot order="1"/>
  <alias name="ua-sm2262"/>
  <address type="pci" domain="0x0000" bus="0x00" slot="0x07" function="0x0"/>
</hostdev>

<qemu:commandline>
    <qemu:arg value="-set"/>
    <qemu:arg value="device.ua-sm2262.x-msix-relocation=bar2"/>
</qemu:commandline>
<!-- 新的-->

<qemu:override>
<qemu:device alias="ua-sm2262">
    <qemu:frontend>
    <qemu:property name="x-msix-relocation" type="string" value="bar2"/>
    </qemu:frontend>
</qemu:device>
</qemu:override>
```