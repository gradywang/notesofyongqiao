### Centos7虚拟机的网络配置 - 网络地址转换（NAT）+ Host Only
- 首先参考Ubuntu的网络配置。
- 启动虚拟机，配置网络：
**注意：用ipconfig查看VirtualBox Host-Only Network的网关，必须和eth1的配置一致。如果没有配置，都不要配**
```
# cat /etc/sysconfig/network-scripts/ifcfg-enp0s3
TYPE=Ethernet
BOOTPROTO=dhcp
DEFROUTE=yes
PEERDNS=yes
PEERROUTES=yes
IPV4_FAILURE_FATAL=no
IPV6INIT=yes
IPV6_AUTOCONF=yes
IPV6_DEFROUTE=yes
IPV6_PEERDNS=yes
IPV6_PEERROUTES=yes
IPV6_FAILURE_FATAL=no
NAME=enp0s3
UUID=5ec629d4-e77f-4ff6-84a2-c8d5a2424655
DEVICE=enp0s3
ONBOOT=yes

# cat /etc/sysconfig/network-scripts/ifcfg-enp0s8
TYPE=Ethernet
BOOTPROTO=static
IPADDR=192.168.56.110
NETMASK=255.255.255.0
NM_CONTROLLED=no
DEFROUTE=yes
PEERDNS=yes
PEERROUTES=yes
IPV4_FAILURE_FATAL=no
IPV6INIT=yes
IPV6_AUTOCONF=yes
IPV6_DEFROUTE=yes
IPV6_PEERDNS=yes
IPV6_PEERROUTES=yes
IPV6_FAILURE_FATAL=no
NAME=enp0s8
UUID=43034c4d-cadf-4d41-804a-a68ef33c0c98
DEVICE=enp0s8
ONBOOT=yes

# ip addr
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN 
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
2: enp0s3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP qlen 1000
    link/ether 08:00:27:1a:46:46 brd ff:ff:ff:ff:ff:ff
    inet 10.0.2.15/24 brd 10.0.2.255 scope global dynamic enp0s3
       valid_lft 85965sec preferred_lft 85965sec
    inet6 fe80::a00:27ff:fe1a:4646/64 scope link 
       valid_lft forever preferred_lft forever
3: enp0s8: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP qlen 1000
    link/ether 08:00:27:e7:5e:41 brd ff:ff:ff:ff:ff:ff
    inet 192.168.56.110/24 brd 192.168.56.255 scope global enp0s8
       valid_lft forever preferred_lft forever
    inet6 fe80::a00:27ff:fee7:5e41/64 scope link 
       valid_lft forever preferred_lft forever

```
- 测试虚拟机联通internet
```
# ping baidu.com
PING baidu.com (123.125.114.144) 56(84) bytes of data.
64 bytes from 123.125.114.144: icmp_seq=1 ttl=51 time=126 ms
64 bytes from 123.125.114.144: icmp_seq=2 ttl=51 time=128 ms
64 bytes from 123.125.114.144: icmp_seq=3 ttl=51 time=128 ms
64 bytes from 123.125.114.144: icmp_seq=4 ttl=51 time=128 ms
```
- 测试主机联通虚拟机 - 通过xShell等工具登录。
- 修改主机名
```
# hostnamectl set-hostname centos7host1.wyq.com
# vim /etc/hosts
```
