# core

1. kvstore
2. NodeController:
   1. status：NodeNotReady/NodeUnreachable/NetworkUnavailable/MemoryPressure/PIDPressure/DiskPressure 
   2. condition/taint标签
   3. 驱逐Pod
   4. feature-gates
      1. node.kubernetes.io/exclude-disruption： 网络中断不驱逐Pod
      2. TaintNodesByCondition: NoSchedule
      3. TaintBasedEvictions:
      4. NodeLease 