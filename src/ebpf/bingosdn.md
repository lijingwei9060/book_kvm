# 功能与概念

1.  VPC: Subnet *n / 1 个 DHCP /route table*n / acl /
    1.  Subnet
    2.  DHCP
    3.  Route Table
    4.  ACL
2.  Security Group:
3.  Interface： mac(arp)、subnet(gateway/IP/netmask/vlan)、SG(rules(proto/sip/smask/sport/dip/dport)\*n)
4.  Gateway: 网关
5.  Public IP：
6.

```json
"bingo.vnet.createDhcpOptions":{"dhcpOptionsId":"dopt-default","netbiosNodeType":2,"domainNameServers":["114.114.114.114"],"nextServerIp":"169.254.169.254","bootFileName":"pxelinux.0","archBootFileMap":{"00":"undionly.kpxe","11":"ipxe.efi_aarch64","06":"ipxe.efi_x86","255":"default.ipxe"},"ntpServers":["169.254.169.254"]},
"bingo/vnet/createVpc": {"vpcId":"vpc-14451725","cidrBlock":"172.16.1.0/24","dhcpOptionsId":"dopt-default"},
"bingo/vnet/createRouteTable":{"routeTableId":"rt-DC09281D","vpcId":"vpc-1546FA54","routeSet":[{"routeTableId":"rt-DC09281D","destinationCidrBlock":"172.17.21.0/24","vpcPeeringId":"pcx-BCC34EF3"},{"routeTableId":"rt-DC09281D","destinationCidrBlock":"0.0.0.0/0","gatewayId":"igw-B83E58CC"}]},
"bingo/vnet/createNetworkAcl":{"networkAclId":"acl-D5C47D23","vpcId":"vpc-5B848143","entrySet":[{"networkAclId":"acl-D5C47D23","ruleNumber":100,"protocol":-1,"ruleAction":"allow","cidrBlock":"0.0.0.0/0","fromPort":-1,"toPort":-1,"egress":true},{"networkAclId":"acl-D5C47D23","ruleNumber":100,"protocol":-1,"ruleAction":"allow","cidrBlock":"0.0.0.0/0","fromPort":-1,"toPort":-1,"egress":false}]},
"bingo/vnet/createSubnet":{"subnetId":"subnet-1FB4A293","vpcId":"vpc-5B848143","cidrBlock":"10.16.161.0/24","routeTableId":"rt-27221AC6","networkAclId":"acl-D5C47D23","microSegmentation":false,"gatewayIp":"10.16.161.254","vlanId":100},
"bingo/vnet/createVpcPeering":{"peerId":"pcx-BCC34EF3","vpcId":"vpc-E21A6668","peerVpcId":"vpc-1546FA54"},
"bingo/vnet/createSecurityGroup":{"groupId":"sg-B840A81E","ipPermissionType":"simple","ipPermissions":[{"groupId":"sg-B840A81E","ipPermissionId":"rule-158D983C06057F12EF8DB1CE8AB6683B5FD6CAFB","ipProtocol":-1,"fromPort":1,"toPort":65535,"ipRanges":["0.0.0.0/0"],"groups":[],"egress":true,"isAccept":true,"l2Accept":false},{"groupId":"sg-B840A81E","ipPermissionId":"rule-E2E55EFAFA7EE379B31402E57E96D4F9FA41CB70","ipProtocol":-1,"fromPort":1,"toPort":65535,"ipRanges":["::/0"],"groups":[],"egress":true,"isAccept":true,"l2Accept":false},{"groupId":"sg-B840A81E","ipPermissionId":"rule-ECB50DB47203C2DC4C6F658F1209BF6732A8EF27","ipProtocol":-1,"fromPort":1,"toPort":65535,"ipRanges":["0.0.0.0/0"],"groups":[],"egress":false,"isAccept":true,"l2Accept":false}],"complexIpPermissions":[]},

"bingo/vnet/createNetworkInterface":{"networkInterfaceId":"eni-67733018","subnetId":"subnet-1FB4A293","macAddress":"D0:0D:9A:D4:35:58","privateIpAddress":"10.16.161.79","privateIpAddressesSet":[],"groupSet":["sg-8B584704"],"sourceDestCheck":true,"noMatchPort":false,"firstPacketLimit":30000, "lvsProxyPortList":[80],"needModLvsVip":true,"isBareMetal":false, sysMode:true},
"bingo/vnet/createGateway":{"gatewayId":"igw-9F8354B9","type":"Internet","ipAddresses":["10.16.161.254"]},
"bingo/vnet/associateAddress":{"networkInterfaceId":"eni-67733018","gatewayId":"igw-9F8354B9","publicIp":"10.16.161.79/24","privateIpAddress":"10.16.161.79","queueId":0,lvsHeaderNetworkInterfaceIds":null, "guid":40597,"bmVlanId":0,"slaveNetworkInterfaceIds":["eni-767B8591","eni-67733018"], sysMode: true},
"bingo/vnet/checkNetworkInterfaces":{"macList":["d0:0d:8d:8e:a9:d0"],"timeout":3},
deleteNetworkInterface, data=["eni-07522712"]
disassociateAddress, data=["10.16.161.30"]
```
