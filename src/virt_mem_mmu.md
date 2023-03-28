# MMU
kvm中的MMU支持传统的MMU和硬件支持的TDP(NPT和EPT)，支持2、3、4、5级别地址转换支持global page、pae、pse(page size extension)、pse36(36位地址)，cr0.wp(write protect)和1GB的大页。
支持转换的场景, 如果请求的地址转换硬件支持，则采用direct mode，否则用shadow mode：
1. Guest的分页关闭，则支持gpa -> hpa。
2. Guest分页打开，支持gva-> gpa -> hpa
3. Guest嵌入guest， 支持ngva->ngpa->gpa->hpa
   
事件驱动：
Guest事件：写入控制寄存器；invlpg、invlpga指令；访问缺失的或者保护的地址转换；
host事件：改变从gpa到hpa的转换，包括gpa到hva和hva到hpa；内存收缩。


# 管理
kvm_mmu_prepare_zap_page(vcpu->kvm, sp, &invalid_list);
kvm_sync_page(vcpu, sp, &invalid_list)
kvm_flush_remote_tlbs(vcpu->kvm);
sp = kvm_mmu_alloc_page(vcpu, direct)

## 数据结构
- struct kvm_vcpu_arch 
  - struct kvm_mmu *mmu        // 始终指向L1的mmu
  - struct kvm_mmu guest_mmu   // 嵌套模式下的L1的mmu
  - struct kvm_mmu root_mmu    // 非嵌套模式下L1的mmu
  - struct kvm_mmu nested_mmu; // 被嵌套的MMU
  - struct kvm_mmu *walk_mmu;  // 指向mmu上下文，用于gva到gpa转换 
  - struct kvm_mmu_memory_cache mmu_pte_list_desc_cache; // 用来分配struct pte_list_desc结构，该结构主要用于反向映射，参考rmap_add函数，每个rmapp指向的就是一个pte_list。后面介绍反向映射的时候会详细介绍。
  - struct kvm_mmu_memory_cache mmu_page_cache; // 用来分配spt页结构，spt页结构是存储spt paging structure的页，对应kvm_mmu_page.spt
  - struct kvm_mmu_memory_cache mmu_page_header_cache; // 用来分配struct kvm_mmu_page结构，从该cache分配的页面可能会调用kmem_cache机制来分配
- struct kvm_arch
  - struct list_head active_mmu_pages: 活动的mmu page，这个就是spt吧？
  - struct list_head zapped_obsolete_pages： 过期的page？
  - struct list_head lpage_disallowed_mmu_pages： 不需要大页的page？
  - spinlock_t mmu_unsync_pages_lock
  - struct list_head tdp_mmu_roots
  - struct list_head tdp_mmu_pages
  - struct workqueue_struct *tdp_mmu_zap_wq： 应该是压缩的时候的内核任务
  - bool shadow_root_allocated
  - hpa_t	hv_root_tdp
- struct kvm_mmu_page: 代表一个保存mmu的物理页面，对应物理页面page->private为struct *kvm_mmu_page
	- struct list_head link 	    // 将该页结构链接到kvm->arch.active_mmu_pages和invalid_list上，标注该页结构不同的状态
	- struct hlist_node hash_link // KVM中会为所有的mmu_page维护一个hash链表，用于快速找到对应的kvm_mmu_page实例，4096个hash链
	- bool tdp_mmu_page;  //表示是否为EPT页表页（在alloc_tdp_mmu_page中设置） 
	- bool unsync; // 用在最后一级页表页，用于判断该页的页表项是否与guest的翻译同步（即是否所有pte都和guest的tlb一致）
	- u8 mmu_valid_gen // 该页的generation number，用于和kvm->arch.mmu_valid_gen进行比较，比它小表示该页是invalid的；将kvm->arch.mmu_valid_gen加1，那么当前所有的MMU页结构都变成了invalid，可以快速碾压失效该页表页所管理的guest物理地址空间，而处理掉页结构的过程可以留给后面的过程（如内存不够时）再处理，这样就可以加快这个过程；当mmu_valid_gen值达到最大时，可以调用kvm_mmu_invalidate_zap_all_pages手动废弃掉所有的MMU页结构。
	- bool lpage_disallowed; /* Can't be replaced by an equiv large page */
	- union kvm_mmu_page_role role;  // role.level: 表示页结构在EPT页层级中的level，例如level为1是最底层的页表，每个条目指向一个物理页，level为4表示最顶层页表(即EPTP，地址存储在VMCS的EPT pointer）; 表示页表页内的表项通过多少个level的逻辑关系进行管理，当没有开启HOST大页的时候，level=1，就是一个HOST物理页面中有512个管理表项： 1=4k sptes, 2=2M sptes, 3=1G sptes; 在非hugepage情况下，tdp_level =1 时，一个host页面(4k)中的表项就可以管理 512 个 guest 物理页框(一个页表项用8字节表示);tdp_level =2 时，一个host页面(4k)中的表项就可以管理 512*512 = 262144 个 guest 物理页框;tdp_level =3 时，一个host页面(4k)中的表项就可以管理 512*512 * 512 = 134217728个 guest物理页框; 由函数alloc_tdp_mmu_page设置
	- gfn_t gfn;   // 通过kvm_mmu_get_page传进来的gfn，在EPT机制下，每个kvm_mmu_page对应一个gfn，shadow paging见gfns 
	- u64 *spt;    // 该kvm_mmu_page对应的页表页的宿主机虚拟地址hva	
	- gfn_t *gfns; // 在shadow paging机制下，每个kvm_mmu_page对应多个gfn，存储在该数组中
	- union {
	- 	int root_count; // 当前是一个active root，用在第4级页表，标识有多少EPTP指向该级页表页；用在第4级页表，标识有多少EPTP指向该级页表页，root_count只对eptp指向的mmu page有意义，其他mmu page都是0;  他的值表示该页表页被多少个vcpu作为根页结构；当为非0值时，该页表页不可以被回收（kvm_mmu_zap_oldest_mmu_pages）; A counter keeping track of how many hardware registers (guest cr3 or pdptrs) are now pointing at the page. While this counter is nonzero, the page cannot be destroyed. See role.invalid. get_tdp_mmu_vcpu_root函数中申请新页表页时，设置初始值为1
	- 	refcount_t tdp_mmu_root_count;
	- };
	- unsigned int unsync_children; // 记录该页表页中有多少个spte是unsync状态的
	- union {
	- 	struct kvm_rmap_head parent_ptes; //表示有哪些上一级页表页的页表项指向该页表页, 和rmap有关， rmap pointers to parent sptes 
	- 	tdp_ptep_t ptep;
	- };
	- union {
	- 	DECLARE_BITMAP(unsync_child_bitmap, 512); // 记录了unsync的sptes的bitmap，用于快速查找
	- 	struct {
	- 		struct work_struct tdp_mmu_async_work;
	- 		void *tdp_mmu_async_data;
	- 	};
	- };
	- struct list_head lpage_disallowed_link;
	- atomic_t write_flooding_count; // 在页表页写保护模式下，用于避免过多的页表项修改造成的模拟（emulation）；在写保护模式下，对于任何一个页的写都会导致KVM进行一次emulation。对于叶子节点（真正指向数据页的节点），可以使用unsync状态来保护频繁的写操作不会导致大量的emulation，但是对于非叶子节点（paging structure节点）则不行。 对于非叶子节点的写emulation会修改该域，如果写emulation非常频繁，KVM会unmap该页以避免过多的写emulation。
- kvm_mmu: 代表一个模拟的MMU设备,可以是tdp mmu、也可以是soft mmu，支持2(32bit)、3(32bit)、4(64bit)、5(64bit)级分页
	- struct kvm_mmu_root_info root: // 包含gpa和hpa地址，对应SPTE树根信息
	- union kvm_mmu_role mmu_role;
	- u8 root_level         // 当Guest采用不同的分页模式时，页结构的层级页各有不同，root_level表示的是最顶层的页结构是第几级
	- u8 shadow_root_level： 就是影子页表的级数，EPT情况下这个是4
	- u8 ept_ad;
	- bool direct_map;     // 区分mmu是基于影子页表实现还是基于内存硬件机制实现，direct_map为true时表示基于硬件（EPT/NPT）实现
	- struct kvm_mmu_root_info prev_roots[KVM_MMU_NUM_PREV_ROOTS];
	- u8 permissions[16];
	- u32 pkru_mask;
	- u64 *pae_root;
	- u64 *pml4_root;
	- u64 *pml5_root: 现在mmu支持5级，这个就是5级页表spt
	- struct rsvd_bits_validate shadow_zero_check;
	- struct rsvd_bits_validate guest_rsvd_check;
	- u64 pdptrs[4]; /* pae */
- kvm_mmu_page_role // 表示mmu page所处的层级，上下层级关系
    - level	该页表页的层级
    - cr4_pae	记录了cr4.pae的值，如果是direct模式，该值为0
    - quadrant	暂时不清楚
    - direct	如果是EPT机制，则该值为1，否则为0
    - access	该页表页的访问权限，参见之后的说明
    - invalid	表示该页是否有效（暂时不确定）
    - nxe	记录了efer.nxe的值（暂时不清楚什么作用）
    - cr0_wp	记录了cr0.wp的值，表示该页是否写保护
    - smep_andnot_wp	记录了cr4.smep && !cr0.wp的值（暂时不确定什么作用）
- struct kvm_mmu_pages
- struct kvm_page_fault:
  - addr: gpa，guest物理页地址
  - bool rsvd： invalid generation number？？？
  - bool exec: 不可执行？
  - bool present: 不存在
  - bool write： 不可写？
- struct kvm_page_track_notifier_node: mmu 的page 跟踪通知链接
  - track_write = kvm_mmu_pte_write，页面写入跟踪
  - track_flush_slot = kvm_mmu_invalidate_zap_pages_in_memslot： 

## 初始化

static struct kvm *kvm_create_vm(unsigned long type): 通过ioctl创建vm
	r = kvm_arch_init_vm(kvm, type)： 调用不同架构的kvm初始化共走，
        ret = kvm_page_track_init(kvm)：初始化内存页面跟踪功能
		ret = kvm_mmu_init_vm(kvm)：
            r = kvm_mmu_init_tdp_mmu(kvm)： 这里只是初始化了kvm.arch中关于mmu链表结构，和tdp_mmu_enabled, 并没有对mmu进行初始化。
	r = kvm_init_mmu_notifier(kvm)：配置struct mmu_notifier_ops kvm_mmu_notifier_ops
	r = kvm_arch_post_init_vm(kvm); 调用kvm_mmu_post_init_vm(kvm)，创建线程kvm-nx-lpage-recovery，看名字和大页管理相关

KVM MMU创建路径： kvm_vm_ioctl_create_vcpu -> kvm_arch_vcpu_setup -> kvm_mmu_setup -> init_kvm_mmu 调用链中。init_kvm_mmu函数根据创建MMU的类型分别有三个调用路径 init_kvm_nested_mmu、 init_kvm_tdp_mmu、 init_kvm_softmmu。init_kvm_nested_mmu是nested virtualization中调用的，init_kvm_tdp_mmu是支持EPT的虚拟化调用的（tdp的含义是Two-dimentional Paging，也就是EPT），init_kvm_soft_mmu是软件SPT（Shadow Page Table）调用的。


int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
    r = kvm_mmu_create(vcpu);
        ret = __kvm_mmu_create(vcpu, &vcpu->arch.guest_mmu);
        1. vcpu->arch.guest_mmu isn't used when !tdp_enabled.
        2. 32bit，支持pae，分配mmu->pae_root为一个页面，pae_root要分配4个页面
        ret = __kvm_mmu_create(vcpu, &vcpu->arch.root_mmu);
    kvm_init_mmu(vcpu);
        init_kvm_tdp_mmu(vcpu)： 初始化tdp mmu

int kvm_mmu_load(struct kvm_vcpu *vcpu)
  r = mmu_topup_memory_caches(vcpu, !vcpu->arch.mmu->direct_map);
  r = mmu_alloc_special_roots(vcpu) // 分配pml4_root、pml4_root和pae_root页面
  r = mmu_alloc_direct_roots(vcpu);
  kvm_mmu_sync_roots(vcpu);
  kvm_mmu_load_pgd(vcpu);
  static_call(kvm_x86_flush_tlb_current)(vcpu);

## 建立EPT结构
int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
    static int direct_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
        1.  is_tdp_mmu(vcpu->arch.mmu): 判断是否是tdp
        2.  page_fault_handle_page_track(vcpu, fault)： page track是干什么的？
        3.  r = fast_page_fault(vcpu, fault) // GFN对应的物理页存在且violation是由读写操作引起的，才可以使用快速处理
        4.  r = mmu_topup_memory_caches(vcpu, false) // 进行缓存池的分配
        5.  kvm_faultin_pfn(vcpu, fault, &r): // 内存被删除退出；内存不可见(apic access page)退出; 物理页面被换出请求换入(主机缺页中断)；
        6.  handle_abnormal_pfn(vcpu, fault, ACC_ALL, &r)
        7.  is_page_fault_stale(vcpu, fault, mmu_seq)
        8.  r = make_mmu_pages_available(vcpu)
        9.  r = kvm_tdp_mmu_map(vcpu, fault);
        10. r = __direct_map(vcpu, fault);
        static int __direct_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
        根据page fault构建shadow table，即在level相等之前，发现需要的某一级的页表项为NULL，就调用kvm_mmu_get_page获取一个page，然后调用link_shadow_page设置页表项指向page
            entry的level和请求的level是否相等，相等说明该entry处引起的violation，即该entry对应的下级页或者页表不在内存中，或者直接为NULL。
            level不相等，就进入后面的if判断，这是判断该entry对应的下一级页是否存在，如果不存在需要重新构建，存在就直接向后遍历，即对比二级页表中的entry

## walk mmu

## vm_exit
EXIT_REASON_EPT_VIOLATION = handle_ept_violation
触发原因：
error_code: EPT_VIOLATION_ACC_READ (读),EPT_VIOLATION_ACC_WRITE(写),EPT_VIOLATION_ACC_INSTR(fetch), PFERR_PRESENT_MASK(存在吗，EPT_VIOLATION_READABLE | EPT_VIOLATION_WRITABLE |	EPT_VIOLATION_EXECUTABLE), EPT_VIOLATION_GVA_TRANSLATED
过程链：
  kvm_mmu_page_fault(vcpu, gpa, error_code, NULL, 0)
  1. r = handle_mmio_page_fault(vcpu, cr2_or_gpa, direct)： 
  2. r = kvm_mmu_do_page_fault(vcpu, cr2_or_gpa, lower_32_bits(error_code), false);


handle_ept_misconfig

static int handle_cr(struct kvm_vcpu *vcpu): 
触发原因：处理cr访问，使用vmcs是不会退出到这里的，需要设置VMCS的cr3 load-exiting
vm—exit: EXIT_REASON_CR_ACCESS
处理链： 
    从vmcs读取vm-exit的action和具体的寄存器CR，写入cr0、cr3、cr4、cr8，clts，读cr3、cr8，lmsw
    1. cr0变更，启动guest 分页(X86_CR0_PG), 清理apf队列、重置apfhash表，刷新guest 的tlb，设置kvm_vcpu.requests标志位
    2. cr0变更，涉及到分页或者写保护(cr0.wp), 重置vcpu对应的mmu(删除kvm_vcpu.arch.root_mmu\guest_mmu, 以及mmio； 新建mmu 嵌套、soft或者tdp)。
    3. cr0变更，禁用缓存X86_CR0_CD，清楚spte表的叶子节点


## 快速fast_page_fault
- spte not present ,potentially caused by access tracking
- spte present, the fault is caused by write-protect, that means we just need change the W bit of the spte which can be done out of mmu-lock

过程：
walk_shadow_page_lockless_begin(vcpu); ???/
如果是tdp mmu，sptep 获取最低level的 shadow page walk for given gpa，

## slow page fault
- the mmio spte with invalid generation number
- (fault->exec && fault->present): the page fault is due to an NX violation