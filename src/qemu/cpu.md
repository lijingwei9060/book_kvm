# qom

TYPE_DEVICE -> TYPE_CPU -> TYPE_X86_CPU -> X86_CPU_TYPE_NAME("max")/X86_CPU_TYPE_NAME("base")

x86_register_cpudef_types(&builtin_x86_defs[i]) // 注册具体的cpu型号

## 初始化CPU

DEFINE_Q35_MACHINE
pc_q35_init(machine);