# centos6安装swoole

选择版本 2.0以上的需要php7

服务器上使用的是php5.6 所以只能安装php1.10.3
[swoole-1.10.3](https://github.com/swoole/swoole-src/archive/v1.10.3.tar.gz)

两种安装方式

1：比较简单 
```
pecl install swoole # 需要安装pecl工具，我虚拟机上没有安装成功
```


 2：编译安装
```
yum install php-devel php-pear
```

swoole下载地址：https://github.com/swoole/swoole-src/releases 

```
ll /usr/lib64/php/modules/ |wc -l
cd /data/software/

wget https://github.com/swoole/swoole-src/archive/swoole-1.7.6-stable.tar.gz
tar -zxvf swoole-1.7.6-stable.tar.gz
cd swoole-src-swoole-1.7.6-stable
phpize 
./configure
make  && make install
```
如果出现：Build complete.就表示安装成功

下来修改php.ini添加swoole扩展
extension_dir = "/usr/lib64/php/modules/"这个centos里边如果是yum安装的php，扩展默认就在这个目录，可以不配置
   添加extension=swoole.so
```
ll /usr/lib64/php/modules/swoole.so 

vi /data/conf/php.ini
添加：
extension=swoole.so

httpd -t
service httpd reload
```

编辑phpinfo文件上传：
访问： http://域名/phpinfo.php
搜索 swoole
```
php -m |grep swoole
```

重启php-fpm:  /etc/init.d/php-fpm  restart

在phpinfo里能到swoole就表示成功了，下边就开始愉快地使用swoole吧



https://blog.csdn.net/xueshao110/article/details/80286840

