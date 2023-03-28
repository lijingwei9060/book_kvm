# 概念
seqlock所示一种写优先的锁。其分为读顺序锁和写顺序锁, 但是写优先。写锁不会被读锁阻塞，读锁也不会被写锁阻塞, 写锁会被写锁阻塞。

如果读执行单元在读操作期间,写执行单元已经发生了写操作, 那么读执行单元必须重新去读数据,以便确保读到的数据是完整的;这种锁在读写操作同时进行的概率比较小,性能是非常好的,而且它允许读写操作同时进行,因而更大地提高了并发性。

顺序锁有一个限制:它必须要求被保护的共享资源中不能含有指针;因为写执行单元可能会使指针失效,当读执行单元如果正要访问该指针时,系统就会崩溃。

# 原理
eqlock的实现思路是，用一个递增的整型数表示sequence。写操作进入临界区时，sequence++；退出临界区时，sequence再++。写操作还需要获得一个锁（比如mutex），这个锁仅用于写写互斥，以保证同一时间最多只有一个正在进行的写操作。
当sequence为奇数时，表示有写操作正在进行，这时读操作要进入临界区需要等待，直到sequence变为偶数。读操作进入临界区时，需要记录下当前sequence的值，等它退出临界区的时候用记录的sequence与当前sequence做比较，不相等则表示在读操作进入临界区期间发生了写操作，这时候读操作读到的东西是无效的，需要返回重试。

seqlock写写是必须要互斥的。但是seqlock的应用场景本身就是读多写少的情况，写冲突的概率是很低的。所以这里的写写互斥基本上不会有什么性能损失。

而读写操作是不需要互斥的。seqlock的应用场景是写操作优先于读操作，对于写操作来说，几乎是没有阻塞的（除非发生写写冲突这一小概率事件），只需要做sequence++这一附加动作。而读操作也不需要阻塞，只是当发现读写冲突时需要retry。

seqlock的一个典型应用是时钟的更新，系统中每1毫秒会有一个时钟中断，相应的中断处理程序会更新时钟（写操作）。而用户程序可以调用gettimeofday之类的系统调用来获取当前时间（读操作）。在这种情况下，使用seqlock可以避免过多的gettimeofday系统调用把中断处理程序给阻塞了（如果使用读写锁，而不用seqlock的话就会这样）。中断处理程序总是优先的，而如果gettimeofday系统调用与之冲突了，那用户程序多等等也无妨。

# api

static inline int grow_chain32(struct ufs_inode_info *ufsi,
			       struct buffer_head *bh, __fs32 *v,
			       Indirect *from, Indirect *to)
{
	Indirect *p;
	unsigned seq;
	to->bh = bh;
	do {
		seq = read_seqbegin(&ufsi->meta_lock);
		to->key32 = *(__fs32 *)(to->p = v);
		for (p = from; p <= to && p->key32 == *(__fs32 *)p->p; p++)
			;
	} while (read_seqretry(&ufsi->meta_lock, seq));
	return (p > to);
}
其源码分析如下：
可以看到这个函数没实现为内联函数
```C
static inline unsigned read_seqbegin(const seqlock_t *sl)
{
	return read_seqcount_begin(&sl->seqcount);
}
static inline unsigned read_seqcount_begin(const seqcount_t *s)
{
	// 没有定义CONFIG_DEBUG_LOCK_ALLOC的时候为空函数
	seqcount_lockdep_reader_access(s);
	return raw_read_seqcount_begin(s);
}
static inline unsigned raw_read_seqcount_begin(const seqcount_t *s)
{
	// 开始一个seq-read的critical section，without barrier
	unsigned ret = __read_seqcount_begin(s);
	// 内存barrier 
	smp_rmb();
	return ret;
}
 
static inline unsigned __read_seqcount_begin(const seqcount_t *s)
{
	unsigned ret;
 
repeat:
	// 这里尝试从读取s->sequence的值，如果其返回为1的话，则说明可能正在写，则读尝试继续读取。
	// 从这里可以很明显的看到顺序锁是写优先的。因为如果读获取不到锁的话，会一直等待，直到写释放锁.
	ret = READ_ONCE(s->sequence);
	if (unlikely(ret & 1)) {
		cpu_relax();
		goto repeat;
	}
	return ret;
}
```