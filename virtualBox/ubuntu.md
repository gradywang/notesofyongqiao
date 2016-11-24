### Ubuntu14.04虚拟机的网络配置 - 网络地址转换（NAT）+ Host Only
- 首先在VirtualBox界面按下Ctrl+G，在弹出页面中配置`网络->仅主机（Host-Only）网络`
```
主机虚拟网络界面：
IPv4地址：192.168.56.1 --在windows控制台上执行ipconfig查看VritualBox Host-Only Networks获取它的IP地址。
IPv4网络掩码：255.255.255.0

DHCP服务：
服务器地址：192.168.56.100
服务器网络掩码：255.255.255.0
最小地址：192.168.56.101
最大地址：192.168.56.254
```
- 创建Ubuntu虚拟机，添加两块网卡
```
第一块： 网络地址转换（NAT）
第二块：仅主机（Host-Only）适配器
```
- 启动虚拟机，配置网络：
**注意：用ipconfig查看VirtualBox Host-Only Network的网关，必须和eth1的配置一直。如果没有配置，都不要配**
```
# cat /etc/network/interfaces
# This file describes the network interfaces available on your system
# and how to activate them. For more information, see interfaces(5).

# The loopback network interface
auto lo
iface lo inet loopback

# The primary network interface
auto eth0
iface eth0 inet dhcp

auto eth1
iface eth1 inet static
address 192.168.56.101
netmask 255.255.255.0
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
