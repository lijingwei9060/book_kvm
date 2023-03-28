
# 编译器代码生成区域

- pure_initcall
- core_initcall
  - core_initcall(init_jiffies_clocksource)
- postcore_initcall
- arch_initcall
- subsys_initcall
- fs_initcall
  - fs_initcall(clocksource_done_booting);
- device_initcall
  - device_initcall(init_clocksource_sysfs);
  - device_initcall(timekeeping_init_ops)
- late_initcall



# 阶段

- finished_booting


// include/linux/init.h

#define __init		__section(".init.text") __cold  __latent_entropy __noinitretpoline __nocfi
#define __initdata	__section(".init.data")
#define __initconst	__section(".init.rodata")
#define __exitdata	__section(".exit.data")
#define __exit_call	__used __section(".exitcall.exit")
