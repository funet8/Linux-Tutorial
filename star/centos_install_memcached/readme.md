# 安装memcache
```
[root@localhost ~]# cd /data/software
上传libevent-1.4.13-stable.tar.gz文件
[root@localhost software]# tar -zxvf libevent-1.4.13-stable.tar.gz
[root@localhost software]# cd libevent-1.4.13-stable
[root@localhost libevent-1.4.13-stable]# ./configure --prefix=/usr
[root@localhost libevent-1.4.13-stable]# make && make install

[root@localhost libevent-1.4.13-stable]# ls -al /usr/lib | grep libevent  # 查看 libevent 是否安装完成
```


上传memcached-1.4.17.tar.gz文件
```
tar -zxvf memcached-1.4.17.tar.gz
cd memcached-1.4.17
[root@localhost memcached-1.4.17]# ./configure --with-libevent=/usr
[root@localhost memcached-1.4.17]# make && make install

[root@localhost memcached-1.4.17]# ls -al /usr/local/bin/mem*   # 查看memcache是否安装完成
```


  启动Memcache的服务器端：
```
  /usr/local/bin/memcached -d -m 200 -u www -p 12321 -c 256 -P /tmp/memcached.pid  #(不指定ip)
```

 #参数说明:
```
#-d选项是启动一个守护进程，
#-m是分配给Memcache使用的内存数量，单位是MB，我这里是200MB，
#-u是运行Memcache的用户，我这里是www （或root），
#-l是监听的服务器IP地址，如果有多个地址的话，我这里指定了服务器的IP地址202.207.177.177，
#-p是设置Memcache监听的端口，我这里设置了11211，最好是1024以上的端口，
#-c选项是最大运行的并发连接数，默认是1024，我这里设置了256，按照你服务器的负载量来设定，
#-P是设置保存Memcache的pid文件，我这里是保存在 /tmp/memcached.pid，
#2.如果要结束Memcache进程，执行：
kill `cat /tmp/memcached.pid`
```





## 添加防火墙规则

```
# -I 在前面添加规则
# drop目标端口12321端口的所有数据包
iptables -I INPUT -p tcp --dport 12321 -j DROP
# 单独接受特定的ip的当前端口的数据包，ip地址
iptables -I INPUT -s 192.168.1.2 -p tcp --dport 12321 -j ACCEPT
iptables -I INPUT -s 192.168.1.3 -p tcp --dport 12321 -j ACCEPT
iptables -I INPUT -s 192.168.1.4 -p tcp --dport 12321 -j ACCEPT
iptables -I INPUT -s 192.168.1.5 -p tcp --dport 12321 -j ACCEPT
iptables -I INPUT -s 127.0.0.1 -p tcp --dport 12321 -j ACCEPT

service iptables save
```



## 查看启动的端口号
```
netstat -tanp # 查看所有用户开启的端口
netstat -tunp # 查看当前用户开启的端口
```



*******************20170627---修改************************************

# 安装php-memcache的扩展
```
yum install -y libmemcached
wget http://pecl.php.net/get/memcache-3.0.8.tgz
tar xzvf memcache-3.0.8.tgz  
cd memcache-3.0.8

[root@centos-03 memcache-3.0.8]# which phpize
/usr/bin/phpize
[root@centos-03 memcache-3.0.8]# /usr/bin/phpize
Configuring for:
PHP Api Version:         20090626
Zend Module Api No:      20090626
Zend Extension Api No:   220090626
find / -name php-config
./configure --enable-memcache --with-php-config=/usr/local/php/bin/php-config --with-zlib-dir
设为：
./configure --enable-memcache --with-php-config=/usr/bin/php-config --with-zlib-dir

make && make install
make test

ll /usr/lib64/php/modules/memcache.so
-rwxr-xr-x 1 root root 477764 Jun 26 19:59 /usr/lib64/php/modules/memcache.so
vi /data/conf/php.ini
添加：
extension = "/usr/lib64/php/modules/memcache.so"
```

*******************************************************

遇到错误：
```
Build complete.
Don't forget to run 'make test'.
+-----------------------------------------------------------+
|                       ! ERROR !                           |
| The test-suite requires that proc_open() is available.    |
| Please check if you disabled it in php.ini.               |
+-----------------------------------------------------------+
```


解决方法：
```
[root@localhost memcache-2.2.4]# vi /data/conf/php.ini 【修改php.ini配置文件】
找到disable_functions = shell_exec, system, passthru, exec, popen， proc_open()
改为disable_functions = shell_exec, system, passthru, exec, popen
新增一个扩展
extension = "memcache.so"
保存退出。
接着make test
```


### 如果可以找到则重新加载php配置文件进行测试
```
service httpd reload
```





### 测试memcache的功能是否正常

# 新建index.php文件测试看php是否支持memcache
```
<?php
ini_set('display_errors',1);
error_reporting(7);
$mem = new Memcache;
$mem->connect('127.0.0.1',12321);
$mem->set('test','Hello world!',0,12);
$val = $mem->get('test');
echo $val;
var_dump($val);

```

如果页面中输出Hello world!string(12) "Hello world!"  则说明此时php已经支持memcache模块

## 开机启动
```
vi /etc/rc.d/rc.local
	# memcache 启动
	/usr/local/bin/memcached -d -m 200 -u www -p 12321 -c 256 -P /tmp/memcached.pid
```


## 关闭 memcached
```
ps aux|grep memcached 	或者 kill `cat /tmp/memcached.pid`
/usr/local/bin/memcached -d -m 200 -u www -p 12321 -c 500 -P /tmp/memcached.pid 
```

# 过期版本：

## 安装php-memcache的扩展
```
[root@localhost]# tar -zxvf memcache-2.2.4.tgz
[root@localhost]# cd memcache-2.2.4
[root@localhost]# phpize # 如果没有找到phpize命令则 运行：yum -y install php-devel

[root@localhost]#./configure --with-php-config=/usr/bin/php-config --enable-memcache
```


error: memcache support requires ZLIB. Use --with-zlib-dir=<DIR> to specify prefix where ZLIB include and library are located   
这个错误就要执行：
```
yum -y  install zlib-devel
```

```
 #  ./configure --with-php-config=/usr/bin/php-config --enable-memcache
make
make test
```


## 查看是否可以在扩展目录下找到 memcache.so
```
ls /usr/lib64/php/modules/  # 如果找不到则直接复制一个过去 
cp modules/memcache.so /usr/lib64/php/modules/ 或者：cp /data/software/memcache-2.2.4/modules/memcache.so /usr/lib64/php/modules/

[root@localhost memcache-2.2.4]# make
[root@localhost memcache-2.2.4]# make test
```

