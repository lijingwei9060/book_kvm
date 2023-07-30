# 相关结构

TopologyHint用中文描述为“拓扑提示”，在Topology Manager中，TopologyHint的定义如下：
```go
type TopologyHint struct {
    NUMANodeAffinity bitmask.BitMask
    Preferred bool
}
```

preferred: 在满足申请资源个数的前提下，选择的资源所涉及的NUMA节点个数最少，就是“优先考虑的”。

## 策略

Topology Manager提供了四种策略供用户组合各个资源的TopologyHint。这四种策略是：

1. none：什么也不做，与没有开启Topology Manager的效果一样。
2. best-effort: 允许Topology Manager通过组合各个资源提供的TopologyHint，而找到一个最优的TopologyHint，如果没有找到也没关系，节点也会接纳这个Pod。
3. restricted：允许Topology Manager通过组合各个资源提供的TopologyHint，而找到一个最优的TopologyHint，如果没有找到，那么节点会拒绝接纳这个Pod，如果Pod遭到节点拒绝，其状态将变为Terminated。
4. single-numa-node：允许Topology Manager通过组合各个资源提供的TopologyHint，而找到一个最优的TopologyHint，并且这个最优的TopologyHint所涉及的NUMA节点个数是1。如果没有找到，那么节点会拒绝接纳这个Pod，如果Pod遭到节点拒绝，其状态将变为Terminated。

## 设计模式

HintProvider是topology管理的接口定义，实现的有CPU Manager ，Device Manager，HugePages组件
```go
type HintProvider interface {
    // 根据container请求的资源数产生一组TopologyHint
    GetTopologyHints(*v1.Pod, *v1.Container) map[string][]TopologyHint
    GetPodTopologyHints(pod *v1.Pod) map[string][]TopologyHint
    // 根据container请求的资源数为container分配具体的资源
    Allocate(*v1.Pod, *v1.Container) error
}
```
topology_manager::TopologyHint(struct):  container的NumaNode亲和性
topology_manager::HintProvider(interface): 亲和性管理能力接口, `CPUManager`, `DeviceManager`, `MemoryManager`
topology_manager::Manager(interface): pod拓扑管理接口，目前只实现了一个`manager`, pod和container拓扑团里的入口。
topology_manager::Policy(interface): pod 拓扑管理的审计结果，具体实现有`bestEffortPolicy`, `restrictedPolicy`, `singleNumaNodePolicy`
topology_manager::Scope(interface): 拓扑管理器的Scope接口，具体实现有`containerScope`和`podScope`，包含具体的Policy.
topology_manager::Store(interface): 保存pod亲和性


## 资源

```go
type FsInfo struct {
	// Block device associated with the filesystem.
	Device string `json:"device"`
	// DeviceMajor is the major identifier of the device, used for correlation with blkio stats
	DeviceMajor uint64 `json:"-"`
	// DeviceMinor is the minor identifier of the device, used for correlation with blkio stats
	DeviceMinor uint64 `json:"-"`

	// Total number of bytes available on the filesystem.
	Capacity uint64 `json:"capacity"`

	// Type of device.
	Type string `json:"type"`

	// Total number of inodes available on the filesystem.
	Inodes uint64 `json:"inodes"`

	// HasInodes when true, indicates that Inodes info will be available.
	HasInodes bool `json:"has_inodes"`
}

type Node struct {
	Id int `json:"node_id"`
	// Per-node memory
	Memory    uint64          `json:"memory"`
	HugePages []HugePagesInfo `json:"hugepages"`
	Cores     []Core          `json:"cores"`
	Caches    []Cache         `json:"caches"`
	Distances []uint64        `json:"distances"`
}

type Core struct {
	Id           int     `json:"core_id"`
	Threads      []int   `json:"thread_ids"`
	Caches       []Cache `json:"caches"`
	UncoreCaches []Cache `json:"uncore_caches"`
	SocketID     int     `json:"socket_id"`
}

type Cache struct {
	// Id of memory cache
	Id int `json:"id"`
	// Size of memory cache in bytes.
	Size uint64 `json:"size"`
	// Type of memory cache: data, instruction, or unified.
	Type string `json:"type"`
	// Level (distance from cpus) in a multi-level cache hierarchy.
	Level int `json:"level"`
}

type HugePagesInfo struct {
	// huge page size (in kB)
	PageSize uint64 `json:"page_size"`

	// number of huge pages
	NumPages uint64 `json:"num_pages"`
}

type DiskInfo struct {
	// device name
	Name string `json:"name"`

	// Major number
	Major uint64 `json:"major"`

	// Minor number
	Minor uint64 `json:"minor"`

	// Size in bytes
	Size uint64 `json:"size"`

	// I/O Scheduler - one of "none", "noop", "cfq", "deadline"
	Scheduler string `json:"scheduler"`
}

type NetInfo struct {
	// Device name
	Name string `json:"name"`

	// Mac Address
	MacAddress string `json:"mac_address"`

	// Speed in MBits/s
	Speed int64 `json:"speed"`

	// Maximum Transmission Unit
	Mtu int64 `json:"mtu"`
}

type MachineInfo struct {
	// The time of this information point.
	Timestamp time.Time `json:"timestamp"`

	// Vendor id of CPU.
	CPUVendorID string `json:"vendor_id"`

	// The number of cores in this machine.
	NumCores int `json:"num_cores"`

	// The number of physical cores in this machine.
	NumPhysicalCores int `json:"num_physical_cores"`

	// The number of cpu sockets in this machine.
	NumSockets int `json:"num_sockets"`

	// Maximum clock speed for the cores, in KHz.
	CpuFrequency uint64 `json:"cpu_frequency_khz"`

	// The amount of memory (in bytes) in this machine
	MemoryCapacity uint64 `json:"memory_capacity"`

	// The amount of swap (in bytes) in this machine
	SwapCapacity uint64 `json:"swap_capacity"`

	// Memory capacity and number of DIMMs by memory type
	MemoryByType map[string]*MemoryInfo `json:"memory_by_type"`

	NVMInfo NVMInfo `json:"nvm"`

	// HugePages on this machine.
	HugePages []HugePagesInfo `json:"hugepages"`

	// The machine id
	MachineID string `json:"machine_id"`

	// The system uuid
	SystemUUID string `json:"system_uuid"`

	// The boot id
	BootID string `json:"boot_id"`

	// Filesystems on this machine.
	Filesystems []FsInfo `json:"filesystems"`

	// Disk map
	DiskMap map[string]DiskInfo `json:"disk_map"`

	// Network devices
	NetworkDevices []NetInfo `json:"network_devices"`

	// Machine Topology
	// Describes cpu/memory layout and hierarchy.
	Topology []Node `json:"topology"`

	// Cloud provider the machine belongs to.
	CloudProvider CloudProvider `json:"cloud_provider"`

	// Type of cloud instance (e.g. GCE standard) the machine is.
	InstanceType InstanceType `json:"instance_type"`

	// ID of cloud instance (e.g. instance-1) given to it by the cloud provider.
	InstanceID InstanceID `json:"instance_id"`
}

type MemoryInfo struct {
	// The amount of memory (in bytes).
	Capacity uint64 `json:"capacity"`

	// Number of memory DIMMs.
	DimmCount uint `json:"dimm_count"`
}

type NVMInfo struct {
	// The total NVM capacity in bytes for memory mode.
	MemoryModeCapacity uint64 `json:"memory_mode_capacity"`

	//The total NVM capacity in bytes for app direct mode.
	AppDirectModeCapacity uint64 `json:"app direct_mode_capacity"`

	// Average power budget in watts for NVM devices configured in BIOS.
	AvgPowerBudget uint `json:"avg_power_budget"`
}

type VersionInfo struct {
	// Kernel version.
	KernelVersion string `json:"kernel_version"`

	// OS image being used for cadvisor container, or host image if running on host directly.
	ContainerOsVersion string `json:"container_os_version"`

	// Docker version.
	DockerVersion string `json:"docker_version"`

	// Docker API Version
	DockerAPIVersion string `json:"docker_api_version"`

	// cAdvisor version.
	CadvisorVersion string `json:"cadvisor_version"`
	// cAdvisor git revision.
	CadvisorRevision string `json:"cadvisor_revision"`
}
```