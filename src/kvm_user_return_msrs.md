在kvm_arch_init初始化的过程中，有一个针对每个CPU都会初始化的变量user_return_msrs。这是一个为host保存的寄存器变量数组，命名和作用都非常有意思。

存在一些寄存器只工作在用户态，也就是在用户态才需要进行读写操作，在内核态是没有用处的。所以只需要从vmm non-root模式切换到kvm然后再到qemu这个切换到用户态过程中才需要加载这些寄存器，而从vmm non-root到kvm然后又再次vm-entry的过程就不需要加载这些寄存器，因为用不到。所以在2009年的时候已经做这些寄存器进行管理，只有切换到用户态才加载，否则成本太高了。除此之外，在除此加载的时候还考虑一些特点，虚拟机和物理机OS相同，切换到用户态也不需要加载；同样的从物理机切换到虚拟机也不需要加载，因为他们相同。ref[x86 shared msr infrastructure](https://lore.kernel.org/lkml/1253105134-8862-4-git-send-email-avi@redhat.com/)

在Intel CPU中的值得什么寄存器呢？
- MSR_EFER：            0xc0000080 /* extended feature register */
- MSR_STAR              0xc0000081 /* legacy mode SYSCALL target */
- MSR_LSTAR             0xc0000082 /* long mode SYSCALL target */
- MSR_CSTAR             0xc0000083 /* compat mode SYSCALL target */
- MSR_SYSCALL_MASK      0xc0000084 /* EFLAGS mask for syscall */
- MSR_TSC_AUX           0xc0000103 /* Auxiliary TSC */
- MSR_IA32_TSX_CTRL     0x00000122 


## msr从host到guest
## 从Guest 到 host