#

##  mac 寻址

需要使用 bpf_fib_lookup 便可以借助内核能力查询 mac 地址，这也是不采用 kernel bypass 的好处之一，我们在提升了性能的同时，还能享受内核带来的红利。

```C
int rc = bpf_fib_lookup(ctx, &fib_params, sizeof(fib_params), 0);
    switch (rc) {
        case BPF_FIB_LKUP_RET_SUCCESS:         /* lookup successful */
            memcpy(eth->h_dest, fib_params.dmac, ETH_ALEN);
            memcpy(eth->h_source, fib_params.smac, ETH_ALEN);
            action = XDP_TX;
            break;
        case BPF_FIB_LKUP_RET_BLACKHOLE:    /* dest is blackholed; can be dropped */
     		// ...
            action = XDP_DROP;
            break;
        case BPF_FIB_LKUP_RET_NOT_FWDED:    /* packet is not forwarded */
      		// ...
            break;
	}
```


[ref](https://github.com/MageekChiu/xdp4slb/blob/main/README.md)