# intro

maple tree（取这个名字可能是借用了枫叶的形状，意指能走向多个方向）与 rbtrees 有根本性的差异。它们属于 B-tree 类型(https://en.wikipedia.org/wiki/B-tree)，也就是说它们的每个节点可以包含两个以上的元素，leaf node（叶子节点）中最多包含 16 个元素，而 internal node（内部节点）中最多包含 10 个元素。使用 B-trees 也会导致很少需要创建新的 node，因为 node 可能包含一些空余空间，可以随着时间的推移而填充利用起来，这就不需要额外进行分配了。每个 node 最多需要 256 字节，这是常用的 cache line size 的整数倍。node 中增加的元素数量以及 cache-aligned size 就意味着在遍历树时会减少 cache-miss。

maple tree 对搜索过程也有改进，同样是来自于 B-tree 结构特点。在 B-tree 中，每个 node 都有一些 key 键值，名为 "pivot"，它会将 node 分隔成 subtree（子树）。在某个 key 之前的 subtree 只会包含小于等于 key 的数据，而这个 key 之后的子树只包含大于 key 的值（并且小于下一个 key 值）。

当然，maple tree 的设计中也是按照 lockless 方式的要求来的，使用 read-copy-update (RCU) 方式。maple tree 是一个通用结构，可以用在内核的不同子系统中。第一个用到 maple tree 的地方就是用来替换 VMA 管理中用到的 rbtree 和双向链表。作者之一 Liam Howlett 在一篇博客中解释了设计由来(https://blogs.oracle.com/linux/the-maple-tree)。


Maple tree 提供了两组 API：一个是简单 API ，一个是高级 API。简单 API 使用 mtree_前缀来标记相关功能，主结构 struct maple_tree 定义如下：

```C
struct maple_tree {
  spinlock_t    ma_lock;
  unsigned int  ma_flags;
  void __rcu    *ma_root;
};
```
需要静态初始化（static initialize）的话，可以使用 `DEFINE_MTREE(name)` 和` MTREE_INIT(name，flags)`，后者会的 flags 目前只定义了两个 bit 选项，其中 `MAPLE_ALLOC_RANGE` 表示该树将被用于分配 range，并且需要把多个分配区域之间的空间（gap）管理起来；`MAPLE_USE_RCU` 会激活 RCU mode，用在多个 reader 的场景下。
```C
void mtree_init(struct maple_tree *mt, unsigned int ma_flags); // mtree_init() API 也使用相同的 flags，不过是用在动态初始化（dynamic initialization）场景：
void mtree_destroy(struct maple_tree *mt); // 开发者可以用这个函数来 free 整个 tree：
```

可以用三个函数来给树增加条目：mtree_insert()、mtree_insert_range()和 mtree_store_range()。前两个函数只有在条目不存在的情况下才会添加，而第三个函数可以对现有的条目进行覆盖。它们的定义如下：

```C
int mtree_insert(struct maple_tree *mt, unsigned long index, void *entry, gfp_t gfp);
int mtree_insert_range(struct maple_tree *mt, unsigned long first, unsigned long last, void *entry, gfp_t gfp);
int mtree_store_range(struct maple_tree *mt, unsigned long first, unsigned long last, void *entry, gfp_t gfp);
```

mtree_insert()的参数 mt 是指向 tree 的指针，index 就是 entry index，entry 是指向一个条目的的指针，有必要的话可以利用 gfp 来指定新增 tree node 的内存分配参数（memory allocation flag）。mtree_insert_range() 会利用给出的 entry 数据来插入从 first 到 last 的一个 range 范围。这些函数成功时返回 0，否则返回负值，如果返回-EEXIST 就表示 key 已经存在。mtree_store_range()与 mtree_insert_range()接受的参数相同，不同的是，它会替换相应 key 的任何现有条目。

有两个函数可以用来从 tree 中获取一个条目或删除一个条目：

```C
void *mtree_load(struct maple_tree *mt, unsigned long index);
void *mtree_erase(struct maple_tree *mt, unsigned long index);
```

要读取一个条目的话，可以使用 mtree_load()，它的参数是一个指向 tree 的指针 mt ，以及所要读取的数据的键值 index。该函数会返回一个指向该条目的指针，如果在 tree 中没有找到键值，则返回 NULL。mtree_erase() 也是同样的语法，用于从 tree 中删除一个 entry。它会从 tree 中删除给定的 key，并返回相关的 entry，如果没有找到，则返回 NULL。

简单的 API 不止上面这些，还有比如 mtree_alloc_range() 可以用来从 key space 中分配一个 range。而高级 API (用 mas_ 前缀标记出来了) 则额外增加了遍历整个 tree 的迭代函数，以及使用 state variable 来访问后一个或者前一个元素。通过这种细粒度的操作，开发者就可以根据需要来恢复中断了的搜索。还有供开发人员找到空闲区域或者对 tree 进行复制操作的 API。