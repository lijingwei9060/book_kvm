# namespace

```txt
     +---------+    +-------+    +--------+    +------------------------+
     |  RSDP   | +->| XSDT  | +->|  FADT  |    |  +-------------------+ |
     +---------+ |  +-------+ |  +--------+  +-|->|       DSDT        | |
     | Pointer | |  | Entry |-+  | ...... |  | |  +-------------------+ |
     +---------+ |  +-------+    | X_DSDT |--+ |  | Definition Blocks | |
     | Pointer |-+  | ..... |    | ...... |    |  +-------------------+ |
     +---------+    +-------+    +--------+    |  +-------------------+ |
                    | Entry |------------------|->|       SSDT        | |
                    +- - - -+                  |  +-------------------| |
                    | Entry | - - - - - - - -+ |  | Definition Blocks | |
                    +- - - -+                | |  +-------------------+ |
                                             | |  +- - - - - - - - - -+ |
                                             +-|->|       SSDT        | |
                                               |  +-------------------+ |
                                               |  | Definition Blocks | |
                                               |  +- - - - - - - - - -+ |
                                               +------------------------+
                                                           |
                                              OSPM Loading |
                                                          \|/
                                                    +----------------+
                                                    | ACPI Namespace |
                                                    +----------------+


```