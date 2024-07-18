tables.Sysctl{
		{Name: "net.core.bpf_jit_enable", Val: "1", IgnoreErr: true, Warn: "Unable to ensure that BPF JIT compilation is enabled. This can be ignored when Cilium is running inside non-host network namespace (e.g. with kind or minikube)"},
		{Name: "net.ipv4.conf.all.rp_filter", Val: "0", IgnoreErr: false},
		{Name: "net.ipv4.fib_multipath_use_neigh", Val: "1", IgnoreErr: true},
		{Name: "kernel.unprivileged_bpf_disabled", Val: "1", IgnoreErr: true},
		{Name: "kernel.timer_migration", Val: "0", IgnoreErr: true},
		{Name: "net.ipv6.conf.all.disable_ipv6", Val: "0", IgnoreErr: false},
		{Name: "net.core.fb_tunnels_only_for_init_net", Val: "2", IgnoreErr: true},
	}
	// add internal ipv4 and ipv6 addresses to cilium_host
	addHostDeviceAddr(hostDev1, internalIPv4, internalIPv6)
	// clean up ingress qdiscs
	cleanIngressQdisc(devices)
	// compile encryption programs
	reinitializeIPSec()
	// Reinstall proxy rules for any running proxies if needed
	ReinstallRoutingRules()

Endpoint::Regenerate()
 regenerateBPF()
 updateRealizedState()
	fetchOrCompile
    reloadDatapath
		ep.IsHost() => reloadHostDatapath()
		loadDatapath()
		attachSKBProgram()
			tcx => 
				netkit => upsertNetkitProgram() 
						  removeTCFilters()
			tc => attachTCProgram()
			detachGeneric(bpffsDir, progName, "tcx")
		detachSKBProgram()
		ep.RequireEndpointRoute()
		ep.IPv4Address()
		ep.IPv6Address()
	
	/sys/fs/bpf/cilium/endpoints/<endpoint-id>/links
	
	
	
	
## tcx
https://github.com/torvalds/linux/commit/e420bed025071a623d2720a92bc2245c84757ecb





## command

bpftool net list