## centos下安装docker
Docker 运行在 CentOS-6.5 或更高的版本的 CentOS 上，需要内核版本是 2.6.32-431 或者更高版本 ，因为这是允许它运行的指定内核补丁版本。

### docker6安装docker
错误方法：
~~~
[root@centos-02 ~]# uname -r
2.6.32-573.26.1.el6.x86_64
[root@centos-02 ~]# yum install docker
[root@centos-02 ~]# docker ps
Segmentation Fault or Critical Error encountered. Dumping core and aborting.
Aborted (core dumped)
~~~
centos6.5可以直接安装docker，docker在centos6及以后的版本中都可以安装，如果你的6版系统中不能安装先配置一下EPEL库来安装
~~~
yum remove docker
yum install http://mirrors.yun-idc.com/epel/6/i386/epel-release-6-8.noarch.rpm 
yum install docker-io 
service docker start
[root@centos-02 ~]# docker ps
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
~~~
安装成功。


### CentOS7安装docker
CentOS7 系统 CentOS-Extras 库中已带 Docker，可以直接安装：
~~~
yum install docker
~~~

