# Linux内核TCP参数优化设置

在Linux下高并发的服务器中，TCP TIME_WAIT套接字数量经常可达两三万，服务器很容易就会被拖死。不过，我们可以通过修改Linux内核参数来减少服务器的TIME_WAIT套接字数量，命令如下所示：

nano /etc/sysctl.conf

然后，增加以下参数：

```
net.ipv4.tcp_fin_timeout = 30
net.ipv4.tcp_keepalive_time = 1800
net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_tw_recycle = 1
net.ipv4.ip_local_port_range = 1024 65000
net.ipv4.tcp_max_syn_backlog = 8192
net.ipv4.tcp_max_tw_buckets = 5120
```


其中：

net.ipv4.tcp_syncookies=1表示开启SYN Cookies。当出现SYN等待队列溢出时，启用cookie来处理，可防范少量的SYN攻击。默认为0，表示关闭。

net.ipv4.tcp_tw_reuse=1表示开启重用。允许将TIME-WAIT套接字重新用于新的TCp连接。默认为0，表示关闭。

net.ipv4.tcp_tw_recycle=1表示开启TCP连接中TIME-WAIT套接字的快速回收。默认为0，表示关闭。

net.ipv4.tcp_fin_timeout=30表示如果套接字由本端要求关闭，这个参数决定了它保持在FIN-WAIT-2状态的时间。

net.ipv4.tcp_keepalive_time=1800表示当keepalive启用时，TCP发送keepalive消息的频度。默认是2小时，这里改为30分钟。

net.ipv4.ip_local_port_range=1024 65000表示向外连接的端口范围。默认值很小：32768～61000，改为1024～65000。

net.ipv4.tcp_max_syn_backlog=8192表示SYN队列的长度，默认为1024，加大队列长度为8192，可以容纳更多等待连接的网络连接数。

net.ipv4.tcp_max_tw_buckets=5120表示系统同时保持TIME_WAIT套接字的最大数量，如果超过这个数字，TIME_WAIT套接字将立刻被清除并打印警告信息。默认为180000，改为5120。对于Apache、Nginx等服务器，前面介绍的几个参数已经可以很好地减少TIME_WAIT套接字数量，但是对于Squid来说，效果却不大。有了此参数就可以控制TIME_WAIT套接字的最大数量，避免Squid服务器被大量的TIME_WAIT套接字拖死。

执行以下命令使内核配置立即生效：

/sbin/sysctl -p

如果是用于Apache或Nginx等的Web服务器，或Nginx的反向代理，则只需要更改以下几项即可：

`net.ipv4.tcp_syncookies = 1` 
`net.ipv4.tcp_tw_reuse = 1`
`net.ipv4.tcp_tw_recycle = 1`
`net.ipv4.ip_local_port_range = 1024 65000`

执行以下命令使内核配置立即生效：
```
/sbin/sysctl -p
```


