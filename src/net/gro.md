# 数据结构

- napi_gro_cb(GRO控制块): GRO功能使用skb结构体内私有空间cb[48]来存放gro所用到的一些信息,skb->cb指向该结构。提供给GRO操作函数，不改变skb中提供给协议层的属性，实现协议层offload处理。
- struct list_head offload_base: 全局变量，保留设备注册的`packet_offload`函数，有设备链路层(eth_packet_offload)、ip层(ip_packet_offload)、tcp层、udp层、vxlan、vlan(vlan_packet_offloads)、mpls、ipip

```C
#define MAX_GRO_SKBS 8
#define GRO_MAX_HEAD (MAX_HEADER + 128)
#define GRO_HASH_BUCKETS  8 //size of gro hash buckets, must less than bit number of napi_struct::gro_bitmask
static struct list_head offload_base __read_mostly = LIST_HEAD_INIT(offload_base);
int gro_normal_batch __read_mostly = 8; //Maximum number of GRO_NORMAL skbs to batch up for list-RX

struct gro_list { 
    struct list_head    list; // list contains packets ordered by age. youngest packets at the head of it. Complete skbs in reverse order to reduce latencies.
    int            count;
};

struct napi_struct {
    unsigned long   gro_bitmask;
    struct gro_list  gro_hash[GRO_HASH_BUCKETS]; 
    struct list_head    rx_list; /* Pending GRO_NORMAL skbs */
    int     rx_count; /* length of rx_list */
}

enum gro_result {
    GRO_MERGED,       //报文已经被保存到gro_list中，不要求释放sk
    GRO_MERGED_FREE, //报文已经merge，需要释放skb
    GRO_HELD,        // 这个表示当前数据已经被gro保存起来，但是并没有进行合并，因此skb还需要保存。
    GRO_NORMAL,      //返回值为normal，则直接提交报文给协议栈, netif_receive_skb(skb)
    GRO_CONSUMED,
};
typedef enum gro_result gro_result_t;
```

```C
struct napi_gro_cb {
    void    *frag0; // 指向存在skb_shinfo(skb)->frag[0].page + offset 页的数据的头部, GRO使用过程中，如果skb是线性的，就置为空。如果是非线性的并且报文头部全部存在非线性区中，    就指向页中的数据起始部分
    unsigned int frag0_len; // 第一页中数据的长度，如果frag0 字段不为空，就设置该字段，否则为0。( Length of frag0.)
    int data_offset; // 表明skb->data到GRO需要处理的数据区的偏移量。因为在GRO合并处理过程中skb->data是不能被改变的，所以需要使用该字段来记录一下偏移量。GRO处理过程中根据该记录值快速找到要处理的数据部分。比如进入ip层进行GRO处理，这时skb->data指向ip 头，而ip层的gro 正好要处理ip头，这时偏移量就为0。 进入传输层后进行GRO处理，这时skb->data还指向ip头，而tcp层gro要处理tcp头，这时偏移量就是ip头部长度。
    u16 flush; //如果该字段不为0，表示该数据报文没必要再等待合并， 可以直接送进协议栈进行处理了
    u16    flush_id; //Save the IP ID here and check when we get to the transport layer
    u16 count; //该报文被合并过的次数
    u16    proto; //Used in ipv6_gro_receive() and foo-over-udp
    unsigned long age; // jiffies when first packet was created/queued

    /* portion of the cb set to zero at every gro iteration */
    struct_group(zeroed,
        u16    gro_remcsum_start; //Start offset for remote checksum offload
        u8  same_flow:1; //标记挂在napi->gro_list上的报文是否跟现在的报文进行匹配。每层的gro_receive都设置该标记位。 接收到一个报文后，使用该报文和挂在napi->gro_list 上的报文进行匹配。 在链路层，使用dev 和 mac头进行匹配，如果一样表示两个报文是通一个设备发过来的，就标记napi->gro_list上对应的skb的same为1。 到网络层，再进一步进行匹配时，只需跟napi->list上刚被链路层标记 same为1的报文进行网络层的匹配即可，不需再跟每个报文进行匹配。如果网络层不匹配，就清除该标记。到传输层，也是只配置被网络层标记same为1 的报文即可。这样设计为的是减少没必要的匹配操作
        u8    encap_mark:1; //Used in tunnel GRO receive
        u8    csum_valid:1; //GRO checksum is valid
        u8    csum_cnt:3; //Number of checksums via CHECKSUM_UNNECESSARY
        u8  free:2; // 是否该被丢弃
        u8    is_ipv6:1; //Used in foo-over-udp, set in udp[46]_gro_receive
        u8    is_fou:1; //Used in GRE, set in fou/gue_gro_receive
        u8    is_atomic:1; // Used to determine if flush_id can be ignored
        u8 recursion_counter:4; //Number of gro_receive callbacks this packet already went through
        u8    is_flist:1; //GRO is done by frag_list pointer chaining.
    );    
    __wsum    csum; //used to support CHECKSUM_COMPLETE for tunneling protocols
    struct sk_buff *last; //used in skb_gro_receive() slow path
}
```

```C
struct packet_offload {
    __be16      type;   /* This is really htons(ether_type). */
    u16     priority;
    struct offload_callbacks callbacks;
    struct list_head    list;
};
```


## offload管理

- dev_add_offload： 增加offload
- dev_remove_offload： 删除offload

## CB管理

- skb_gro_reset_offset() 来重置和初始化skb->cb区域。如果是skb非线性的，并且本身不包含数据(包括头也没有),而所有的数据都保存在skb_shared_info中(支持S/G的网卡有可能会这么做)。因为合并报文时需要报文头的信息，这时报文头是存在skb_shared_info的frags[0]中的，我们使用指针指向正确的报文头部。
- skb_set_network_header(skb, skb_gro_offset(skb));
- skb_reset_mac_len(skb);

### skb_gro_reset_offset

skb本身不包含数据(包括头也没有),而所有的数据都保存在`skb_shared_info`中(支持S/G的网卡有可能会这么做).此时我们如果想要合并的话，就需要将包头这些信息取出来，也就是从skb_shared_info的frags[0]中去的，在 skb_gro_reset_offset中就有做这个事情,而这里就会把头的信息保存到`napi_gro_cb` 的frags0中。并且此时frags必然不会在high mem,要么是线性区，要么是dma(S/G io)。

```C
static inline void skb_gro_reset_offset(struct sk_buff *skb, u32 nhoff)
{
    const struct skb_shared_info *pinfo = skb_shinfo(skb);
    const skb_frag_t *frag0 = &pinfo->frags[0];

    NAPI_GRO_CB(skb)->data_offset = 0;
    NAPI_GRO_CB(skb)->frag0 = NULL;
    NAPI_GRO_CB(skb)->frag0_len = 0;

    // 如果mac_header和skb->tail相等并且地址不在高端内存，则说明包头保存在skb_shinfo中，所以我们需要从frags中取得对应的数据包
    if (!skb_headlen(skb) && pinfo->nr_frags && !PageHighMem(skb_frag_page(frag0)) && (!NET_IP_ALIGN || !((skb_frag_off(frag0) + nhoff) & 3))) {
        // 可以看到frag0保存的就是对应的skb的frags的第一个元素的地址
        // frag0的作用是: 有些包的包头会存在skb->frag[0]里面，gro合并时会调用skb_gro_header_slow将包头拉到线性空间中，那么在非线性skb->frag[0]中的包头部分就应该删掉。
        NAPI_GRO_CB(skb)->frag0 = skb_frag_address(frag0); 
        NAPI_GRO_CB(skb)->frag0_len = min_t(unsigned int, skb_frag_size(frag0), skb->end - skb->tail);
    }
}
```

## skb处理过程

入口函数：gro_result_t napi_gro_receive(struct napi_struct *napi, struct sk_buff *skb)

- napi_gro_flush(struct napi_struct *napi, bool flush_old): 把napi->gro_list上的报文都送到协议栈，不用再等待合并。
- napi_skb_finish(napi, skb, gro_result_t ret): 根据gro返回情况，对skb的处理
- gro_normal_one(napi, skb, 1)： 把一个skb挂载napi->rx_list上，如果大于batch，调用gro_normal_list
- gro_normal_list(napi): 装给设备子系统, 发到协议栈
trace_napi_gro_receive_entry(skb)
dev_gro_receive(napi, skb)
ret = napi_skb_finish(napi, skb, dev_gro_receive(napi, skb))

napi_complete(struct napi_struct *n)
napi_gro_flush
gro_normal_list(struct napi_struct *n)


```C
void napi_gro_flush(struct napi_struct *napi, bool flush_old)
{
    unsigned long bitmask = napi->gro_bitmask;
    unsigned int i, base = ~0U;

    while ((i = ffs(bitmask)) != 0) {
        bitmask >>= i;
        base += i;
        __napi_gro_flush_chain(napi, base, flush_old);
    }
}

static void __napi_gro_flush_chain(struct napi_struct *napi, u32 index, bool flush_old)
{
    struct list_head *head = &napi->gro_hash[index].list;
    struct sk_buff *skb, *p;

    list_for_each_entry_safe_reverse(skb, p, head, list) { // 这个list是按照age排序的，最年轻的在头部
        if (flush_old && NAPI_GRO_CB(skb)->age == jiffies) // 如果只是flush 就得，跳过一个jiffies周期内的
            return;
        skb_list_del_init(skb);
        napi_gro_complete(napi, skb);
        napi->gro_hash[index].count--;
    }

    if (!napi->gro_hash[index].count)
        __clear_bit(index, &napi->gro_bitmask);   // 这个hash链表没有要处理的，清楚标志位
}

static void napi_gro_complete(struct napi_struct *napi, struct sk_buff *skb)
{
    struct packet_offload *ptype;
    __be16 type = skb->protocol;
    struct list_head *head = &offload_base;
    int err = -ENOENT;

    BUILD_BUG_ON(sizeof(struct napi_gro_cb) > sizeof(skb->cb));

    if (NAPI_GRO_CB(skb)->count == 1) { // 快捷处理，这个skb不是gro，没有被合并过
        skb_shinfo(skb)->gso_size = 0;
        goto out;
    }

    rcu_read_lock();
    list_for_each_entry_rcu(ptype, head, list) {
        if (ptype->type != type || !ptype->callbacks.gro_complete)
            continue;

        err = INDIRECT_CALL_INET(ptype->callbacks.gro_complete,
                     ipv6_gro_complete, inet_gro_complete,
                     skb, 0);
        break;
    }
    rcu_read_unlock();

    if (err) {
        WARN_ON(&ptype->list == head);
        kfree_skb(skb);
        return;
    }

out:
    gro_normal_one(napi, skb, NAPI_GRO_CB(skb)->count);
}

static inline void gro_normal_one(struct napi_struct *napi, struct sk_buff *skb, int segs)
{
    list_add_tail(&skb->list, &napi->rx_list);
    napi->rx_count += segs;
    if (napi->rx_count >= READ_ONCE(gro_normal_batch))
        gro_normal_list(napi);
}

/* Pass the currently batched GRO_NORMAL SKBs up to the stack. */
static inline void gro_normal_list(struct napi_struct *napi)
{
    if (!napi->rx_count)
        return;
    netif_receive_skb_list_internal(&napi->rx_list);
    INIT_LIST_HEAD(&napi->rx_list);
    napi->rx_count = 0;
}

```

eth_gro_complete(struct sk_buff *skb, int nhoff)
inet_gro_complete
udp4_gro_complete
tcp4_gro_complete