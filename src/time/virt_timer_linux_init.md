# 时间系统初始化

在 init/main.c 的内核启动函数 start_kernel 中，对时钟系统进行了初始化。
```C
start_kernel 
    => setup_arch(&command_line) 
        |-> tsc_early_init()
            |-> determine_cpu_tsc_frequencies(true)  // 矫正cpu_khz和tsc_khz
            |-> tsc_enable_sched_clock() //
        => x86_init.timers.wallclock_init()              // 在x86下其实啥也没做
        => register_refined_jiffies(CLOCK_TICK_RATE)     // 初始化 refined_jiffies,注册第一个clocksource，tick的频率为pit的频率。clocksource是只读的，没有中断。
            |->__clocksource_register()
                |-> clocksource_select()                 // 推动选举，这个时候refined_jiffies是唯一一个cloudsource
                    |-> best = clocksource_find_best(false, false)          // 这个时候还没有完成引导，finished_booting = 0，找不到最优的clocksource，不会切换。现在还没有注册clock_tick_device，这个时间内的jiffies会更新吗？
    |-> parse_args(..., unknown_bootoption) //解析命令行参数
        |-> obsolete_checksetup(param)      // Handle obsolete-style parameters 
            |-> __setup("nohz_full=", housekeeping_nohz_full_setup)  // CONFIG_NO_HZ_FULL=y 这是默认值
                |-> tick_nohz_full_setup(non_housekeeping_mask)
                    |-> tick_nohz_full_running = true // 初始化变量，暂时这是说明是否支持nohz_full模式，并不代表真的在这个模式。

    => tick_init()                                                 // 初始化 tick 系统
        => tick_broadcast_init()                                   // 初始化变量
        => tick_nohz_init()                                        // 这个地方只是检查no_hz_full可以用行吗，没有初始化其他的
    => rcu_init_nohz()
    => init_timers()                                                 // 初始化低精度定期器系统
        |-> init_timer_cpus()
            |-> init_timer_cpu(cpu)
                |-> timer_base->cpu = cpu; // 初始化每个cpu对应timer_base的cpu
                |-> base->clk = jiffies;   // 这个时候tick开始了吗？没有吧
		        |-> base->next_expiry = base->clk + NEXT_TIMER_MAX_DELTA; // delta = 2^30, 这是第一次初始化，所以还不知道next_expiry
        |-> posix_cputimers_init_work()  => handle_posix_cpu_timers   // ?
            |-> clear_posix_cputimers_work(current)                   // 依然不懂
        |-> open_softirq(TIMER_SOFTIRQ, run_timer_softirq)            // 注册软中断号，和对应的中断处理函数(__run_timers)
    => hrtimers_init()                                               // 初始化高精度定期器系统
        |-> hrtimers_prepare_cpu(smp_processor_id());                 // hrtimer_cpu_base 初始化当前cpu的hrtimer_cpu_base
	    |-> open_softirq(HRTIMER_SOFTIRQ, hrtimer_run_softirq);       // 注册软中断号
    => softirq_init()
        |-> tasklet_vec, tasklet_hi_vec 链表初始化
        |-> open_softirq(TASKLET_SOFTIRQ, tasklet_action) => softirq_vec[nr].action = action
	    |-> open_softirq(HI_SOFTIRQ, tasklet_hi_action) => softirq_vec[nr].action = action
    => timekeeping_init()
        => read_persistent_wall_and_boot_offset(&wall_time, &boot_offset) // 从持久化设备中(rtc)读取时间,并计算开机offset(lapic timer中的tsc)
            => read_persistent_clock64(wall_time) => x86_platform.get_wallclock(ts)   // 也就是从cmos中读取时间
            => *boot_offset = ns_to_timespec64(local_clock()) => native_sched_clock(void) => rdtsc() // 读取开机以来cpu中的tsc值然后转换成纳秒，如果是虚拟机调用dummy_sched_clock
            => ntp_init()
            => clock = clocksource_default_clock(); clock->enable(clock); // jiffies没有enable，没有开始计时
            => tk_setup_internals(tk, clock)
            => tk_set_xtime(tk, &wall_time)
            => tk_set_wall_to_mono(tk, wall_to_mono)
            => timekeeping_update(tk, TK_MIRROR | TK_CLOCK_WAS_SET)

    => time_init                                                   // 设置 late_time_init 为 x86_late_time_init
        => x86_late_time_init 
            => x86_init.timers.timer_init() = hpet_time_init() //初始化 hpet，如果不支持，则初始化 pit,   开始tick
                |-> hpet_enable() //Try to setup the HPET timer. Returns 1 on success.
                    |-> clocksource_register_hz(&clocksource_hpet, (u32)hpet_freq)
                    |-> hpet_legacy_clockevent_register(&hpet_base.channels[0]) // 注册了第一个clockevent
                        |-> hpet_enable_legacy_int() // 打开hpet的硬件中断
                        |-> clockevents_config_and_register(&hc->evt, hpet_freq, HPET_MIN_PROG_DELTA, 0x7FFFFFFF) // 注册第一个clockevent，回到tick 设备启动
                            |-> tick_setup_device()
                                |-> tick_next_period = ktime_get();
                                |-> tick_setup_periodic(newdev, 0);
                        |-> global_clock_event = &hc->evt // 修改全局clock_event
                |-> pit_timer_init() //如果hpet不成功，则设置pit
                |-> request_irq(0, timer_interrupt, flags, "timer", NULL)
            => tsc_init                              // 初始化 tsc，需要借助其他时间源来校准，因此放 hpet 后
    => arch_call_rest_init() => rest_init() => kernel_thread(kernel_init, NULL, CLONE_FS) => kernel_init_freeable() => do_basic_setup() => do_initcalls()   //  APIC timer 在此初始化?
        => arch_initcall(init_pit_clocksource)
        => core_initcall(init_jiffies_clocksource)
        => fs_initcall(clocksource_done_booting) // 完成clocksource初始化，finish_booting = 1,  before device_initcall but after subsys_initcall
            |-> curr_clocksource = clocksource_default_clock(); // 这个时候还是pit设备
	        |-> finished_booting = 1;
            |-> clocksource_select() // 真的切换时钟
                |-> timekeeping_notify(best) // 
                    |-> stop_machine(change_clocksource, clock, NULL); // 切换tk_core的时钟, stop_machine: freeze the machine on all CPUs and run this function
                        |-> timekeeping_forward_now(tk); // update clock to the current time,更新tkr_mono, trk_raw,更新xtime
                        |-> tk_setup_internals(tk, new); // 还是配置tk内部
                        |-> timekeeping_update(tk, TK_CLEAR_NTP | TK_MIRROR | TK_CLOCK_WAS_SET);
                    |-> tick_clock_notify(); // Async notification about clocksource changes
        => fs_initcall(init_acpi_pm_clocksource);
        => fs_initcall(hpet_late_init);
        => device_initcall(init_tsc_clocksource);
```