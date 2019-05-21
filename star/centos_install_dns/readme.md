# 简单dns服务器搭建

## 一：软件安装
```
[root@localhost ~]# yum -y install bind*
```



## 二：修改主配置文件
```
[root@localhost ~]# cp /etc/named.conf /etc/named.conf.bak  # 修改之前先备份一遍
```

修改配置文件
```
[root@localhost ~]# vi /etc/named.conf  

options {

        listen-on port 53 { any; }; // 监听在主机的53端口上。any代表监听所有的主机
        directory       "/var/named"; // 如果此档案底下有规范到正反解的zone file 档名时，该档名预设应该放置在哪个目录底下

		 // 下面三项是服务的相关统计信息

        dump-file       "/var/named/data/cache_dump.db";
        statistics-file "/var/named/data/named_stats.txt";
        memstatistics-file "/var/named/data/named_mem_stats.txt";
        allow-query     { any; }; // 谁可以对我的DNS服务器提出查询请求。any代表任何人
        recursion yes;
        dnssec-enable yes;
        dnssec-validation yes;
        dnssec-lookaside auto;
        forwarders { // 指定上层DNS服务器
           192.168.1.1;
        };
        bindkeys-file "/etc/named.iscdlv.key";
        managed-keys-directory "/var/named/dynamic";
};

logging {

        channel default_debug {
                file "data/named.run";
                severity dynamic;
        };

};
zone "." IN {
        type hint;
        file "named.ca";
};

include "/etc/named.rfc1912.zones";
include "/etc/named.root.key";
```






## 三 自定义域名解析配置
```
[root@localhost ~]#  vi /etc/named.rfc1912.zones  # 比如我们要添加yumaozdy.com这个域的解析可以添加下面这一段

zone "yumaozdy.com" IN {    // 定义要解析主域名
        type master;
        file "yumaozdy.com.zone";  // 具体相关解析的配置文件保存在 /var/named/yumaozdy.com.zone 文件中

};
```






## 四 自定义yumaozdy.com.zone文件
```
[root@ns named]# vi /var/named/yumaozdy.com.zone 

$TTL 86400
@       IN SOA          ns.yumaozdy.com. root (
                                        1       ; serial
                                        1D      ; refresh
                                        1H      ; retry
                                        1W      ; expire
                                        0 )     ; minimum  

@       IN      NS      ns.yumaozdy.com.
ns      IN      A       192.168.1.219
www     IN      A       192.168.1.45
bbs     IN      A       192.168.1.46
ttt     IN      A       192.168.1.68




// 其中   ns.yumaozdy.com 代表当前dns服务器名称。所以  ns.yumaozdy.com 一定要解析到自己本身

 www     IN      A       192.168.1.45  // 代表 www.yumaozdy.com 解析到  192.168.1.45服务器上。其他的类似
```






## 五 修改权限
```
[root@ns named]# chown root:named  yumaozdy.com.zone  # 这一步一定要做
```


## 六 重启服务
```
[root@dns_server named]# service named restart
```




## 七 如果我们要追加一个域的解析。
比如google.com 则：
```
vi /etc/named.rfc1912.zones 

// 添加下面这段
zone "google.com" IN {
        type master;
        file "google.com.zone";
};
```


```
[root@ns named]# cp -a yumaozdy.com.zone google.com.zone
[root@ns named]# vi google.com.zone 

$TTL 86400
@       IN SOA          ns.google.com. root (
                                        1       ; serial
                                        1D      ; refresh
                                        1H      ; retry
                                        1W      ; expire
                                        0 )     ; minimum
@       IN      NS      ns.google.com.
ns      IN      A       192.168.1.219
www     IN      A       192.168.1.11
bbs     IN      A       192.168.1.46
ttt     IN      A       192.168.1.68
```



```
chkconfig named on
```



## 八、关闭selinux（略）

## 九、添加防火墙规则
```
vi /etc/sysconfig/iptables

-A INPUT -m state --state NEW -m tcp -p tcp --dport 53 -j ACCEPT
-A INPUT -m state --state NEW -m udp -p udp --dport 53 -j ACCEPT
-A INPUT -m state --state NEW -m tcp -p tcp --dport 953 -j ACCEPT

添加规则，并且保存（注意位置）

service iptables restart
```


## 十、测试
```
vim /etc/resolv.conf
nameserver 192.168.1.219
```


