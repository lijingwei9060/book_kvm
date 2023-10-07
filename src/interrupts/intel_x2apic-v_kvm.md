# 概念

功能目标： 
1. lapic-virtualization： 设备，寄存器，功能模拟
2. virtual interrupt delivery
3. posted interrupt

具体：
1. tpr shadow，写入VIRTUAL_APIC_PAGE_ADDR virtual apic page物理地址。
2. apic access page， 写入APIC_ACCESS_ADDR 物理地址
3. pi支持
4. vpid支持： VIRTUAL_PROCESSOR_ID

## 功能模拟

#### KVM Timer

host有自己的lapic timer，硬件实现，guest也有自己的lapic timer，kvm模拟。一个pcup上要运行很多个vcpu，每个vcpu都有自己的lapic timer，kvm要模拟很多个lapic timer，kvm用软件定时器hrtimer来模拟lapic timer，guest写tscdeadline msr，kvm把这个tsc值转换成一个软件定时器的值，启动软件定时器，硬件定时器驱动软件定时器，软件定时器超时后，假如硬件timer中断正好把vcpu exiting出来，那么设置timer interrupt pending，重新enter时把timer中断注入，如果vcpu运行在其它pcpu上，需要把vcpu kick出来，所以最好把timer绑定的物理cpu和vcpu所运行的物理cpu始终一致，如果vcpu运行的物理cpu变化了，migrate timer到新的物理cpu，这样中断来了vcpu自动exit，不再需要kick一次。

preemption timer是intel vmx技术增加的一种硬件timer，和tsc相关，在VMCS中设置一个值 ，vm entry，时间到了，preemption timer就会触发vcpu exiting出来。vcpu写tscdeadline msr exiting出来，kvm把这个值写到VMCS中，enter non-root，时间到了exiting出来，设置pending，然后重新进入把中断注入。

```C
kvm_set_lapic_tscdeadline_msr
  -->start_apic_timer
      -->restart_apic_timer
          {
            if (!start_hv_timer(apic))
		start_sw_timer(apic);
           }
```

这儿hv_timer就是preemption timer，sw_timer是软件hrtimer，有preemption timer就用hv_timer，没有就用sw_timer。hv_timer的问题就是可能时间没到，vcpu由于其它原因exit出来，那么就需要kvm_lapic_switch_to_sw_timer，再次enter时kvm_lapic_switch_to_hv_timer。

参考： https://cloud.tencent.com/developer/article/1848757

https://lore.kernel.org/kvm/1562376411-3533-1-git-send-email-wanpengli@tencent.com/t/

## 数据结构
- kvm_lapic: 每个vcpu都有，该结构主要由3部分信息形成：即将作为IO设备注册到Guest的设备相关信息；一个定时器；Lapic的apic-page信息
- APIC-access page in kvm->kvm_arch->apic_access_page， 在alloc_apic_access_page中分配4K空间，gpa为0xFEE00000H。
- virtual-apic page 保存在kvm_lapic->regs，每个vcpu都有，4K大小，在int kvm_create_lapic(struct kvm_vcpu *vcpu)中分配。

```c
struct kvm_lapic {
	unsigned long base_address; // LAPIC的基地址
	struct kvm_io_device dev; // 准备将LAPIC注册为IO设备
	struct { // 定义一个基于HRTIMER的定时器
		atomic_t pending;
		s64 period;	/* unit: ns */
		u32 divide_count;
		ktime_t last_update;
		struct hrtimer dev;
	} timer;
	struct kvm_vcpu *vcpu; // 所属vcpu
	struct page *regs_page; // lapic所有的寄存器都在apic-page上存放。
	void *regs;
};

```

```C
struct apic {
	/* Hotpath functions first */
	void	(*eoi_write)(u32 reg, u32 v);
	void	(*native_eoi_write)(u32 reg, u32 v);
	void	(*write)(u32 reg, u32 v);
	u32	(*read)(u32 reg);

	/* IPI related functions */
	void	(*wait_icr_idle)(void);
	u32	(*safe_wait_icr_idle)(void);

	void	(*send_IPI)(int cpu, int vector);
	void	(*send_IPI_mask)(const struct cpumask *mask, int vector);
	void	(*send_IPI_mask_allbutself)(const struct cpumask *msk, int vec);
	void	(*send_IPI_allbutself)(int vector);
	void	(*send_IPI_all)(int vector);
	void	(*send_IPI_self)(int vector);

	u32	disable_esr;

	enum apic_delivery_modes delivery_mode;
	bool	dest_mode_logical;

	u32	(*calc_dest_apicid)(unsigned int cpu);

	/* ICR related functions */
	u64	(*icr_read)(void);
	void	(*icr_write)(u32 low, u32 high);

	/* Probe, setup and smpboot functions */
	int	(*probe)(void);
	int	(*acpi_madt_oem_check)(char *oem_id, char *oem_table_id);
	int	(*apic_id_valid)(u32 apicid);
	int	(*apic_id_registered)(void);

	bool	(*check_apicid_used)(physid_mask_t *map, int apicid);
	void	(*init_apic_ldr)(void);
	void	(*ioapic_phys_id_map)(physid_mask_t *phys_map, physid_mask_t *retmap);
	void	(*setup_apic_routing)(void);
	int	(*cpu_present_to_apicid)(int mps_cpu);
	void	(*apicid_to_cpu_present)(int phys_apicid, physid_mask_t *retmap);
	int	(*check_phys_apicid_present)(int phys_apicid);
	int	(*phys_pkg_id)(int cpuid_apic, int index_msb);

	u32	(*get_apic_id)(unsigned long x);
	u32	(*set_apic_id)(unsigned int id);

	/* wakeup_secondary_cpu */
	int	(*wakeup_secondary_cpu)(int apicid, unsigned long start_eip);
	/* wakeup secondary CPU using 64-bit wakeup point */
	int	(*wakeup_secondary_cpu_64)(int apicid, unsigned long start_eip);

	void	(*inquire_remote_apic)(int apicid);

#ifdef CONFIG_X86_32
	/*
	 * Called very early during boot from get_smp_config().  It should
	 * return the logical apicid.  x86_[bios]_cpu_to_apicid is
	 * initialized before this function is called.
	 *
	 * If logical apicid can't be determined that early, the function
	 * may return BAD_APICID.  Logical apicid will be configured after
	 * init_apic_ldr() while bringing up CPUs.  Note that NUMA affinity
	 * won't be applied properly during early boot in this case.
	 */
	int (*x86_32_early_logical_apicid)(int cpu);
#endif
	char	*name;
};

static struct apic apic_x2apic_cluster __ro_after_init = {

	.name				= "cluster x2apic",
	.probe				= x2apic_cluster_probe,
	.acpi_madt_oem_check		= x2apic_acpi_madt_oem_check,
	.apic_id_valid			= x2apic_apic_id_valid,
	.apic_id_registered		= x2apic_apic_id_registered,

	.delivery_mode			= APIC_DELIVERY_MODE_FIXED,
	.dest_mode_logical		= true,

	.disable_esr			= 0,

	.check_apicid_used		= NULL,
	.init_apic_ldr			= init_x2apic_ldr,
	.ioapic_phys_id_map		= NULL,
	.setup_apic_routing		= NULL,
	.cpu_present_to_apicid		= default_cpu_present_to_apicid,
	.apicid_to_cpu_present		= NULL,
	.check_phys_apicid_present	= default_check_phys_apicid_present,
	.phys_pkg_id			= x2apic_phys_pkg_id,

	.get_apic_id			= x2apic_get_apic_id,
	.set_apic_id			= x2apic_set_apic_id,

	.calc_dest_apicid		= x2apic_calc_apicid,

	.send_IPI			= x2apic_send_IPI,
	.send_IPI_mask			= x2apic_send_IPI_mask,
	.send_IPI_mask_allbutself	= x2apic_send_IPI_mask_allbutself,
	.send_IPI_allbutself		= x2apic_send_IPI_allbutself,
	.send_IPI_all			= x2apic_send_IPI_all,
	.send_IPI_self			= x2apic_send_IPI_self,

	.inquire_remote_apic		= NULL,

	.read				= native_apic_msr_read,
	.write				= native_apic_msr_write,
	.eoi_write			= native_apic_msr_eoi_write,
	.icr_read			= native_x2apic_icr_read,
	.icr_write			= native_x2apic_icr_write,
	.wait_icr_idle			= native_x2apic_wait_icr_idle,
	.safe_wait_icr_idle		= native_safe_x2apic_wait_icr_idle,
};

```

## 接口
static int alloc_apic_access_page(struct kvm *kvm)： 为每个虚拟机分配apic access page，gpa为0xFEE0000H。
static void vmx_vcpu_reset(struct kvm_vcpu *vcpu)： 写入APIC-access page 和 virutal-apic page信息到VMCS中。

kvm_irq_delivery_to_apic: 遍历每个vcpu，查看其apic id和重定向表中取出的id是否一样
kvm_lowest_prio_delivery
kvm_apic_set_irq
__apic_accept_irq: lapic收到来自其它CPU或IOAPIC发来的中断向量。lapic递交中断信号的主要动作就是往它模拟的lapic的寄存器地址上，IRR对应的地方写1，之后标记vcpu上的request的对应bit，这里是event。注意，除了这种方式，如果硬件支持posted-interrupt方式deliver中断，需要优先考虑使用。lapic将内存中IRR上中断向量对应bit置1后，make request就完成了。之后就是唤醒vcpu或者将其从guest态踢出，让其再次进入guest态前能够处理中断，这个动作被称为Kick


kvm_irq_delivery_to_apic
kvm_arch_async_page_present
kvm_irq_delivery_to_apic_fast
kvm_pv_send_ipi


vmx_deliver_interrupt()
|-> vmx_deliver_posted_interrupt(vcpu, vector)