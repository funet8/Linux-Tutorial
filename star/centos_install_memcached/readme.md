# ��װmemcache
```
[root@localhost ~]# cd /data/software
�ϴ�libevent-1.4.13-stable.tar.gz�ļ�
[root@localhost software]# tar -zxvf libevent-1.4.13-stable.tar.gz
[root@localhost software]# cd libevent-1.4.13-stable
[root@localhost libevent-1.4.13-stable]# ./configure --prefix=/usr
[root@localhost libevent-1.4.13-stable]# make && make install

[root@localhost libevent-1.4.13-stable]# ls -al /usr/lib | grep libevent  # �鿴 libevent �Ƿ�װ���
```


�ϴ�memcached-1.4.17.tar.gz�ļ�
```
tar -zxvf memcached-1.4.17.tar.gz
cd memcached-1.4.17
[root@localhost memcached-1.4.17]# ./configure --with-libevent=/usr
[root@localhost memcached-1.4.17]# make && make install

[root@localhost memcached-1.4.17]# ls -al /usr/local/bin/mem*   # �鿴memcache�Ƿ�װ���
```


  ����Memcache�ķ������ˣ�
```
  /usr/local/bin/memcached -d -m 200 -u www -p 12321 -c 256 -P /tmp/memcached.pid  #(��ָ��ip)
```

 #����˵��:
```
#-dѡ��������һ���ػ����̣�
#-m�Ƿ����Memcacheʹ�õ��ڴ���������λ��MB����������200MB��
#-u������Memcache���û�����������www ����root����
#-l�Ǽ����ķ�����IP��ַ������ж����ַ�Ļ���������ָ���˷�������IP��ַ202.207.177.177��
#-p������Memcache�����Ķ˿ڣ�������������11211�������1024���ϵĶ˿ڣ�
#-cѡ����������еĲ�����������Ĭ����1024��������������256��������������ĸ��������趨��
#-P�����ñ���Memcache��pid�ļ����������Ǳ����� /tmp/memcached.pid��
#2.���Ҫ����Memcache���̣�ִ�У�
kill `cat /tmp/memcached.pid`
```





## ��ӷ���ǽ����

```
# -I ��ǰ����ӹ���
# dropĿ��˿�12321�˿ڵ��������ݰ�
iptables -I INPUT -p tcp --dport 12321 -j DROP
# ���������ض���ip�ĵ�ǰ�˿ڵ����ݰ���ip��ַ
iptables -I INPUT -s 192.168.1.2 -p tcp --dport 12321 -j ACCEPT
iptables -I INPUT -s 192.168.1.3 -p tcp --dport 12321 -j ACCEPT
iptables -I INPUT -s 192.168.1.4 -p tcp --dport 12321 -j ACCEPT
iptables -I INPUT -s 192.168.1.5 -p tcp --dport 12321 -j ACCEPT
iptables -I INPUT -s 127.0.0.1 -p tcp --dport 12321 -j ACCEPT

service iptables save
```



## �鿴�����Ķ˿ں�
```
netstat -tanp # �鿴�����û������Ķ˿�
netstat -tunp # �鿴��ǰ�û������Ķ˿�
```



*******************20170627---�޸�************************************

# ��װphp-memcache����չ
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
��Ϊ��
./configure --enable-memcache --with-php-config=/usr/bin/php-config --with-zlib-dir

make && make install
make test

ll /usr/lib64/php/modules/memcache.so
-rwxr-xr-x 1 root root 477764 Jun 26 19:59 /usr/lib64/php/modules/memcache.so
vi /data/conf/php.ini
��ӣ�
extension = "/usr/lib64/php/modules/memcache.so"
```

*******************************************************

��������
```
Build complete.
Don't forget to run 'make test'.
+-----------------------------------------------------------+
|                       ! ERROR !                           |
| The test-suite requires that proc_open() is available.    |
| Please check if you disabled it in php.ini.               |
+-----------------------------------------------------------+
```


���������
```
[root@localhost memcache-2.2.4]# vi /data/conf/php.ini ���޸�php.ini�����ļ���
�ҵ�disable_functions = shell_exec, system, passthru, exec, popen�� proc_open()
��Ϊdisable_functions = shell_exec, system, passthru, exec, popen
����һ����չ
extension = "memcache.so"
�����˳���
����make test
```


### ��������ҵ������¼���php�����ļ����в���
```
service httpd reload
```





### ����memcache�Ĺ����Ƿ�����

# �½�index.php�ļ����Կ�php�Ƿ�֧��memcache
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

���ҳ�������Hello world!string(12) "Hello world!"  ��˵����ʱphp�Ѿ�֧��memcacheģ��

## ��������
```
vi /etc/rc.d/rc.local
	# memcache ����
	/usr/local/bin/memcached -d -m 200 -u www -p 12321 -c 256 -P /tmp/memcached.pid
```


## �ر� memcached
```
ps aux|grep memcached 	���� kill `cat /tmp/memcached.pid`
/usr/local/bin/memcached -d -m 200 -u www -p 12321 -c 500 -P /tmp/memcached.pid 
```

# ���ڰ汾��

## ��װphp-memcache����չ
```
[root@localhost]# tar -zxvf memcache-2.2.4.tgz
[root@localhost]# cd memcache-2.2.4
[root@localhost]# phpize # ���û���ҵ�phpize������ ���У�yum -y install php-devel

[root@localhost]#./configure --with-php-config=/usr/bin/php-config --enable-memcache
```


error: memcache support requires ZLIB. Use --with-zlib-dir=<DIR> to specify prefix where ZLIB include and library are located   
��������Ҫִ�У�
```
yum -y  install zlib-devel
```

```
 #  ./configure --with-php-config=/usr/bin/php-config --enable-memcache
make
make test
```


## �鿴�Ƿ��������չĿ¼���ҵ� memcache.so
```
ls /usr/lib64/php/modules/  # ����Ҳ�����ֱ�Ӹ���һ����ȥ 
cp modules/memcache.so /usr/lib64/php/modules/ ���ߣ�cp /data/software/memcache-2.2.4/modules/memcache.so /usr/lib64/php/modules/

[root@localhost memcache-2.2.4]# make
[root@localhost memcache-2.2.4]# make test
```

