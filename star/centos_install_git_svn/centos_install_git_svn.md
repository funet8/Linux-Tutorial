# centos下搭建svn服务器

(一) 软件安装 
```
# yum -y install subversion # 安装软件
# mkdir -p /root/svn/version1 # 创建svn版本库目录 
```

(二) 单个版本库配置 
```
1 创建版本库 [root@M1 ~]# svnadmin create /root/svn/version1/
[root@M1 ~]# ls /root/svn/version1/
conf db format hooks locks README.txt

[root@M1 ~]# cd /root/svn/version1/conf/
[root@M1 conf]# ls
authz passwd svnserve.conf 
# passwd 为密码文件 authz为文件权限控制文件 svnserve.conf为svn服务配置文件 

```

2 配置版本库 # 设置帐号密码
```
 [root@M1 conf]# vi passwd
[users]
svnyumao = 123456 # 添加一个用户 # 设置权限 
[root@M1 conf]# vi authz
[groups]
yumaotest = svnyumao # 添加一个用户组并且包含上面创建的用户 [/]
@yumaotest = rw # 替version1版本库分配权限 # 设置svnserve配置 [root@M1 conf]# vi svnserve.conf
[general]
anon-access = read
auth-access = write
password-db = /root/svn/version1/conf/passwd
authz-db = /root/svn/version1/conf/authz
realm = My First Repository
```

3 启动svn
```
# svnserve -d -r /root/svn/version1 

# 尽量不要使用系统提供的 /etc/init.d/svnserve start 来启动，因为系统默认的启动脚本中没有使用 –r /svn/project参数指定一个资源。这种情况下启动的svn服务，客户端连接会提示“svn: No repository found in 'svn://192.168.31.2/project' ”这样的错误 

```


4 关闭svn
```
[root@M1 conf]# ps -ef | grep svnserve
[root@M1 conf]# kill -9 1669 (进程号)
```



5 windows 下进行测试  直接使用TortoiseSVN 软件checkout
