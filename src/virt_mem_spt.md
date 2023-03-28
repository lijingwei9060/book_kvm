

# 影子页表
X86的MMU进行线性地址到物理地址转换，TLB保存了线性地址到物理地址的缓存。然而，Guest里面vCpU看到的是GVA，最后要访问到物理内存需要经过GVA到GPA，再到HVA然后才到HPA的过程，这个转换连非常长，所以KVM做了影子页表缓存GVA到HPA转换，减少转换次数。

影子页表 `struct kvm_mmu_page`包含512个spte，可以是叶子节点也可以非叶子节点，一张表包含的spte可能是混合叶子和非叶子。
非叶子spte可以让硬件mmu找到叶子页面，指向其他的影子页表。
叶子spte对应



# 影子页表管理
建立、查询、重建



# EPT管理过程
EPT页表反应了GPA -> HPA的映射关系。

CPU首先会查找Guest CR3指向的L4页表。由于Guest CR3给出的是GPA，因此CPU需要通过EPT页表来实现Guest CR3 GPA -> HPA的转换。CPU首先会查看硬件的EPT TLB，如果没有对应的转换，CPU会进一步查找EPT页表，如果还没有，CPU则抛出EPT Violation异常由VMM来处理。

获得L4页表地址后，CPU根据GVA和L4页表项的内容，来获取L3页表项的GPA。如果L4页表中GVA对应的表项显示为“缺页”，那么CPU产生Page Fault，直接交由Guest Kernel处理。注意，**这里不会产生VM-Exi**t。获得L3页表项的GPA后，CPU同样要通过查询EPT页表来实现L3 GPA -> HPA的转换，过程和上面一样。

同样的，CPU会依次查找L2、L1页表，最后获得GVA对应的GPA，然后通过查询EPT页表获得HPA。从上面的过程可以看出，CPU需要5次查询EPT页表，每次查询都需要4次内存访问，因此最坏的情况下总共需要20次内存访问。EPT硬件通过增大EPT TLB来尽量减少内存访问。

为了支持EPT，VT-x规范在VMCS的“VM-Execution控制域”中提供了Enable EPT字段。如果在VM-Entry的时候该位被置上，EPT功能就会被启用，CPU会使用EPT功能进行两次转换。
EPT页表的基地址是由VMCS“VM-Execution控制域”的Extended page table pointer字段来指定的，它包含了EPT页表的宿主机物理地址。

EPT通过EPT页表中的SP字段支持大小为2MB或者1GB的超级页。下图给出了2MB超级页的地址转换过程。和上图不同点在于，当CPU发现SP字段为1时，就会停止继续向下遍历页表，而是直接转换了。

EPT同样会使用TLB缓冲来加速页表的查找过程。因此，VT-x还提供了一条新的指令INVEPT，可以使EPT的TLB项失效。这样，当EPT页表有更新时，CPU可以执行INVEPT使旧的TLB失效，使CPU使用新的EPT表项。

和CR3页表会导致Page Fault一样，使用EPT之后，如果CPU在遍历EPT页表进行GPA -> HPA转换时，也会发生异常。

- GPA的地址位数大于GAW。
- 客户机试图读一个不可读的页（R=0）。
- 客户机试图写一个不可写的页（W=0）。
- 客户机试图执行一个不可执行的页（X=0）。

发生异常时，CPU会产生VM-Exit，退出的原因为EPT Violation。VMCS的“VM-Exit信息域”还包括如下信息。

- VM-Exit physical-address information：引起EPT Violation的GPA。
- VM-Exit linear-address information：引起EPT Violation的GVA。
- Qualification：引起EPT Violation的原因，如由于读引起、由于写引起等。

如果VMM给虚拟机分配的物理内存足够连续的话，VMM可以在EPT页表中尽量使用超级页(大页)，这样有利于提高TLB性能。

当CPU开始使用EPT时，VMM还需要处理EPT Violation。通常来说，EPT Violation的来源有如下几种。

- 客户机访问MMIO地址。这种情况下，VMM需要将请求转给I/O虚拟化模块。
- EPT页表的动态创建。有些VMM采用懒惰方法，一开始EPT页表为空，当第一次使用发生EPT Violation时再建立映射。

Intel EPT相关的VMEXIT有两个：
- EPT Misconfiguration：EPT pte配置错误，具体情况参考Intel Manual 3C, 28.2.3.1 EPT Misconfigurations
- EPT Violation：当guest VM访存出发到EPT相关的部分，在不产生EPT Misconfiguration的前提下，可能会产生EPT Violation，具体情况参考Intel Manual 3C, 28.2.3.2 EPT Violations

# VPID(EPT)
在每次VM-Entry和VM-Exit时，CPU会强制TLB内容全部失效，以避免VMM以及不同虚拟机虚拟处理器之前TLB项的混用，因为硬件无法区分一个TLB项是属于VMM还是某一特定的虚拟机处理器。

VPID是一种硬件级的对TLB资源管理的优化。通过在硬件上为每个TLB项增加一个标志，来标识不同的虚拟处理器地址空间，从而区分开VMM以及不同虚拟机的不同虚拟处理器的TLB。换而言之，硬件具备了区分不同的TLB项属于不同虚拟处理器地址空间（对应于不同对的虚拟处理器）的能力。这样，硬件可以避免在每次VM-Entry和VM-Exit时，使全部TLB失效，提高了VM切换的效率。并且，由于这些继续存在的TLB项，硬件也避免了VM切换后的一些不必要的页表遍历，减少了内存访问，提高了VMM以及虚拟机的运行速度。

VT-x通过在VMCS中增加两个域来支持VPID。第一个是VMCS中的Enable VPID域，当该域被置上时，VT-x硬件会启用VPID功能。第二个是VMCS中的VPID域，用于标识该VMCS对应的TLB。VMM本身也需要一个VPID，VT-x规定虚拟处理器标志0被指定用于VMM自身，其他虚拟机虚拟处理器不得使用。VPID个数有限个。

因此，在软件上使用VPID非常简单，主要做两件事情。首先是为VMCS分配一个VPID，这个VPID只要是非0的, 0代表物理机，而且和其他VMCS的VPID不同就可以了；其次是在VMCS中将Enable VPID置上，剩下的事情硬件会自动处理。

# MMU管理
static struct kvm *kvm_create_vm(unsigned long type): 通过ioctl创建vm
	int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)： 调用架构初始化相关
		kvm_init_mmu->init_kvm_tdp_mmu
	r = hardware_enable_all();
	r = kvm_init_mmu_notifier(kvm);
	r = kvm_arch_post_init_vm(kvm);

KVM MMU创建路径： kvm_vm_ioctl_create_vcpu -> kvm_arch_vcpu_setup -> kvm_mmu_setup -> init_kvm_mmu 调用链中。init_kvm_mmu函数根据创建MMU的类型分别有三个调用路径 init_kvm_nested_mmu、 init_kvm_tdp_mmu、 init_kvm_softmmu。init_kvm_nested_mmu是nested virtualization中调用的，init_kvm_tdp_mmu是支持EPT的虚拟化调用的（tdp的含义是Two-dimentional Paging，也就是EPT），init_kvm_soft_mmu是软件SPT（Shadow Page Table）调用的。
