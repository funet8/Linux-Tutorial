# Linux服务器配置SSH免密码登陆

## 系统说明

192.168.4.179 centos6
192.168.4.181 centos6
192.168.4.182 centos6 

ssh端口： 60920

在三台服务器上设置www的密码
用户www


在179上操作：
```
#su -l www
$ mkdir /home/www/.ssh
$ chmod 700 /home/www/.ssh
$ ssh-keygen -t rsa -f /home/www/.ssh/id_rsa -P ''
$ ssh-copy-id "-p 60920 www@192.168.4.181" 
$ ssh-copy-id "-p 60920 www@192.168.4.182" 
```


测试：
```
ssh -p 60920 www@192.168.4.181
ssh -p 60920 www@192.168.4.182
```

在181上操作
```
# su -l www
$ ssh-keygen -t rsa -f /home/www/.ssh/id_rsa -P ''
$ ssh-copy-id "-p 60920 www@192.168.4.179"
测试登录：
ssh -p 60920 www@192.168.4.179
```



在182上操作
```
# su -l www
$ ssh-keygen -t rsa -f /home/www/.ssh/id_rsa -P ''
$ ssh-copy-id "-p 60920 www@192.168.4.179"
测试登录：
ssh -p 60920 www@192.168.4.179
```



第二种方法
```
# su -l www
$ mkdir /home/www/.ssh
$ chmod 700 /home/www/.ssh
$ vi /home/www/.ssh/authorized_keys 将179中的/home/www/.ssh/id_rsa.pub 写入
$ chmod 600 /home/www/.ssh/authorized_keys
在179上测试：
ssh -p 60920 www@192.168.4.185
```











