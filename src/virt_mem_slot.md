虚拟机的内存地址空间是由用户态程序申请并注册给KVM。


# 管理过程
入口函数
1. `check_memory_region_flags` 检查传递过来的mem 标记是否合法，目前只允许脏页跟踪和设置只读。脏页跟踪是为了热迁移做准备工作，只读是为了写入时触发vm-exit。
2. 参数检查： 大小没有溢出，page页面对齐，gpa物理地址页面对齐
3. 找到原先的内存条(可能为NULL)，比对old和new内存条来判断是新增、修改还是删除。修改的时候要求hva、大小、flag相同，起始位置不同是移动，flag不同则修改flag。创建和修改不能导致内存条重叠。调用`kvm_set_memslot`进行修改。
4. `kvm_set_memslot`
   1. 如果是删除或者move，先把原先的old内存条调用`kvm_invalidate_memslot` 失效，变成全0的值。flag变成`KVM_MEMSLOT_INVALID`, 替换kvm中memslot， 刷新shadow memslot，回收guest memory。
   2. `kvm_create_memslot`：先调用`kvm_replace_memslot` 插入new slot到kvm 的inactive memslot中。`kvm_activate_memslot`切换active和inactive set，generation += 2，调用架构相关函数`kvm_arch_memslots_updated`，在x86上会可能导致mmio spte失效，对每个vcpu kick out . 切换active和inactive的过程中有许多锁(slots_arch_lock, mn_invalidate_lock)的管理，要保持`kvm.mn_active_invalidate_count` 下降到0，禁止当前kvm中断, 重新调度(vcpu？)。切换完之后在调用一次`kvm_replace_memslot`，使得 active和inactive保持一致。
   3. `kvm_delete_memslot`: 
   4. `kvm_move_memslot`
   5. `kvm_update_flags_memslot`
   6. `kvm_commit_memory_region` 前面做的变化内容太多，如果有一个地方不成功进行回滚比较复杂，所以变成前面只负责准备各个部分的变化，把结果提交到kvm上进行变更。`nr_memslot_pages` 变化，释放old slot，对于dirt flag变化需要释放dirty bitmap。根据不同架构，再次调用`kvm_arch_commit_memory_region` 架构相关进行调整，对于x86，需要再次计算mmu page数量变化。设置dirty flag和readonly flag会调用响应配置，配置dirt log和删除write 权限。

# 数据结构
- `kvm_memory_slot` 代表一个内存条
  - id_node: 指向hash桶，指向active 或者inactive set中的hash桶。
  - hva_node： 指向间隔树node(start、last，红黑树管理)，2个也是对应到active 或者inactive set。
  - gfn_node: 指向set中gfn_tree的node, 所以也是2个。
  - arch：包含内存条对应的架构相关信息，比如rmap和lpage_info。rmap保留gfn到对应页面的映射，如果没有启用tdp或者已经分配了spte的root就会创建rmap。lpage_info只有一个字段是否开启了大页。rmap有KVM_NR_PAGE_SIZES个类型，
- `kvm_userspace_memory_region` 代表用户传递过来的内存条地址空间。
  - as_id: 地址空间id，是slot >> 16
  - id: (u16)slot
- `kvm_memslots` ： 代表memslot集合，内部采用红黑树进行管理，7位 hash表保存slot id到memslot的映射。
  - node_idx: 代表这个set中所属的类型，active 或者inactive，0或者1；
  - id_hash: 按照id进行hash(用一个大的素数相乘，导致数据溢出然后打散)到具体的桶上，有1<<7个桶。
  - gfn_tree： 以gfn为基础的红黑树