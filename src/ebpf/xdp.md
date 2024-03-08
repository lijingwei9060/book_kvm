# xdp: express data path

BPF 技术与 XDP（eXpress Data Path） 和 TC（Traffic Control） 组合可以实现功能更加强大的网络功能，
XDP 只作用与网络包的 Ingress 层面，
BPF 钩子位于网络驱动中尽可能早的位置，无需进行原始包的复制就可以实现最佳的数据包处理性能，挂载的 BPF 程序是运行过滤的理想选择，可用于丢弃恶意或非预期的流量、进行 DDOS 攻击保护等场景；
而 TC Ingress 比 XDP 技术处于更高层次的位置，BPF 程序在 L3 层之前运行，可以访问到与数据包相关的大部分元数据，是本地节点处理的理想的地方，可以用于流量监控或者 L3/L4 的端点策略控制，同时配合 TC egress 则可实现对于容器环境下更高维度和级别的网络结构。


XDP 全称为 eXpress Data Path，是 Linux 内核网络栈的最底层。它只存在于 RX （接收数据）路径上，允许在网络设备驱动内部网络堆栈中数据来源最早的地方进行数据包处理，在特定模式下可以在操作系统分配内存（skb）之前就已经完成处理。
插播一下 XDP 的工作模式：
XDP 有三种工作模式，默认是 native（原生）模式，当讨论 XDP 时通常隐含的都是指这种模式。

1. Native XDP： XDP 程序 hook 到网络设备的驱动上，它是 XDP 最原始的模式，因为还是先于操作系统进行数据处理，它的执行性能还是很高的，当然需要网卡驱动支持。大部分广泛使用的 10G 及更高速的网卡都已经支持这种模式。
2. Offloaded XDP： XDP 程序直接 hook 到可编程网卡硬件设备上，与其他两种模式相比，它的处理性能最强；由于处于数据链路的最前端，过滤效率也是最高的。如果需要使用这种模式，需要在加载程序时明确声明。
3. Generic XDP： 对于还没有实现 native 或 offloaded XDP 的驱动，内核提供了一个 generic XDP 选项，这是操作系统内核提供的通用 XDP 兼容模式，它可以在没有硬件或驱动程序支持的主机上执行 XDP 程序。在这种模式下，XDP 的执行是由操作系统本身来完成的，以模拟 native 模式执行。好处是，只要内核够高，人人都能玩 XDP；缺点是由于是仿真执行，需要分配额外的套接字缓冲区（SKB），导致处理性能下降，跟 native 模式在10倍左右的差距。

对于在生产环境使用 XDP，推荐要么选择 native 要么选择 offloaded 模式。这两种模式需要网卡驱动的支持，对于那些不支持 XDP 的驱动，内核提供了 Generic XDP ，这是软件实现的 XDP，性能会低一些， 在实现上就是将 XDP 的执行上移到了核心网络栈。

XDP 程序返回一个判决结果给驱动，可以是 PASS, TRANSMIT, 或 DROP。
(1) native/offloaded 模式：XDP 在内核收包函数 receive_skb() 之前。
![l2](./images/l2.png)
(2) Generic XDP 模式：XDP 在内核收包函数 receive_skb() 之后。
![l2_2l3](./images/l2_l3.png)

1. TRANSMIT 非常有用，有了这个功能，就可以用 XDP 实现一个 TCP/IP 负载均衡器。XDP 只适合对包进行较小修改，如果是大动作修改，那这样的 XDP 程序的性能可能并不会很高，因为这些操作会降低 poll 函数处理 DMA ring-buffer 的能力。
2. 如果返回的是 DROP，这个包就可以直接原地丢弃了，而无需再穿越后面复杂的协议栈然后再在某个地方被丢弃，从而节省了大量资源。在业界最出名的一个应用场景就是 Facebook 基于 XDP 实现高效的防 DDoS 攻击，其本质上就是实现尽可能早地实现「丢包」，而不去消耗系统资源创建完整的网络栈链路，即「early drop」。
3. 如果返回是 PASS，内核会继续沿着默认路径处理包，如果是 native/offloaded 模式 ，后续到达 clean_rx() 方法；如果是 Generic XDP 模式，将导到 check_taps()下面的 Step 6 继续讲解。

## 数据结构

XDP程序使用的数据结构是xdp_buff，而不是sk_buff，xdp_buff可以视为sk_buff的轻量级版本。两者的区别在于：sk_buff包含数据包的元数据，xdp_buff创建更早，不依赖与其他内核层，因此XDP可以更快的获取和处理数据包。
xdp_buff数据结构定义如下：
```C
// /linux/include/net/xdp.h
struct xdp_rxq_info {
	struct net_device *dev;
	u32 queue_index;
	u32 reg_state;
	struct xdp_mem_info mem;
} ____cacheline_aligned; /* perf critical, avoid false-sharing */

struct xdp_buff {
	void *data;
	void *data_end;
	void *data_meta;
	void *data_hard_start;
	unsigned long handle;
	struct xdp_rxq_info *rxq;
};
```

sk_buff数据结构定义如下：
```C
// /include/linux/skbuff.h
struct sk_buff {
	union {
		struct {
			/* These two members must be first. */
			struct sk_buff		*next;
			struct sk_buff		*prev;

			union {
				struct net_device	*dev;
				/* Some protocols might use this space to store information,
				 * while device pointer would be NULL.
				 * UDP receive path is one user.
				 */
				unsigned long		dev_scratch;
			};
		};
		struct rb_node		rbnode; /* used in netem, ip4 defrag, and tcp stack */
		struct list_head	list;
	};

	union {
		struct sock		*sk;
		int			ip_defrag_offset;
	};

	union {
		ktime_t		tstamp;
		u64		skb_mstamp_ns; /* earliest departure time */
	};
	/*
	 * This is the control buffer. It is free to use for every
	 * layer. Please put your private variables there. If you
	 * want to keep them across layers you have to do a skb_clone()
	 * first. This is owned by whoever has the skb queued ATM.
	 */
	char			cb[48] __aligned(8);

	union {
		struct {
			unsigned long	_skb_refdst;
			void		(*destructor)(struct sk_buff *skb);
		};
		struct list_head	tcp_tsorted_anchor;
	};

#if defined(CONFIG_NF_CONNTRACK) || defined(CONFIG_NF_CONNTRACK_MODULE)
	unsigned long		 _nfct;
#endif
	unsigned int		len,
				data_len;
	__u16			mac_len,
				hdr_len;

	/* Following fields are _not_ copied in __copy_skb_header()
	 * Note that queue_mapping is here mostly to fill a hole.
	 */
	__u16			queue_mapping;

/* if you move cloned around you also must adapt those constants */
#ifdef __BIG_ENDIAN_BITFIELD
#define CLONED_MASK	(1 << 7)
#else
#define CLONED_MASK	1
#endif
#define CLONED_OFFSET()		offsetof(struct sk_buff, __cloned_offset)

	__u8			__cloned_offset[0];
	__u8			cloned:1,
				nohdr:1,
				fclone:2,
				peeked:1,
				head_frag:1,
				xmit_more:1,
				pfmemalloc:1;
#ifdef CONFIG_SKB_EXTENSIONS
	__u8			active_extensions;
#endif
	/* fields enclosed in headers_start/headers_end are copied
	 * using a single memcpy() in __copy_skb_header()
	 */
	/* private: */
	__u32			headers_start[0];
	/* public: */

/* if you move pkt_type around you also must adapt those constants */
#ifdef __BIG_ENDIAN_BITFIELD
#define PKT_TYPE_MAX	(7 << 5)
#else
#define PKT_TYPE_MAX	7
#endif
#define PKT_TYPE_OFFSET()	offsetof(struct sk_buff, __pkt_type_offset)

	__u8			__pkt_type_offset[0];
	__u8			pkt_type:3;
	__u8			ignore_df:1;
	__u8			nf_trace:1;
	__u8			ip_summed:2;
	__u8			ooo_okay:1;

	__u8			l4_hash:1;
	__u8			sw_hash:1;
	__u8			wifi_acked_valid:1;
	__u8			wifi_acked:1;
	__u8			no_fcs:1;
	/* Indicates the inner headers are valid in the skbuff. */
	__u8			encapsulation:1;
	__u8			encap_hdr_csum:1;
	__u8			csum_valid:1;

#ifdef __BIG_ENDIAN_BITFIELD
#define PKT_VLAN_PRESENT_BIT	7
#else
#define PKT_VLAN_PRESENT_BIT	0
#endif
#define PKT_VLAN_PRESENT_OFFSET()	offsetof(struct sk_buff, __pkt_vlan_present_offset)
	__u8			__pkt_vlan_present_offset[0];
	__u8			vlan_present:1;
	__u8			csum_complete_sw:1;
	__u8			csum_level:2;
	__u8			csum_not_inet:1;
	__u8			dst_pending_confirm:1;
#ifdef CONFIG_IPV6_NDISC_NODETYPE
	__u8			ndisc_nodetype:2;
#endif

	__u8			ipvs_property:1;
	__u8			inner_protocol_type:1;
	__u8			remcsum_offload:1;
#ifdef CONFIG_NET_SWITCHDEV
	__u8			offload_fwd_mark:1;
	__u8			offload_l3_fwd_mark:1;
#endif
#ifdef CONFIG_NET_CLS_ACT
	__u8			tc_skip_classify:1;
	__u8			tc_at_ingress:1;
	__u8			tc_redirected:1;
	__u8			tc_from_ingress:1;
#endif
#ifdef CONFIG_TLS_DEVICE
	__u8			decrypted:1;
#endif

#ifdef CONFIG_NET_SCHED
	__u16			tc_index;	/* traffic control index */
#endif

	union {
		__wsum		csum;
		struct {
			__u16	csum_start;
			__u16	csum_offset;
		};
	};
	__u32			priority;
	int			skb_iif;
	__u32			hash;
	__be16			vlan_proto;
	__u16			vlan_tci;
#if defined(CONFIG_NET_RX_BUSY_POLL) || defined(CONFIG_XPS)
	union {
		unsigned int	napi_id;
		unsigned int	sender_cpu;
	};
#endif
#ifdef CONFIG_NETWORK_SECMARK
	__u32		secmark;
#endif

	union {
		__u32		mark;
		__u32		reserved_tailroom;
	};

	union {
		__be16		inner_protocol;
		__u8		inner_ipproto;
	};

	__u16			inner_transport_header;
	__u16			inner_network_header;
	__u16			inner_mac_header;

	__be16			protocol;
	__u16			transport_header;
	__u16			network_header;
	__u16			mac_header;

	/* private: */
	__u32			headers_end[0];
	/* public: */

	/* These elements must be at the end, see alloc_skb() for details.  */
	sk_buff_data_t		tail;
	sk_buff_data_t		end;
	unsigned char		*head,
				*data;
	unsigned int		truesize;
	refcount_t		users;

#ifdef CONFIG_SKB_EXTENSIONS
	/* only useable after checking ->active_extensions != 0 */
	struct skb_ext		*extensions;
#endif
};
```

# XDP操作模式

XDP支持3种工作模式，默认使用native模式：

- Native XDP：在native模式下，XDP BPF程序运行在网络驱动的早期接收路径上（RX队列），因此，使用该模式时需要网卡驱动程序支持。
- Offloaded XDP：在Offloaded模式下，XDP BFP程序直接在NIC（Network Interface Controller）中处理数据包，而不使用主机CPU，相比native模式，性能更高
- Generic XDP：Generic模式主要提供给开发人员测试使用，对于网卡或驱动无法支持native或offloaded模式的情况，内核提供了通用的generic模式，运行在协议栈中，不需要对驱动做任何修改。生产环境中建议使用native或offloaded模式

# XDP操作结果码
- XDP_DROP：丢弃数据包，发生在驱动程序的最早RX阶段
- XDP_PASS：将数据包传递到协议栈处理，操作可能为以下两种形式：
1、正常接收数据包，分配愿数据sk_buff结构并且将接收数据包入栈，然后将数据包引导到另一个CPU进行处理。他允许原始接口到用户空间进行处理。 这可能发生在数据包修改前或修改后。
2、通过GRO（Generic receive offload）方式接收大的数据包，并且合并相同连接的数据包。经过处理后，GRO最终将数据包传入“正常接收”流
- XDP_TX：转发数据包，将接收到的数据包发送回数据包到达的同一网卡。这可能在数据包修改前或修改后发生
- XDP_REDIRECT：数据包重定向，XDP_TX，XDP_REDIRECT是将数据包送到另一块网卡或传入到BPF的cpumap中
- XDP_ABORTED：表示eBPF程序发生错误，并导致数据包被丢弃。自己开发的程序不应该使用该返回码

# XDP和iproute2加载器

iproute2工具中提供的ip命令可以充当XDP加载器的角色，将XDP程序编译成ELF文件并加载他。

编写XDP程序xdp_filter.c，程序功能为丢弃所有TCP连接包，程序将xdp_md结构指针作为输入，相当于驱动程序xdp_buff的BPF结构。程序的入口函数为filter，编译后ELF文件的区域名为mysection。
将XDP程序编译为ELF文件: `clang -O2 -target bpf -c xdp_filter.c -o xdp_filter.o`
使用ip命令加载XDP程序，将mysection部分作为程序的入口点: `ip link set dev ens33 xdp obj xdp_filter.o sec mysection`

没有报错即完成加载，可以通过以下命令查看结果：
```txt
$ sudo ip a show ens33
2: ens33: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 xdpgeneric/id:56 qdisc fq_codel state UP group default qlen 1000
    link/ether 00:0c:29:2f:a8:41 brd ff:ff:ff:ff:ff:ff
    inet 192.168.136.140/24 brd 192.168.136.255 scope global dynamic noprefixroute ens33
       valid_lft 1629sec preferred_lft 1629sec
    inet6 fe80::d411:ff0d:f428:ce2a/64 scope link noprefixroute 
       valid_lft forever preferred_lft forever
```
其中，xdpgeneric/id:56说明使用的驱动程序为xdpgeneric，XDP程序id为56

验证连接阻断效果
1. 使用nc -l 8888监听8888 TCP端口，使用nc xxxxx 8888连接发送数据，目标主机未收到任何数据，说明TCP连接阻断成功
2. 使用nc -kul 9999监听UDP 9999端口，使用nc -u xxxxx 9999连接发送数据，目标主机正常收到数据，说明UDP连接不受影响
卸载XDP程序`ip link set dev ens33 xdp off`