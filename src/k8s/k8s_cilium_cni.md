# add

1. 创建netnamespace，netns.OpenPinned(args.Netns)
2. 配置sysctl相关参数，sysctl.NewDirectSysctl(afero.NewOsFs(), "/proc")
3. 删除endpoint，link.DeleteByName(epConf.IfName())
4. IP地址分配，如果是代理程序则有代理处理，否则通过IPAM提供。allocateIPsWithDelegatedPlugin(context.TODO(), conf, n, args.StdinData)、allocateIPsWithCiliumAgent(c, cniArgs, epConf.IPAMPool())，如果失败则释放IPreleaseIPsFunc(context.TODO())。通过client在对应的pool中申请IP，并提供释放IP的方法。connector.SufficientAddressing(ipam.HostAddressing)确保IPv4或者IPv6地址分配。
5. 准备epConf.PrepareEndpoint(ipam) 

veth => connector.SetupVeth(cniID, int(conf.DeviceMTU),int(conf.GROMaxSize), int(conf.GSOMaxSize),int(conf.GROIPV4MaxSize), int(conf.GSOIPV4MaxSize), ep, sysctl)
        netlink.LinkDel(veth)
        netlink.LinkSetNsFd(peer, ns.FD())
        connector.SetupVethRemoteNs(ns, tmpIfName, epConf.IfName())

prepareIP(ep.Addressing.IPV6, state, int(conf.RouteMTU))
interfaceAdd(ipConfig, ipam.IPV4, conf)

sysctl.Disable("net.ipv6.conf.all.disable_ipv6")
macAddrStr, err = configureIface(ipam, epConf.IfName(), state)
c.EndpointCreate(ep)
mac.ReplaceMacAddressWithLinkName(args.IfName, newEp.Status.Networking.Mac)